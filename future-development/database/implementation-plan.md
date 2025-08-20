# Database Implementation Plan - PostgreSQL Migration

## 🎯 **Implementation Overview**

Comprehensive plan for migrating from JSON file-based storage to PostgreSQL with Redis caching, designed to support enhanced admin panel, PendScan, and existing server infrastructure.

## 📅 **Phase 1: Infrastructure Setup (Week 1)**

### **Day 1-2: Database Installation & Configuration**

#### **PostgreSQL Setup**
```bash
# Production-Ready PostgreSQL Installation
# Ubuntu/Debian
sudo apt update
sudo apt install postgresql-15 postgresql-contrib-15

# PostgreSQL Configuration
sudo nano /etc/postgresql/15/main/postgresql.conf

# Key Settings for Production
shared_buffers = 256MB
effective_cache_size = 1GB
maintenance_work_mem = 64MB
checkpoint_completion_target = 0.9
wal_buffers = 16MB
default_statistics_target = 100
random_page_cost = 1.1
effective_io_concurrency = 200
max_connections = 100
```

#### **Database Creation & User Setup**
```sql
-- Create Production Database and Users
CREATE DATABASE pend_production;
CREATE DATABASE pend_analytics;

-- Create Application User
CREATE USER pend_app WITH PASSWORD 'secure_password_here';
GRANT CONNECT ON DATABASE pend_production TO pend_app;
GRANT USAGE ON SCHEMA public TO pend_app;
GRANT CREATE ON SCHEMA public TO pend_app;

-- Create Analytics User (Read-only for reporting)
CREATE USER pend_analytics WITH PASSWORD 'analytics_password_here';
GRANT CONNECT ON DATABASE pend_production TO pend_analytics;
GRANT USAGE ON SCHEMA public TO pend_analytics;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO pend_analytics;
```

#### **Required Extensions Installation**
```sql
-- Connect to pend_production database
\c pend_production;

-- Install Required Extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";      -- UUID generation
CREATE EXTENSION IF NOT EXISTS "pgcrypto";       -- Encryption functions
CREATE EXTENSION IF NOT EXISTS "pg_trgm";        -- Full-text search
CREATE EXTENSION IF NOT EXISTS "btree_gin";      -- Advanced indexing
CREATE EXTENSION IF NOT EXISTS "unaccent";       -- Text normalization

-- For analytics database (TimescaleDB)
\c pend_analytics;
CREATE EXTENSION IF NOT EXISTS timescaledb;
```

### **Day 3: Redis Setup & Configuration**

#### **Redis Installation**
```bash
# Redis Installation
sudo apt update
sudo apt install redis-server

# Redis Configuration
sudo nano /etc/redis/redis.conf

# Production Settings
maxmemory 512mb
maxmemory-policy allkeys-lru
save 900 1
save 300 10
save 60 10000
requirepass your_redis_password_here
```

#### **Redis Connection Testing**
```bash
# Test Redis Connection
redis-cli ping
redis-cli auth your_redis_password_here
redis-cli set test_key "test_value"
redis-cli get test_key
```

### **Day 4: Schema Creation**

