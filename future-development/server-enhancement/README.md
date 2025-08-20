# Server Enhancement - Production Architecture

## 🏗️ **Architecture Overview**

Migration of the server from JSON-based storage to a production-ready architecture with PostgreSQL, enhanced logging, structured services, and modern API design aligned with admin panel and PendScan enhancements.

## 📊 **Current State Analysis**

### **Existing Server Architecture**
```typescript
// Current Structure (server/)
├── index.js                     # Monolithic server (1276 lines)
├── routes/                      # API endpoints (14 route files)
├── services/                    # Business logic (10 service files)
├── utils/                       # Utility functions
├── middleware/                  # Security and session middleware
├── explorer-data/               # JSON-based blockchain data
├── server-logs.json             # Basic logging (500 entries max)
├── wallet-db.json               # User wallet mappings
└── admin-*.json                 # Admin data files
```

### **Current Limitations**
```typescript
Current Issues: {
  architecture: "Monolithic index.js with 1276 lines",
  logging: "Basic JSON logging, 500 entries max",
  dataStorage: "JSON files without ACID properties",
  scalability: "Single-threaded, no clustering",
  monitoring: "Limited error tracking and metrics",
  documentation: "Minimal API and service documentation",
  testing: "No test coverage for critical paths",
  deployment: "Manual deployment, no CI/CD"
}

Production Requirements: {
  scalability: "Handle 20000+ concurrent users",
  reliability: "99.9% uptime with proper monitoring",
  performance: "Sub-200ms API response times",
  security: "Enhanced authentication and audit trails",
  maintainability: "Modular architecture with proper testing",
  observability: "Comprehensive logging and metrics"
}
```

## 🚀 **Target Architecture**

### **Production Server Structure**

