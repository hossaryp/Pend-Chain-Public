# Database Requirements - PostgreSQL Migration

## 📋 **Functional Requirements**

### **1. Data Migration Requirements**

#### **1.1 Complete Data Preservation**
- **Zero Data Loss**: All existing data must be migrated without loss
  - 139 user wallet mappings from `wallet-db.json`
  - All admin opportunities from `admin-opportunities.json`
  - Complete admin action logs from `admin-logs.json`
  - All KYC metadata from `uploads/kyc/metadata.json`
  - Full blockchain explorer data from `explorer-data/` directory

#### **1.2 Data Integrity Validation**
- **Pre-migration Checksums**: Generate data checksums before migration
- **Post-migration Verification**: Validate all migrated data against source
- **Referential Integrity**: Establish and validate all foreign key relationships
- **Data Type Conversion**: Convert JSON fields to appropriate PostgreSQL types
- **Constraint Validation**: Ensure all data meets new database constraints

#### **1.3 Migration Rollback Capability**
- **Backup Strategy**: Complete backup of JSON files before migration
- **Rollback Scripts**: Automated scripts to revert to JSON storage if needed
- **Parallel Operation**: Run both systems during transition period
- **Data Sync**: Real-time synchronization between old and new systems

### **2. Performance Requirements**

#### **2.1 Query Performance Standards**
- **Simple Queries**: < 50ms response time (user lookups, asset details)
- **Complex Queries**: < 500ms response time (analytics, reports)
- **Bulk Operations**: < 5 seconds for batch operations (1000+ records)
- **Real-time Data**: < 100ms for live updates (blockchain data)
- **Search Operations**: < 200ms for full-text search across assets and users

#### **2.2 Scalability Targets**
```typescript
// Performance Benchmarks
Current Scale: {
  users: 139,
  transactions_per_day: "Hundreds",
  concurrent_admin_users: 5,
  api_requests_per_minute: 1000
}

Target Scale (Q2 2025): {
  users: 1000,
  transactions_per_day: "Thousands", 
  concurrent_admin_users: 20,
  api_requests_per_minute: 10000
}

Future Scale (Q4 2025): {
  users: 10000,
  transactions_per_day: "Tens of thousands",
  concurrent_admin_users: 50,
  api_requests_per_minute: 50000
}
```

#### **2.3 Caching Requirements**
- **Cache Hit Ratio**: Minimum 80% for frequently accessed data
- **Cache Invalidation**: Real-time invalidation for data updates
- **Multi-level Caching**: Browser, CDN, Redis, and query result caching
- **Cache Warming**: Pre-populate cache with commonly accessed data

### **3. Integration Requirements**

#### **3.1 Admin Panel Integration**
- **Asset Management**: Full CRUD operations with complex filtering
  ```sql
  -- Required Query Capabilities
  - Filter by: type, status, category, date range, investment amount
  - Sort by: created date, total invested, investor count, ROI
  - Search: full-text search across title, description, category
  - Aggregate: total AUM, average investment, performance metrics
  ```

- **KYC Management**: Document workflow with status tracking
  ```sql
  -- KYC Query Requirements
  - List pending applications with priority sorting
  - Filter by status, submission date, document types
  - Bulk status updates with audit trail
  - Document security with access logging
  - Performance metrics for verification times
  ```

- **User Management**: Comprehensive user directory with analytics
  ```sql
  -- User Management Queries
  - Search by phone (partial), wallet address, tier level
  - Filter by registration date, investment activity, compliance status
  - Bulk operations with CSV import/export
  - User journey analytics and engagement metrics
  ```

#### **3.2 PendScan Integration**
- **Blockchain Data**: Real-time block and transaction processing
  ```sql
  -- PendScan Data Requirements
  - Store 74k+ existing blocks with full transaction details
  - Real-time ingestion of new blocks and transactions
  - Historical data queries with time-range filtering
  - Network statistics and performance metrics
  - Wallet directory with privacy-safe data exposure
  ```

- **Analytics & Reporting**: Time-series data for network monitoring
  ```sql
  -- Analytics Requirements
  - Time-series storage for network metrics
  - Aggregated views for daily/weekly/monthly statistics
  - Real-time dashboard metrics
  - Historical trend analysis
  - Export capabilities for regulatory reporting
  ```