#### **Core Schema Implementation**
```sql
-- File: migrations/001_create_core_schema.sql
\c pend_production;

-- Users & Identity Management
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  phone_hash VARCHAR(64) UNIQUE NOT NULL,
  blockchain_address VARCHAR(42) UNIQUE NOT NULL,
  tier INTEGER DEFAULT 0 CHECK (tier >= 0 AND tier <= 5),
  status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'suspended', 'closed')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE user_profiles (
  user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
  phone_number_masked VARCHAR(20),
  country_code VARCHAR(3),
  registration_ip INET,
  last_login_at TIMESTAMPTZ,
  login_count INTEGER DEFAULT 0,
  device_fingerprints JSONB DEFAULT '[]',
  preferences JSONB DEFAULT '{}',
  metadata JSONB DEFAULT '{}'
);

-- Asset Management
CREATE TABLE assets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  contract_address VARCHAR(42) UNIQUE NOT NULL,
  type VARCHAR(20) NOT NULL CHECK (type IN ('investment', 'interest')),
  title VARCHAR(255) NOT NULL,
  description TEXT,
  category VARCHAR(50),
  location VARCHAR(255),
  image_url VARCHAR(500),
  status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'paused', 'closed', 'draft')),
  metadata JSONB DEFAULT '{}',
  created_by UUID REFERENCES users(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE asset_details (
  asset_id UUID PRIMARY KEY REFERENCES assets(id) ON DELETE CASCADE,
  token_symbol VARCHAR(10),
  token_price DECIMAL(18,6),
  max_supply BIGINT,
  expected_roi DECIMAL(5,2),
  lockup_period INTEGER,
  minimum_investment DECIMAL(18,6),
  soft_cap DECIMAL(18,6),
  deadline TIMESTAMPTZ,
  contact_format VARCHAR(20) CHECK (contact_format IN ('whatsapp', 'email')),
  contact_value VARCHAR(255),
  jurisdiction VARCHAR(100),
  spv_name VARCHAR(255),
  custody_type VARCHAR(100),
  min_tier_required INTEGER DEFAULT 1,
  legal_documents JSONB DEFAULT '[]',
  agreement_url VARCHAR(500),
  agreement_hash VARCHAR(66)
);

CREATE TABLE asset_metrics (
  asset_id UUID PRIMARY KEY REFERENCES assets(id) ON DELETE CASCADE,
  total_invested DECIMAL(18,6) DEFAULT 0,
  investor_count INTEGER DEFAULT 0,
  interested_count INTEGER DEFAULT 0,
  performance_data JSONB DEFAULT '{}',
  last_updated TIMESTAMPTZ DEFAULT NOW()
);

-- Investment Tracking
CREATE TABLE investments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  asset_id UUID REFERENCES assets(id),
  amount DECIMAL(18,6) NOT NULL,
  currency VARCHAR(10) NOT NULL,
  transaction_hash VARCHAR(66),
  block_number BIGINT,
  status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'failed', 'refunded')),
  invested_at TIMESTAMPTZ DEFAULT NOW(),
  confirmed_at TIMESTAMPTZ,
  metadata JSONB DEFAULT '{}'
);

-- KYC & Compliance
CREATE TABLE kyc_applications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  status VARCHAR(20) DEFAULT 'pending_review' CHECK (status IN ('pending_review', 'under_review', 'verified', 'rejected')),
  submitted_at TIMESTAMPTZ DEFAULT NOW(),
  reviewed_at TIMESTAMPTZ,
  verified_by UUID REFERENCES admin_users(id),
  rejection_reason TEXT,
  review_notes TEXT,
  metadata JSONB DEFAULT '{}'
);

CREATE TABLE kyc_documents (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  application_id UUID REFERENCES kyc_applications(id) ON DELETE CASCADE,
  document_type VARCHAR(20) NOT NULL CHECK (document_type IN ('id', 'passport', 'utility', 'driver_license')),
  original_filename VARCHAR(255),
  stored_filename VARCHAR(255),
  file_path VARCHAR(500),
  file_size INTEGER,
  mime_type VARCHAR(100),
  file_hash VARCHAR(64),
  uploaded_at TIMESTAMPTZ DEFAULT NOW(),
  metadata JSONB DEFAULT '{}'
);

-- Admin System
CREATE TABLE admin_users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) UNIQUE NOT NULL,
  name VARCHAR(255) NOT NULL,
  role VARCHAR(50) NOT NULL CHECK (role IN ('super_admin', 'asset_manager', 'kyc_verifier', 'auditor', 'viewer')),
  permissions JSONB DEFAULT '[]',
  blockchain_address VARCHAR(42),
  password_hash VARCHAR(255),
  is_active BOOLEAN DEFAULT true,
  last_login_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE admin_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  admin_id UUID REFERENCES admin_users(id),
  action VARCHAR(100) NOT NULL,
  resource_type VARCHAR(50),
  resource_id VARCHAR(255),
  old_values JSONB,
  new_values JSONB,
  ip_address INET,
  user_agent TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

### **Day 5: Index Creation & Performance Optimization**

#### **Performance Indexes**
```sql
-- File: migrations/002_create_indexes.sql

-- Users & Authentication Indexes
CREATE INDEX idx_users_phone_hash ON users(phone_hash);
CREATE INDEX idx_users_blockchain_address ON users(blockchain_address);
CREATE INDEX idx_users_tier ON users(tier);
CREATE INDEX idx_users_status ON users(status);
CREATE INDEX idx_users_created_at ON users(created_at);

