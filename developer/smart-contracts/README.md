# Smart Contracts Documentation

Complete documentation for all smart contracts in the Pend Beta ecosystem.

## Contract Deployment Information

### 📋 [Contract Addresses](./CONTRACT_ADDRESSES.md)
Production contract deployments with addresses and verification status.

### 🚀 [Deployed Contracts](./deployed-contracts.md)
Complete overview of all deployed contracts and their purposes.

## Core Contracts

### 🔐 [Core Contracts](./core-contracts/)
Essential blockchain contracts that power the platform:

- **[AccessControlHub](./core-contracts/AccessControlHub.md)** - Role-based access control system
- **[AssetFactory](./core-contracts/AssetFactory.md)** - Asset tokenization and creation
- **[SmartWallet](./core-contracts/SmartWallet.md)** - User wallet contract implementation
- **[ConsentManager](./core-contracts/ConsentManager.md)** - Compliance and consent management
- **[InvestmentAgreement](./core-contracts/InvestmentAgreement.md)** - Investment agreement contracts
- **[EGPStableCoin](./core-contracts/EGPStableCoin.md)** - EGP stablecoin implementation
- **[Identity Registry](./core-contracts/identity-registry.md)** - KYC and identity management

## Pool Contracts

### 💰 [Pool Contracts](./pool-contracts/)
Investment pool and portfolio management contracts:

- **[HarvestPool](./pool-contracts/HarvestPool.md)** - Dynamic NAV pool implementation
- **[HarvestPool V2 Upgrade](./pool-contracts/HarvestPool-V2-Upgrade.md)** - Version 2 improvements
- **[HarvestPool V3 Production](./pool-contracts/HarvestPool-V3-Production.md)** - Latest production version
- **[InterestOnlyAsset](./pool-contracts/InterestOnlyAsset-README.md)** - Interest-bearing asset contracts

## Contract Architecture

The smart contract architecture follows these principles:

1. **Modular Design**: Contracts are loosely coupled and can be upgraded independently
2. **Access Control**: Role-based permissions using AccessControlHub
3. **Compliance First**: Built-in regulatory compliance mechanisms
4. **Upgradeability**: Proxy patterns for contract upgrades
5. **Gas Optimization**: Efficient gas usage for mobile users

## Development Workflow

1. **Development**: Write and test contracts in Hardhat environment
2. **Testing**: Comprehensive test suite with 95%+ coverage
3. **Deployment**: Automated deployment scripts
4. **Verification**: Contract verification on block explorer
5. **Documentation**: Update documentation and addresses

## Testing

All contracts include comprehensive test suites:
- Unit tests for individual functions
- Integration tests for contract interactions
- End-to-end tests for complete user flows

## Related Documentation

- **[Architecture](../architecture/)** - System architecture overview
- **[Components](../components/)** - Frontend integration details
- **[Features](../../features/)** - Feature-specific contract usage 