#### **3.3 Existing Server Integration**
- **API Compatibility**: Maintain existing API contract during transition
- **Route Enhancement**: Gradual enhancement of routes to use PostgreSQL
- **Backward Compatibility**: Support both JSON and PostgreSQL during migration
- **Error Handling**: Graceful fallback to backup systems if database unavailable

### **4. Security & Compliance Requirements**

#### **4.1 Data Protection**
- **Encryption at Rest**: AES-256 encryption for sensitive database fields
- **Encryption in Transit**: TLS 1.3 for all database connections
- **Access Control**: Role-based access with principle of least privilege
- **Audit Logging**: Complete audit trail for all data access and modifications

#### **4.2 Privacy Compliance**
- **GDPR Compliance**: Right to deletion, data portability, access logs
- **Phone Number Hashing**: SHA-256 hashing for phone number storage
- **PII Protection**: Separate storage and encryption for personally identifiable information
- **Data Retention**: Configurable retention policies for different data types

#### **4.3 Regulatory Requirements**
- **Financial Compliance**: Support for AML/KYC regulatory requirements
- **Audit Trail**: Immutable audit logs for all financial transactions
- **Data Integrity**: Checksums and validation for critical financial data
- **Backup Compliance**: Regulatory-compliant backup and retention policies

### **5. Availability & Reliability Requirements**

#### **5.1 High Availability**
- **Uptime Target**: 99.9% availability (8.77 hours downtime per year)
- **Database Clustering**: Primary-replica setup with automatic failover
- **Load Balancing**: Connection pooling and read replica load distribution
- **Disaster Recovery**: Cross-region backup with 4-hour recovery time objective

#### **5.2 Backup & Recovery**
- **Backup Frequency**: Continuous WAL archiving + daily full backups
- **Retention Policy**: 30 days local, 90 days offsite, 7 years compliance data
- **Recovery Testing**: Monthly recovery drills with documented procedures
- **Point-in-Time Recovery**: Ability to restore to any point within retention period

#### **5.3 Monitoring & Alerting**
- **Database Metrics**: CPU, memory, disk I/O, connection count, query performance
- **Application Metrics**: Query response times, error rates, throughput
- **Alert Thresholds**: Proactive alerts for performance degradation
- **Health Checks**: Automated health monitoring with escalation procedures

## 🔧 **Technical Requirements**

### **6. Database Configuration**

#### **6.1 PostgreSQL Configuration**
```sql
-- Minimum PostgreSQL Version: 15+
-- Required Extensions:
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";      -- UUID generation
CREATE EXTENSION IF NOT EXISTS "pgcrypto";       -- Encryption functions
CREATE EXTENSION IF NOT EXISTS "pg_trgm";        -- Full-text search
CREATE EXTENSION IF NOT EXISTS "btree_gin";      -- Advanced indexing
CREATE EXTENSION IF NOT EXISTS "timescaledb";    -- Time-series data

-- Database Settings:
shared_buffers = 256MB                 -- Memory for caching
max_connections = 100                  -- Connection limit
work_mem = 4MB                        -- Memory per query
maintenance_work_mem = 64MB           -- Memory for maintenance
checkpoint_completion_target = 0.9    -- Checkpoint timing
wal_buffers = 16MB                    -- WAL buffer size
```

#### **6.2 Redis Configuration**
```redis
# Redis Configuration for Caching
maxmemory 512mb
maxmemory-policy allkeys-lru
save 900 1                    # Save snapshot if at least 1 key changed in 900 seconds
save 300 10                   # Save snapshot if at least 10 keys changed in 300 seconds
save 60 10000                 # Save snapshot if at least 10000 keys changed in 60 seconds
```

#### **6.3 Connection Management**
```typescript
// Connection Pool Configuration
const poolConfig = {
  min: 2,                     // Minimum connections
  max: 20,                    // Maximum connections  
  acquireTimeoutMillis: 60000, // Connection acquisition timeout
  idleTimeoutMillis: 30000,   // Idle connection timeout
  reapIntervalMillis: 1000,   // Cleanup interval
  createRetryIntervalMillis: 200, // Retry interval for failed connections
  propagateCreateError: false // Don't crash on connection errors
};
```

### **7. Data Model Requirements**

#### **7.1 Schema Validation**
- **Data Types**: Appropriate PostgreSQL types for all fields
- **Constraints**: Check constraints for data validation
- **Indexes**: Optimized indexes for query performance
- **Foreign Keys**: Referential integrity between related tables