-- Asset Indexes
CREATE INDEX idx_assets_contract_address ON assets(contract_address);
CREATE INDEX idx_assets_type ON assets(type);
CREATE INDEX idx_assets_category ON assets(category);
CREATE INDEX idx_assets_status ON assets(status);
CREATE INDEX idx_assets_created_at ON assets(created_at);

-- Investment Indexes
CREATE INDEX idx_investments_user_id ON investments(user_id);
CREATE INDEX idx_investments_asset_id ON investments(asset_id);
CREATE INDEX idx_investments_status ON investments(status);
CREATE INDEX idx_investments_invested_at ON investments(invested_at);
CREATE INDEX idx_investments_user_asset ON investments(user_id, asset_id);

-- KYC Indexes
CREATE INDEX idx_kyc_applications_user_id ON kyc_applications(user_id);
CREATE INDEX idx_kyc_applications_status ON kyc_applications(status);
CREATE INDEX idx_kyc_applications_submitted_at ON kyc_applications(submitted_at);
CREATE INDEX idx_kyc_documents_application_id ON kyc_documents(application_id);

-- Admin Indexes
CREATE INDEX idx_admin_users_email ON admin_users(email);
CREATE INDEX idx_admin_users_role ON admin_users(role);
CREATE INDEX idx_admin_logs_admin_id ON admin_logs(admin_id);
CREATE INDEX idx_admin_logs_created_at ON admin_logs(created_at);
CREATE INDEX idx_admin_logs_resource ON admin_logs(resource_type, resource_id);

-- JSONB Indexes for Performance
CREATE INDEX idx_user_metadata_gin ON users USING GIN (metadata);
CREATE INDEX idx_asset_performance_gin ON asset_metrics USING GIN (performance_data);
CREATE INDEX idx_user_preferences_gin ON user_profiles USING GIN (preferences);
```

## 📅 **Phase 2: Data Migration (Week 2)**

### **Day 1-2: Migration Script Development**

#### **Data Migration Utilities**
```javascript
// File: server/migrations/migrate-data.js
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
const { Pool } = require('pg');

class DataMigrator {
  constructor() {
    this.pool = new Pool({
      user: process.env.DB_USER,
      host: process.env.DB_HOST,
      database: process.env.DB_NAME,
      password: process.env.DB_PASSWORD,
      port: process.env.DB_PORT || 5432,
    });
  }

  // Migrate wallet-db.json to users table
  async migrateUsers() {
    console.log('🔄 Migrating user data...');
    
    const walletDb = JSON.parse(
      fs.readFileSync(path.join(__dirname, '../wallet-db.json'), 'utf8')
    );

    const client = await this.pool.connect();
    
    try {
      await client.query('BEGIN');
      
      for (const [phoneHash, blockchainAddress] of Object.entries(walletDb)) {
        // Insert user
        const userResult = await client.query(`
          INSERT INTO users (phone_hash, blockchain_address, tier, created_at)
          VALUES ($1, $2, $3, NOW())
          ON CONFLICT (phone_hash) DO NOTHING
          RETURNING id
        `, [phoneHash, blockchainAddress, 0]);

        if (userResult.rows.length > 0) {
          const userId = userResult.rows[0].id;
          
          // Insert user profile
          await client.query(`
            INSERT INTO user_profiles (user_id, phone_number_masked, metadata)
            VALUES ($1, $2, $3)
          `, [
            userId,
            this.maskPhoneNumber(phoneHash),
            JSON.stringify({ migrated_from: 'wallet-db.json' })
          ]);
        }
      }
      
      await client.query('COMMIT');
      console.log(`✅ Migrated ${Object.keys(walletDb).length} users`);
      
    } catch (error) {
      await client.query('ROLLBACK');
      console.error('❌ User migration failed:', error);
      throw error;
    } finally {
      client.release();
    }
  }

