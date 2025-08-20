# AccessControlHub Migration Guide

## Overview

This guide explains how to migrate existing contracts in the PEND ecosystem to use the centralized AccessControlHub for role management instead of maintaining their own access control logic.

## Migration Benefits

- **Centralized Management**: Single source of truth for all role assignments
- **Reduced Gas Costs**: No duplicate role storage across contracts
- **Consistent Security**: Unified access control patterns
- **Easy Auditing**: All role changes in one place
- **Batch Operations**: Efficient multi-user role management

## Contracts to Migrate

### 1. AssetFactory Contract

**Current State**: Uses its own `authorizedAssetManagers` mapping

**Migration Steps**:

1. **Update Constructor**:
```solidity
// Add AccessControlHub reference
IAccessControlHub public immutable accessControlHub;

constructor(address _consentManager, address _accessControlHub) {
    consentManager = _consentManager;
    accessControlHub = IAccessControlHub(_accessControlHub);
}
```

2. **Replace Authorization Modifier**:
```solidity
// Old modifier
modifier onlyAuthorizedAssetManager() {
    if (!authorizedAssetManagers[msg.sender]) revert NotAuthorizedAssetManager();
    _;
}

// New modifier using AccessControlHub
modifier onlyAuthorizedAssetManager() {
    if (!accessControlHub.isAssetIssuer(msg.sender)) revert NotAuthorizedAssetManager();
    _;
}
```

3. **Remove Local Authorization Functions**:
```solidity
// Remove these functions as they're handled by AccessControlHub:
// - authorizeAssetManager()
// - revokeAssetManager()
// - authorizedAssetManagers mapping
// - assetManagerNames mapping
```

### 2. InterestOnlyAssetFactory Contract

Similar migration pattern as AssetFactory - replace local authorization with AccessControlHub's ASSET_ISSUER_ROLE.

### 3. ConsentManager Contract

**Current State**: Uses a single `validator` address

**Migration Steps**:

1. **Use CONSENT_AGENT_ROLE**:
```solidity
modifier onlyValidator() {
    if (!accessControlHub.isConsentAgent(msg.sender)) revert NotValidator();
    _;
}
```

### 4. PendIdentityRegistry Contract

**Current State**: Uses `validator` role

**Migration Steps**:

1. **Use KYC_CONFIRMER_ROLE** for identity verification:
```solidity
modifier onlyValidator() {
    if (!accessControlHub.isKYCConfirmer(msg.sender)) revert NotValidator();
    _;
}
```

### 5. InvestmentAgreement Contract

Similar pattern - replace `validator` with CONSENT_AGENT_ROLE.

## Migration Script Example

```javascript
// scripts/migrate-to-access-control-hub.js
const hre = require("hardhat");

async function main() {
    // Deploy AccessControlHub
    const AccessControlHub = await hre.ethers.getContractFactory("AccessControlHub");
    const accessControlHub = await AccessControlHub.deploy();
    await accessControlHub.waitForDeployment();
    
    const hubAddress = await accessControlHub.getAddress();
    console.log("AccessControlHub deployed to:", hubAddress);
    
    // Get role constants
    const ASSET_ISSUER_ROLE = await accessControlHub.ASSET_ISSUER_ROLE();
    const KYC_CONFIRMER_ROLE = await accessControlHub.KYC_CONFIRMER_ROLE();
    const CONSENT_AGENT_ROLE = await accessControlHub.CONSENT_AGENT_ROLE();
    
    // Migrate existing asset managers
    const existingAssetManagers = [
        "0x...", // List from current AssetFactory
        "0x...",
    ];
    
    // Grant roles in batch
    await accessControlHub.grantRoleBatch(ASSET_ISSUER_ROLE, existingAssetManagers);
    console.log("Migrated asset issuers");
    
    // Migrate validators
    const existingValidators = ["0x..."];
    for (const validator of existingValidators) {
        await accessControlHub.grantRole(KYC_CONFIRMER_ROLE, validator);
        await accessControlHub.grantRole(CONSENT_AGENT_ROLE, validator);
    }
    console.log("Migrated validators");
    
    // Deploy updated contracts with AccessControlHub
    // ... deploy new versions of contracts
}

main().catch((error) => {
    console.error(error);
    process.exit(1);
});
```

## Testing Migration

```javascript
// test/migration.test.js
describe("AccessControlHub Migration", function () {
    it("Should maintain existing permissions after migration", async function () {
        // Deploy old and new systems
        const oldAssetFactory = await deployOldAssetFactory();
        const accessControlHub = await deployAccessControlHub();
        const newAssetFactory = await deployNewAssetFactory(accessControlHub.address);
        
        // Get existing asset managers
        const assetManager = await getExistingAssetManager();
        
        // Grant role in AccessControlHub
        const ASSET_ISSUER_ROLE = await accessControlHub.ASSET_ISSUER_ROLE();
        await accessControlHub.grantRole(ASSET_ISSUER_ROLE, assetManager);
        
        // Test that permissions work in new system
        await expect(
            newAssetFactory.connect(assetManager).deployAsset(...)
        ).to.not.be.reverted;
    });
});
```

## Post-Migration Checklist

- [ ] Deploy AccessControlHub to production network
- [ ] Grant initial roles to existing authorized addresses
- [ ] Deploy updated contracts with AccessControlHub integration
- [ ] Update frontend to check roles via AccessControlHub
- [ ] Update backend services to use AccessControlHub for authorization
- [ ] Remove old authorization code from contracts
- [ ] Update documentation to reference AccessControlHub
- [ ] Monitor events from AccessControlHub for role changes

## Role Mapping Reference

| Old System | AccessControlHub Role | Description |
|------------|----------------------|-------------|
| `authorizedAssetManagers` | `ASSET_ISSUER_ROLE` | Can deploy and manage assets |
| `validator` (ConsentManager) | `CONSENT_AGENT_ROLE` | Can verify consent |
| `validator` (IdentityRegistry) | `KYC_CONFIRMER_ROLE` | Can verify identities |
| N/A | `AUDITOR_ROLE` | New role for audit access |
| N/A | `DATA_VIEWER_ROLE` | New role for data viewing |

## Security Considerations

1. **Gradual Migration**: Deploy new contracts alongside old ones initially
2. **Role Verification**: Ensure all existing permissions are properly migrated
3. **Backup Plan**: Keep old contracts accessible until migration is verified
4. **Audit Trail**: Document all role assignments during migration

## Support

For migration assistance:
- Review `contracts/examples/AccessControlIntegrationExample.sol`
- Check `docs/contracts/AccessControlHub.md` for detailed documentation
- Run tests: `npx hardhat test test/accessControlHub.t.js` 