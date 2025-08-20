// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IConsentManager {
    /*//////////////////////////////////////////////////////////////
                                STRUCTS
    //////////////////////////////////////////////////////////////*/
    
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
                                EVENTS
    //////////////////////////////////////////////////////////////*/
    
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

    /*//////////////////////////////////////////////////////////////
                          LEGACY FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    
    function verifyConsent(bytes calldata rawInput, string calldata phoneNumber, string calldata action) external returns (bool);
    function getConsent(bytes32 identityHash, string calldata action) external view returns (bytes32, uint256, bool, bytes32);
    function isVerified(bytes32 identityHash, string calldata action) external view returns (bool);
    function getVerifiedActions(bytes32 identityHash) external view returns (string[] memory);

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
    ) external;
    
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
    ) external;

    /*//////////////////////////////////////////////////////////////
                          CONSENT QUERY FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    
    /**
     * @notice Get the number of consents logged for a user
     * @param user Address of the user
     * @return count Number of consent logs for the user
     */
    function consentCount(address user) external view returns (uint256 count);
    
    /**
     * @notice Get consent history for a user (hashes only)
     * @param user Address of the user
     * @return hashes Array of consent hashes for the user
     */
    function getConsentHistory(address user) external view returns (bytes32[] memory hashes);
    
    /**
     * @notice Get detailed consent history for audit purposes
     * @param user Address of the user
     * @return logs Array of detailed consent logs
     */
    function getDetailedConsentHistory(address user) external view returns (ConsentLog[] memory logs);
    
    /**
     * @notice Check if user has consented to a specific version
     * @param user Address of the user
     * @param versionId Version identifier to check
     * @return hasConsented Whether the user has consented to this version
     */
    function hasUserConsentedToVersion(address user, string calldata versionId) external view returns (bool hasConsented);
    
    /**
     * @notice Get consents by hash (for cross-referencing)
     * @param consentHash Hash to lookup
     * @return logs Array of consent logs with this hash
     */
    function getConsentsByHash(bytes32 consentHash) external view returns (ConsentLog[] memory logs);

    /*//////////////////////////////////////////////////////////////
                          ACCESS CONTROL FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    
    function setConsentAgent(address agent, bool authorized) external;
    function setConsentViewer(address viewer, bool authorized) external;
    function setConsentAuditor(address auditor, bool authorized) external;
    function setSupportedVersion(string calldata versionId, bool supported) external;

    /*//////////////////////////////////////////////////////////////
                          UTILITY FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    
    function getContractStats() external view returns (uint256[5] memory stats);
    function transferOwnership(address newOwner) external;
} 