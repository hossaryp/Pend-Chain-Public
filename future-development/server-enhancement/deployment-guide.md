# Server Deployment Guide

## 🚀 **Production Deployment Overview**

Comprehensive guide for deploying the enhanced Pend server architecture to production environments with Docker, monitoring, and high availability configurations.

## 📋 **Prerequisites**

### **System Requirements**
- **CPU**: 4+ cores (8+ recommended for production)
- **RAM**: 8GB minimum (16GB+ recommended)
- **Storage**: 100GB+ SSD storage
- **Network**: High-speed internet connection with static IP
- **OS**: Ubuntu 20.04 LTS or similar Linux distribution

### **Software Dependencies**
```bash
# Docker and Docker Compose
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo curl -L "https://github.com/docker/compose/releases/download/v2.21.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Node.js (for development)
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# PostgreSQL Client (for management)
sudo apt-get install -y postgresql-client

# Redis Client (for management)
sudo apt-get install -y redis-tools

# Nginx (for reverse proxy)
sudo apt-get install -y nginx

# PM2 (for process management - alternative to Docker)
sudo npm install -g pm2
```

## 🐳 **Docker Configuration**

### **Production Dockerfile**
```dockerfile
# server/Dockerfile
FROM node:18-alpine AS builder

# Install dependencies for native modules
RUN apk add --no-cache python3 make g++

WORKDIR /app

# Copy package files
COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force

# Copy source code
COPY . .

# Create non-root user
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nodejs -u 1001

# Set ownership
RUN chown -R nodejs:nodejs /app
USER nodejs

# Expose port
EXPOSE 3001

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3001/api/v1/health || exit 1

# Start command
CMD ["npm", "start"]
```

### **Production Docker Compose**
```yaml
# server/docker-compose.prod.yml
version: '3.8'

services:
  # Main Application Server
  server:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: pend-server
    restart: unless-stopped
    ports:
      - "3001:3001"
    environment:
      - NODE_ENV=production
      - SERVER_INSTANCE=prod-docker-1
      - DB_HOST=postgres
      - DB_PORT=5432
      - DB_NAME=${DB_NAME:-pend_production}
      - DB_USER=${DB_USER:-pend_user}
      - DB_PASSWORD=${DB_PASSWORD}
      - REDIS_HOST=redis
      - REDIS_PORT=6379
      - REDIS_PASSWORD=${REDIS_PASSWORD}
      - LOG_LEVEL=${LOG_LEVEL:-info}
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
    volumes:
      - ./logs:/app/logs
      - ./uploads:/app/uploads
    networks:
      - pend-network
    deploy:
      resources:
        limits:
          memory: 2G
          cpus: '1.0'
        reservations:
          memory: 1G
          cpus: '0.5'

  # PostgreSQL Database
  postgres:
    image: postgres:15-alpine
    container_name: pend-postgres
    restart: unless-stopped
    environment:
      - POSTGRES_DB=${DB_NAME:-pend_production}
      - POSTGRES_USER=${DB_USER:-pend_user}
      - POSTGRES_PASSWORD=${DB_PASSWORD}
      - POSTGRES_INITDB_ARGS=--auth-host=scram-sha-256
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./scripts/database/init.sql:/docker-entrypoint-initdb.d/init.sql:ro
    networks:
      - pend-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${DB_USER:-pend_user} -d ${DB_NAME:-pend_production}"]
      interval: 10s
      timeout: 5s
      retries: 5
    deploy:
      resources:
        limits:
          memory: 4G
          cpus: '2.0'
        reservations:
          memory: 2G
          cpus: '1.0'

  # Redis Cache
  redis:
    image: redis:7-alpine
    container_name: pend-redis
    restart: unless-stopped
    command: redis-server --requirepass ${REDIS_PASSWORD}
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
      - ./config/redis.conf:/etc/redis/redis.conf:ro
    networks:
      - pend-network
    healthcheck:
      test: ["CMD", "redis-cli", "--raw", "incr", "ping"]
      interval: 10s
      timeout: 3s
      retries: 5
    deploy:
      resources:
        limits:
          memory: 1G
          cpus: '0.5'

  # Nginx Reverse Proxy
  nginx:
    image: nginx:alpine
    container_name: pend-nginx
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./config/nginx.conf:/etc/nginx/nginx.conf:ro
      - ./config/ssl:/etc/nginx/ssl:ro
      - nginx_logs:/var/log/nginx
    depends_on:
      - server
    networks:
      - pend-network

  # Monitoring - Prometheus
  prometheus:
    image: prom/prometheus:latest
    container_name: pend-prometheus
    restart: unless-stopped
    ports:
      - "9090:9090"
    volumes:
      - ./config/prometheus.yml:/etc/prometheus/prometheus.yml:ro
      - prometheus_data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.console.libraries=/etc/prometheus/console_libraries'
      - '--web.console.templates=/etc/prometheus/consoles'
      - '--storage.tsdb.retention.time=200h'
      - '--web.enable-lifecycle'
    networks:
      - pend-network

  # Monitoring - Grafana
  grafana:
    image: grafana/grafana:latest
    container_name: pend-grafana
    restart: unless-stopped
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=${GRAFANA_PASSWORD:-admin}
    volumes:
      - grafana_data:/var/lib/grafana
      - ./config/grafana/dashboards:/etc/grafana/provisioning/dashboards:ro
      - ./config/grafana/datasources:/etc/grafana/provisioning/datasources:ro
    networks:
      - pend-network

volumes:
  postgres_data:
    driver: local
  redis_data:
    driver: local
  prometheus_data:
    driver: local
  grafana_data:
    driver: local
  nginx_logs:
    driver: local

networks:
  pend-network:
    driver: bridge
```

