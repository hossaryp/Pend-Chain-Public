# Architecture Documentation

Technical architecture documentation for the Pend Beta platform.

## Core Architecture Documents

### 🏗️ [System Architecture](./system-architecture.md)
Complete technical architecture covering all system components, including:
- Explore marketplace architecture
- Smart wallet system design
- Pool/bundle architecture
- Blockchain infrastructure
- Compliance systems
- Scaling strategy

### ⚙️ [Application Logic](./application-logic.md)
Core application logic and business flow documentation covering:
- User authentication flow
- Investment process logic
- Wallet management logic
- Transaction processing

### 🔄 [System Restructure](./system-restructure.md)
Documentation of system restructuring efforts and architectural changes:
- System refactoring summaries
- Architectural evolution
- Migration strategies

## Architecture Principles

The Pend Beta architecture follows these key principles:

1. **Progressive Identity**: Identity verification as infrastructure
2. **Blockchain-First**: Leverage blockchain for transparency and compliance
3. **Mobile-First**: Designed for emerging market users
4. **Modular Design**: Loosely coupled components for scalability
5. **Compliance by Design**: Regulatory compliance built into architecture

## System Overview

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Wallet UI     │────│   Backend API    │────│  Blockchain     │
│   (React)       │    │   (Node.js)      │    │  (Besu/Ethereum)│
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                │
                                │
                         ┌──────────────────┐
                         │   Smart Contracts│
                         │   - AssetFactory  │
                         │   - SmartWallet   │
                         │   - ConsentMgr    │
                         │   - HarvestPool   │
                         └──────────────────┘
```

## Related Documentation

- **[Smart Contracts](../smart-contracts/)** - Contract architecture details
- **[Components](../components/)** - Individual component architecture
- **[API Documentation](../api/)** - API architecture and design 