  // Migrate admin-opportunities.json to assets table
  async migrateAssets() {
    console.log('🔄 Migrating asset data...');
    
    const opportunitiesData = JSON.parse(
      fs.readFileSync(path.join(__dirname, '../admin-opportunities.json'), 'utf8')
    );

    const opportunities = opportunitiesData.opportunities || [];
    const client = await this.pool.connect();
    
    try {
      await client.query('BEGIN');
      
      for (const opportunity of opportunities) {
        // Insert asset
        const assetResult = await client.query(`
          INSERT INTO assets (
            contract_address, type, title, description, category, 
            status, metadata, created_at
          ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
          ON CONFLICT (contract_address) DO NOTHING
          RETURNING id
        `, [
          opportunity.contractAddress,
          opportunity.type,
          opportunity.title,
          opportunity.description || '',
          opportunity.category || 'General',
          opportunity.status || 'active',
          JSON.stringify({
            migrated_from: 'admin-opportunities.json',
            original_id: opportunity.id
          }),
          opportunity.createdAt || new Date().toISOString()
        ]);

        if (assetResult.rows.length > 0) {
          const assetId = assetResult.rows[0].id;
          
          // Insert asset details
          await client.query(`
            INSERT INTO asset_details (
              asset_id, token_symbol, token_price, max_supply,
              expected_roi, lockup_period, minimum_investment,
              soft_cap, deadline, contact_format, contact_value
            ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
          `, [
            assetId,
            opportunity.tokenSymbol || null,
            opportunity.tokenPrice || null,
            opportunity.maxSupply || null,
            opportunity.expectedROI || null,
            opportunity.lockupPeriod || null,
            opportunity.minimumInvestment || null,
            opportunity.softCap || null,
            opportunity.deadline || null,
            opportunity.contactFormat || null,
            opportunity.contactValue || null
          ]);

          // Insert asset metrics
          await client.query(`
            INSERT INTO asset_metrics (
              asset_id, total_invested, investor_count, interested_count
            ) VALUES ($1, $2, $3, $4)
          `, [
            assetId,
            opportunity.totalInvested || 0,
            opportunity.investorCount || 0,
            opportunity.interestedCount || 0
          ]);
        }
      }
      
      await client.query('COMMIT');
      console.log(`✅ Migrated ${opportunities.length} assets`);
      
    } catch (error) {
      await client.query('ROLLBACK');
      console.error('❌ Asset migration failed:', error);
      throw error;
    } finally {
      client.release();
    }
  }

  // Migrate admin-logs.json to admin_logs table
  async migrateAdminLogs() {
    console.log('🔄 Migrating admin logs...');
    
    const logsData = JSON.parse(
      fs.readFileSync(path.join(__dirname, '../admin-logs.json'), 'utf8')
    );

    const logs = logsData.logs || [];
    const client = await this.pool.connect();
    
    try {
      await client.query('BEGIN');
      
      for (const log of logs) {
        await client.query(`
          INSERT INTO admin_logs (
            action, resource_type, resource_id, 
            old_values, new_values, ip_address, created_at
          ) VALUES ($1, $2, $3, $4, $5, $6, $7)
        `, [
          log.action,
          'opportunity', // Most logs are opportunity-related
          log.data?.contractAddress || log.data?.id?.toString(),
          null, // old_values not available in current format
          JSON.stringify(log.data),
          log.data?.ip || null,
          log.timestamp
        ]);
      }
      
      await client.query('COMMIT');
      console.log(`✅ Migrated ${logs.length} admin logs`);
      
    } catch (error) {
      await client.query('ROLLBACK');
      console.error('❌ Admin logs migration failed:', error);
      throw error;
    } finally {
      client.release();
    }
  }