```typescript
// Enhanced Server Structure
server/
├── src/                         # Source code organization
│   ├── app.js                   # Express app configuration
│   ├── server.js                # Server startup and clustering
│   ├── config/                  # Configuration management
│   │   ├── database.js          # PostgreSQL configuration
│   │   ├── redis.js             # Redis configuration
│   │   ├── logging.js           # Winston logging configuration
│   │   └── environments/        # Environment-specific configs
│   │       ├── development.js
│   │       ├── staging.js
│   │       └── production.js
│   ├── controllers/             # Route controllers (business logic)
│   │   ├── auth.controller.js
│   │   ├── wallet.controller.js
│   │   ├── kyc.controller.js
│   │   ├── admin.controller.js
│   │   ├── explorer.controller.js
│   │   └── health.controller.js
│   ├── services/                # Enhanced business services
│   │   ├── database/
│   │   │   ├── user.service.js
│   │   │   ├── asset.service.js
│   │   │   └── transaction.service.js
│   │   ├── blockchain/
│   │   │   ├── blockchain.service.js
│   │   │   ├── contract.service.js
│   │   │   └── event.service.js
│   │   ├── logging/
│   │   │   ├── audit.service.js
│   │   │   ├── metrics.service.js
│   │   │   └── alerting.service.js
│   │   ├── cache/
│   │   │   ├── redis.service.js
│   │   │   └── session.service.js
│   │   └── external/
│   │       ├── sms.service.js
│   │       └── storage.service.js
│   ├── models/                  # Database models and schemas
│   │   ├── User.js
│   │   ├── Asset.js
│   │   ├── Transaction.js
│   │   ├── AdminLog.js
│   │   └── ServerMetrics.js
│   ├── middleware/              # Enhanced middleware
│   │   ├── auth.middleware.js
│   │   ├── validation.middleware.js
│   │   ├── logging.middleware.js
│   │   ├── security.middleware.js
│   │   ├── rateLimit.middleware.js
│   │   └── metrics.middleware.js
│   ├── routes/                  # Organized route definitions
│   │   ├── v1/                  # API versioning
│   │   │   ├── auth.routes.js
│   │   │   ├── wallet.routes.js
│   │   │   ├── kyc.routes.js
│   │   │   ├── admin.routes.js
│   │   │   ├── explorer.routes.js
│   │   │   └── health.routes.js
│   │   └── index.js             # Route aggregation
│   ├── utils/                   # Utility functions
│   │   ├── validators.js
│   │   ├── formatters.js
│   │   ├── encryption.js
│   │   ├── constants.js
│   │   └── helpers.js
│   ├── database/                # Database management
│   │   ├── migrations/          # Schema migrations
│   │   │   ├── 001_initial_schema.sql
│   │   │   ├── 002_enhanced_logging.sql
│   │   │   └── 003_performance_indexes.sql
│   │   ├── seeds/               # Initial data
│   │   │   ├── admin_users.js
│   │   │   └── system_config.js
│   │   ├── connection.js        # Database connection pool
│   │   └── query-builder.js     # Query building utilities
│   └── workers/                 # Background job workers
│       ├── blockchain-monitor.js
│       ├── metrics-collector.js
│       └── cleanup-worker.js
├── tests/                       # Comprehensive test suite
│   ├── unit/                    # Unit tests
│   │   ├── services/
│   │   ├── controllers/
│   │   └── utils/
│   ├── integration/             # Integration tests
│   │   ├── api/
│   │   ├── database/
│   │   └── blockchain/
│   ├── e2e/                     # End-to-end tests
│   │   └── api-flows/
│   └── fixtures/                # Test data
├── docs/                        # Server documentation
│   ├── api/                     # API documentation
│   │   ├── openapi.yaml
│   │   └── endpoints/
│   ├── architecture/            # Architecture documentation
│   │   ├── system-design.md
│   │   ├── database-schema.md
│   │   └── service-architecture.md
│   ├── deployment/              # Deployment guides
│   │   ├── docker.md
│   │   ├── kubernetes.md
│   │   └── monitoring.md
│   └── development/             # Development guides
│       ├── setup.md
│       ├── testing.md
│       └── contributing.md
├── scripts/                     # Deployment and utility scripts
│   ├── deploy/
│   │   ├── production.sh
│   │   └── staging.sh
│   ├── database/
│   │   ├── migrate.js
│   │   ├── seed.js
│   │   └── backup.js
│   └── monitoring/
│       ├── health-check.js
│       └── performance-test.js
├── logs/                        # Log files (production)
├── uploads/                     # File uploads (KYC documents)
├── package.json
├── docker-compose.yml           # Local development
├── docker-compose.prod.yml      # Production deployment
├── Dockerfile                   # Production container
├── .env.example                 # Environment configuration
└── ecosystem.config.js          # PM2 configuration
```

## 🗄️ **Enhanced Database Architecture**

### **PostgreSQL Schema for Production**

