# Enhanced Consent Manager Contract Documentation

## Overview

The Enhanced Consent Manager contract is a critical component of the Pend ecosystem, managing user consents and verification status for all on-chain actions with comprehensive FRA compliance and audit capabilities.

## Contract Address

```
0x5103f499A89127068c20711974572563c3dCb819
```

## Key Features

### 1. Enhanced Consent Management
- **FRA-compliant consent logging** with version tracking
- **Role-based access control** (agents, viewers, auditors)
- **Detailed audit trails** with IP and device metadata
- **Cross-referencing capabilities** for compliance reviews
- **Backward compatibility** with legacy consent systems

### 2. Verification System
- **Tiered verification levels** (maintained)
- **Phone number verification** (maintained)
- **Biometric verification support** (maintained)
- **Multi-factor authentication** support through action types
- **Progressive disclosure** based on verification status

### 3. FRA Compliance Features
- **Version management** for legal document compliance
- **Consent history tracking** with immutable audit trails
- **Device and IP logging** for security analysis
- **Action type categorization** (KYC, Investment, Biometric, etc.)
- **Emergency controls** for security incidents

### 4. Security Features
- **Smart contract-level access control** with multiple roles
- **Consent validation** with cryptographic verification
- **Rate limiting and abuse protection** (backend integration)
- **Emergency pause** functionality for security issues

## Contract Interface

### Core Structures

```solidity
struct ConsentLog {
    bytes32 consentHash;
    string versionId;
    uint256 timestamp;
    bytes32 actionType;
    address loggedBy;
    string ipAddress;
    string deviceInfo;
    bool fraCompliant;
}
```

### Enhanced Events

```solidity
event ConsentLogged(
    address indexed user,
    bytes32 indexed consentHash,
    string indexed versionId,
    uint256 timestamp,
    address loggedBy
);

event FRAConsentLogged(
    address indexed user,
    bytes32 indexed consentHash,
    string versionId,
    bytes32 actionType,
    string ipAddress,
    string deviceInfo,
    uint256 timestamp
);

event ConsentAgentUpdated(address indexed agent, bool authorized);
event ConsentViewerUpdated(address indexed viewer, bool authorized);
event ConsentAuditorUpdated(address indexed auditor, bool authorized);
```

### Enhanced Functions

#### Core Consent Logging
```solidity
function logConsent(
    address user,
    bytes32 consentHash,
    string calldata versionId
) external onlyConsentAgent;

function logFRAConsent(
    address user,
    bytes32 consentHash,
    string calldata versionId,
    bytes32 actionType,
    string calldata ipAddress,
    string calldata deviceInfo
) external onlyConsentAgent;
```

#### Consent Queries
```solidity
function consentCount(address user) external view returns (uint256);

function getConsentHistory(address user) external view 
    onlyAuthorizedViewer returns (bytes32[] memory);

function getDetailedConsentHistory(address user) external view 
    onlyAuthorizedAuditor returns (ConsentLog[] memory);

function hasUserConsentedToVersion(address user, string calldata versionId) 
    external view returns (bool);

function getConsentsByHash(bytes32 consentHash) external view 
    onlyAuthorizedAuditor returns (ConsentLog[] memory);
```

#### Access Control Management
```solidity
function setConsentAgent(address agent, bool authorized) external onlyOwner;
function setConsentViewer(address viewer, bool authorized) external onlyOwner;
function setConsentAuditor(address auditor, bool authorized) external onlyOwner;
function setSupportedVersion(string calldata versionId, bool supported) external onlyOwner;
```

#### Legacy Support (Backward Compatibility)
```solidity
function storeConsent(bytes32 identityHash, bytes32 consentHash, string calldata action) external onlyValidator;
function verifyConsent(bytes calldata rawInput, string calldata phoneNumber, string calldata action) external returns (bool);
function isVerified(bytes32 identityHash, string calldata action) external view returns (bool);
function getVerifiedActions(bytes32 identityHash) external view returns (string[] memory);
```

## FRA Compliance Features