  // Migrate KYC metadata
  async migrateKYCData() {
    console.log('🔄 Migrating KYC data...');
    
    const metadataPath = path.join(__dirname, '../uploads/kyc/metadata.json');
    
    if (!fs.existsSync(metadataPath)) {
      console.log('ℹ️ No KYC metadata file found, skipping...');
      return;
    }

    const metadata = JSON.parse(fs.readFileSync(metadataPath, 'utf8'));
    const client = await this.pool.connect();
    
    try {
      await client.query('BEGIN');
      
      for (const [phoneHash, userKyc] of Object.entries(metadata)) {
        // Find user by phone hash
        const userResult = await client.query(`
          SELECT id FROM users WHERE phone_hash = $1
        `, [phoneHash]);

        if (userResult.rows.length === 0) {
          console.log(`⚠️ User not found for phone hash: ${phoneHash.substring(0, 8)}...`);
          continue;
        }

        const userId = userResult.rows[0].id;

        // Insert KYC application
        const kycResult = await client.query(`
          INSERT INTO kyc_applications (
            user_id, status, submitted_at, reviewed_at, 
            verified_by, rejection_reason, metadata
          ) VALUES ($1, $2, $3, $4, $5, $6, $7)
          RETURNING id
        `, [
          userId,
          userKyc.verificationStatus || 'pending_review',
          userKyc.lastUpdated,
          userKyc.verifiedAt || null,
          null, // verified_by not available in current format
          userKyc.rejectionReason || null,
          JSON.stringify({ migrated_from: 'kyc_metadata.json' })
        ]);

        const applicationId = kycResult.rows[0].id;

        // Insert KYC documents
        for (const [docType, doc] of Object.entries(userKyc.documents || {})) {
          await client.query(`
            INSERT INTO kyc_documents (
              application_id, document_type, original_filename,
              stored_filename, file_path, file_size, mime_type,
              uploaded_at, metadata
            ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
          `, [
            applicationId,
            docType,
            doc.originalName,
            doc.id,
            doc.path,
            doc.size,
            doc.mimeType,
            doc.uploadedAt,
            JSON.stringify({ migrated_from: 'kyc_metadata.json' })
          ]);
        }
      }
      
      await client.query('COMMIT');
      console.log(`✅ Migrated ${Object.keys(metadata).length} KYC applications`);
      
    } catch (error) {
      await client.query('ROLLBACK');
      console.error('❌ KYC migration failed:', error);
      throw error;
    } finally {
      client.release();
    }
  }

  // Utility functions
  maskPhoneNumber(phoneHash) {
    // Create a consistent masked phone number from hash
    return `+***${phoneHash.substring(0, 4)}`;
  }

  async validateMigration() {
    console.log('🔍 Validating migration...');
    
    const client = await this.pool.connect();
    
    try {
      // Count records in each table
      const counts = await Promise.all([
        client.query('SELECT COUNT(*) FROM users'),
        client.query('SELECT COUNT(*) FROM assets'),
        client.query('SELECT COUNT(*) FROM admin_logs'),
        client.query('SELECT COUNT(*) FROM kyc_applications')
      ]);

      console.log('📊 Migration Results:');
      console.log(`   Users: ${counts[0].rows[0].count}`);
      console.log(`   Assets: ${counts[1].rows[0].count}`);
      console.log(`   Admin Logs: ${counts[2].rows[0].count}`);
      console.log(`   KYC Applications: ${counts[3].rows[0].count}`);

      return true;
    } catch (error) {
      console.error('❌ Validation failed:', error);
      return false;
    } finally {
      client.release();
    }
  }

  async close() {
    await this.pool.end();
  }
}

// Migration execution
async function runMigration() {
  const migrator = new DataMigrator();
  
  try {
    await migrator.migrateUsers();
    await migrator.migrateAssets();
    await migrator.migrateAdminLogs();
    await migrator.migrateKYCData();
    
    const isValid = await migrator.validateMigration();
    
    if (isValid) {
      console.log('🎉 Migration completed successfully!');
    } else {
      console.log('❌ Migration validation failed!');
      process.exit(1);
    }
    
  } catch (error) {
    console.error('💥 Migration failed:', error);
    process.exit(1);
  } finally {
    await migrator.close();
  }
}

// Run migration if called directly
if (require.main === module) {
  runMigration();
}

module.exports = { DataMigrator };
```

### **Day 3-4: Migration Execution & Validation**

#### **Migration Script Execution**
```bash
# Create migration environment variables
export DB_HOST=localhost
export DB_PORT=5432
export DB_NAME=pend_production
export DB_USER=pend_app
export DB_PASSWORD=secure_password_here

# Run data migration
cd server
node migrations/migrate-data.js

# Validate migration results
node migrations/validate-migration.js
```

#### **Data Validation Scripts**
```javascript
// File: server/migrations/validate-migration.js
const { DataMigrator } = require('./migrate-data');
const fs = require('fs');