```sql
-- Core Users & Identity Management
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  phone_hash VARCHAR(64) UNIQUE NOT NULL,
  blockchain_address VARCHAR(42) UNIQUE NOT NULL,
  tier INTEGER DEFAULT 0 CHECK (tier >= 0 AND tier <= 5),
  status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'suspended', 'closed')),
  email VARCHAR(255),
  country_code VARCHAR(3),
  registration_ip INET,
  last_login_at TIMESTAMPTZ,
  login_count INTEGER DEFAULT 0,
  failed_login_attempts INTEGER DEFAULT 0,
  locked_until TIMESTAMPTZ,
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enhanced Server Logging with Full Audit Trail
CREATE TABLE server_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  timestamp TIMESTAMPTZ DEFAULT NOW(),
  level VARCHAR(10) NOT NULL CHECK (level IN ('error', 'warn', 'info', 'debug', 'trace')),
  category VARCHAR(50) NOT NULL, -- 'API', 'BLOCKCHAIN', 'AUTH', 'KYC', 'ADMIN', 'SECURITY'
  event_type VARCHAR(50) NOT NULL,
  user_id UUID REFERENCES users(id),
  admin_id UUID REFERENCES admin_users(id),
  session_id VARCHAR(100),
  request_id VARCHAR(36),
  correlation_id VARCHAR(36), -- For tracing across services
  ip_address INET,
  user_agent TEXT,
  endpoint VARCHAR(255),
  method VARCHAR(10),
  status_code INTEGER,
  response_time_ms INTEGER,
  request_size_bytes INTEGER,
  response_size_bytes INTEGER,
  error_code VARCHAR(50),
  error_message TEXT,
  error_stack TEXT,
  request_data JSONB,
  response_data JSONB,
  metadata JSONB DEFAULT '{}',
  
  -- Indexing for performance
  CONSTRAINT valid_http_method CHECK (method IN ('GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS')),
  CONSTRAINT valid_status_code CHECK (status_code >= 100 AND status_code <= 599)
);

-- API Performance Metrics with Time-Series Data
CREATE TABLE api_metrics (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  timestamp TIMESTAMPTZ DEFAULT NOW(),
  endpoint VARCHAR(255) NOT NULL,
  method VARCHAR(10) NOT NULL,
  response_time_ms INTEGER,
  status_code INTEGER,
  request_size_bytes INTEGER,
  response_size_bytes INTEGER,
  cache_hit BOOLEAN DEFAULT false,
  user_id UUID REFERENCES users(id),
  error_type VARCHAR(50),
  database_query_time_ms INTEGER,
  external_api_time_ms INTEGER,
  concurrent_requests INTEGER,
  memory_usage_mb DECIMAL(10,2),
  cpu_usage_percent DECIMAL(5,2)
);

-- System Health and Resource Metrics
CREATE TABLE system_metrics (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  timestamp TIMESTAMPTZ DEFAULT NOW(),
  server_instance VARCHAR(50) NOT NULL,
  metric_type VARCHAR(50) NOT NULL, -- 'cpu', 'memory', 'disk', 'network', 'database'
  metric_name VARCHAR(100) NOT NULL,
  value DECIMAL(18,6),
  unit VARCHAR(20),
  threshold_warning DECIMAL(18,6),
  threshold_critical DECIMAL(18,6),
  alert_sent BOOLEAN DEFAULT false,
  metadata JSONB DEFAULT '{}'
);

-- Blockchain Event Processing
CREATE TABLE blockchain_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  timestamp TIMESTAMPTZ DEFAULT NOW(),
  event_type VARCHAR(50) NOT NULL,
  contract_address VARCHAR(42),
  transaction_hash VARCHAR(66),
  block_number BIGINT,
  block_hash VARCHAR(66),
  log_index INTEGER,
  event_signature VARCHAR(66),
  decoded_data JSONB,
  raw_data TEXT,
  processed BOOLEAN DEFAULT false,
  processing_attempts INTEGER DEFAULT 0,
  last_processing_error TEXT,
  processed_at TIMESTAMPTZ
);

-- Admin Activity Audit Trail
CREATE TABLE admin_audit_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  timestamp TIMESTAMPTZ DEFAULT NOW(),
  admin_id UUID REFERENCES admin_users(id),
  action VARCHAR(100) NOT NULL,
  resource_type VARCHAR(50), -- 'user', 'asset', 'kyc', 'system'
  resource_id VARCHAR(255),
  old_values JSONB,
  new_values JSONB,
  ip_address INET,
  user_agent TEXT,
  session_id VARCHAR(100),
  justification TEXT, -- Why the action was taken
  approval_required BOOLEAN DEFAULT false,
  approved_by UUID REFERENCES admin_users(id),
  approved_at TIMESTAMPTZ
);

-- Security Events and Threat Detection
CREATE TABLE security_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  timestamp TIMESTAMPTZ DEFAULT NOW(),
  event_type VARCHAR(50) NOT NULL, -- 'failed_login', 'suspicious_activity', 'rate_limit_exceeded'
  severity VARCHAR(10) CHECK (severity IN ('low', 'medium', 'high', 'critical')),
  user_id UUID REFERENCES users(id),
  ip_address INET,
  user_agent TEXT,
  endpoint VARCHAR(255),
  threat_indicators JSONB,
  automatic_action_taken VARCHAR(100), -- 'blocked', 'rate_limited', 'flagged'
  investigated BOOLEAN DEFAULT false,
  investigated_by UUID REFERENCES admin_users(id),
  investigation_notes TEXT,
  false_positive BOOLEAN DEFAULT false
);

-- Performance Indexes for Production Scale
CREATE INDEX idx_server_logs_timestamp_desc ON server_logs(timestamp DESC);
CREATE INDEX idx_server_logs_category_timestamp ON server_logs(category, timestamp DESC);
CREATE INDEX idx_server_logs_user_timestamp ON server_logs(user_id, timestamp DESC) WHERE user_id IS NOT NULL;
CREATE INDEX idx_server_logs_endpoint_method ON server_logs(endpoint, method);
CREATE INDEX idx_server_logs_error_level ON server_logs(level, timestamp DESC) WHERE level IN ('error', 'warn');

CREATE INDEX idx_api_metrics_endpoint_time ON api_metrics(endpoint, timestamp DESC);
CREATE INDEX idx_api_metrics_performance ON api_metrics(response_time_ms, timestamp DESC);
CREATE INDEX idx_api_metrics_errors ON api_metrics(status_code, timestamp DESC) WHERE status_code >= 400;

CREATE INDEX idx_system_metrics_instance_type ON system_metrics(server_instance, metric_type, timestamp DESC);
CREATE INDEX idx_system_metrics_alerts ON system_metrics(alert_sent, timestamp DESC) WHERE alert_sent = false;

CREATE INDEX idx_blockchain_events_processed ON blockchain_events(processed, timestamp DESC);
CREATE INDEX idx_blockchain_events_contract ON blockchain_events(contract_address, event_type, timestamp DESC);

CREATE INDEX idx_admin_audit_resource ON admin_audit_logs(resource_type, resource_id, timestamp DESC);
CREATE INDEX idx_admin_audit_admin ON admin_audit_logs(admin_id, timestamp DESC);

CREATE INDEX idx_security_events_severity ON security_events(severity, timestamp DESC);
CREATE INDEX idx_security_events_ip ON security_events(ip_address, timestamp DESC);
CREATE INDEX idx_security_events_investigated ON security_events(investigated, timestamp DESC) WHERE investigated = false;

-- Partitioning for Log Tables (for production scale)
-- Partition by month for better performance
-- Example: CREATE TABLE server_logs_2025_01 PARTITION OF server_logs FOR VALUES FROM ('2025-01-01') TO ('2025-02-01');
```

