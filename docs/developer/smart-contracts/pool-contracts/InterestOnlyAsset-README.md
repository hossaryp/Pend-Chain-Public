# InterestOnlyAsset System - Pre-Launch Interest Tracking

## 🎯 Overview

The `InterestOnlyAsset` system enables Pend to gauge demand for real-world asset investment opportunities **before** deploying full ERC-20 tokenization. This allows for:

- **Demand Validation**: Test market interest before full deployment
- **Whitelist Building**: Create verified investor lists for priority access
- **Consent Management**: Collect legal consent and contact information on-chain
- **Investment Intent Tracking**: Gather planned investment amounts for capacity planning
- **Risk Mitigation**: Avoid deploying unpopular assets or adjust parameters based on demand

---

## 🏗️ Architecture

### Core Contracts

1. **`InterestOnlyAsset.sol`** - Individual interest tracking contract for each asset
2. **`InterestOnlyAssetFactory.sol`** - Factory for deploying and managing multiple interest assets

### Integration with Existing System

- **ConsentManager Integration**: Full consent verification support
- **Asset Manager Authorization**: Role-based access control from existing AssetFactory
- **Event-Driven**: Comprehensive events for blockchain indexing and analytics

---

## 📋 InterestOnlyAsset Contract

### Constructor Parameters

```solidity
constructor(
    string memory _name,                 // "Solar Farm Aswan Q1 2026"
    string memory _metadataUrl,          // Off-chain asset details URL
    string memory _agreementUrl,         // Legal agreement PDF URL
    bytes32 _agreementHash,              // Hash of legal agreement
    uint256 _softCap,                    // Max interested users (e.g., 100)
    uint256 _deadline,                   // Optional deadline (0 = no deadline)
    address _consentManager              // ConsentManager contract address
)
```

### Core Functions

#### Interest Registration

```solidity
// Basic interest registration
function showInterest(
    string calldata contact,             // Email or phone
    bytes32 consentHash,                 // Hash of consent data
    uint256 investmentIntent             // Planned investment amount in wei
) external;

// Interest registration with consent verification
function showInterestWithConsent(
    string calldata contact,
    bytes32 consentHash,
    uint256 investmentIntent,
    bytes calldata rawInput,             // Consent verification data
    string calldata phoneNumber,         // Phone for consent verification
    string calldata action               // Action type for consent
) external;
```

#### Interest Management

```solidity
// Withdraw interest
function withdrawInterest() external;

// Update planned investment amount
function updateInvestmentIntent(uint256 newInvestmentIntent) external;
```

#### Admin Functions

```solidity
// Close/reopen interest period
function closeInterestPeriod() external onlyAdmin;
function reopenInterestPeriod() external onlyAdmin;

// Mark as ready for tokenization
function setReadyForDeployment(bool ready) external onlyAdmin;

// Update parameters
function updateSoftCap(uint256 newSoftCap) external onlyAdmin;
function updateDeadline(uint256 newDeadline) external onlyAdmin;
function updateMetadata(string calldata newMetadataUrl) external onlyAdmin;

// Transfer admin role
function transferAdmin(address newAdmin) external onlyAdmin;
```

#### View Functions

```solidity
// Get all interested users
function getAllInterested() external view returns (address[] memory);

// Get interest count
function interestedCount() external view returns (uint256);

// Check if address is interested
function isInterested(address user) external view returns (bool);

// Get user's interest record
function getInterestRecord(address user) external view returns (InterestRecord memory);

// Get comprehensive asset information
function getAssetInfo() external view returns (...);

// Utility functions
function getRemainingSlots() external view returns (uint256);
function getTimeRemaining() external view returns (uint256);
function isSoftCapReached() external view returns (bool);
function isExpired() external view returns (bool);
```

### Events

```solidity
event InterestRegistered(
    address indexed user,
    string contact,
    uint256 investmentIntent,
    bytes32 consentHash,
    uint256 timestamp
);

event InterestWithdrawn(address indexed user, uint256 timestamp);
event InterestPeriodClosed(uint256 finalCount, uint256 totalIntent, uint256 timestamp);
event ReadyForDeployment(bool ready, uint256 timestamp);
event SoftCapUpdated(uint256 oldCap, uint256 newCap);
event DeadlineUpdated(uint256 oldDeadline, uint256 newDeadline);
event AdminTransferred(address indexed oldAdmin, address indexed newAdmin);
```