## ⚙️ **Environment Configuration**

### **Production Environment Variables**
```bash
# server/.env.production
# Application Configuration
NODE_ENV=production
SERVER_INSTANCE=prod-1
PORT=3001
API_VERSION=v1

# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=pend_production
DB_USER=pend_user
DB_PASSWORD=your_secure_database_password
DB_SSL=true
DB_MAX_CONNECTIONS=20
DB_IDLE_TIMEOUT=30000
DB_CONNECTION_TIMEOUT=2000

# Redis Configuration
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=your_secure_redis_password
REDIS_DB=0
REDIS_MAX_RETRIES=3

# Blockchain Configuration
RPC_URL=http://127.0.0.1:8545
CHAIN_ID=7777
VALIDATOR_PRIVATE_KEY=your_validator_private_key

# Contract Addresses
SMART_WALLET_FACTORY_ADDRESS=0x0f84B067f6C71861E705aA45233854F5Db33926d
CONSENT_MANAGER_ADDRESS=0x5103f499A89127068c20711974572563c3dCb819
IDENTITY_REGISTRY_ADDRESS=0x074C5a96106b2Dcefb74b174034bd356943b2723
EGP_STABLECOIN_ADDRESS=your_egp_contract_address
HVT_ADDRESS=your_hvt_contract_address
HARVEST_POOL_ADDRESS=your_harvest_pool_address

# Security Configuration
JWT_SECRET=your_jwt_secret_key
JWT_EXPIRES_IN=24h
BCRYPT_ROUNDS=12
SESSION_SECRET=your_session_secret

# WebAuthn Configuration
RP_ID=your-domain.com
ORIGIN=https://your-domain.com
RP_NAME="Pend Wallet Production"

# External Services
TWILIO_SID=your_twilio_sid
TWILIO_TOKEN=your_twilio_token
TWILIO_FROM=your_phone_number

# Logging Configuration
LOG_LEVEL=info
LOG_MAX_FILES=30
LOG_MAX_SIZE=100m

# Monitoring Configuration
METRICS_ENABLED=true
HEALTH_CHECK_INTERVAL=30000
ALERT_WEBHOOK_URL=your_slack_webhook_url

# Performance Configuration
RATE_LIMIT_WINDOW=15
RATE_LIMIT_MAX_REQUESTS=100
CACHE_TTL_DEFAULT=300
CACHE_TTL_LONG=3600
CACHE_TTL_SHORT=30

# File Upload Configuration
UPLOAD_MAX_SIZE=10485760
UPLOAD_ALLOWED_TYPES=image/jpeg,image/png,application/pdf
UPLOAD_PATH=/app/uploads

# SSL/TLS Configuration
SSL_CERT_PATH=/etc/ssl/certs/server.crt
SSL_KEY_PATH=/etc/ssl/private/server.key

# Backup Configuration
BACKUP_ENABLED=true
BACKUP_SCHEDULE="0 2 * * *"
BACKUP_RETENTION_DAYS=30
BACKUP_S3_BUCKET=your-backup-bucket
```

