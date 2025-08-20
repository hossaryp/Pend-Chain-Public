# 🌍 Pend Ecosystem - Environment Management

Complete guide to deploying and managing the Pend ecosystem across development, staging, and production environments.

## 🎯 Overview

The Pend ecosystem supports three distinct environments:
- **🚀 Development**: Local development and testing
- **🎭 Staging**: Pre-production testing and integration
- **🏭 Production**: Live system with 95,170+ EGP in real funds

## 🚀 Development Environment

### Purpose
Local development environment for rapid iteration and testing.

### Configuration
```bash
# Network
RPC_URL=http://127.0.0.1:8545
CHAIN_ID=7777
NODE_ENV=development

# Services  
API_SERVER_URL=http://localhost:3001
WALLET_UI_URL=http://localhost:5173
```

### Quick Start
```bash
# Option 1: Use deployment script
./scripts/deploy-env.sh development

# Option 2: Manual setup
cp config/environments/development.env .env
cd besu-network && docker compose up -d
cd ../server && npm install && npm start &
cd ../wallet-ui && npm install && npm run dev &
```

### Access Points
- **📱 Wallet UI**: http://localhost:5173
- **🔧 API Server**: http://localhost:3001
- **📊 Explorer**: http://localhost:3001/explorer/advanced
- **🔗 Besu RPC**: http://localhost:8545-8549

### Features
- ✅ Hot reloading for rapid development
- ✅ Debug mode enabled
- ✅ Local 5-node IBFT2 network
- ✅ Complete analytics and explorer
- ✅ Test data generation

## 🎭 Staging Environment

### Purpose
Pre-production environment for integration testing and final validation.

### Configuration
```bash
# Network
RPC_URL=https://staging-rpc.pend.network
CHAIN_ID=7777
NODE_ENV=staging

# Services
API_SERVER_URL=https://staging-api.pend.network
WALLET_UI_URL=https://staging-wallet.pend.network
```

### Deployment
```bash
# Automated deployment
./scripts/deploy-env.sh staging

# Or via GitHub Actions
git tag v1.0.0-rc1
git push origin v1.0.0-rc1
```

### Access Points
- **📱 Staging Wallet**: https://staging-wallet.pend.network
- **🔧 Staging API**: https://staging-api.pend.network
- **🔗 Staging RPC**: https://staging-rpc.pend.network

### Features
- ✅ Production-like environment
- ✅ SSL/HTTPS enabled
- ✅ Test data available
- ✅ Relaxed rate limiting for testing
- ✅ Integration testing capabilities

### GitHub Environment Setup
1. Go to repository → Settings → Environments
2. Create "staging" environment
3. Add environment variables:
   ```
   TWILIO_SID=staging_sid
   TWILIO_TOKEN=staging_token
   DEPLOYER_PRIVATE_KEY=staging_key
   ```

## 🏭 Production Environment

### Purpose
**LIVE SYSTEM** handling real funds and serving actual users.

### ⚠️ Critical Information
- **💰 TVL**: 95,170+ EGP in live funds
- **👥 Users**: 78 active wallets
- **🔗 Network**: 5-node IBFT2 blockchain
- **🏆 Performance**: 120% returns to investors

### Configuration
```bash
# Network
RPC_URL=https://rpc.pend.network
CHAIN_ID=7777
NODE_ENV=production

# Services
API_SERVER_URL=https://api.pend.network
WALLET_UI_URL=https://wallet.pend.network
```

### Deployment (HIGH SECURITY)
```bash
# Manual deployment with confirmation
./scripts/deploy-env.sh production
# Requires typing: "DEPLOY PRODUCTION"

# Or via GitHub Actions (recommended)
git tag v1.0.0
git push origin v1.0.0
# Requires manual approval in GitHub
```

### Access Points
- **📱 Production Wallet**: https://wallet.pend.network
- **🔧 Production API**: https://api.pend.network
- **📊 Live Explorer**: https://api.pend.network/explorer/advanced
- **🔗 Production RPC**: https://rpc.pend.network

### Security Features
- ✅ Manual approval required for all deployments
- ✅ Security scans before deployment
- ✅ Production secrets in GitHub Environments
- ✅ SSL/HTTPS with security headers
- ✅ Strict rate limiting
- ✅ Comprehensive monitoring
- ✅ Automatic backups