#### **7.2 JSON Storage Strategy**
```sql
-- JSONB Usage Guidelines
metadata JSONB DEFAULT '{}' -- For flexible, searchable JSON data
preferences JSONB DEFAULT '{}' -- User preferences and settings
event_data JSONB DEFAULT '{}' -- Analytics event data
performance_data JSONB DEFAULT '{}' -- Asset performance metrics

-- JSONB Indexes for Performance
CREATE INDEX idx_user_metadata_gin ON users USING GIN (metadata);
CREATE INDEX idx_asset_performance_gin ON asset_metrics USING GIN (performance_data);
```

#### **7.3 Audit Trail Requirements**
```sql
-- Audit Trail Table Structure
CREATE TABLE audit_trail (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  table_name VARCHAR(50) NOT NULL,
  record_id VARCHAR(255) NOT NULL,
  action VARCHAR(20) NOT NULL, -- INSERT, UPDATE, DELETE
  old_values JSONB,
  new_values JSONB,
  changed_by UUID, -- admin_users.id
  changed_at TIMESTAMPTZ DEFAULT NOW(),
  ip_address INET,
  user_agent TEXT
);

-- Trigger for Automatic Audit Logging
CREATE OR REPLACE FUNCTION audit_trigger_function()
RETURNS TRIGGER AS $$
BEGIN
  -- Audit trail implementation
END;
$$ LANGUAGE plpgsql;
```

### **8. Analytics & Reporting Requirements**

#### **8.1 Time-Series Data**
- **TimescaleDB Integration**: Specialized storage for blockchain and analytics data
- **Data Compression**: Automatic compression for historical data
- **Retention Policies**: Automated data lifecycle management
- **Aggregation Views**: Pre-computed views for common analytics queries

#### **8.2 Real-Time Analytics**
```sql
-- Real-Time Metrics Views
CREATE MATERIALIZED VIEW real_time_stats AS
SELECT 
  COUNT(*) as total_users,
  COUNT(*) FILTER (WHERE created_at > NOW() - INTERVAL '24 hours') as new_users_today,
  SUM(total_invested) as total_aum,
  COUNT(DISTINCT asset_id) as active_assets
FROM users u
LEFT JOIN investments i ON u.id = i.user_id;

-- Refresh Strategy: Every 5 minutes
```

#### **8.3 Export Requirements**
- **Data Export Formats**: CSV, Excel, JSON, PDF
- **Filtered Exports**: Support for complex filtering before export
- **Large Dataset Handling**: Streaming exports for large datasets
- **Scheduled Exports**: Automated exports for regulatory reporting

## 🚀 **Migration Strategy Requirements**

### **9. Migration Phases**

#### **9.1 Phase 1: Infrastructure Setup (Week 1)**
- PostgreSQL installation and configuration
- Redis setup and configuration
- Database schema creation and validation
- Connection pooling and monitoring setup

#### **9.2 Phase 2: Data Migration (Week 2)**
- JSON to PostgreSQL data migration scripts
- Data validation and integrity checks
- Performance testing with migrated data
- Rollback procedure validation

#### **9.3 Phase 3: Application Integration (Week 3-4)**
- Server route enhancement for PostgreSQL
- Admin panel database integration
- PendScan database integration
- Comprehensive testing and validation

### **10. Testing Requirements**

#### **10.1 Data Migration Testing**
- **Unit Tests**: Individual migration script testing
- **Integration Tests**: End-to-end migration workflow testing
- **Performance Tests**: Migration performance with production data volumes
- **Rollback Tests**: Validation of rollback procedures

#### **10.2 Application Testing**
- **API Tests**: All enhanced routes with PostgreSQL backend
- **Load Tests**: Performance testing with concurrent users
- **Security Tests**: Access control and audit trail validation
- **Compatibility Tests**: Backward compatibility during transition

#### **10.3 Disaster Recovery Testing**
- **Backup Tests**: Validation of backup procedures
- **Recovery Tests**: Full database recovery from backups
- **Failover Tests**: Primary-replica failover scenarios
- **Network Partition Tests**: Database behavior during network issues

---

*These requirements ensure a robust, scalable, and secure database migration that supports the admin panel, PendScan, and existing server infrastructure while maintaining data integrity and system performance.* 