### **Nginx Configuration**
```nginx
# server/config/nginx.conf
events {
    worker_connections 1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    # Logging format
    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for" '
                    'rt=$request_time uct="$upstream_connect_time" '
                    'uht="$upstream_header_time" urt="$upstream_response_time"';

    access_log /var/log/nginx/access.log main;
    error_log /var/log/nginx/error.log warn;

    # Basic Settings
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;
    client_max_body_size 10M;

    # Gzip Compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_types
        text/plain
        text/css
        text/xml
        text/javascript
        application/json
        application/javascript
        application/xml+rss
        application/atom+xml
        image/svg+xml;

    # Rate Limiting
    limit_req_zone $binary_remote_addr zone=api:10m rate=10r/s;
    limit_req_zone $binary_remote_addr zone=auth:10m rate=5r/s;

    # Upstream servers
    upstream pend_server {
        least_conn;
        server server:3001 max_fails=3 fail_timeout=30s;
        # Add more servers for load balancing
        # server server2:3001 max_fails=3 fail_timeout=30s;
    }

    # Main server configuration
    server {
        listen 80;
        server_name your-domain.com www.your-domain.com;
        
        # Redirect HTTP to HTTPS
        return 301 https://$server_name$request_uri;
    }

    # HTTPS server configuration
    server {
        listen 443 ssl http2;
        server_name your-domain.com www.your-domain.com;

        # SSL Configuration
        ssl_certificate /etc/nginx/ssl/server.crt;
        ssl_certificate_key /etc/nginx/ssl/server.key;
        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384;
        ssl_prefer_server_ciphers off;
        ssl_session_cache shared:SSL:10m;
        ssl_session_timeout 10m;

        # Security Headers
        add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
        add_header X-Content-Type-Options nosniff always;
        add_header X-Frame-Options DENY always;
        add_header X-XSS-Protection "1; mode=block" always;
        add_header Referrer-Policy "strict-origin-when-cross-origin" always;

        # API endpoints
        location /api/ {
            limit_req zone=api burst=20 nodelay;
            
            proxy_pass http://pend_server;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_cache_bypass $http_upgrade;
            
            # Timeouts
            proxy_connect_timeout 60s;
            proxy_send_timeout 60s;
            proxy_read_timeout 60s;
        }

        # Authentication endpoints (stricter rate limiting)
        location /api/auth/ {
            limit_req zone=auth burst=10 nodelay;
            
            proxy_pass http://pend_server;
            proxy_http_version 1.1;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }

        # Health check endpoint
        location /api/v1/health {
            proxy_pass http://pend_server;
            access_log off;
        }

        # Static files (if serving from nginx)
        location /static/ {
            alias /var/www/static/;
            expires 1y;
            add_header Cache-Control "public, immutable";
        }

        # Block access to sensitive files
        location ~ /\. {
            deny all;
            access_log off;
            log_not_found off;
        }
    }
}
```

## 📊 **Monitoring Configuration**

### **Prometheus Configuration**
```yaml
# server/config/prometheus.yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

rule_files:
  # - "first_rules.yml"
  # - "second_rules.yml"

scrape_configs:
  # Pend Server metrics
  - job_name: 'pend-server'
    static_configs:
      - targets: ['server:3001']
    metrics_path: '/api/v1/health/metrics'
    scrape_interval: 30s

  # Node.js application metrics
  - job_name: 'node-exporter'
    static_configs:
      - targets: ['localhost:9100']

  # PostgreSQL metrics
  - job_name: 'postgres-exporter'
    static_configs:
      - targets: ['localhost:9187']

  # Redis metrics
  - job_name: 'redis-exporter'
    static_configs:
      - targets: ['localhost:9121']

  # Nginx metrics
  - job_name: 'nginx-exporter'
    static_configs:
      - targets: ['localhost:9113']
```

## 🔧 **PM2 Configuration (Alternative to Docker)**

### **PM2 Ecosystem File**
```javascript
// server/ecosystem.config.js
module.exports = {
  apps: [
    {
      name: 'pend-server',
      script: './src/server.js',
      instances: 'max', // Use all CPU cores
      exec_mode: 'cluster',
      env: {
        NODE_ENV: 'development',
        PORT: 3001
      },
      env_production: {
        NODE_ENV: 'production',
        PORT: 3001,
        LOG_LEVEL: 'info'
      },
      // Logging
      log_file: './logs/combined.log',
      out_file: './logs/out.log',
      error_file: './logs/error.log',
      log_date_format: 'YYYY-MM-DD HH:mm:ss Z',
      
      // Monitoring
      monitoring: false, // Set to true for PM2 Plus
      
      // Auto-restart configuration
      max_memory_restart: '1G',
      restart_delay: 4000,
      max_restarts: 10,
      min_uptime: '10s',
      
      // Health monitoring
      health_check_grace_period: 3000,
      health_check_fatal_exceptions: true
    },
    
    // Background workers
    {
      name: 'blockchain-monitor',
      script: './src/workers/blockchain-monitor.js',
      instances: 1,
      env_production: {
        NODE_ENV: 'production'
      }
    },
    
    {
      name: 'metrics-collector',
      script: './src/workers/metrics-collector.js',
      instances: 1,
      env_production: {
        NODE_ENV: 'production'
      }
    }
  ],

  deploy: {
    production: {
      user: 'pend',
      host: 'your-server.com',
      ref: 'origin/main',
      repo: 'git@github.com:your-org/pend-server.git',
      path: '/var/www/pend-server',
      'pre-deploy-local': '',
      'post-deploy': 'npm install && npm run migrate && pm2 reload ecosystem.config.js --env production',
      'pre-setup': ''
    }
  }
};
```

