# Enhanced PendIdentityRegistry Documentation

## 🆕 **NEWLY DEPLOYED - December 2025**

Enhanced identity registry with comprehensive KYC management and extensible hash storage for the Pend ecosystem.

## 📋 **Overview**

The **Enhanced PendIdentityRegistry** is a next-generation smart contract that provides:
- **Comprehensive KYC Management** with hash logging and verification
- **Extensible Hash Storage** supporting multiple hash types per identity
- **Role-Based Access Control** integration with AccessControlHub
- **Advanced Audit Functions** for compliance and oversight
- **Region-Based User Management** with audit trails

## 🔗 **Contract Details**

- **Contract Address**: `0x074C5a96106b2Dcefb74b174034bd356943b2723`
- **Network**: Pend Local Network (Chain ID: 7777)
- **Deployed**: December 26, 2025
- **AccessControlHub**: `0x57Bee198a7148A94f27a71465216bB67f166b9F4`
- **ConsentManager**: `0xdcA98EF58D3cD8d15560A20d9ff6A393E6323E87`

## 🎯 **Core KYC Functions**

### 1. **logKYC() Function**
```solidity
function logKYC(address user, bytes32 kycHash, string metadata) external onlyKYCConfirmer
```
- **Purpose**: Logs KYC hash for a user with metadata
- **Access**: KYC_CONFIRMER_ROLE only
- **Events**: Emits `KYCLogged` event
- **Usage**: Primary function for recording KYC completion

### 2. **isKYCed() Function**
```solidity
function isKYCed(address user) external view returns (bool)
```
- **Purpose**: Check if user has completed KYC
- **Access**: Public view function
- **Returns**: True if user has KYC hash recorded
- **Usage**: Quick KYC status verification

### 3. **getKYC() Function**
```solidity
function getKYC(address user) external view returns (bytes32 kycHash, uint256 timestamp)
```
- **Purpose**: Retrieve latest KYC data for user
- **Access**: Public view function  
- **Returns**: KYC hash and timestamp
- **Usage**: Get KYC verification details

## 🔧 **Extensible Hash Storage**

### Supported Hash Types
```solidity
bytes32 public constant KYC_HASH_TYPE = keccak256("KYC_HASH");
bytes32 public constant BIOMETRIC_HASH_TYPE = keccak256("BIOMETRIC_HASH");
bytes32 public constant DEVICE_HASH_TYPE = keccak256("DEVICE_HASH");
bytes32 public constant LOCATION_HASH_TYPE = keccak256("LOCATION_HASH");
bytes32 public constant GOV_ID_HASH_TYPE = keccak256("GOV_ID_HASH");
```

### Hash Storage Functions

#### Store Single Hash
```solidity
function storeHash(
    address user,
    bytes32 hashType,
    bytes32 hashValue,
    string metadata
) external onlyKYCConfirmer
```

#### Store Multiple Hashes
```solidity
function storeHashesBatch(
    address user,
    bytes32[] hashTypes,
    bytes32[] hashValues,
    string[] metadataArray
) external onlyKYCConfirmer
```

#### Retrieve Hash Data
```solidity
function getLatestHash(address user, bytes32 hashType) external view returns (bytes32, uint256)
function getAllHashes(address user, bytes32 hashType) external view returns (HashRecord[])
```

## 🏛️ **Audit Functions**

### For Data Viewers & Auditors

#### User Enumeration
```solidity
function getAllUsers() external view onlyDataViewer returns (address[])
function getUsersByRegion(string region) external view onlyDataViewer returns (address[])
function getTotalUserCount() external view returns (uint256)
function getUserCountByRegion(string region) external view returns (uint256)
```

#### KYC Statistics (Auditor Only)
```solidity
function getKYCStats() external view onlyAuditor returns (
    uint256 totalUsers,
    uint256 kycedUsers,
    uint256 verifiedUsers
)
```

## 🌍 **Region Management**

### Pre-configured Regions
- **EG**: Egypt
- **US**: United States  
- **EU**: European Union
- **GLOBAL**: Global/International

### Region Functions
```solidity
function addRegion(string region) external onlyKYCConfirmer
function isValidRegion(string region) external view returns (bool)
```

## 🔐 **Role-Based Access Control**

### Required Roles

| Function Category | Required Role | Description |
|------------------|---------------|-------------|
| KYC Operations | `KYC_CONFIRMER_ROLE` | Log KYC, store hashes, verify identities |
| Data Access | `DATA_VIEWER_ROLE` | View user lists and basic statistics |
| Audit Functions | `AUDITOR_ROLE` | Access advanced statistics and audit data |

### Role Constants
```javascript
// Role identifiers (from AccessControlHub)
KYC_CONFIRMER_ROLE: 0xc306eb14cc851371fb03b806f481b27efeb013e0c92fe29ccf2316f866d137cd
AUDITOR_ROLE: 0x59a1c48e5837ad7a7f3dcedcbe129bf3249ec4fbf651fd4f5e2600ead39fe2f5
DATA_VIEWER_ROLE: 0xa6bef0a9c9172963f33abd87689a7211b856899bba2160209d377e22dd3d1136
```

## 📝 **Usage Examples**

### Identity Registration
```javascript
// Register new identity
await registry.registerIdentity(
    ethers.keccak256(ethers.toUtf8Bytes("user@example.com")), // identityHash
    "device-fingerprint-123",                                  // deviceFingerprint
    ethers.keccak256(ethers.toUtf8Bytes("consent-data")),     // consentHash  
    "EG",                                                      // region
    "+20123456789"                                            // phoneNumber
);
```