### **Redis Caching Architecture**

```typescript
// Enhanced Caching Strategy
class CacheService {
  constructor() {
    this.redis = new Redis({
      host: process.env.REDIS_HOST,
      port: process.env.REDIS_PORT,
      password: process.env.REDIS_PASSWORD,
      db: 0,
      retryDelayOnFailover: 100,
      maxRetriesPerRequest: 3,
      lazyConnect: true
    });
    
    this.defaultTTL = 300; // 5 minutes
    this.longTTL = 3600;   // 1 hour
    this.shortTTL = 30;    // 30 seconds
  }

  // Cache Strategies by Data Type
  async cacheApiResponse(endpoint, method, params, data, ttl = this.defaultTTL) {
    const key = `api:${method}:${endpoint}:${this.hashParams(params)}`;
    await this.redis.setex(key, ttl, JSON.stringify({
      data,
      cached_at: Date.now(),
      ttl
    }));
  }

  async getCachedApiResponse(endpoint, method, params) {
    const key = `api:${method}:${endpoint}:${this.hashParams(params)}`;
    const cached = await this.redis.get(key);
    
    if (cached) {
      const parsed = JSON.parse(cached);
      return {
        ...parsed,
        cache_hit: true,
        age: Date.now() - parsed.cached_at
      };
    }
    
    return null;
  }

  // User Session Management
  async cacheUserSession(sessionId, userData, ttl = 86400) { // 24 hours
    await this.redis.setex(`session:${sessionId}`, ttl, JSON.stringify({
      ...userData,
      last_accessed: Date.now()
    }));
  }

  // Blockchain Data Caching (short TTL for real-time data)
  async cacheBlockchainData(type, identifier, data, ttl = this.shortTTL) {
    const key = `blockchain:${type}:${identifier}`;
    await this.redis.setex(key, ttl, JSON.stringify({
      data,
      block_number: data.blockNumber,
      cached_at: Date.now()
    }));
  }

  // Rate Limiting
  async checkRateLimit(identifier, limit, windowSeconds) {
    const key = `rate_limit:${identifier}`;
    const current = await this.redis.incr(key);
    
    if (current === 1) {
      await this.redis.expire(key, windowSeconds);
    }
    
    return {
      current,
      limit,
      remaining: Math.max(0, limit - current),
      resetTime: await this.redis.ttl(key)
    };
  }

  // Performance Metrics Caching
  async cacheMetrics(metricType, data, ttl = 60) { // 1 minute
    const key = `metrics:${metricType}:${Math.floor(Date.now() / 60000)}`;
    await this.redis.setex(key, ttl, JSON.stringify(data));
  }

  // Utility Methods
  hashParams(params) {
    const crypto = require('crypto');
    return crypto.createHash('md5').update(JSON.stringify(params)).digest('hex');
  }

  async invalidatePattern(pattern) {
    const keys = await this.redis.keys(pattern);
    if (keys.length > 0) {
      await this.redis.del(keys);
    }
    return keys.length;
  }
}

module.exports = new CacheService();
```