## 🚀 **Deployment Scripts**

### **Complete Deployment Script**
```bash
#!/bin/bash
# server/scripts/deploy/complete-deployment.sh

set -e

# Configuration
DEPLOY_ENV=${1:-production}
BACKUP_ENABLED=${2:-true}
HEALTH_CHECK_RETRIES=30
HEALTH_CHECK_INTERVAL=10

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# Pre-deployment backup
create_backup() {
    if [ "$BACKUP_ENABLED" = "true" ]; then
        log_step "Creating pre-deployment backup..."
        
        # Database backup
        BACKUP_DIR="./backups/$(date +%Y%m%d_%H%M%S)"
        mkdir -p "$BACKUP_DIR"
        
        # PostgreSQL backup
        pg_dump -h localhost -U $DB_USER -d $DB_NAME > "$BACKUP_DIR/database.sql"
        
        # Application files backup
        tar -czf "$BACKUP_DIR/app_files.tar.gz" ./src ./config ./package.json
        
        log_info "Backup created at: $BACKUP_DIR"
    else
        log_warning "Backup skipped"
    fi
}

# Health check function
health_check() {
    local url=$1
    local retries=$2
    local interval=$3
    
    log_step "Performing health check on $url..."
    
    for i in $(seq 1 $retries); do
        if curl -f -s "$url" > /dev/null; then
            log_info "Health check passed"
            return 0
        fi
        
        log_warning "Health check attempt $i/$retries failed, retrying in ${interval}s..."
        sleep $interval
    done
    
    log_error "Health check failed after $retries attempts"
    return 1
}

# Deploy with Docker
deploy_docker() {
    log_step "Deploying with Docker..."
    
    # Build and start services
    docker-compose -f docker-compose.prod.yml build
    docker-compose -f docker-compose.prod.yml up -d
    
    # Wait for services to be ready
    log_step "Waiting for services to be ready..."
    sleep 30
    
    # Health check
    if ! health_check "http://localhost:3001/api/v1/health" $HEALTH_CHECK_RETRIES $HEALTH_CHECK_INTERVAL; then
        log_error "Deployment failed - health check failed"
        return 1
    fi
    
    log_info "Docker deployment completed successfully"
}

# Deploy with PM2
deploy_pm2() {
    log_step "Deploying with PM2..."
    
    # Install dependencies
    npm ci --only=production
    
    # Run database migrations
    npm run migrate
    
    # Start/restart PM2 services
    pm2 start ecosystem.config.js --env $DEPLOY_ENV
    pm2 save
    
    # Health check
    if ! health_check "http://localhost:3001/api/v1/health" $HEALTH_CHECK_RETRIES $HEALTH_CHECK_INTERVAL; then
        log_error "Deployment failed - health check failed"
        return 1
    fi
    
    log_info "PM2 deployment completed successfully"
}

# Post-deployment tasks
post_deployment() {
    log_step "Running post-deployment tasks..."
    
    # Clear caches
    if command -v redis-cli &> /dev/null; then
        redis-cli -a $REDIS_PASSWORD FLUSHDB
        log_info "Redis cache cleared"
    fi
    
    # Send notification (if webhook configured)
    if [ -n "$SLACK_WEBHOOK_URL" ]; then
        curl -X POST -H 'Content-type: application/json' \
            --data '{"text":"🚀 Pend Server deployment completed successfully!"}' \
            $SLACK_WEBHOOK_URL
    fi
    
    log_info "Post-deployment tasks completed"
}

# Rollback function
rollback() {
    log_error "Deployment failed, initiating rollback..."
    
    # Stop current deployment
    if command -v docker-compose &> /dev/null; then
        docker-compose -f docker-compose.prod.yml down
    fi
    
    if command -v pm2 &> /dev/null; then
        pm2 stop all
    fi
    
    # Restore from backup if available
    if [ -d "./backups" ]; then
        LATEST_BACKUP=$(ls -1t ./backups | head -n 1)
        if [ -n "$LATEST_BACKUP" ]; then
            log_warning "Restoring from backup: $LATEST_BACKUP"
            # Implement restoration logic here
        fi
    fi
    
    log_error "Rollback completed"
    exit 1
}

# Main deployment function
main() {
    log_info "Starting deployment process for environment: $DEPLOY_ENV"
    
    # Set error handler
    trap rollback ERR
    
    # Pre-deployment checks
    log_step "Running pre-deployment checks..."
    
    # Check environment variables
    if [ -z "$DB_PASSWORD" ] || [ -z "$REDIS_PASSWORD" ]; then
        log_error "Required environment variables are not set"
        exit 1
    fi
    
    # Create backup
    create_backup
    
    # Choose deployment method
    if command -v docker-compose &> /dev/null; then
        deploy_docker
    elif command -v pm2 &> /dev/null; then
        deploy_pm2
    else
        log_error "Neither Docker nor PM2 is available"
        exit 1
    fi
    
    # Post-deployment tasks
    post_deployment
    
    log_info "🎉 Deployment completed successfully!"
    log_info "Server is running at: http://localhost:3001"
    log_info "Health endpoint: http://localhost:3001/api/v1/health"
    log_info "Metrics endpoint: http://localhost:3001/api/v1/health/metrics"
    
    # Display useful information
    echo ""
    echo "📊 Monitoring URLs:"
    echo "   - Grafana: http://localhost:3000 (admin/admin)"
    echo "   - Prometheus: http://localhost:9090"
    echo ""
    echo "🔧 Management commands:"
    echo "   - View logs: docker-compose -f docker-compose.prod.yml logs -f"
    echo "   - Scale services: docker-compose -f docker-compose.prod.yml up -d --scale server=3"
    echo "   - Database console: psql -h localhost -U $DB_USER -d $DB_NAME"
    echo "   - Redis console: redis-cli -h localhost -a $REDIS_PASSWORD"
}

# Run main function
main "$@"
```

