# AccessControlHub Documentation

## Overview

The `AccessControlHub` contract serves as a centralized role management system for the entire PEND ecosystem. It provides a gas-efficient, secure way to manage roles across multiple contracts, ensuring consistent access control throughout the platform.

## Key Features

- **Centralized Role Management**: Single source of truth for all role assignments
- **5 Pre-defined Roles**: ASSET_ISSUER, KYC_CONFIRMER, CONSENT_AGENT, AUDITOR, DATA_VIEWER
- **Batch Operations**: Grant roles to multiple addresses in a single transaction
- **Role Enumeration**: Query all roles for a specific user
- **Pausable**: Emergency pause functionality for security
- **Gas Efficient**: Uses keccak256 hashes for role identifiers

## Roles

### 1. ASSET_ISSUER_ROLE
- **Purpose**: Deploy and manage tokenized assets
- **Typical Users**: Asset managers, property owners, fund managers
- **Key Permissions**: Deploy new assets, update asset metadata, manage asset lifecycle

### 2. KYC_CONFIRMER_ROLE
- **Purpose**: Verify and confirm user KYC status
- **Typical Users**: Compliance officers, KYC providers
- **Key Permissions**: Update user KYC status, access identity verification data

### 3. CONSENT_AGENT_ROLE
- **Purpose**: Manage user consent and agreements
- **Typical Users**: Legal compliance team, consent management services
- **Key Permissions**: Record consent, verify agreement signatures

### 4. AUDITOR_ROLE
- **Purpose**: View all system data for audit purposes
- **Typical Users**: External auditors, internal audit team
- **Key Permissions**: Read-only access to all system data, generate reports

### 5. DATA_VIEWER_ROLE
- **Purpose**: Limited data viewing permissions
- **Typical Users**: Analytics team, reporting services
- **Key Permissions**: View aggregated data, access non-sensitive information

## Contract Functions

### Role Management

```solidity
// Grant a role to an address
function grantRole(bytes32 role, address account) external onlyOwner

// Revoke a role from an address
function revokeRole(bytes32 role, address account) external onlyOwner

// Grant a role to multiple addresses
function grantRoleBatch(bytes32 role, address[] calldata accounts) external onlyOwner

// User can renounce their own role
function renounceRole(bytes32 role) external
```

### Role Queries

```solidity
// Check if an address has a specific role
function hasRole(bytes32 role, address account) public view returns (bool)

// Get all roles for an address
function getRoles(address account) external view returns (bytes32[] memory)

// Get count of addresses with a specific role
function getRoleMemberCount(bytes32 role) external view returns (uint256)

// Check multiple roles at once
function hasRoles(address account, bytes32[] calldata roles) external view returns (bool[] memory)
```

### Convenience Functions

```solidity
// Role-specific checkers
function isAssetIssuer(address account) external view returns (bool)
function isKYCConfirmer(address account) external view returns (bool)
function isConsentAgent(address account) external view returns (bool)
function isAuditor(address account) external view returns (bool)
function isDataViewer(address account) external view returns (bool)
```

## Integration Guide

### 1. Import the Interface

```solidity
import "./IAccessControlHub.sol";
```

### 2. Store Reference in Your Contract

```solidity
IAccessControlHub public immutable accessControlHub;

constructor(address _accessControlHub) {
    accessControlHub = IAccessControlHub(_accessControlHub);
}
```

### 3. Create Role-Based Modifiers

```solidity
modifier onlyAssetIssuer() {
    require(accessControlHub.isAssetIssuer(msg.sender), "Not asset issuer");
    _;
}

modifier onlyKYCConfirmer() {
    require(accessControlHub.isKYCConfirmer(msg.sender), "Not KYC confirmer");
    _;
}
```

### 4. Use in Functions

```solidity
function deployAsset(...) external onlyAssetIssuer {
    // Asset deployment logic
}

function confirmKYC(address user) external onlyKYCConfirmer {
    // KYC confirmation logic
}
```

## Deployment

### Using Hardhat

```bash
npx hardhat run scripts/deploy-access-control-hub.js --network <network-name>
```

### Post-Deployment Setup

1. **Grant Initial Roles**:
```javascript
const ASSET_ISSUER_ROLE = await accessControlHub.ASSET_ISSUER_ROLE();
await accessControlHub.grantRole(ASSET_ISSUER_ROLE, assetManagerAddress);
```

2. **Batch Grant for Multiple Users**:
```javascript
const auditors = [address1, address2, address3];
await accessControlHub.grantRoleBatch(AUDITOR_ROLE, auditors);
```

3. **Update Other Contracts**:
Update existing contracts to use the AccessControlHub address for role checks.

## Security Considerations

1. **Owner Privileges**: Only the owner can grant/revoke roles. Ensure proper key management.
2. **Role Separation**: Keep roles separate and minimal - don't combine multiple permissions.
3. **Emergency Pause**: Use the pause functionality in case of security incidents.
4. **Regular Audits**: Periodically review role assignments using the enumeration functions.

## Gas Optimization Tips

1. **Batch Operations**: Use `grantRoleBatch` when assigning roles to multiple addresses.
2. **Role Caching**: Cache role checks in your contracts if checking multiple times in one transaction.
3. **Use Convenience Functions**: The role-specific checkers (e.g., `isAssetIssuer`) are more gas-efficient than generic `hasRole`.

## Example Integration

See `AccessControlIntegrationExample.sol` for a complete example of how to integrate the AccessControlHub into your contracts.

## Testing

Run the comprehensive test suite:
```bash
npx hardhat test test/accessControlHub.t.js
```

## Events

The contract emits the following events for off-chain monitoring:
- `RoleGranted`: When a role is granted to an address
- `RoleRevoked`: When a role is revoked from an address
- `RoleBatchGranted`: When roles are granted in batch
- `OwnershipTransferred`: When contract ownership changes
- `ContractPaused`/`ContractUnpaused`: When contract is paused/unpaused 