# AssetFactory System - Tokenized Real-World Assets

## Overview

The AssetFactory system is a comprehensive smart contract solution for deploying and managing tokenized real-world assets on the Ethereum blockchain. It provides a scalable, secure, and compliant framework for asset managers to create ERC-20 tokens representing fractional ownership of physical assets.

## Architecture

### Core Components

1. **AssetFactory Contract**: Main factory contract that deploys and manages asset contracts
2. **FractionalBuyAsset Contract**: Individual asset tokens with ERC-20 functionality
3. **ConsentManager Integration**: Identity-based consent verification system
4. **Role-Based Access Control**: Permissioned asset manager authorization

### System Features

- ✅ **ERC-20 Token Support**: Full fractional ownership with standard token functionality
- ✅ **Legal Agreement Integration**: On-chain legal document URLs and hashes
- ✅ **Lock-up Periods**: Configurable token transfer restrictions
- ✅ **Metadata Management**: Off-chain asset information linking
- ✅ **Category Organization**: Asset classification (Real Estate, Agriculture, Equipment, etc.)
- ✅ **Price Range Filtering**: Investment opportunity discovery
- ✅ **Redemption Logic**: Configurable token redemption capabilities
- ✅ **Consent Enforcement**: Integration with identity verification systems
- ✅ **Minimum Investment Limits**: Regulatory compliance features
- ✅ **Asset Manager Metrics**: Performance tracking and analytics

## Contract Addresses (Hardhat Network)

```
ConsentManager: 0x5FbDB2315678afecb367f032d93F642f64180aa3
AssetFactory: 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512
Sample Asset: 0xCafac3dD18aC6c6e92c921884f9E4176737C052c
```

## Usage

### 1. Deploy the System

```bash
# Deploy AssetFactory and dependencies
npx hardhat run scripts/deploy-asset-factory.js

# Or deploy to a specific network
npx hardhat run scripts/deploy-asset-factory.js --network <network-name>
```

### 2. Authorize Asset Managers

```javascript
// Authorize a new asset manager
await assetFactory.authorizeAssetManager(
  "0x1234...5678",  // Manager address
  "Real Estate Corp" // Display name
);
```

### 3. Deploy New Assets

```javascript
const deployTx = await assetFactory.deployAsset(
  "Luxury Apartment Building - NYC",           // Asset name
  "NYCAPT",                                   // Token symbol
  "https://api.pend.com/assets/nyc/metadata", // Metadata URL
  "https://api.pend.com/assets/nyc/legal",    // Legal agreement URL
  "0x1234...hash",                           // Legal agreement hash
  ethers.parseEther("1000"),                 // Token price (in wei)
  ethers.parseUnits("100", 18),              // Max supply
  Math.floor(Date.now() / 1000) + 86400 * 90, // Lock-up end (90 days)
  ethers.parseUnits("1", 18),                // Minimum investment
  "Real Estate"                              // Category
);
```

### 4. Purchase Asset Tokens

```javascript
const asset = await ethers.getContractAt("FractionalBuyAsset", assetAddress);
const purchaseAmount = ethers.parseUnits("5", 18); // 5 tokens
const totalCost = purchaseAmount * await asset.tokenPrice();

await asset.connect(investor).purchaseTokens(purchaseAmount, {
  value: totalCost
});
```

### 5. Query and Discovery

```javascript
// Get all active assets
const activeAssets = await assetFactory.getActiveAssets();

// Filter by category
const realEstateAssets = await assetFactory.getAssetsByCategory("Real Estate");

// Filter by price range
const affordableAssets = await assetFactory.getAssetsByPriceRange(
  ethers.parseEther("100"),   // Min price
  ethers.parseEther("1000")   // Max price
);

// Get asset information
const assetInfo = await assetFactory.getAssetInfo(assetAddress);
```

### 6. Asset Management

```javascript
// Update metadata URL
await assetFactory.updateAssetMetadata(assetAddress, newMetadataUrl);

// Enable redemption
await asset.setRedeemable(true);

// Update lock-up period
await asset.updateLockup(newTimestamp);

// Deactivate asset
await assetFactory.deactivateAsset(assetAddress);
```

## Integration with Pend Ecosystem

### Explorer Tab Population

The AssetFactory emits comprehensive events that can be indexed for the Pend Explorer:

```solidity
event AssetDeployed(
    address indexed contractAddress,
    address indexed assetManager,
    string indexed category,
    string name,
    string symbol,
    string metadataUrl,
    string legalAgreementUrl,
    bytes32 legalAgreementHash,
    uint256 tokenPrice,
    uint256 maxSupply,
    uint256 lockupEndTimestamp,
    uint256 minimumInvestment,
    uint256 deployedAt
);
```

### Backend Integration

