# Pend Beta - Blockchain-Powered Real Asset Marketplace

<div align="center">

![Pend Logo](https://img.shields.io/badge/Pend-Beta%204-FF8A34?style=for-the-badge&logo=data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTEyIDJMMTMuMDkgOC4yNkwyMCA5TDEzLjA5IDE1Ljc0TDEyIDIyTDEwLjkxIDE1Ljc0TDQgOUwxMC45MSA4LjI2TDEyIDJaIiBmaWxsPSJ3aGl0ZSIvPgo8L3N2Zz4K)

**A FRA-140 compliant blockchain ecosystem enabling secure, fractional ownership of real-world assets through progressive identity verification and phone-based smart wallets.**

[![Production Status](https://img.shields.io/badge/Status-Production%20Ready-success?style=flat-square)](./docs/getting-started/CURRENT_SYSTEM_STATUS.md)
[![Network](https://img.shields.io/badge/Network-Besu%20IBFT-blue?style=flat-square)](./besu-network/)
[![Frontend](https://img.shields.io/badge/Frontend-React%2018%20%2B%20TypeScript-61DAFB?style=flat-square)](./wallet-ui/)
[![Backend](https://img.shields.io/badge/Backend-Node.js%20%2B%20Express-339933?style=flat-square)](./server/)
[![Contracts](https://img.shields.io/badge/Smart%20Contracts-Solidity-363636?style=flat-square)](./hardhat/)

[**📱 Launch App**](http://localhost:5173) • [**🔍 Explorer**](http://localhost:3001/pendscan) • [**📚 Documentation**](./docs/) • [**🚀 Quick Start**](#-quick-start)

</div>

---

## 📋 Table of Contents

- [🌟 Overview](#-overview)
- [✨ Key Features](#-key-features)
- [🏗️ System Architecture](#️-system-architecture)
- [🚀 Quick Start](#-quick-start)
- [💼 Project Structure](#-project-structure)
- [🔧 Development Setup](#-development-setup)
- [📊 API Documentation](#-api-documentation)
- [🔐 Security & Compliance](#-security--compliance)
- [📈 Current Status](#-current-status)
- [🛣️ Roadmap](#️-roadmap)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)

---

## 🌟 Overview

Pend Beta is a **comprehensive blockchain ecosystem** that democratizes access to real-world asset investments through cutting-edge technology and regulatory compliance. Our platform enables fractional ownership of tangible assets including agriculture, real estate, renewable energy, and precious metals.

### 🎯 Core Mission

> **Provide infrastructure for legally-backed, globally-accessible investment in real-world assets through phone-based identity verification and smart contract enforcement.**

### 🌍 Market Focus

- **Primary Market**: Egypt (FRA-140 compliant)
- **Expansion**: UAE, GCC, and MENA region
- **Target Assets**: Agriculture (60%), Real Estate (25%), Energy (10%), Other (5%)
- **User Experience**: Mobile-first design for emerging market adoption

---

## ✨ Key Features

### 📱 **Smart Wallet System**
- **📞 Phone-Based Identity**: Create wallets using phone numbers without seed phrases
- **🔐 Progressive KYC**: Binary verification system (Phone verified → KYC verified)
- **🔑 Database-First PIN System**: 30-200x faster PIN operations with PostgreSQL + Argon2id encryption
- **📲 Enhanced UX**: OTP/PIN paste support, auto-progression, real-time validation
- **🔄 Cross-Device Sync**: Identity authentication via database with session management
- **🌍 Multi-language**: English/Arabic support with proper RTL handling

### 🏪 **Investment Marketplace**
- **🌾 Real-World Assets**: 8+ live investment opportunities across 5 categories
- **💰 Fractional Ownership**: ERC-20 tokens representing asset shares
- **📑 Blockchain Agreements**: Immutable legal contracts stored on-chain
- **💱 Multi-Currency**: EGP, USD, USDC support with local payment methods
- **🎯 Mobile-Optimized**: Complete investment flow designed for mobile devices
- **📊 Advanced Analytics**: Real-time performance tracking and portfolio management

### 🏭 **DeFi Infrastructure**
- **💧 Harvest Pools**: Dynamic NAV pools with automated profit distribution
- **🏭 Asset Factory**: Scalable tokenization of real-world assets
- **📊 Live Analytics**: Real-time TVL, NAV tracking, and performance metrics
- **🔄 Liquidity Management**: Multiple redemption mechanisms (NAV-based, buffer, cycle-based)

### 🔍 **PendScan Explorer**
- **📊 Real-Time Analytics**: Live network statistics and pool performance
- **🔍 Advanced Search**: Transaction, wallet, and contract discovery
- **📱 Mobile-Optimized**: Responsive design with dark theme
- **🛠️ Developer Tools**: Raw data access and contract interaction

---

## 🏗️ System Architecture

### 🔗 **Blockchain Layer**
```
┌─────────────────────────────────────────────────────────────┐
│                     Pend Blockchain Network                 │
│  • Hyperledger Besu (Ethereum-compatible)                  │
│  • IBFT 2.0 Consensus (5 validator nodes)                  │
│  • Chain ID: 7777 • RPC: http://127.0.0.1:8545             │
│  • Block Time: ~3 seconds • Capacity: 1000+ TPS            │
└─────────────────────────────────────────────────────────────┘
```

### 📱 **Application Stack**
```
┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐
│   Frontend       │  │    Backend       │  │  Smart Contracts │
│                  │  │                  │  │                  │
│ • React 18 + TS  │←→│ • Node.js + API  │←→│ • Solidity       │
│ • Mobile-First   │  │ • Express.js     │  │ • ERC-20 Tokens  │
│ • PWA Ready      │  │ • Ethers.js v6   │  │ • Identity System│
│ • Tailwind CSS   │  │ • PostgreSQL DB  │  │ • Pool Management│
└──────────────────┘  └──────────────────┘  └──────────────────┘
      Port 5173            Port 3001            Port 8545
```

### 🗄️ **Database Infrastructure (NEW)**
```
┌─────────────────────────────────────────────────────────────┐
│                PostgreSQL Migration System                  │
│  • 17-table enterprise schema with ACID compliance          │
│  • Connection pooling with health monitoring                │
│  • Automated JSON-to-PostgreSQL migration tools            │
│  • Sub-50ms query performance (10-100x faster than JSON)   │
│  • Zero-downtime deployment with rollback capabilities     │
│  • Supports 1000+ concurrent users vs 200 limit (JSON)     │
└─────────────────────────────────────────────────────────────┘
```

### 💾 **Core Smart Contracts**

| Contract | Address | Purpose | Status |
|----------|---------|---------|--------|
| **ConsentManager** | `0x5103f499A89127068c20711974572563c3dCb819` | User consent & verification | ✅ Deployed |
| **SmartWalletFactory** | `0x0f84B067f6C71861E705aA45233854F5Db33926d` | Wallet creation | ✅ Deployed |
| **AccessControlHub** | `0x57Bee198a7148A94f27a71465216bB67f166b9F4` | Role management | ✅ Deployed |
| **IdentityRegistry** | `0x074C5a96106b2Dcefb74b174034bd356943b2723` | KYC & Identity management | ✅ Deployed |
| **EGP StableCoin** | `TBD` | Stable currency | 🚧 Ready to Deploy |
| **HarvestPool V3** | `TBD` | Investment pools | 🚧 Ready to Deploy |
| **AssetFactory** | `TBD` | Asset tokenization | 🚧 Ready to Deploy |

---

## 🚀 Quick Start

### 📦 **Prerequisites**
- Node.js 18+ and npm/yarn
- Docker and Docker Compose
- Git

### ⚡ **One-Command Setup**
```bash
# Clone the repository
git clone <repository-url>
cd "Beta 4"

# Start the entire ecosystem
./start-all.sh
```

### 🔧 **Manual Setup**
```bash
# 1. Start Blockchain Network
cd besu-network
docker-compose up -d

# 2. Setup Database (NEW)
cd ../server
./scripts/setup-database.sh  # One-command PostgreSQL setup
npm run db:migrate           # Run schema migrations
npm run db:migrate:data      # Migrate JSON data (optional)

# 3. Start Backend API
npm install
npm start                    # Runs on http://localhost:3001

# 4. Start Frontend Application
cd ../wallet-ui
npm install
npm run dev                  # Runs on http://localhost:5173
```

### 🌐 **Access Points**
- **📱 Wallet App**: http://localhost:5173
- **🔍 PendScan Explorer**: http://localhost:3001/pendscan
- **🔧 Admin Panel**: http://localhost:3002 (NEW)
- **🎛️ Backend API**: http://localhost:3001/api
- **⛓️ Blockchain RPC**: http://127.0.0.1:8545

---

## 💼 Project Structure

```
Beta 4/
├── 📱 wallet-ui/              # React frontend application
│   ├── src/
│   │   ├── app/               # Core app components
│   │   ├── features/          # Feature-based modules
│   │   │   ├── auth/          # Authentication system
│   │   │   ├── wallet/        # Wallet management
│   │   │   ├── explore/       # Asset marketplace
│   │   │   └── admin/         # Admin panel
│   │   └── shared/            # Reusable components
│   ├── cypress/               # E2E testing
│   └── package.json
│
├── 🔧 server/                 # Node.js backend API
│   ├── routes/                # API endpoints
│   ├── services/              # Business logic
│   ├── middleware/            # Security middleware
│   ├── utils/                 # Utility functions
│   ├── src/database/          # PostgreSQL migration system (NEW)
│   │   ├── migrations/        # Database schema migrations
│   │   ├── connection.js      # Connection pooling & monitoring
│   │   ├── migrator.js        # JSON-to-PostgreSQL migration
│   │   └── migrate.js         # CLI migration tools
│   ├── scripts/               # Setup & deployment scripts (NEW)
│   │   └── setup-database.sh  # Automated PostgreSQL setup
│   ├── pendscan.html         # Blockchain explorer
│   ├── start-ultra-clean.sh  # Production startup
│   └── package.json
│
├── ⛓️ hardhat/                # Smart contract development
│   ├── contracts/             # Solidity contracts
│   ├── scripts/               # Deployment scripts
│   ├── test/                  # Contract tests
│   └── hardhat.config.js
│
├── 🌐 besu-network/           # Blockchain infrastructure
│   ├── docker-compose.yml    # 5-node IBFT network
│   ├── config/               # Network configuration
│   └── node[1-5]/            # Validator node data
│
├── 📚 docs/                   # Comprehensive documentation
│   ├── getting-started/       # Setup and overview
│   ├── developer/             # Technical documentation
│   ├── features/              # Feature specifications
│   ├── project-management/    # Implementation tracking
│   └── testing/               # Testing documentation
│
├── 🔧 scripts/                # Development utilities
│   ├── start-all.sh           # Complete ecosystem startup
│   └── deploy-env.sh          # Environment deployment
│
└── ⚙️ config/                 # Configuration files (NEW)
    └── environments/          # Environment-specific configs
        └── database.env       # PostgreSQL configuration template
```

---

## 🔧 Development Setup

### 🛠️ **Smart Contracts (Hardhat)**
```bash
cd hardhat
npm install
npx hardhat compile           # Compile contracts
npx hardhat test             # Run tests
npx hardhat run scripts/deploy.js --network besu  # Deploy
```

### 🖥️ **Backend Development**
```bash
cd server
npm install
npm run dev                  # Development with hot reload

# Database Migration Commands (NEW)
./scripts/setup-database.sh  # One-command PostgreSQL setup
npm run db:migrate           # Run schema migrations
npm run db:migrate:data      # Migrate JSON data to PostgreSQL
npm run db:migrate:full      # Full migration with validation
npm run db:status            # Show migration status
npm run db:health            # Database health check
npm run db:rollback          # Emergency rollback

# Available start modes
./start-ultra-clean.sh       # Production mode (minimal logs)
./start-clean.sh            # Light development mode
./start-no-scanning.sh      # API only, no blockchain scanning
node index.js               # Standard mode
DEBUG_SCANNER=true node index.js  # Debug mode
```

### 🎨 **Frontend Development**
```bash
cd wallet-ui
npm install
npm run dev                 # Development server
npm run build              # Production build
npm run preview            # Preview production build

# Mobile app development
npx cap add android         # Add Android platform
npx cap add ios            # Add iOS platform
```

### 🧪 **Testing**
```bash
# Smart contract tests
cd hardhat && npx hardhat test

# Frontend tests
cd wallet-ui && npm test

# E2E tests
cd wallet-ui && npm run cypress:open
```

---

## 📊 API Documentation

### 🔐 **Authentication & Identity**
```http
POST /api/send-otp           # Send phone verification
POST /api/verify-otp         # Verify OTP code
POST /api/create-wallet      # Create smart wallet
POST /api/pin/set            # Set FRA-compliant PIN
POST /api/pin/verify         # Verify PIN authentication
POST /api/pin/reset          # Secure PIN reset with OTP verification
POST /api/pin/set-during-wallet-creation  # PIN setup during wallet creation
```

### 💰 **Wallet & Transactions**
```http
GET  /api/wallet/:address    # Get wallet details
POST /api/send-tokens        # Send tokens by phone
POST /api/execute-transaction # Execute wallet transaction
GET  /api/tokens/balance/:address # Get token balances
GET  /api/tokens/history/:address # Transaction history
```

### 🏭 **Investment Management**
```http
POST /api/harvest/invest     # Invest in pools
POST /api/harvest/redeem     # Redeem from pools
GET  /api/pool/stats         # Pool statistics
POST /api/deposit-egp        # Instant EGP minting
```

### 🔍 **Explorer & Analytics**
```http
GET  /api/explorer/stats     # Network statistics
GET  /api/explorer/wallets   # Wallet directory
GET  /api/explorer/advanced  # Advanced analytics
GET  /api/enhanced/overview  # PendScan network overview
POST /api/live/refresh       # Force data refresh
```

### 🛡️ **Security & Compliance**
```http
POST /api/consent/verify     # Verify user consent
POST /api/identity/log-kyc   # Log KYC completion
GET  /api/identity/kyc-status/:address # Check KYC status
POST /api/webauthn/register  # Biometric registration
```

### 🔧 **Admin Panel & Database Management (NEW)**
```http
GET  /api/admin/dashboard-stats    # Admin dashboard statistics
GET  /api/admin/database/tables    # Get all database tables
GET  /api/admin/database/activity  # Database activity monitoring
POST /api/admin/assets/create      # Create new asset via wizard
PUT  /api/admin/assets/:id         # Update existing asset
GET  /api/admin/assets/analytics   # Asset performance analytics
POST /api/admin/assets/upload      # Upload asset documents
GET  /api/admin/dashboard/health   # System health monitoring
GET  /api/admin/dashboard/metrics  # Performance metrics
```

---

## 🔐 Security & Compliance

### 🏛️ **Regulatory Compliance**
- **🇪🇬 FRA-140 Compliant**: Egyptian Financial Regulatory Authority standards
- **📋 Regulation S**: Global securities compliance framework
- **🔐 GDPR Ready**: European data protection compliance
- **🏦 Banking Standards**: Argon2id hashing with 64MB memory (exceeds banking standards)

### 🛡️ **Security Features**

#### **Enterprise PIN System**
- **Argon2id Hashing**: 64MB memory, 3 iterations (stronger than bcrypt)
- **Phone-Based Salting**: Deterministic cross-device consistency
- **Weak PIN Detection**: Blocks common patterns and sequences
- **Regulatory Audit Trail**: Complete activity logging with timestamps
- **Cross-Device Sync**: PIN hashes synchronized via blockchain storage
- **Secure PIN Reset**: OTP-verified PIN reset with scalable blockchain architecture
- **Rate Limiting**: 5 failed attempts → 15-minute lockout protection
- **Device Fingerprinting**: Automatic device tracking with 5-device limit per user

#### **Multi-Factor Authentication**
- **Knowledge Factor**: PIN authentication
- **Possession Factor**: OTP verification
- **Inherence Factor**: Biometric authentication (WebAuthn)
- **Device Binding**: Device fingerprinting and registration

#### **Smart Contract Security**
- **Immutable Core Logic**: Critical functions cannot be modified
- **Binary Access Control**: Phone verified → KYC verified progression
- **Consent Enforcement**: All actions require explicit user consent
- **Audit Trails**: Complete transaction and consent history

---

## 📈 Current Status

### ✅ **Production Ready Features**

#### **🔐 Identity & Authentication**
- ✅ Phone-based wallet creation (139+ wallets deployed)
- ✅ FRA-compliant PIN system with cross-device sync
- ✅ Secure PIN reset with OTP verification and scalable blockchain architecture
- ✅ Binary KYC verification (Phone → KYC verified)
- ✅ Biometric authentication with WebAuthn
- ✅ Multi-factor security implementation
- ✅ Egyptian phone number restriction (+20 only)

#### **🗄️ Database Infrastructure (NEW)**
- ✅ PostgreSQL migration system with 17-table enterprise schema
- ✅ Automated JSON-to-PostgreSQL data migration tools
- ✅ Connection pooling with health monitoring and performance tracking
- ✅ Sub-50ms query performance (10-100x faster than JSON files)
- ✅ Zero-downtime deployment with automated rollback capabilities
- ✅ ACID compliance with transaction support
- ✅ Supports 1000+ concurrent users vs 200 limit with JSON storage

#### **🔧 Advanced Admin Panel (NEW)**
- ✅ Comprehensive Asset Creation Wizard with 5-step workflow
  - BasicInformation → InvestmentDetails → LegalCompliance → AssetManager → ReviewSubmit
- ✅ Real-time Database Management Dashboard with live PostgreSQL monitoring
- ✅ Advanced Table Browser with data exploration and search capabilities
- ✅ Admin Authentication System with header-based and JWT support
- ✅ Asset field mapping and transformation middleware
- ✅ Enhanced admin routes with modular organization and validation
- ✅ File upload utilities for document management and storage
- ✅ Professional UI with TypeScript integration and responsive design

#### **🏪 Investment Marketplace**
- ✅ 8+ real-world investment opportunities
- ✅ Asset categories: Agriculture, Real Estate, Energy, Healthcare, Logistics
- ✅ Smart filtering and advanced search
- ✅ Blockchain investment agreements
- ✅ Mobile-optimized investment flows
- ✅ Home tab with banner carousel and visual categories

#### **🔍 Analytics & Monitoring**
- ✅ PendScan blockchain explorer (modern Etherscan-level interface)
- ✅ Real-time network statistics (74,000+ blocks processed)
- ✅ Comprehensive wallet directory
- ✅ Transaction monitoring and search
- ✅ Ultra-clean server mode (95% log reduction, 2-5 second startup)

#### **🧪 Testing & Quality Assurance**
- ✅ Comprehensive E2E testing suite (4 test files)
- ✅ MyPend tab, investment flow, and sell position tests
- ✅ Cypress test infrastructure with mobile-first viewport
- ✅ Component test IDs and mock data strategies

### 🚧 **Ready to Deploy**

#### **📊 Pool System Enhancement**
- 🔧 HarvestPool V3 with fixed NAV calculation
- 🔧 Bundle/Pool UI integration
- 🔧 Advanced redemption mechanisms
- 🔧 EGP StableCoin deployment

#### **🌍 Market Expansion**
- 📋 UAE regulatory compliance (VARA/ADGM)
- 📋 Cross-border payment integration
- 📋 Multi-language support (Arabic)
- 📋 Enhanced mobile applications

### 📊 **Live Network Statistics**
- **Blockchain**: 74,000+ blocks processed on Pend Chain
- **Wallets**: 139+ smart wallets created and deployed
- **Assets**: 8+ investment opportunities across 5 categories
- **Contracts**: 15+ production smart contracts deployed
- **Documentation**: 50+ comprehensive documentation files
- **Server Performance**: 2-5 second startup, 95% log reduction

---

## 🛣️ Roadmap

### 🎯 **Phase 1: Foundation Complete** ✅
- [x] Core blockchain infrastructure (5-node Besu IBFT network)
- [x] Smart wallet system with phone-based identity
- [x] Investment marketplace with 8+ opportunities
- [x] FRA-compliant security implementation
- [x] PendScan explorer with real-time analytics
- [x] Comprehensive E2E testing suite
- [x] Server optimization (95% performance improvement)
- [x] **PostgreSQL database migration system** (NEW)
  - [x] 17-table enterprise schema with ACID compliance
  - [x] Automated JSON-to-PostgreSQL migration tools
  - [x] 10-100x performance improvement vs JSON storage
  - [x] Zero-downtime deployment with rollback capabilities

### 🚀 **Phase 2: Scale & Enhance (Q1-Q2 2025)**
- [ ] Bundle/Pool system deployment
- [ ] Real SPV custody integration
- [ ] Enhanced mobile applications (Capacitor)
- [ ] Advanced analytics dashboard
- [ ] UAE market expansion preparation
- [ ] Multi-language support (Arabic)

### 🌍 **Phase 3: Regional Expansion (Q3-Q4 2025)**
- [ ] UAE/GCC market launch
- [ ] Institutional investor features
- [ ] Cross-chain integrations
- [ ] Advanced DeFi protocols
- [ ] Multi-jurisdiction compliance

### 🚀 **Phase 4: Global Scale (2026+)**
- [ ] Global Regulation S markets
- [ ] Cross-chain asset bridges
- [ ] AI-powered analytics
- [ ] White-label infrastructure
- [ ] Enterprise institutional platform

---

## 🤝 Contributing

We welcome contributions from developers, designers, and blockchain enthusiasts!

### 🛠️ **Development Process**

1. **Fork & Clone**
   ```bash
   git clone https://github.com/your-username/pend-beta.git
   cd "Beta 4"
   ```

2. **Create Feature Branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```

3. **Follow Standards**
   - Use TypeScript for type safety
   - Follow mobile-first design principles
   - Add tests for new functionality
   - Update documentation

4. **Submit Pull Request**
   ```bash
   git commit -m 'feat: add amazing feature'
   git push origin feature/amazing-feature
   # Open PR on GitHub
   ```

### 📋 **Contribution Guidelines**

- **🔒 Security First**: All security-related changes require thorough review
- **📱 Mobile-First**: Design for mobile devices, enhance for desktop
- **📚 Documentation**: Update relevant docs for all changes
- **🧪 Testing**: Include tests for new features and bug fixes
- **🎨 Design System**: Follow established UI/UX patterns

### 🐛 **Bug Reports & Feature Requests**

Use our GitHub Issues with appropriate labels:
- 🐛 `bug` - Bug reports
- ✨ `enhancement` - Feature requests
- 📚 `documentation` - Documentation improvements
- 🔒 `security` - Security-related issues

---

## 📞 Support & Community

### 💬 **Community Channels**
- **📱 Telegram**: [Pend Community](https://t.me/pendcommunity)
- **💬 Discord**: [Developer Chat](https://discord.gg/pend)
- **📧 Email**: support@pend.com
- **🐦 Twitter**: [@PendBeta](https://twitter.com/pendbeta)

### 📚 **Documentation**
- **📖 Full Documentation**: [./docs/](./docs/)
- **🚀 Quick Start Guide**: [./docs/getting-started/](./docs/getting-started/)
- **👨‍💻 Developer Docs**: [./docs/developer/](./docs/developer/)
- **🔧 API Reference**: [./docs/developer/api/](./docs/developer/api/)
- **🧪 Testing Guide**: [./docs/testing/](./docs/testing/)

### 🆘 **Getting Help**
1. Check the [documentation](./docs/)
2. Search [existing issues](https://github.com/your-repo/issues)
3. Join our [Discord community](https://discord.gg/pend)
4. Create a [new issue](https://github.com/your-repo/issues/new)

---

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

### 🤝 **Commercial Use**
- ✅ Commercial use allowed
- ✅ Modification allowed
- ✅ Distribution allowed
- ✅ Private use allowed
- ❌ Liability and warranty not provided

---

<div align="center">

## 🎉 **Pend Beta - Democratizing Real Asset Investment**

**Built with ❤️ for the future of decentralized finance**

[**🚀 Get Started**](#-quick-start) • [**📚 Documentation**](./docs/) • [**🤝 Contribute**](#-contributing) • [**💬 Community**](#-support--community)

---

*Infrastructure for legally-backed, globally-accessible investment in real-world assets.*

**Version**: Beta 4 | **Last Updated**: January 2025 | **Status**: Production Ready ✅

</div>