---

## 🏭 InterestOnlyAssetFactory Contract

### Factory Functions

```solidity
// Deploy new interest asset
function deployInterestAsset(
    string calldata name,
    string calldata metadataUrl,
    string calldata agreementUrl,
    bytes32 agreementHash,
    uint256 softCap,
    uint256 deadline,
    string calldata category
) external onlyAuthorizedAssetManager returns (address);

// Deploy with consent verification
function deployInterestAssetWithConsent(...) external returns (address);
```

### Management Functions

```solidity
// Asset management
function deactivateInterestAsset(address assetAddress) external;
function markReadyForTokenization(address assetAddress, bool ready) external;
function updateInterestAssetMetadata(address assetAddress, string calldata newMetadataUrl) external;

// Access control
function authorizeAssetManager(address manager, string calldata name) external onlyOwner;
function revokeAssetManager(address manager) external onlyOwner;
```

### View Functions

```solidity
// Get all assets
function getAllInterestAssets() external view returns (address[] memory);
function getActiveInterestAssets() external view returns (address[] memory);
function getReadyForTokenization() external view returns (address[] memory);

// Get assets by category/manager
function getInterestAssetsByCategory(string calldata category) external view returns (address[] memory);
function getInterestAssetsByManager(address manager) external view returns (address[] memory);

// Factory statistics
function getFactoryStats() external view returns (uint256 totalDeployed, uint256 totalActive, uint256 totalReady);

// Comprehensive summary for UI
function getInterestAssetsSummary() external view returns (
    address[] memory addresses,
    string[] memory names,
    string[] memory categories,
    uint256[] memory softCaps,
    uint256[] memory interestedCounts,
    bool[] memory activeStatus,
    bool[] memory readyForTokenization
);
```

---

## 🚀 Deployment Guide

### 1. Deploy Contracts

```bash
cd hardhat
npx hardhat run scripts/deploy-interest-only-assets.js --network besu
```

### 2. Contract Addresses

After deployment, you'll get addresses like:
```
InterestOnlyAssetFactory: 0x[factory-address]
Sample Assets:
  - Solar Farm Aswan Q1 2026: 0x[solar-address]
  - Gold Fund Q3 2026: 0x[gold-address]
```

### 3. Authorize Asset Managers

```solidity
// Factory owner authorizes asset managers
factory.authorizeAssetManager(managerAddress, "Manager Name");
```

---

## 💻 Integration Examples

### Frontend Integration

```javascript
// Get factory contract
const factory = new ethers.Contract(factoryAddress, factoryABI, provider);

// Get all active interest assets
const activeAssets = await factory.getActiveInterestAssets();

// Get comprehensive asset summary for UI
const [addresses, names, categories, softCaps, interestedCounts, activeStatus, readyForTokenization] = 
    await factory.getInterestAssetsSummary();

// For each asset, create UI cards
for (let i = 0; i < addresses.length; i++) {
    if (activeStatus[i]) {
        const asset = new ethers.Contract(addresses[i], interestAssetABI, provider);
        const assetInfo = await asset.getAssetInfo();
        
        // Create asset card with:
        // - Name: names[i]
        // - Category: categories[i] 
        // - Interest: interestedCounts[i] / softCaps[i]
        // - Status: readyForTokenization[i] ? "Ready for Investment" : "Gauging Interest"
    }
}
```

### User Interest Registration

```javascript
// Show interest in an asset
const interestAsset = new ethers.Contract(assetAddress, interestAssetABI, signer);

const contact = "user@example.com";
const consentHash = ethers.keccak256(ethers.toUtf8Bytes("consent-data"));
const investmentIntent = ethers.parseEther("1000"); // 1000 EGP intended

await interestAsset.showInterest(contact, consentHash, investmentIntent);

// With consent verification
await interestAsset.showInterestWithConsent(
    contact,
    consentHash, 
    investmentIntent,
    rawConsentInput,
    phoneNumber,
    "show_asset_interest"
);
```

---

## 🎯 Use Cases

### 1. Early Asset Listings

**Scenario**: Pend wants to list "Solar Farm in Aswan" but needs to validate demand first.

**Process**:
1. Deploy `InterestOnlyAsset` with 100 user soft cap
2. Market the opportunity through Explore tab
3. Users register interest with planned investment amounts
4. Once 80+ users show interest, deploy full ERC-20 contract
5. Migrate interested users to priority whitelist

