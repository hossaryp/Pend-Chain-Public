# Explorer Data Database Migration

## Overview
Migration of explorer data from JSON files to PostgreSQL database for better performance, scalability, and reliability.

## Migration Date
- **Date**: July 2, 2025
- **Version**: 1.0.0

## Files Migrated

### JSON Files to Database Tables
1. **wallets-directory.json** (42KB) → `wallets` table
2. **transactions-log.json** (89KB) → `transaction_logs` table  
3. **persistent-transactions.json** (7.5KB) → `blockchain_transactions` table
4. **full-chain-history.json** (602KB) → `chain_history` table
5. **live-stats.json** (717B) → `blockchain_stats` table
6. **identity-map.json** (7.8KB) → `identity_mappings` table

**Total Space to be Freed**: ~748KB

## Database Schema

### New Tables Created

#### 1. `wallets` Table
```sql
CREATE TABLE wallets (
  identity_hash VARCHAR(66) PRIMARY KEY,
  wallet_address VARCHAR(42) UNIQUE NOT NULL,
  phone_hash VARCHAR(66),
  masked_phone VARCHAR(20),
  full_phone_number VARCHAR(20),
  phone_timestamp TIMESTAMPTZ,
  phone_block_number BIGINT,
  phone_tx_hash VARCHAR(66),
  created_at TIMESTAMPTZ NOT NULL,
  created_block BIGINT,
  creation_tx_hash VARCHAR(66),
  balances JSONB DEFAULT '{}',
  identity JSONB,
  real_phone_number BOOLEAN DEFAULT false,
  last_updated TIMESTAMPTZ DEFAULT NOW()
);
```

#### 2. `transaction_logs` Table
```sql
CREATE TABLE transaction_logs (
  id SERIAL PRIMARY KEY,
  content_hash VARCHAR(20),
  timestamp TIMESTAMPTZ NOT NULL,
  type VARCHAR(50) NOT NULL,
  from_address VARCHAR(42),
  to_address VARCHAR(42),
  amount VARCHAR(50),
  tx_hash VARCHAR(66),
  block_number BIGINT,
  identity_hash VARCHAR(66),
  wallet_address VARCHAR(42),
  phone_number VARCHAR(20),
  sub_type VARCHAR(50),
  action VARCHAR(100),
  metadata JSONB DEFAULT '{}'
);
```

#### 3. `chain_history` Table
```sql
CREATE TABLE chain_history (
  id SERIAL PRIMARY KEY,
  block_number BIGINT NOT NULL,
  timestamp TIMESTAMPTZ NOT NULL,
  transaction_count INTEGER DEFAULT 0,
  gas_used BIGINT,
  gas_limit BIGINT,
  base_fee_per_gas BIGINT,
  size BIGINT,
  miner VARCHAR(42),
  extra_data TEXT
);
```

#### 4. `blockchain_stats` Table
```sql
CREATE TABLE blockchain_stats (
  id SERIAL PRIMARY KEY,
  metric_name VARCHAR(100) NOT NULL UNIQUE,
  metric_value NUMERIC,
  string_value VARCHAR(255),
  json_value JSONB,
  last_updated TIMESTAMPTZ DEFAULT NOW()
);
```

## Migration Process

### Step 1: Create Migration Files
- Created `002_explorer_data_migration.sql` with table definitions
- Created `migrateExplorerData.js` script for data migration

### Step 2: Run Migration Script
```bash
cd server/src/database
node migrateExplorerData.js
```

### Step 3: Update Services
Services that need updating to use database instead of JSON:
1. `data-collector.js` - Update to write to database
2. `routes/explorer.js` - Update to read from database
3. `services/walletService.js` - Update wallet queries
4. `services/transactionService.js` - Update transaction queries
5. `utils/blockchainPhoneReader.js` - Update phone cache

### Step 4: Verify & Clean Up
After confirming all services work correctly:
1. Monitor for 24 hours
2. Delete JSON files when confirmed stable
3. Remove JSON file references from code

## Benefits

### Performance Improvements
- **Query Speed**: Database indexes provide faster lookups
- **Concurrent Access**: Multiple services can read/write simultaneously
- **Reduced Memory**: No need to load entire JSON files into memory

### Reliability
- **ACID Compliance**: Database transactions ensure data integrity
- **Backup**: Database backups are more reliable than file backups
- **Recovery**: Point-in-time recovery possible

### Scalability
- **Data Growth**: Database can handle millions of records efficiently
- **Partitioning**: Can partition tables by date/block number
- **Replication**: Can replicate for read scaling

## Rollback Plan

If issues occur:
1. Services still have JSON reading code (not removed yet)
2. JSON files are preserved until migration is confirmed
3. Can switch back by updating service configurations

## Next Steps

1. **Immediate**:
   - Run migration script
   - Update data-collector.js to use database
   - Test all explorer endpoints

2. **Within 24 Hours**:
   - Monitor performance and errors
   - Update remaining services
   - Create database backup

3. **After Confirmation** (1 week):
   - Delete JSON files
   - Remove JSON handling code
   - Optimize database queries

## Technical Contact
For issues or questions about this migration, contact the DevOps team. 