### KYC Operations
```javascript
// Log KYC completion
await registry.logKYC(
    userAddress,
    ethers.keccak256(ethers.toUtf8Bytes("kyc-verification-data")),
    "KYC completed via document verification"
);

// Check KYC status  
const isKYCed = await registry.isKYCed(userAddress);

// Get KYC details
const [kycHash, timestamp] = await registry.getKYC(userAddress);
```

### Extensible Hash Storage
```javascript
// Store biometric hash
await registry.storeHash(
    userAddress,
    await registry.BIOMETRIC_HASH_TYPE(),
    ethers.keccak256(ethers.toUtf8Bytes("face-template-data")),
    "Facial recognition template v2.1"
);

// Store multiple hashes at once
await registry.storeHashesBatch(
    userAddress,
    [
        await registry.DEVICE_HASH_TYPE(),
        await registry.LOCATION_HASH_TYPE()
    ],
    [
        ethers.keccak256(ethers.toUtf8Bytes("device-fingerprint")),
        ethers.keccak256(ethers.toUtf8Bytes("location-proof"))
    ],
    ["Device authentication", "Location verification"]
);
```

### Audit Operations
```javascript
// Get all users (DATA_VIEWER_ROLE required)
const allUsers = await registry.getAllUsers();

// Get users by region
const egyptianUsers = await registry.getUsersByRegion("EG");

// Get KYC statistics (AUDITOR_ROLE required)
const [totalUsers, kycedUsers, verifiedUsers] = await registry.getKYCStats();
```

## 🔄 **Integration with Existing System**

### Backward Compatibility
The enhanced contract maintains backward compatibility with existing functions:
- `registerPhoneNumber()` - Legacy phone registration
- `upgradeIdentity()` - Legacy identity upgrade with gov ID and biometric hashes

### Server Integration
Update your environment variables:
```bash
IDENTITY_REGISTRY_ADDRESS=0x074C5a96106b2Dcefb74b174034bd356943b2723
```

Update contract ABIs to include new functions:
```javascript
const identityRegistryAbi = [
    // Core KYC functions
    'function logKYC(address user, bytes32 kycHash, string metadata)',
    'function isKYCed(address user) view returns (bool)',
    'function getKYC(address user) view returns (bytes32, uint256)',
    
    // Hash storage functions
    'function storeHash(address user, bytes32 hashType, bytes32 hashValue, string metadata)',
    'function getLatestHash(address user, bytes32 hashType) view returns (bytes32, uint256)',
    
    // Audit functions
    'function getAllUsers() view returns (address[])',
    'function getUsersByRegion(string region) view returns (address[])',
    'function getKYCStats() view returns (uint256, uint256, uint256)',
    
    // Constants
    'function KYC_HASH_TYPE() view returns (bytes32)',
    'function BIOMETRIC_HASH_TYPE() view returns (bytes32)',
    'function DEVICE_HASH_TYPE() view returns (bytes32)',
    'function LOCATION_HASH_TYPE() view returns (bytes32)',
    'function GOV_ID_HASH_TYPE() view returns (bytes32)',
    
    // Events
    'event KYCLogged(address indexed user, bytes32 indexed kycHash, uint256 timestamp, string metadata)',
    'event HashStored(address indexed user, bytes32 indexed hashType, bytes32 indexed hashValue, uint256 timestamp, string metadata)'
];
```

## 🛡️ **Security Considerations**

### Access Control
- All KYC operations require `KYC_CONFIRMER_ROLE`
- Audit functions require appropriate roles (`DATA_VIEWER_ROLE` or `AUDITOR_ROLE`)
- Hash storage supports overwriting and multiple entries per identity

### Data Privacy
- All sensitive data is stored as hashes
- Metadata is stored on-chain for audit trails
- Off-chain data correlation required for full functionality

### Hash Management
- Multiple hash versions supported per type
- Latest hash easily retrievable
- Historical hash data maintained for audit

## 🔧 **Testing & Verification**

### Deployed Hash Type Constants
```
KYC_HASH_TYPE: 0xb3bc1cc745a34d6b6ed982778605337402498f0e2fee0d09106d501371a02377
BIOMETRIC_HASH_TYPE: 0x5d05dc8fff2ef0c2903c5f97bfc6c6228e056d7c75f1e401572980385f41777
DEVICE_HASH_TYPE: 0x2b4387c14cc7dd036809f9ef0ced335c71282192bb5902b52e46772e0471e98
LOCATION_HASH_TYPE: 0xefe04680ca70112a75abc53a3fd18791d7a7c123e1bce3c9fa32f22352dac294
GOV_ID_HASH_TYPE: 0x6b9dee94bf8ede571bc584e33f336ba8cb4d3ac4dba902a6f022c54785b83443
```

### Valid Regions
- EG ✅
- US ✅  
- EU ✅
- GLOBAL ✅

## 📊 **Current Status**
- **Total Users**: 0 (freshly deployed)
- **Roles Configured**: ✅ KYC_CONFIRMER, AUDITOR, DATA_VIEWER
- **Region Support**: ✅ 4 regions configured
- **Hash Types**: ✅ 5 hash types supported
- **Integration Ready**: ✅ Backward compatible

---

**🎉 The Enhanced PendIdentityRegistry is now live and ready for comprehensive KYC and identity management operations!** 