### Supported Version Types
- **FRA-1.0, FRA-2.0**: General FRA compliance
- **FRA-INVESTMENT-1.0**: Investment-specific consents
- **FRA-KYC-2.0**: Enhanced KYC compliance
- **FRA-BIOMETRIC-1.0**: Biometric data consent
- **FRA-DEVICE-1.0**: Device verification consent
- **TERMS-1.0, PRIVACY-1.0**: Standard legal documents

### Role-Based Access Control

| Role | Permissions | Functions |
|------|-------------|-----------|
| **Owner** | Full control | All management functions |
| **Consent Agent** | Log consents | `logConsent()`, `logFRAConsent()` |
| **Viewer** | Read consent data | `getConsentHistory()` |
| **Auditor** | Full audit access | `getDetailedConsentHistory()`, `getConsentsByHash()` |

### Audit Trail Components
- **Consent Hash**: Cryptographic proof of agreement
- **Version ID**: Legal document version for compliance
- **Timestamp**: Immutable blockchain timestamp
- **Action Type**: Categorized consent purpose
- **Logged By**: Agent who recorded the consent
- **IP Address**: User's IP for audit trail
- **Device Info**: Device fingerprint for security
- **FRA Compliant**: Compliance flag for regulatory reporting

## Integration Guide

### 1. Enhanced Consent Logging

```typescript
// Basic consent logging
await consentManager.logConsent(
    userAddress,
    consentHash,
    "FRA-INVESTMENT-1.0"
);

// Full FRA-compliant consent with metadata
await consentManager.logFRAConsent(
    userAddress,
    consentHash,
    "FRA-KYC-2.0",
    ethers.keccak256(ethers.toUtf8Bytes("KYC_VERIFICATION")),
    "192.168.1.100",
    "iPhone13,iOS15.2,Safari"
);
```

### 2. Consent Queries

```typescript
// Check consent count
const count = await consentManager.consentCount(userAddress);

// Get consent history (as viewer)
const history = await consentManager.connect(viewer).getConsentHistory(userAddress);

// Check version-specific consent
const hasKYC = await consentManager.hasUserConsentedToVersion(
    userAddress, 
    "FRA-KYC-2.0"
);

// Get detailed audit history (as auditor)
const detailedHistory = await consentManager.connect(auditor)
    .getDetailedConsentHistory(userAddress);
```

### 3. Role Management

```typescript
// Set up roles (owner only)
await consentManager.setConsentAgent(agentAddress, true);
await consentManager.setConsentAuditor(auditorAddress, true);
await consentManager.setConsentViewer(viewerAddress, true);

// Add supported versions
await consentManager.setSupportedVersion("FRA-CUSTOM-1.0", true);
```

### 4. Legacy Integration

```typescript
// Legacy consent verification (still supported)
await consentManager.verifyConsent(
    rawOtpBytes,
    phoneNumber,
    "wallet_creation"
);

// Check legacy verification status
const isVerified = await consentManager.isVerified(
    identityHash,
    "wallet_creation"
);
```

## Deployment Information

- **Network**: Besu Private Chain
- **Deployed At**: Block 2902
- **Deployment Date**: June 26, 2025
- **Deployer**: `0xeaf4197108Dd5810EC0f6036ee0e6E77621a2E39`
- **Validator**: `0xeaf4197108Dd5810EC0f6036ee0e6E77621a2E39`

## Contract Statistics

The contract provides real-time statistics via `getContractStats()`:
- Total consent logs recorded
- Number of supported versions
- Active agents, viewers, and auditors
- Contract operational metrics

## Security Considerations

1. **Access Control**: Strict role-based permissions with owner controls
2. **Data Privacy**: IP addresses and device info stored for audit purposes only
3. **Immutability**: Consent records cannot be modified once logged
4. **Emergency Controls**: Owner can pause operations if security issues arise
5. **Backward Compatibility**: Legacy functions maintained for existing integrations

## Upgrade Path

The enhanced ConsentManager maintains full backward compatibility with existing systems while adding comprehensive FRA compliance features. No changes are required to existing integrations, but new features are available for enhanced compliance and audit capabilities.

For technical support or integration questions, refer to the deployment documentation or contact the development team. 