```javascript
// Example backend service integration
class AssetExplorerService {
  async getAssetsForExplorer() {
    const activeAssets = await assetFactory.getActiveAssets();
    const assetsWithDetails = await Promise.all(
      activeAssets.map(async (address) => {
        const info = await assetFactory.getAssetInfo(address);
        const asset = await ethers.getContractAt("FractionalBuyAsset", address);
        const totalSupply = await asset.totalSupply();
        
        return {
          address,
          name: info.name,
          symbol: info.symbol,
          category: info.category,
          tokenPrice: info.tokenPrice.toString(),
          totalSupply: totalSupply.toString(),
          metadataUrl: info.metadataUrl,
          assetManager: info.assetManager,
          active: info.active
        };
      })
    );
    
    return assetsWithDetails;
  }
}
```

### Consent Manager Integration

For enhanced security and compliance:

```javascript
// Deploy asset with consent verification
await assetFactory.deployAssetWithConsent(
  // ... asset parameters
  rawConsentInput,    // Consent verification data
  phoneNumber,        // User identifier
  "deploy_asset"      // Action being consented to
);

// Set consent requirements for users
await asset.setConsentRequired(userAddress, true);
```

## Smart Contract Security

### Access Control
- Owner-controlled asset manager authorization
- Asset manager-specific asset control
- Factory-level deactivation capabilities

### Validation
- Parameter validation on deployment
- Balance and supply checks
- Lock-up period enforcement

### Upgradeability
- Modular design for future enhancements
- Category-specific logic expansion
- Plugin architecture for consent systems

## Testing

```bash
# Run all tests
npx hardhat test test/assetFactory.t.js

# Run specific test suites
npx hardhat test test/assetFactory.t.js --grep "Access Control"
npx hardhat test test/assetFactory.t.js --grep "Asset Deployment"
npx hardhat test test/assetFactory.t.js --grep "Token Functionality"
```

### Test Coverage

- ✅ Role-based access control
- ✅ Asset deployment and registration
- ✅ Token purchase and transfer mechanics
- ✅ Lock-up period enforcement
- ✅ Metadata and asset management
- ✅ Query and filtering functions
- ✅ ConsentManager integration
- ✅ Error handling and validation

## Deployment Configurations

### Development (Hardhat Network)
```bash
npx hardhat run scripts/deploy-asset-factory.js
```

### Local Besu Network
```bash
npx hardhat run scripts/deploy-asset-factory.js --network besu
```

### Production Network
```bash
npx hardhat run scripts/deploy-asset-factory.js --network <production-network>
```

## API Reference

### AssetFactory Main Functions

```solidity
// Asset Manager Management
function authorizeAssetManager(address manager, string name) external onlyOwner
function revokeAssetManager(address manager) external onlyOwner

// Asset Deployment
function deployAsset(...params) external onlyAuthorizedAssetManager returns (address)
function deployAssetWithConsent(...params, consent) external returns (address)

// Asset Management
function deactivateAsset(address assetAddress) external
function updateAssetMetadata(address assetAddress, string newUrl) external

// Query Functions
function getAllAssets() external view returns (address[])
function getActiveAssets() external view returns (address[])
function getAssetsByCategory(string category) external view returns (address[])
function getAssetsByPriceRange(uint256 min, uint256 max) external view returns (address[])
function getAssetInfo(address assetAddress) external view returns (AssetInfo)
```

### FractionalBuyAsset Main Functions

```solidity
// ERC-20 Standard
function transfer(address to, uint256 amount) external returns (bool)
function approve(address spender, uint256 amount) external returns (bool)
function transferFrom(address from, address to, uint256 amount) external returns (bool)

// Asset-Specific
function purchaseTokens(uint256 amount) external payable
function redeem(uint256 amount) external
function updateMetadata(string newUrl) external onlyAssetManager
function setRedeemable(bool redeemable) external onlyAssetManager
```

## Future Enhancements

### Phase 2: Advanced Features
- Multi-currency support (pEGP, USDC, ETH)
- Dividend/yield distribution mechanisms
- Governance token integration
- Cross-chain asset bridging

### Phase 3: Compliance & Regulation
- KYC/AML integration
- Regulatory reporting tools
- Jurisdiction-specific compliance
- Automated tax reporting

### Phase 4: DeFi Integration
- Lending/borrowing against assets
- Liquidity pools for asset tokens
- Yield farming opportunities
- Insurance protocol integration

## Support and Documentation

For additional support:
- Technical Documentation: `/docs/`
- Test Examples: `/test/assetFactory.t.js`
- Deployment Scripts: `/scripts/`
- Contract Source: `/contracts/AssetFactory.sol` & `/contracts/FractionalBuyAsset.sol`

## License

MIT License - see LICENSE file for details.

---

*Built for the Pend ecosystem - Democratizing investment opportunities through blockchain technology.* 