### 2. Investment Parameter Optimization

**Scenario**: Unsure about minimum investment amount for "Gold Fund Q3".

**Process**:
1. Deploy interest asset asking for investment intent
2. Analyze submitted investment intent amounts
3. Set optimal minimum investment based on actual demand
4. Deploy ERC-20 with optimized parameters

### 3. Market Timing

**Scenario**: Want to launch asset at optimal time.

**Process**:
1. Deploy interest asset with extended deadline
2. Monitor interest registration rate over time
3. Launch full asset when interest rate peaks
4. Use deadline pressure to create urgency

---

## 🔄 Migration to Full Tokenization

### Option 1: Manual Migration

1. Mark interest asset as ready for tokenization:
   ```solidity
   interestAsset.setReadyForDeployment(true);
   factory.markReadyForTokenization(assetAddress, true);
   ```

2. Deploy full ERC-20 asset using `AssetFactory`

3. Whitelist interested users for priority access

### Option 2: Automated Migration (Future Enhancement)

Could add migration function to automatically deploy ERC-20 and transfer whitelist:

```solidity
function migrateToTokenization(
    address interestAssetAddress,
    uint256 tokenPrice,
    uint256 maxSupply,
    uint256 lockupEndTimestamp,
    uint256 minimumInvestment
) external returns (address newAssetAddress);
```

---

## 📊 Analytics and Monitoring

### Key Metrics to Track

1. **Interest Rate**: Registration rate over time
2. **Investment Intent**: Total planned investment vs. asset capacity  
3. **Completion Rate**: % of soft cap reached
4. **Geographic Distribution**: Based on consent data
5. **Drop-off Rate**: Users who withdraw interest

### Event Monitoring

```javascript
// Monitor interest registrations
factory.on("InterestAssetDeployed", (contractAddress, assetManager, category, name) => {
    console.log(`New interest asset: ${name} in ${category}`);
});

interestAsset.on("InterestRegistered", (user, contact, investmentIntent, consentHash, timestamp) => {
    console.log(`New interest from ${user}: ${ethers.formatEther(investmentIntent)} EGP`);
});
```

---

## 🔒 Security Considerations

### Access Control
- Only authorized asset managers can deploy assets
- Only asset admins can manage individual assets
- Only users can manage their own interest records

### Consent Management
- All interest registration requires consent hash
- Optional integration with ConsentManager for verification
- Contact information stored on-chain but can be hashed for privacy

### Data Integrity
- Immutable interest records (except withdrawal)
- Tamper-proof soft cap and deadline enforcement
- Comprehensive event logging for audit trails

---

## 🧪 Testing

Run the comprehensive test suite:

```bash
cd hardhat
npx hardhat test test/interestOnlyAsset.t.js
```

### Test Coverage

- ✅ Deployment validation
- ✅ Interest registration (valid/invalid cases)
- ✅ Soft cap enforcement  
- ✅ Deadline enforcement
- ✅ Interest withdrawal
- ✅ Investment intent updates
- ✅ Admin functions
- ✅ Factory deployment
- ✅ Access control
- ✅ Event emissions
- ✅ View functions
- ✅ Edge cases and error conditions

---

## 🔮 Future Enhancements

### Planned Features

1. **Automated Migration**: Direct migration from interest → ERC-20
2. **Tiered Interest**: Different investment tiers with different benefits
3. **Interest NFTs**: Non-transferable NFTs representing interest registration
4. **Referral Tracking**: Track how users discovered opportunities
5. **Interest Staking**: Require small stake to show serious interest
6. **Batch Operations**: Deploy multiple related assets simultaneously

### Integration Opportunities

1. **PendScan Explorer**: Add interest asset tracking
2. **Notification System**: Alert interested users when assets go live
3. **Analytics Dashboard**: Real-time interest metrics for asset managers
4. **Mobile App**: Push notifications for new interest opportunities

---

## 📞 Support

For questions or issues with the InterestOnlyAsset system:

1. **Documentation**: This README and inline code comments
2. **Tests**: Comprehensive test suite demonstrates all functionality
3. **Examples**: Deployment script shows real-world usage
4. **Architecture**: Follows existing Pend contract patterns

**Built for efficient demand validation in Egyptian DeFi** 🇪🇬 