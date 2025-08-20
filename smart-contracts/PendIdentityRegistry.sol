// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./AccessControlHub.sol";
import "./IConsentManager.sol";

/// @title PendIdentityRegistry
/// @notice Enhanced identity registry with KYC management and extensible hash storage
/// @dev Integrates with AccessControlHub for role-based permissions
contract PendIdentityRegistry {
    /*//////////////////////////////////////////////////////////////
                                CONSTANTS
    //////////////////////////////////////////////////////////////*/
    
    // Hash types for extensible storage
    bytes32 public constant KYC_HASH_TYPE = keccak256("KYC_HASH");
    bytes32 public constant BIOMETRIC_HASH_TYPE = keccak256("BIOMETRIC_HASH");
    bytes32 public constant DEVICE_HASH_TYPE = keccak256("DEVICE_HASH");
    bytes32 public constant LOCATION_HASH_TYPE = keccak256("LOCATION_HASH");
    bytes32 public constant GOV_ID_HASH_TYPE = keccak256("GOV_ID_HASH");
    
    /*//////////////////////////////////////////////////////////////
                                STRUCTS
    //////////////////////////////////////////////////////////////*/
    
    struct Identity {
        bytes32 identityHash;
        uint256 registeredAt;
        string deviceFingerprint;
        bytes32 consentHash;
        bool verified;
        string region;
        string phoneNumber;
        uint256 lastUpdated;
    }
    
    struct HashRecord {
        bytes32 hashValue;
        uint256 timestamp;
        bytes32 hashType;
        string metadata;
    }

    /*//////////////////////////////////////////////////////////////
                                STORAGE
    //////////////////////////////////////////////////////////////*/
    
    // Core identity storage
    mapping(address => Identity) private identities;
    mapping(bytes32 => address) private identityHashToAddress;
    
    // Extensible hash storage - supports multiple hashes per identity
    mapping(address => mapping(bytes32 => HashRecord[])) private userHashes;
    mapping(address => mapping(bytes32 => bytes32)) private latestHashes;
    
    // Audit and enumeration
    address[] private allUsers;
    mapping(address => bool) private isRegisteredUser;
    mapping(string => address[]) private usersByRegion;
    mapping(string => bool) private validRegions;
    
    // Contract references
    AccessControlHub public accessControlHub;
    IConsentManager public consentManager;

    /*//////////////////////////////////////////////////////////////
                                EVENTS
    //////////////////////////////////////////////////////////////*/
    
    event IdentityRegistered(
        address indexed user,
        bytes32 indexed identityHash,
        uint256 timestamp,
        string region
    );
    
    event KYCLogged(
        address indexed user,
        bytes32 indexed kycHash,
        uint256 timestamp,
        string metadata
    );
    
    event HashStored(
        address indexed user,
        bytes32 indexed hashType,
        bytes32 indexed hashValue,
        uint256 timestamp,
        string metadata
    );
    
    event IdentityVerified(
        address indexed user,
        bytes32 indexed identityHash,
        uint256 timestamp
    );
    
    event PhoneRegistered(
        bytes32 indexed identityHash,
        string phoneNumber,
        uint256 timestamp
    );

    event RegionAdded(string region);
    
    /*//////////////////////////////////////////////////////////////
                                ERRORS
    //////////////////////////////////////////////////////////////*/
    
    error NotAuthorized();
    error AlreadyRegistered();
    error NotRegistered();
    error InvalidRegion();
    error InvalidHashType();
    error ZeroAddress();
    error EmptyString();
    
    /*//////////////////////////////////////////////////////////////
                                MODIFIERS
    //////////////////////////////////////////////////////////////*/
    
    modifier onlyKYCConfirmer() {
        if (!accessControlHub.hasRole(accessControlHub.KYC_CONFIRMER_ROLE(), msg.sender)) {
            revert NotAuthorized();
        }
        _;
    }
    
    modifier onlyDataViewer() {
        if (!accessControlHub.hasRole(accessControlHub.DATA_VIEWER_ROLE(), msg.sender) &&
            !accessControlHub.hasRole(accessControlHub.AUDITOR_ROLE(), msg.sender)) {
            revert NotAuthorized();
        }
        _;
    }
    
    modifier onlyAuditor() {
        if (!accessControlHub.hasRole(accessControlHub.AUDITOR_ROLE(), msg.sender)) {
            revert NotAuthorized();
        }
        _;
    }
    
    modifier onlyRegistered(address user) {
        if (!isRegisteredUser[user]) revert NotRegistered();
        _;
    }
    
    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor(
        address _accessControlHub,
        address _consentManager
    ) {
        if (_accessControlHub == address(0) || _consentManager == address(0)) {
            revert ZeroAddress();
        }
        
        accessControlHub = AccessControlHub(_accessControlHub);
        consentManager = IConsentManager(_consentManager);
        
        // Initialize valid regions
        validRegions["EG"] = true;
        validRegions["US"] = true;
        validRegions["EU"] = true;
        validRegions["GLOBAL"] = true;
    }
    
    /*//////////////////////////////////////////////////////////////
                          CORE KYC FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    
    /// @notice Log KYC hash for a user
    /// @param user The user address
    /// @param kycHash The KYC hash to log
    /// @param metadata Optional metadata for the KYC record
    function logKYC(
        address user,
        bytes32 kycHash,
        string calldata metadata
    ) external onlyKYCConfirmer onlyRegistered(user) {
        _storeHash(user, KYC_HASH_TYPE, kycHash, metadata);
        emit KYCLogged(user, kycHash, block.timestamp, metadata);
    }
    
    /// @notice Check if a user has completed KYC
    /// @param user The user address to check
    /// @return bool True if user has KYC hash recorded
    function isKYCed(address user) external view returns (bool) {
        return latestHashes[user][KYC_HASH_TYPE] != bytes32(0);
    }
    
    /// @notice Get latest KYC data for a user
    /// @param user The user address
    /// @return kycHash The latest KYC hash
    /// @return timestamp When the KYC was recorded
    function getKYC(address user) external view returns (bytes32 kycHash, uint256 timestamp) {
        bytes32 hash = latestHashes[user][KYC_HASH_TYPE];
        if (hash == bytes32(0)) return (bytes32(0), 0);
        
        HashRecord[] storage records = userHashes[user][KYC_HASH_TYPE];
        for (uint256 i = records.length; i > 0; i--) {
            if (records[i-1].hashValue == hash) {
                return (hash, records[i-1].timestamp);
            }
        }
        return (bytes32(0), 0);
    }
    
    /*//////////////////////////////////////////////////////////////
                        EXTENSIBLE HASH STORAGE
    //////////////////////////////////////////////////////////////*/
    
    /// @notice Store any type of hash for a user
    /// @param user The user address
    /// @param hashType The type of hash (KYC_HASH_TYPE, BIOMETRIC_HASH_TYPE, etc.)
    /// @param hashValue The hash value to store
    /// @param metadata Optional metadata
    function storeHash(
        address user,
        bytes32 hashType,
        bytes32 hashValue,
        string calldata metadata
    ) external onlyKYCConfirmer onlyRegistered(user) {
        _storeHash(user, hashType, hashValue, metadata);
    }
    
    /// @notice Store multiple hashes for a user in batch
    /// @param user The user address
    /// @param hashTypes Array of hash types
    /// @param hashValues Array of hash values
    /// @param metadataArray Array of metadata strings
    function storeHashesBatch(
        address user,
        bytes32[] calldata hashTypes,
        bytes32[] calldata hashValues,
        string[] calldata metadataArray
    ) external onlyKYCConfirmer onlyRegistered(user) {
        require(hashTypes.length == hashValues.length && hashValues.length == metadataArray.length, "Array length mismatch");
        
        for (uint256 i = 0; i < hashTypes.length; i++) {
            _storeHash(user, hashTypes[i], hashValues[i], metadataArray[i]);
        }
    }
    
    /// @notice Get latest hash of a specific type for a user
    /// @param user The user address
    /// @param hashType The hash type to retrieve
    /// @return hashValue The latest hash value
    /// @return timestamp When it was stored
    function getLatestHash(
        address user, 
        bytes32 hashType
    ) external view returns (bytes32 hashValue, uint256 timestamp) {
        bytes32 hash = latestHashes[user][hashType];
        if (hash == bytes32(0)) return (bytes32(0), 0);
        
        HashRecord[] storage records = userHashes[user][hashType];
        for (uint256 i = records.length; i > 0; i--) {
            if (records[i-1].hashValue == hash) {
                return (hash, records[i-1].timestamp);
            }
        }
        return (bytes32(0), 0);
    }
    
    /// @notice Get all hashes of a specific type for a user
    /// @param user The user address
    /// @param hashType The hash type to retrieve
    /// @return records Array of all hash records of that type
    function getAllHashes(
        address user,
        bytes32 hashType
    ) external view returns (HashRecord[] memory) {
        return userHashes[user][hashType];
    }
    
    /*//////////////////////////////////////////////////////////////
                        IDENTITY MANAGEMENT
    //////////////////////////////////////////////////////////////*/
    
    /// @notice Register a new identity (public function for pre-KYC)
    /// @param identityHash The identity hash
    /// @param deviceFingerprint Device fingerprint
    /// @param consentHash Consent hash
    /// @param region User's region
    /// @param phoneNumber User's phone number
    function registerIdentity(
        bytes32 identityHash,
        string calldata deviceFingerprint,
        bytes32 consentHash,
        string calldata region,
        string calldata phoneNumber
    ) external {
        if (isRegisteredUser[msg.sender]) revert AlreadyRegistered();
        if (!validRegions[region]) revert InvalidRegion();
        if (bytes(phoneNumber).length == 0) revert EmptyString();
        
        Identity storage identity = identities[msg.sender];
        identity.identityHash = identityHash;
        identity.registeredAt = block.timestamp;
        identity.deviceFingerprint = deviceFingerprint;
        identity.consentHash = consentHash;
        identity.verified = false;
        identity.region = region;
        identity.phoneNumber = phoneNumber;
        identity.lastUpdated = block.timestamp;
        
        // Update mappings
        identityHashToAddress[identityHash] = msg.sender;
        isRegisteredUser[msg.sender] = true;
        allUsers.push(msg.sender);
        usersByRegion[region].push(msg.sender);
        
        emit IdentityRegistered(msg.sender, identityHash, block.timestamp, region);
        emit PhoneRegistered(identityHash, phoneNumber, block.timestamp);
    }

    /// @notice Verify an identity (KYC Confirmer only)
    /// @param user The user address to verify
    function verifyIdentity(address user) external onlyKYCConfirmer onlyRegistered(user) {
        Identity storage identity = identities[user];
        identity.verified = true;
        identity.lastUpdated = block.timestamp;
        
        emit IdentityVerified(user, identity.identityHash, block.timestamp);
    }
    
    /// @notice Get identity information
    /// @param user The user address
    /// @return identity The identity struct
    function getIdentity(address user) external view returns (Identity memory) {
        return identities[user];
    }

    /*//////////////////////////////////////////////////////////////
                           AUDIT FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    
    /// @notice Get all registered users (Auditor/DataViewer only)
    /// @return users Array of all registered user addresses
    function getAllUsers() external view onlyDataViewer returns (address[] memory) {
        return allUsers;
    }
    
    /// @notice Get users by region (Auditor/DataViewer only)
    /// @param region The region to filter by
    /// @return users Array of user addresses in that region
    function getUsersByRegion(string calldata region) external view onlyDataViewer returns (address[] memory) {
        return usersByRegion[region];
    }
    
    /// @notice Get total user count
    /// @return count Total number of registered users
    function getTotalUserCount() external view returns (uint256) {
        return allUsers.length;
    }
    
    /// @notice Get user count by region
    /// @param region The region to count
    /// @return count Number of users in that region
    function getUserCountByRegion(string calldata region) external view returns (uint256) {
        return usersByRegion[region].length;
    }
    
    /// @notice Get KYC statistics (Auditor only)
    /// @return totalUsers Total registered users
    /// @return kycedUsers Number of users with KYC
    /// @return verifiedUsers Number of verified users
    function getKYCStats() external view onlyAuditor returns (
        uint256 totalUsers,
        uint256 kycedUsers,
        uint256 verifiedUsers
    ) {
        totalUsers = allUsers.length;
        
        for (uint256 i = 0; i < allUsers.length; i++) {
            address user = allUsers[i];
            if (latestHashes[user][KYC_HASH_TYPE] != bytes32(0)) {
                kycedUsers++;
            }
            if (identities[user].verified) {
                verifiedUsers++;
            }
        }
    }
    
    /*//////////////////////////////////////////////////////////////
                          REGION MANAGEMENT
    //////////////////////////////////////////////////////////////*/
    
    /// @notice Add a new valid region (KYC Confirmer only)
    /// @param region The region code to add
    function addRegion(string calldata region) external onlyKYCConfirmer {
        if (bytes(region).length == 0) revert EmptyString();
        validRegions[region] = true;
        emit RegionAdded(region);
    }
    
    /// @notice Check if a region is valid
    /// @param region The region to check
    /// @return bool True if region is valid
    function isValidRegion(string calldata region) external view returns (bool) {
        return validRegions[region];
    }
    
    /*//////////////////////////////////////////////////////////////
                          INTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    
    function _storeHash(
        address user,
        bytes32 hashType,
        bytes32 hashValue,
        string calldata metadata
    ) internal {
        if (hashValue == bytes32(0)) revert InvalidHashType();
        
        // Store the hash record
        userHashes[user][hashType].push(HashRecord({
            hashValue: hashValue,
            timestamp: block.timestamp,
            hashType: hashType,
            metadata: metadata
        }));
        
        // Update latest hash
        latestHashes[user][hashType] = hashValue;
        
        // Update identity last updated timestamp
        identities[user].lastUpdated = block.timestamp;
        
        emit HashStored(user, hashType, hashValue, block.timestamp, metadata);
    }
    
    /*//////////////////////////////////////////////////////////////
                      BACKWARD COMPATIBILITY
    //////////////////////////////////////////////////////////////*/
    
    /// @notice Legacy function for phone registration (validator only)
    /// @param identityHash The identity hash
    /// @param phoneNumber The phone number
    function registerPhoneNumber(
        bytes32 identityHash,
        string calldata phoneNumber
    ) external onlyKYCConfirmer {
        emit PhoneRegistered(identityHash, phoneNumber, block.timestamp);
    }
    
    /// @notice Legacy function for upgrading identity (validator only)
    /// @param user The user address
    /// @param govIdHash Government ID hash
    /// @param biometricHash Biometric hash
    /// @param deviceFingerprint Device fingerprint
    /// @param metadata Additional metadata
    function upgradeIdentity(
        address user,
        bytes32 govIdHash,
        bytes32 biometricHash,
        string calldata deviceFingerprint,
        string calldata metadata
    ) external onlyKYCConfirmer onlyRegistered(user) {
        if (govIdHash != bytes32(0)) {
            _storeHash(user, GOV_ID_HASH_TYPE, govIdHash, metadata);
        }
        if (biometricHash != bytes32(0)) {
            _storeHash(user, BIOMETRIC_HASH_TYPE, biometricHash, metadata);
        }
        if (bytes(deviceFingerprint).length > 0) {
            identities[user].deviceFingerprint = deviceFingerprint;
            identities[user].lastUpdated = block.timestamp;
        }
    }
} 