## 🔐 **Security Configuration**

### **SSL Certificate Setup**
```bash
#!/bin/bash
# Setup SSL certificates with Let's Encrypt

# Install Certbot
sudo apt-get update
sudo apt-get install -y certbot python3-certbot-nginx

# Generate SSL certificate
sudo certbot --nginx -d your-domain.com -d www.your-domain.com

# Auto-renewal cron job
echo "0 12 * * * /usr/bin/certbot renew --quiet" | sudo crontab -
```

### **Firewall Configuration**
```bash
#!/bin/bash
# Configure UFW firewall

# Enable firewall
sudo ufw enable

# Allow SSH
sudo ufw allow 22/tcp

# Allow HTTP/HTTPS
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Allow database (only from application servers)
sudo ufw allow from 10.0.0.0/8 to any port 5432

# Allow Redis (only from application servers)
sudo ufw allow from 10.0.0.0/8 to any port 6379

# Deny all other traffic
sudo ufw default deny incoming
sudo ufw default allow outgoing
```

## 📈 **Performance Optimization**

### **Database Optimization**
```sql
-- PostgreSQL performance tuning
-- Add to postgresql.conf

# Memory settings
shared_buffers = 256MB
effective_cache_size = 1GB
work_mem = 4MB
maintenance_work_mem = 64MB

# Connection settings
max_connections = 100
shared_preload_libraries = 'pg_stat_statements'

# Checkpoint settings
checkpoint_completion_target = 0.9
wal_buffers = 16MB
default_statistics_target = 100

# Query optimization
random_page_cost = 1.1
effective_io_concurrency = 200
```

### **Node.js Performance Tuning**
```javascript
// server/src/config/performance.js
const cluster = require('cluster');
const os = require('os');

if (cluster.isMaster && process.env.NODE_ENV === 'production') {
  // Fork workers
  const numCPUs = os.cpus().length;
  for (let i = 0; i < numCPUs; i++) {
    cluster.fork();
  }

  cluster.on('exit', (worker, code, signal) => {
    console.log(`Worker ${worker.process.pid} died`);
    cluster.fork();
  });
} else {
  // Worker process
  require('./app');
}

// Memory optimization
if (process.env.NODE_ENV === 'production') {
  // Increase max old space size
  process.env.NODE_OPTIONS = '--max-old-space-size=2048';
  
  // Enable GC optimization
  process.env.NODE_OPTIONS += ' --optimize-for-size';
}
```

This deployment guide provides comprehensive instructions for deploying the enhanced server architecture to production with high availability, monitoring, and security best practices. 