async function validateDataIntegrity() {
  const migrator = new DataMigrator();
  
  try {
    // Validate user count matches
    const walletDb = JSON.parse(fs.readFileSync('../wallet-db.json', 'utf8'));
    const userCount = await migrator.pool.query('SELECT COUNT(*) FROM users');
    
    console.log(`Original users: ${Object.keys(walletDb).length}`);
    console.log(`Migrated users: ${userCount.rows[0].count}`);
    
    if (Object.keys(walletDb).length !== parseInt(userCount.rows[0].count)) {
      throw new Error('User count mismatch!');
    }

    // Validate blockchain addresses are preserved
    for (const [phoneHash, address] of Object.entries(walletDb)) {
      const result = await migrator.pool.query(`
        SELECT blockchain_address FROM users WHERE phone_hash = $1
      `, [phoneHash]);
      
      if (result.rows.length === 0 || result.rows[0].blockchain_address !== address) {
        throw new Error(`Address mismatch for ${phoneHash}`);
      }
    }

    console.log('✅ All validations passed!');
    
  } catch (error) {
    console.error('❌ Validation failed:', error);
    throw error;
  } finally {
    await migrator.close();
  }
}

validateDataIntegrity();
```

### **Day 5: TimescaleDB Setup for Analytics**

#### **Analytics Database Setup**
```sql
-- Connect to analytics database
\c pend_analytics;

-- Create blockchain metrics hypertable
CREATE TABLE blockchain_metrics (
  time TIMESTAMPTZ NOT NULL,
  block_number BIGINT,
  transaction_count INTEGER,
  gas_used BIGINT,
  network_hash_rate BIGINT,
  total_difficulty DECIMAL(36,0),
  block_size BIGINT
);

SELECT create_hypertable('blockchain_metrics', 'time');

-- Create user analytics hypertable
CREATE TABLE user_activity_events (
  time TIMESTAMPTZ NOT NULL,
  user_id UUID,
  event_type VARCHAR(50),
  event_data JSONB,
  session_id VARCHAR(100),
  ip_address INET
);

SELECT create_hypertable('user_activity_events', 'time');

-- Create investment analytics hypertable
CREATE TABLE investment_events (
  time TIMESTAMPTZ NOT NULL,
  user_id UUID,
  asset_id UUID,
  event_type VARCHAR(50), -- 'investment', 'redemption', 'interest_payment'
  amount DECIMAL(18,6),
  currency VARCHAR(10),
  transaction_hash VARCHAR(66)
);

SELECT create_hypertable('investment_events', 'time');
```

## 📅 **Phase 3: Application Integration (Week 3-4)**

### **Week 3: Server Enhancement**

#### **Database Service Layer**
```javascript
// File: server/services/database.js
const { Pool } = require('pg');
const Redis = require('redis');

class DatabaseService {
  constructor() {
    // PostgreSQL connection pool
    this.pool = new Pool({
      user: process.env.DB_USER,
      host: process.env.DB_HOST,
      database: process.env.DB_NAME,
      password: process.env.DB_PASSWORD,
      port: process.env.DB_PORT || 5432,
      max: 20,
      idleTimeoutMillis: 30000,
      connectionTimeoutMillis: 2000,
    });

    // Redis connection
    this.redis = Redis.createClient({
      url: process.env.REDIS_URL || 'redis://localhost:6379',
      password: process.env.REDIS_PASSWORD
    });

    this.redis.connect();
  }

  // Query with caching
  async query(sql, params = [], cacheKey = null, ttl = 300) {
    // Check cache first
    if (cacheKey) {
      const cached = await this.redis.get(cacheKey);
      if (cached) {
        return JSON.parse(cached);
      }
    }

    // Execute query
    const result = await this.pool.query(sql, params);
    
    // Cache result
    if (cacheKey && result.rows.length > 0) {
      await this.redis.setEx(cacheKey, ttl, JSON.stringify(result.rows));
    }

    return result.rows;
  }

  // Transaction wrapper
  async transaction(callback) {
    const client = await this.pool.connect();
    
    try {
      await client.query('BEGIN');
      const result = await callback(client);
      await client.query('COMMIT');
      return result;
    } catch (error) {
      await client.query('ROLLBACK');
      throw error;
    } finally {
      client.release();
    }
  }

  // Cache invalidation
  async invalidateCache(pattern) {
    const keys = await this.redis.keys(pattern);
    if (keys.length > 0) {
      await this.redis.del(keys);
    }
  }

  async close() {
    await this.pool.end();
    await this.redis.quit();
  }
}

module.exports = new DatabaseService();
```

#### **Enhanced User Service**
```javascript
// File: server/services/userService.js
const db = require('./database');