## 📋 **Enhanced Logging System**

### **Winston Configuration with Multiple Transports**

```typescript
// src/config/logging.js
const winston = require('winston');
const DailyRotateFile = require('winston-daily-rotate-file');
const { ElasticsearchTransport } = require('winston-elasticsearch');

// Custom log format with structured data
const logFormat = winston.format.combine(
  winston.format.timestamp({
    format: 'YYYY-MM-DD HH:mm:ss.SSS'
  }),
  winston.format.errors({ stack: true }),
  winston.format.json(),
  winston.format.printf(({ timestamp, level, message, ...meta }) => {
    const logEntry = {
      '@timestamp': timestamp,
      level: level.toUpperCase(),
      message,
      service: 'pend-server',
      version: process.env.npm_package_version || '1.0.0',
      environment: process.env.NODE_ENV || 'development',
      server_instance: process.env.SERVER_INSTANCE || 'local',
      process_id: process.pid,
      ...meta
    };

    // Add performance markers
    if (meta.responseTime) {
      logEntry.performance = {
        response_time_ms: meta.responseTime,
        slow_query: meta.responseTime > 1000,
        very_slow_query: meta.responseTime > 5000
      };
    }

    return JSON.stringify(logEntry);
  })
);

// Create transports array
const transports = [
  // Console output for development
  new winston.transports.Console({
    level: process.env.LOG_LEVEL || 'info',
    format: winston.format.combine(
      winston.format.colorize(),
      winston.format.printf(({ timestamp, level, message, requestId, userId, endpoint, responseTime }) => {
        let output = `${timestamp} [${level}] ${message}`;
        
        if (requestId) output += ` | RequestID: ${requestId}`;
        if (userId) output += ` | UserID: ${userId.substring(0, 8)}...`;
        if (endpoint) output += ` | ${endpoint}`;
        if (responseTime) output += ` | ${responseTime}ms`;
        
        return output;
      })
    )
  }),

  // Daily rotating file for all logs
  new DailyRotateFile({
    filename: 'logs/server-%DATE%.log',
    datePattern: 'YYYY-MM-DD',
    maxSize: '100m',
    maxFiles: '30d',
    level: 'info',
    format: logFormat
  }),

  // Separate file for errors
  new DailyRotateFile({
    filename: 'logs/server-error-%DATE%.log',
    datePattern: 'YYYY-MM-DD',
    maxSize: '50m',
    maxFiles: '90d',
    level: 'error',
    format: logFormat
  }),

  // Performance logs
  new DailyRotateFile({
    filename: 'logs/server-performance-%DATE%.log',
    datePattern: 'YYYY-MM-DD',
    maxSize: '50m',
    maxFiles: '7d',
    level: 'info',
    format: logFormat,
    // Only log entries with performance data
    filter: (info) => info.category === 'PERFORMANCE' || info.responseTime
  }),

  // Security logs
  new DailyRotateFile({
    filename: 'logs/server-security-%DATE%.log',
    datePattern: 'YYYY-MM-DD',
    maxSize: '20m',
    maxFiles: '180d',
    level: 'warn',
    format: logFormat,
    filter: (info) => info.category === 'SECURITY' || info.eventType?.includes('SECURITY')
  })
];

// Add database transport for production
if (process.env.NODE_ENV === 'production') {
  transports.push(new DatabaseTransport({
    level: 'info',
    tableName: 'server_logs'
  }));
}

// Add Elasticsearch transport if configured
if (process.env.ELASTICSEARCH_URL) {
  transports.push(new ElasticsearchTransport({
    level: 'info',
    clientOpts: {
      node: process.env.ELASTICSEARCH_URL
    },
    index: 'pend-server-logs'
  }));
}

// Create logger instance
const logger = winston.createLogger({
  format: logFormat,
  transports,
  exitOnError: false,
  
  // Handle uncaught exceptions and unhandled rejections
  exceptionHandlers: [
    new winston.transports.File({ filename: 'logs/exceptions.log' })
  ],
  rejectionHandlers: [
    new winston.transports.File({ filename: 'logs/rejections.log' })
  ]
});

// Custom database transport for structured logging
class DatabaseTransport extends winston.Transport {
  constructor(options) {
    super(options);
    this.name = 'database';
    this.level = options.level || 'info';
    this.tableName = options.tableName || 'server_logs';
    this.batchSize = options.batchSize || 100;
    this.flushInterval = options.flushInterval || 5000; // 5 seconds
    this.batch = [];
    this.timer = null;
  }

  log(info, callback) {
    setImmediate(() => this.emit('logged', info));

    // Add to batch
    this.batch.push(this.formatForDatabase(info));

    // Flush if batch is full or on error
    if (this.batch.length >= this.batchSize || info.level === 'error') {
      this.flush();
    } else if (!this.timer) {
      // Set timer for periodic flush
      this.timer = setTimeout(() => this.flush(), this.flushInterval);
    }

    callback();
  }

  async flush() {
    if (this.batch.length === 0) return;

    const batch = [...this.batch];
    this.batch = [];
    
    if (this.timer) {
      clearTimeout(this.timer);
      this.timer = null;
    }

    try {
      await this.saveBatchToDatabase(batch);
    } catch (error) {
      console.error('Failed to save logs to database:', error);
      // Could implement retry logic here
    }
  }

  formatForDatabase(logEntry) {
    return {
      timestamp: logEntry.timestamp || new Date().toISOString(),
      level: logEntry.level,
      category: logEntry.category || 'GENERAL',
      event_type: logEntry.eventType || 'LOG',
      user_id: logEntry.userId || null,
      admin_id: logEntry.adminId || null,
      session_id: logEntry.sessionId || null,
      request_id: logEntry.requestId || null,
      correlation_id: logEntry.correlationId || null,
      ip_address: logEntry.ipAddress || null,
      user_agent: logEntry.userAgent || null,
      endpoint: logEntry.endpoint || null,
      method: logEntry.method || null,
      status_code: logEntry.statusCode || null,
      response_time_ms: logEntry.responseTime || null,
      request_size_bytes: logEntry.requestSize || null,
      response_size_bytes: logEntry.responseSize || null,
      error_code: logEntry.errorCode || null,
      error_message: logEntry.error?.message || logEntry.message,
      error_stack: logEntry.error?.stack || logEntry.stack || null,
      request_data: logEntry.requestData ? JSON.stringify(logEntry.requestData) : null,
      response_data: logEntry.responseData ? JSON.stringify(logEntry.responseData) : null,
      metadata: JSON.stringify(logEntry.metadata || {})
    };
  }

  async saveBatchToDatabase(batch) {
    const db = require('../database/connection');
    
    const query = `
      INSERT INTO server_logs (
        timestamp, level, category, event_type, user_id, admin_id,
        session_id, request_id, correlation_id, ip_address, user_agent,
        endpoint, method, status_code, response_time_ms, request_size_bytes,
        response_size_bytes, error_code, error_message, error_stack,
        request_data, response_data, metadata
      ) VALUES ${batch.map((_, i) => `($${i * 23 + 1}, $${i * 23 + 2}, $${i * 23 + 3}, $${i * 23 + 4}, $${i * 23 + 5}, $${i * 23 + 6}, $${i * 23 + 7}, $${i * 23 + 8}, $${i * 23 + 9}, $${i * 23 + 10}, $${i * 23 + 11}, $${i * 23 + 12}, $${i * 23 + 13}, $${i * 23 + 14}, $${i * 23 + 15}, $${i * 23 + 16}, $${i * 23 + 17}, $${i * 23 + 18}, $${i * 23 + 19}, $${i * 23 + 20}, $${i * 23 + 21}, $${i * 23 + 22}, $${i * 23 + 23})`).join(', ')}
    `;

    const values = batch.flatMap(entry => [
      entry.timestamp, entry.level, entry.category, entry.event_type,
      entry.user_id, entry.admin_id, entry.session_id, entry.request_id,
      entry.correlation_id, entry.ip_address, entry.user_agent,
      entry.endpoint, entry.method, entry.status_code, entry.response_time_ms,
      entry.request_size_bytes, entry.response_size_bytes, entry.error_code,
      entry.error_message, entry.error_stack, entry.request_data,
      entry.response_data, entry.metadata
    ]);

    await db.query(query, values);
  }
}

// Export logger with helper methods
logger.addMeta = (meta) => logger.defaultMeta = { ...logger.defaultMeta, ...meta };

// Performance logging helper
logger.perf = (message, startTime, meta = {}) => {
  const responseTime = Date.now() - startTime;
  logger.info(message, {
    ...meta,
    category: 'PERFORMANCE',
    responseTime,
    slow: responseTime > 1000,
    verySlow: responseTime > 5000
  });
};

// Security logging helper
logger.security = (event, details = {}) => {
  logger.warn(event, {
    ...details,
    category: 'SECURITY',
    eventType: `SECURITY_${event.toUpperCase()}`
  });
};

// Business event logging helper
logger.business = (event, details = {}) => {
  logger.info(event, {
    ...details,
    category: 'BUSINESS',
    eventType: event.toUpperCase()
  });
};

module.exports = logger;
```

This comprehensive server enhancement plan provides:

1. **🏗️ Production Architecture**: Modular structure with proper separation of concerns
2. **📊 Enhanced Database**: PostgreSQL with proper indexing and partitioning for scale
3. **⚡ Caching Strategy**: Redis implementation with multiple cache layers
4. **📋 Advanced Logging**: Winston with multiple transports and structured data
5. **🔒 Security Features**: Audit trails, threat detection, and compliance logging
6. **📈 Performance Monitoring**: Metrics collection and performance optimization
7. **🚀 Scalability**: Clustering, load balancing, and horizontal scaling preparation

The next files will cover implementation details, migration scripts, and deployment guides. 