### GitHub Environment Setup
1. Go to repository → Settings → Environments
2. Create "production" environment
3. Configure protection rules:
   - ✅ Required reviewers: 2
   - ✅ Wait timer: 10 minutes
   - ✅ Restrict to protected branches only
4. Add production secrets:
   ```
   DEPLOYER_PRIVATE_KEY=prod_deployer_key
   VALIDATOR_PRIVATE_KEY=prod_validator_key
   TWILIO_SID=prod_twilio_sid
   TWILIO_TOKEN=prod_twilio_token
   JWT_SECRET=prod_jwt_secret
   ENCRYPTION_KEY=prod_encryption_key
   ```

## 📊 Contract Addresses (All Environments)

### V3 Production Contracts
```bash
EGP_STABLECOIN_ADDRESS=0x0e62978a8237984fEB2c99E29A6283Cc1FDdA671
HARVEST_POOL_ADDRESS=0xe4de484028097fA25f7a5893843325385812AD70
HVT_ADDRESS=0x0829E73bEA7d0d07FAFA3A3a6883c568DAf76098
CONSENT_MANAGER_ADDRESS=0x5103f499A89127068c20711974572563c3dCb819
SMART_WALLET_FACTORY_ADDRESS=0x0f84B067f6C71861E705aA45233854F5Db33926d
IDENTITY_REGISTRY_ADDRESS=0x074C5a96106b2Dcefb74b174034bd356943b2723
```

## 🔄 Environment Switching

### Quick Commands
```bash
# Development
./scripts/deploy-env.sh development

# Staging  
./scripts/deploy-env.sh staging

# Production (requires confirmation)
./scripts/deploy-env.sh production
```

### Manual Environment Loading
```bash
# Load specific environment
cp config/environments/development.env .env
source .env

# Verify environment
echo "Current environment: $NODE_ENV"
echo "RPC URL: $RPC_URL"
echo "API URL: $API_SERVER_URL"
```

## 🔧 GitHub Actions Workflows

### Automatic Triggers
- **Development**: Every push to `main` branch
- **Staging**: Tags matching `v*-rc*` (release candidates)
- **Production**: Tags matching `v*` (releases)

### Manual Triggers
All environments support manual deployment via GitHub Actions "workflow_dispatch".

### Workflow Features
- ✅ Dependency installation and caching
- ✅ Security audits
- ✅ Build optimization per environment
- ✅ Health checks and verification
- ✅ Deployment notifications

## 🔒 Security Best Practices

### Environment Isolation
- **Separate secrets** for each environment
- **Different database paths** per environment
- **Environment-specific URLs** and configurations
- **Isolated network access** controls

### Production Security
- **Manual approval** required for all production deployments
- **Security scans** before deployment
- **Audit logging** for all production changes
- **Rollback procedures** in case of issues
- **Monitoring and alerting** for production health

### Secret Management
- **Never commit secrets** to repository
- **Use GitHub Environments** for secret storage
- **Rotate secrets** regularly
- **Monitor secret access** and usage

## 📈 Monitoring & Analytics

### Development Monitoring
- Local console logs
- Development explorer at localhost:3001/explorer/advanced
- Real-time debugging capabilities

### Staging Monitoring  
- Staging-specific analytics
- Integration test results
- Performance benchmarks

### Production Monitoring
- **Live TVL tracking**: 95,170+ EGP
- **User activity monitoring**: 78 wallets
- **Network health**: 5-node consensus
- **Performance metrics**: <200ms API response
- **Error tracking and alerting**

## 🚨 Emergency Procedures

### Production Issues
1. **Immediate**: Contact development team
2. **Assessment**: Check explorer for network health
3. **Communication**: Notify users if necessary
4. **Rollback**: Use previous stable deployment
5. **Investigation**: Debug in staging environment

### Network Issues
1. **Check Besu nodes**: Ensure all 5 validators are running
2. **Verify contracts**: Confirm smart contract functionality
3. **Monitor TVL**: Ensure funds are secure (95,170+ EGP)
4. **User communication**: Update users on status

## 📚 Additional Resources

- **[Technical Documentation](readme-gpt.md)**: Complete system reference
- **[Besu Network Guide](../besu-network/README.md)**: Blockchain setup
- **[Smart Contracts](CONTRACT_ADDRESSES.md)**: Contract addresses and ABIs
- **[API Documentation](../server/README.md)**: Server API reference

---

**⚠️ Production Warning**: The production environment handles real funds (95,170+ EGP) and serves real users (78 wallets). Always exercise extreme caution when making production deployments. 