class UserService {
  async getUserByPhoneHash(phoneHash) {
    const cacheKey = `user:phone:${phoneHash}`;
    
    const users = await db.query(`
      SELECT u.*, up.phone_number_masked, up.country_code, up.last_login_at,
             up.login_count, up.preferences, up.metadata
      FROM users u
      LEFT JOIN user_profiles up ON u.id = up.user_id
      WHERE u.phone_hash = $1
    `, [phoneHash], cacheKey);

    return users[0] || null;
  }

  async getUserByAddress(blockchainAddress) {
    const cacheKey = `user:address:${blockchainAddress}`;
    
    const users = await db.query(`
      SELECT u.*, up.phone_number_masked, up.country_code
      FROM users u
      LEFT JOIN user_profiles up ON u.id = up.user_id
      WHERE u.blockchain_address = $1
    `, [blockchainAddress], cacheKey);

    return users[0] || null;
  }

  async getAllUsers(filters = {}) {
    let whereClause = 'WHERE 1=1';
    const params = [];
    let paramCount = 0;

    // Apply filters
    if (filters.tier !== undefined) {
      whereClause += ` AND u.tier = $${++paramCount}`;
      params.push(filters.tier);
    }

    if (filters.status) {
      whereClause += ` AND u.status = $${++paramCount}`;
      params.push(filters.status);
    }

    if (filters.createdAfter) {
      whereClause += ` AND u.created_at >= $${++paramCount}`;
      params.push(filters.createdAfter);
    }

    const users = await db.query(`
      SELECT u.id, u.tier, u.status, u.created_at,
             up.phone_number_masked, up.country_code, up.last_login_at,
             COUNT(i.id) as investment_count,
             COALESCE(SUM(i.amount), 0) as total_invested
      FROM users u
      LEFT JOIN user_profiles up ON u.id = up.user_id
      LEFT JOIN investments i ON u.id = i.user_id AND i.status = 'confirmed'
      ${whereClause}
      GROUP BY u.id, up.phone_number_masked, up.country_code, up.last_login_at
      ORDER BY u.created_at DESC
    `, params);

    return users;
  }

  async updateUserTier(userId, newTier, adminId) {
    return await db.transaction(async (client) => {
      // Update user tier
      await client.query(`
        UPDATE users SET tier = $1, updated_at = NOW() WHERE id = $2
      `, [newTier, userId]);

      // Log the change
      await client.query(`
        INSERT INTO admin_logs (admin_id, action, resource_type, resource_id, new_values)
        VALUES ($1, 'UPDATE_USER_TIER', 'user', $2, $3)
      `, [adminId, userId, JSON.stringify({ tier: newTier })]);

      // Invalidate cache
      await db.invalidateCache(`user:*`);

      return true;
    });
  }

  async getUserStats() {
    const cacheKey = 'stats:users';
    
    const stats = await db.query(`
      SELECT 
        COUNT(*) as total_users,
        COUNT(*) FILTER (WHERE created_at > NOW() - INTERVAL '24 hours') as new_users_today,
        COUNT(*) FILTER (WHERE created_at > NOW() - INTERVAL '7 days') as new_users_week,
        COUNT(*) FILTER (WHERE status = 'active') as active_users,
        COUNT(*) FILTER (WHERE tier >= 3) as kyc_verified_users
      FROM users
    `, [], cacheKey, 600); // Cache for 10 minutes

    const tierDistribution = await db.query(`
      SELECT tier, COUNT(*) as count
      FROM users
      GROUP BY tier
      ORDER BY tier
    `, [], 'stats:tier_distribution', 600);

    return {
      ...stats[0],
      tierDistribution: tierDistribution.reduce((acc, row) => {
        acc[row.tier] = parseInt(row.count);
        return acc;
      }, {})
    };
  }
}

module.exports = new UserService();
```

### **Week 4: Frontend Integration**

#### **Enhanced API Routes**
```javascript
// File: server/routes/users.js (Enhanced)
const express = require('express');
const router = express.Router();
const userService = require('../services/userService');
const { authenticateAdmin } = require('../middleware/auth');

