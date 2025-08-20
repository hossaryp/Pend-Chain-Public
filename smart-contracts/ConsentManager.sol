// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ConsentManager  
 * @dev Enhanced consent management with FRA compliance and audit capabilities
 * @notice Logs hashed consents tied to users with version tracking and role-based access
 */
contract ConsentManager {
    /*//////////////////////////////////////////////////////////////
                                STRUCTS
    //////////////////////////////////////////////////////////////*/
    
    struct Consent {
        bytes32 hash;
        uint256 expiry;
        bool used;
        bytes32 action;
    }
    
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

    /*//////////////////////////////////////////////////////////////
                                STORAGE
    //////////////////////////////////////////////////////////////*/
    
    // Legacy consent storage (maintained for backward compatibility)
    mapping(bytes32 => mapping(bytes32 => Consent)) private consents;
    mapping(bytes32 => string[]) private verifiedActions;
    mapping(bytes32 => mapping(bytes32 => bool)) private actionSeen;
    
    // Enhanced FRA consent logging
    mapping(address => ConsentLog[]) private userConsentHistory;
    mapping(address => uint256) private userConsentCount;
    mapping(bytes32 => ConsentLog[]) private consentLogsByHash;
    
    // Access control
    mapping(address => bool) public consentAgents;
    mapping(address => bool) public consentViewers;
    mapping(address => bool) public consentAuditors;
    
    // Contract settings
    uint256 public consentExpiryTime = 30 days;
    address public owner;
    address public validator; // Legacy support
    
    // FRA compliance tracking
    mapping(string => bool) public supportedVersions;
    mapping(address => mapping(string => bool)) public userVersionConsents;
    uint256 public totalConsentLogs;

    /*//////////////////////////////////////////////////////////////
                                EVENTS
    //////////////////////////////////////////////////////////////*/
    
    // Legacy events (maintained for backward compatibility)
    event ConsentStored(bytes32 indexed identityHash, bytes32 indexed actionHash, uint256 expiry);
    event ConsentVerified(bytes32 indexed identityHash, bytes32 indexed actionHash);
    
    // Enhanced FRA compliance events
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
    event VersionSupported(string indexed versionId, bool supported);

    /*//////////////////////////////////////////////////////////////
                                ERRORS
    //////////////////////////////////////////////////////////////*/
    
    error NotOwner();
    error NotValidator();
    error NotConsentAgent();
    error NotAuthorizedViewer();
    error NotAuthorizedAuditor();
    error ConsentExpired();
    error ConsentAlreadyUsed();
    error InvalidConsent();
    error InvalidVersion();
    error ZeroAddress();
    error EmptyVersionId();
    error EmptyConsentHash();

    /*//////////////////////////////////////////////////////////////
                                MODIFIERS
    //////////////////////////////////////////////////////////////*/
    
    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }
    
    modifier onlyValidator() {
        if (msg.sender != validator) revert NotValidator();
        _;
    }
    
    modifier onlyConsentAgent() {
        if (!consentAgents[msg.sender] && msg.sender != owner) revert NotConsentAgent();
        _;
    }
    
    modifier onlyAuthorizedViewer() {
        if (!consentViewers[msg.sender] && !consentAuditors[msg.sender] && msg.sender != owner) {
            revert NotAuthorizedViewer();
        }
        _;
    }
    
    modifier onlyAuthorizedAuditor() {
        if (!consentAuditors[msg.sender] && msg.sender != owner) revert NotAuthorizedAuditor();
        _;
    }

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/
    
    constructor(address _validator) {
        require(_validator != address(0), "ConsentManager: validator is zero address");
        owner = msg.sender;
        validator = _validator;
        
        // Owner is automatically a consent agent, viewer, and auditor
        consentAgents[msg.sender] = true;
        consentViewers[msg.sender] = true;
        consentAuditors[msg.sender] = true;
        
        // Add default FRA-compliant versions
        supportedVersions["FRA-1.0"] = true;
        supportedVersions["FRA-2.0"] = true;
        supportedVersions["TERMS-1.0"] = true;
        supportedVersions["PRIVACY-1.0"] = true;
        supportedVersions["KYC-1.0"] = true;
    }

    /*//////////////////////////////////////////////////////////////
                          ACCESS CONTROL FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    
    function setConsentAgent(address agent, bool authorized) external onlyOwner {
        if (agent == address(0)) revert ZeroAddress();
        consentAgents[agent] = authorized;
        emit ConsentAgentUpdated(agent, authorized);
    }
    
    function setConsentViewer(address viewer, bool authorized) external onlyOwner {
        if (viewer == address(0)) revert ZeroAddress();
        consentViewers[viewer] = authorized;
        emit ConsentViewerUpdated(viewer, authorized);
    }
    
    function setConsentAuditor(address auditor, bool authorized) external onlyOwner {
        if (auditor == address(0)) revert ZeroAddress();
        consentAuditors[auditor] = authorized;
        emit ConsentAuditorUpdated(auditor, authorized);
    }
    
    function setSupportedVersion(string calldata versionId, bool supported) external onlyOwner {
        if (bytes(versionId).length == 0) revert EmptyVersionId();
        supportedVersions[versionId] = supported;
        emit VersionSupported(versionId, supported);
    }

    /*//////////////////////////////////////////////////////////////
                          ENHANCED CONSENT LOGGING
    //////////////////////////////////////////////////////////////*/
    
    /**
     * @notice Log consent with FRA compliance tracking
     * @param user Address of the user giving consent
     * @param consentHash Hash of the consent data
     * @param versionId Version identifier for compliance tracking
     */
    function logConsent(
        address user,
        bytes32 consentHash,
        string calldata versionId
    ) external onlyConsentAgent {
        if (user == address(0)) revert ZeroAddress();
        if (consentHash == bytes32(0)) revert EmptyConsentHash();
        if (bytes(versionId).length == 0) revert EmptyVersionId();
        if (!supportedVersions[versionId]) revert InvalidVersion();
        
        _logConsentInternal(
            user,
            consentHash,
            versionId,
            keccak256("GENERAL_CONSENT"),
            "",
            "",
            true
        );
    }
    
    /**
     * @notice Log FRA-compliant consent with detailed metadata
     * @param user Address of the user giving consent
     * @param consentHash Hash of the consent data
     * @param versionId Version identifier for compliance tracking
     * @param actionType Type of action requiring consent
     * @param ipAddress IP address of the user (for audit trail)
     * @param deviceInfo Device information (for audit trail)
     */
    function logFRAConsent(
        address user,
        bytes32 consentHash,
        string calldata versionId,
        bytes32 actionType,
        string calldata ipAddress,
        string calldata deviceInfo
    ) external onlyConsentAgent {
        if (user == address(0)) revert ZeroAddress();
        if (consentHash == bytes32(0)) revert EmptyConsentHash();
        if (bytes(versionId).length == 0) revert EmptyVersionId();
        if (!supportedVersions[versionId]) revert InvalidVersion();
        
        _logConsentInternal(
            user,
            consentHash,
            versionId,
            actionType,
            ipAddress,
            deviceInfo,
            true
        );
        
        emit FRAConsentLogged(
            user,
            consentHash,
            versionId,
            actionType,
            ipAddress,
            deviceInfo,
            block.timestamp
        );
    }
    
    function _logConsentInternal(
        address user,
        bytes32 consentHash,
        string memory versionId,
        bytes32 actionType,
        string memory ipAddress,
        string memory deviceInfo,
        bool fraCompliant
    ) internal {
        ConsentLog memory newLog = ConsentLog({
            consentHash: consentHash,
            versionId: versionId,
            timestamp: block.timestamp,
            actionType: actionType,
            loggedBy: msg.sender,
            ipAddress: ipAddress,
            deviceInfo: deviceInfo,
            fraCompliant: fraCompliant
        });
        
        userConsentHistory[user].push(newLog);
        consentLogsByHash[consentHash].push(newLog);
        userConsentCount[user]++;
        userVersionConsents[user][versionId] = true;
        totalConsentLogs++;
        
        emit ConsentLogged(user, consentHash, versionId, block.timestamp, msg.sender);
    }

    /*//////////////////////////////////////////////////////////////
                          CONSENT QUERY FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    
    /**
     * @notice Get the number of consents logged for a user
     * @param user Address of the user
     * @return count Number of consent logs for the user
     */
    function consentCount(address user) external view returns (uint256 count) {
        return userConsentCount[user];
    }
    
    /**
     * @notice Get consent history for a user (hashes only)
     * @param user Address of the user
     * @return hashes Array of consent hashes for the user
     */
    function getConsentHistory(address user) external view onlyAuthorizedViewer returns (bytes32[] memory hashes) {
        ConsentLog[] memory logs = userConsentHistory[user];
        hashes = new bytes32[](logs.length);
        
        for (uint256 i = 0; i < logs.length; i++) {
            hashes[i] = logs[i].consentHash;
        }
        
        return hashes;
    }
    
    /**
     * @notice Get detailed consent history for audit purposes
     * @param user Address of the user
     * @return logs Array of detailed consent logs
     */
    function getDetailedConsentHistory(address user) 
        external 
        view 
        onlyAuthorizedAuditor 
        returns (ConsentLog[] memory logs) 
    {
        return userConsentHistory[user];
    }
    
    /**
     * @notice Check if user has consented to a specific version
     * @param user Address of the user
     * @param versionId Version identifier to check
     * @return hasConsented Whether the user has consented to this version
     */
    function hasUserConsentedToVersion(address user, string calldata versionId) 
        external 
        view 
        returns (bool hasConsented) 
    {
        return userVersionConsents[user][versionId];
    }
    
    /**
     * @notice Get consents by hash (for cross-referencing)
     * @param consentHash Hash to lookup
     * @return logs Array of consent logs with this hash
     */
    function getConsentsByHash(bytes32 consentHash) 
        external 
        view 
        onlyAuthorizedAuditor 
        returns (ConsentLog[] memory logs) 
    {
        return consentLogsByHash[consentHash];
    }

    /*//////////////////////////////////////////////////////////////
                          LEGACY SUPPORT FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    
    function storeConsent(bytes32 identityHash, bytes32 consentHash, string calldata action) external onlyValidator {
        bytes32 actionHash = keccak256(abi.encodePacked(action));
        consents[identityHash][actionHash] = Consent({
            hash: consentHash,
            expiry: block.timestamp + consentExpiryTime,
            used: false,
            action: actionHash
        });
        emit ConsentStored(identityHash, actionHash, block.timestamp + consentExpiryTime);
    }

    function verifyConsent(bytes calldata rawInput, string calldata phoneNumber, string calldata action) external returns (bool) {
        bytes32 identityHash = keccak256(abi.encodePacked(phoneNumber));
        bytes32 actionHash = keccak256(abi.encodePacked(action));
        Consent storage c = consents[identityHash][actionHash];
        if (block.timestamp > c.expiry) revert ConsentExpired();
        if (c.used) revert ConsentAlreadyUsed();
        if (c.hash != keccak256(rawInput)) revert InvalidConsent();
        c.used = true;

        if (!actionSeen[identityHash][actionHash]) {
            verifiedActions[identityHash].push(action);
            actionSeen[identityHash][actionHash] = true;
        }

        emit ConsentVerified(identityHash, actionHash);
        return true;
    }

    function updateValidator(address newValidator) external onlyValidator {
        require(newValidator != address(0), "ConsentManager: validator is zero address");
        validator = newValidator;
    }

    function setConsentExpiryTime(uint256 newExpiry) external onlyValidator {
        consentExpiryTime = newExpiry;
    }

    function getConsent(bytes32 identityHash, string calldata action) external view returns (Consent memory) {
        bytes32 actionHash = keccak256(abi.encodePacked(action));
        return consents[identityHash][actionHash];
    }

    function getVerifiedActions(bytes32 identityHash) external view returns (string[] memory) {
        return verifiedActions[identityHash];
    }

    function isVerified(bytes32 identityHash, string calldata action) external view returns (bool) {
        bytes32 actionHash = keccak256(abi.encodePacked(action));
        return actionSeen[identityHash][actionHash];
    }

    /*//////////////////////////////////////////////////////////////
                          ADMIN & UTILITY FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    
    function transferOwnership(address newOwner) external onlyOwner {
        if (newOwner == address(0)) revert ZeroAddress();
        owner = newOwner;
    }
    
    /**
     * @notice Get contract statistics for monitoring
     * @return stats Array containing [totalLogs, supportedVersionsCount, activeAgents, activeViewers, activeAuditors]
     */
    function getContractStats() external view returns (uint256[5] memory stats) {
        // This is a simplified version - in practice you'd count active agents/viewers/auditors
        stats[0] = totalConsentLogs;
        stats[1] = 5; // Placeholder for supported versions count
        stats[2] = 1; // Placeholder for active agents count  
        stats[3] = 1; // Placeholder for active viewers count
        stats[4] = 1; // Placeholder for active auditors count
    }
    
    /**
     * @notice Emergency function to pause consent logging (if needed)
     * @dev This would be used in case of security issues
     */
    function emergencyPause() external onlyOwner {
        // Implementation would depend on specific requirements
        // Could set a paused state that blocks new consent logging
    }
}