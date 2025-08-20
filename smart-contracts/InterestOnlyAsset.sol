// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IConsentManager.sol";

/**
 * @title InterestOnlyAsset
 * @dev Tracks interest (whitelisting) in a real-world asset before tokenization
 * @notice Allows users to register interest, sign consent, and be tracked on-chain as part of a whitelist before full ERC-20 deployment
 */
contract InterestOnlyAsset {
    /*//////////////////////////////////////////////////////////////
                                 STRUCTS
    //////////////////////////////////////////////////////////////*/
    struct InterestRecord {
        address user;
        uint256 timestamp;
        string contact;              // Email or phone (stored off-chain style)
        bytes32 consentHash;         // Hash of consent data
        uint256 investmentIntent;    // User's planned investment amount
        bool active;                 // Whether interest is still active
    }

    /*//////////////////////////////////////////////////////////////
                                STORAGE
    //////////////////////////////////////////////////////////////*/
    string public name;
    string public metadataUrl;       // Off-chain asset details
    string public agreementUrl;      // Legal agreement URL
    bytes32 public agreementHash;    // Hash of legal agreement
    uint256 public softCap;          // Maximum number of interested users OR total intended amount
    uint256 public deadline;         // Optional deadline for interest period
    address public admin;            // Contract admin (asset manager)
    address public consentManager;   // Consent verification contract
    
    // Interest tracking
    address[] public interestedUsers;
    mapping(address => InterestRecord) public interestRecords;
    mapping(address => bool) public hasShownInterest;
    
    // Contract state
    bool public interestPeriodActive;
    bool public readyForDeployment;
    uint256 public totalInvestmentIntent;  // Sum of all investment intents
    uint256 public createdAt;
    
    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/
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
    
    /*//////////////////////////////////////////////////////////////
                                 ERRORS
    //////////////////////////////////////////////////////////////*/
    error NotAdmin();
    error InterestPeriodInactive();
    error InterestPeriodExpired();
    error AlreadyShownInterest();
    error SoftCapReached();
    error HasNotShownInterest();
    error ConsentVerificationFailed();
    error InvalidParameters();
    error ZeroAddress();
    error DeadlinePassed();

    /*//////////////////////////////////////////////////////////////
                                MODIFIERS
    //////////////////////////////////////////////////////////////*/
    modifier onlyAdmin() {
        if (msg.sender != admin) revert NotAdmin();
        _;
    }
    
    modifier onlyActiveInterestPeriod() {
        if (!interestPeriodActive) revert InterestPeriodInactive();
        if (deadline > 0 && block.timestamp > deadline) revert InterestPeriodExpired();
        _;
    }

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/
    constructor(
        string memory _name,
        string memory _metadataUrl,
        string memory _agreementUrl,
        bytes32 _agreementHash,
        uint256 _softCap,
        uint256 _deadline,
        address _consentManager
    ) {
        if (bytes(_name).length == 0) revert InvalidParameters();
        if (bytes(_metadataUrl).length == 0) revert InvalidParameters();
        if (bytes(_agreementUrl).length == 0) revert InvalidParameters();
        if (_agreementHash == bytes32(0)) revert InvalidParameters();
        if (_softCap == 0) revert InvalidParameters();
        if (_deadline > 0 && _deadline <= block.timestamp) revert DeadlinePassed();
        
        name = _name;
        metadataUrl = _metadataUrl;
        agreementUrl = _agreementUrl;
        agreementHash = _agreementHash;
        softCap = _softCap;
        deadline = _deadline;
        admin = msg.sender;
        consentManager = _consentManager;
        interestPeriodActive = true;
        readyForDeployment = false;
        createdAt = block.timestamp;
    }

    /*//////////////////////////////////////////////////////////////
                          INTEREST REGISTRATION
    //////////////////////////////////////////////////////////////*/
    function showInterest(
        string calldata contact,
        bytes32 consentHash,
        uint256 investmentIntent
    ) external onlyActiveInterestPeriod {
        if (hasShownInterest[msg.sender]) revert AlreadyShownInterest();
        if (interestedUsers.length >= softCap) revert SoftCapReached();
        if (bytes(contact).length == 0) revert InvalidParameters();
        if (consentHash == bytes32(0)) revert InvalidParameters();
        
        // Create interest record
        InterestRecord memory record = InterestRecord({
            user: msg.sender,
            timestamp: block.timestamp,
            contact: contact,
            consentHash: consentHash,
            investmentIntent: investmentIntent,
            active: true
        });
        
        // Update mappings and arrays
        interestRecords[msg.sender] = record;
        hasShownInterest[msg.sender] = true;
        interestedUsers.push(msg.sender);
        totalInvestmentIntent += investmentIntent;
        
        emit InterestRegistered(
            msg.sender,
            contact,
            investmentIntent,
            consentHash,
            block.timestamp
        );
    }
    
    function showInterestWithConsent(
        string calldata contact,
        bytes32 consentHash,
        uint256 investmentIntent,
        bytes calldata rawInput,
        string calldata phoneNumber,
        string calldata action
    ) external onlyActiveInterestPeriod {
        // Verify consent through ConsentManager if available
        if (consentManager != address(0)) {
            bool consentValid = IConsentManager(consentManager).verifyConsent(
                rawInput,
                phoneNumber,
                action
            );
            if (!consentValid) revert ConsentVerificationFailed();
        }
        
        // Call internal interest registration
        if (hasShownInterest[msg.sender]) revert AlreadyShownInterest();
        if (interestedUsers.length >= softCap) revert SoftCapReached();
        if (bytes(contact).length == 0) revert InvalidParameters();
        if (consentHash == bytes32(0)) revert InvalidParameters();
        
        // Create interest record
        InterestRecord memory record = InterestRecord({
            user: msg.sender,
            timestamp: block.timestamp,
            contact: contact,
            consentHash: consentHash,
            investmentIntent: investmentIntent,
            active: true
        });
        
        // Update mappings and arrays
        interestRecords[msg.sender] = record;
        hasShownInterest[msg.sender] = true;
        interestedUsers.push(msg.sender);
        totalInvestmentIntent += investmentIntent;
        
        emit InterestRegistered(
            msg.sender,
            contact,
            investmentIntent,
            consentHash,
            block.timestamp
        );
    }

    /*//////////////////////////////////////////////////////////////
                          INTEREST MANAGEMENT
    //////////////////////////////////////////////////////////////*/
    function withdrawInterest() external {
        if (!hasShownInterest[msg.sender]) revert HasNotShownInterest();
        
        InterestRecord storage record = interestRecords[msg.sender];
        record.active = false;
        totalInvestmentIntent -= record.investmentIntent;
        
        // Remove from interestedUsers array
        for (uint256 i = 0; i < interestedUsers.length; i++) {
            if (interestedUsers[i] == msg.sender) {
                interestedUsers[i] = interestedUsers[interestedUsers.length - 1];
                interestedUsers.pop();
                break;
            }
        }
        
        hasShownInterest[msg.sender] = false;
        
        emit InterestWithdrawn(msg.sender, block.timestamp);
    }
    
    function updateInvestmentIntent(uint256 newInvestmentIntent) external {
        if (!hasShownInterest[msg.sender]) revert HasNotShownInterest();
        if (!interestPeriodActive) revert InterestPeriodInactive();
        
        InterestRecord storage record = interestRecords[msg.sender];
        uint256 oldIntent = record.investmentIntent;
        record.investmentIntent = newInvestmentIntent;
        
        // Update total
        totalInvestmentIntent = totalInvestmentIntent - oldIntent + newInvestmentIntent;
    }

    /*//////////////////////////////////////////////////////////////
                            ADMIN FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function closeInterestPeriod() external onlyAdmin {
        interestPeriodActive = false;
        emit InterestPeriodClosed(interestedUsers.length, totalInvestmentIntent, block.timestamp);
    }
    
    function reopenInterestPeriod() external onlyAdmin {
        if (deadline > 0 && block.timestamp > deadline) revert DeadlinePassed();
        interestPeriodActive = true;
    }
    
    function setReadyForDeployment(bool ready) external onlyAdmin {
        readyForDeployment = ready;
        emit ReadyForDeployment(ready, block.timestamp);
    }
    
    function updateSoftCap(uint256 newSoftCap) external onlyAdmin {
        if (newSoftCap == 0) revert InvalidParameters();
        uint256 oldCap = softCap;
        softCap = newSoftCap;
        emit SoftCapUpdated(oldCap, newSoftCap);
    }
    
    function updateDeadline(uint256 newDeadline) external onlyAdmin {
        if (newDeadline > 0 && newDeadline <= block.timestamp) revert DeadlinePassed();
        uint256 oldDeadline = deadline;
        deadline = newDeadline;
        emit DeadlineUpdated(oldDeadline, newDeadline);
    }
    
    function updateMetadata(string calldata newMetadataUrl) external onlyAdmin {
        metadataUrl = newMetadataUrl;
    }
    
    function transferAdmin(address newAdmin) external onlyAdmin {
        if (newAdmin == address(0)) revert ZeroAddress();
        address oldAdmin = admin;
        admin = newAdmin;
        emit AdminTransferred(oldAdmin, newAdmin);
    }

    /*//////////////////////////////////////////////////////////////
                              VIEW FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function getAllInterested() external view returns (address[] memory) {
        return interestedUsers;
    }
    
    function interestedCount() external view returns (uint256) {
        return interestedUsers.length;
    }
    
    function isInterested(address user) external view returns (bool) {
        return hasShownInterest[user] && interestRecords[user].active;
    }
    
    function getInterestRecord(address user) external view returns (InterestRecord memory) {
        return interestRecords[user];
    }
    
    function getAssetInfo() external view returns (
        string memory _name,
        string memory _metadataUrl,
        string memory _agreementUrl,
        bytes32 _agreementHash,
        uint256 _softCap,
        uint256 _deadline,
        address _admin,
        bool _interestPeriodActive,
        bool _readyForDeployment,
        uint256 _interestedCount,
        uint256 _totalInvestmentIntent,
        uint256 _createdAt
    ) {
        return (
            name,
            metadataUrl,
            agreementUrl,
            agreementHash,
            softCap,
            deadline,
            admin,
            interestPeriodActive,
            readyForDeployment,
            interestedUsers.length,
            totalInvestmentIntent,
            createdAt
        );
    }
    
    function getActiveInterested() external view returns (address[] memory) {
        uint256 activeCount = 0;
        
        // Count active interests
        for (uint256 i = 0; i < interestedUsers.length; i++) {
            if (interestRecords[interestedUsers[i]].active) {
                activeCount++;
            }
        }
        
        // Create array of active interested users
        address[] memory activeUsers = new address[](activeCount);
        uint256 currentIndex = 0;
        
        for (uint256 i = 0; i < interestedUsers.length; i++) {
            if (interestRecords[interestedUsers[i]].active) {
                activeUsers[currentIndex] = interestedUsers[i];
                currentIndex++;
            }
        }
        
        return activeUsers;
    }
    
    function getInterestWithDetails() external view returns (
        address[] memory users,
        uint256[] memory timestamps,
        uint256[] memory investmentIntents,
        bool[] memory activeStatus
    ) {
        uint256 length = interestedUsers.length;
        users = new address[](length);
        timestamps = new uint256[](length);
        investmentIntents = new uint256[](length);
        activeStatus = new bool[](length);
        
        for (uint256 i = 0; i < length; i++) {
            address user = interestedUsers[i];
            InterestRecord memory record = interestRecords[user];
            
            users[i] = user;
            timestamps[i] = record.timestamp;
            investmentIntents[i] = record.investmentIntent;
            activeStatus[i] = record.active;
        }
        
        return (users, timestamps, investmentIntents, activeStatus);
    }
    
    function isExpired() external view returns (bool) {
        return deadline > 0 && block.timestamp > deadline;
    }
    
    function isSoftCapReached() external view returns (bool) {
        return interestedUsers.length >= softCap;
    }
    
    function getRemainingSlots() external view returns (uint256) {
        if (interestedUsers.length >= softCap) {
            return 0;
        }
        return softCap - interestedUsers.length;
    }
    
    function getTimeRemaining() external view returns (uint256) {
        if (deadline == 0 || block.timestamp >= deadline) {
            return 0;
        }
        return deadline - block.timestamp;
    }
} 