// GET /api/users - Get all users with filtering
router.get('/', authenticateAdmin, async (req, res) => {
  try {
    const filters = {
      tier: req.query.tier ? parseInt(req.query.tier) : undefined,
      status: req.query.status,
      createdAfter: req.query.createdAfter
    };

    const users = await userService.getAllUsers(filters);
    
    res.json({
      success: true,
      users,
      total: users.length
    });
  } catch (error) {
    console.error('Error fetching users:', error);
    res.status(500).json({ error: 'Failed to fetch users' });
  }
});

// GET /api/users/stats - Get user statistics
router.get('/stats', authenticateAdmin, async (req, res) => {
  try {
    const stats = await userService.getUserStats();
    res.json({ success: true, stats });
  } catch (error) {
    console.error('Error fetching user stats:', error);
    res.status(500).json({ error: 'Failed to fetch user statistics' });
  }
});

// PUT /api/users/:id/tier - Update user tier
router.put('/:id/tier', authenticateAdmin, async (req, res) => {
  try {
    const { id } = req.params;
    const { tier } = req.body;
    const adminId = req.user.id; // From auth middleware

    if (tier < 0 || tier > 5) {
      return res.status(400).json({ error: 'Invalid tier level' });
    }

    await userService.updateUserTier(id, tier, adminId);
    
    res.json({
      success: true,
      message: 'User tier updated successfully'
    });
  } catch (error) {
    console.error('Error updating user tier:', error);
    res.status(500).json({ error: 'Failed to update user tier' });
  }
});

module.exports = router;
```

## 🚀 **Deployment & Monitoring**

### **Production Deployment**

#### **Docker Configuration**
```yaml
# File: docker-compose.production.yml
version: '3.8'
services:
  postgresql:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: pend_production
      POSTGRES_USER: pend_app
      POSTGRES_PASSWORD: ${DB_PASSWORD}
      POSTGRES_INITDB_ARGS: "--encoding=UTF-8 --lc-collate=C --lc-ctype=C"
    volumes:
      - pg_data:/var/lib/postgresql/data
      - ./migrations:/docker-entrypoint-initdb.d
    ports:
      - "5432:5432"
    command: postgres -c 'max_connections=100' -c 'shared_buffers=256MB'
    
  redis:
    image: redis:7-alpine
    command: redis-server --requirepass ${REDIS_PASSWORD} --maxmemory 512mb --maxmemory-policy allkeys-lru
    volumes:
      - redis_data:/data
    ports:
      - "6379:6379"
      
  timescaledb:
    image: timescale/timescaledb:latest-pg15
    environment:
      POSTGRES_DB: pend_analytics
      POSTGRES_USER: pend_analytics
      POSTGRES_PASSWORD: ${ANALYTICS_DB_PASSWORD}
    volumes:
      - ts_data:/var/lib/postgresql/data
    ports:
      - "5433:5432"

volumes:
  pg_data:
  redis_data:
  ts_data:
```

#### **Monitoring Setup**
```javascript
// File: server/services/monitoring.js
const db = require('./database');

class MonitoringService {
  async getDatabaseHealth() {
    try {
      // Check PostgreSQL connection
      const pgResult = await db.query('SELECT NOW() as timestamp');
      
      // Check Redis connection
      const redisResult = await db.redis.ping();
      
      // Get connection pool status
      const poolStats = {
        totalCount: db.pool.totalCount,
        idleCount: db.pool.idleCount,
        waitingCount: db.pool.waitingCount
      };

      return {
        postgresql: { status: 'healthy', timestamp: pgResult[0].timestamp },
        redis: { status: redisResult === 'PONG' ? 'healthy' : 'unhealthy' },
        connectionPool: poolStats
      };
    } catch (error) {
      return {
        postgresql: { status: 'unhealthy', error: error.message },
        redis: { status: 'unhealthy' },
        connectionPool: { status: 'unhealthy' }
      };
    }
  }

  async getPerformanceMetrics() {
    const metrics = await db.query(`
      SELECT 
        schemaname,
        tablename,
        attname,
        n_distinct,
        correlation
      FROM pg_stats 
      WHERE schemaname = 'public'
      ORDER BY tablename, attname
    `);

    return metrics;
  }
}

module.exports = new MonitoringService();
```

---

*This implementation plan provides a comprehensive, step-by-step approach to migrating from JSON files to PostgreSQL while maintaining system reliability and supporting enhanced admin panel and PendScan functionality.* 