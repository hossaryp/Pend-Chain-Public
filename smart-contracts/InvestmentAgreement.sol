// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title InvestmentAgreement
 * @dev Stores investment agreement terms on-chain and records user consent signatures
 * @notice Provides immutable proof of agreement acceptance for regulatory compliance (FRA + Reg S)
 */
contract InvestmentAgreement {
    
    /*//////////////////////////////////////////////////////////////
                                STRUCTS
    //////////////////////////////////////////////////////////////*/
    
    struct Agreement {
        string agreementText;           // Full agreement text stored on-chain
        string agreementHash;           // IPFS hash for full document (optional)
        uint256 version;                // Agreement version number
        uint256 createdAt;              // Timestamp when agreement was created
        bool active;                    // Whether this agreement version is active
    }
    
    struct UserSignature {
        address userWallet;             // User's wallet address
        string phoneNumber;             // User's phone number (hashed for privacy)
        uint256 investmentAmount;       // Investment amount at time of signature
        uint256 signedAt;               // Timestamp when user signed
        uint256 agreementVersion;       // Version of agreement signed
        string ipAddress;               // IP address (hashed for audit trail)
        bool verified;                  // Whether signature was verified via OTP
    }
    
    /*//////////////////////////////////////////////////////////////
                                STORAGE
    //////////////////////////////////////////////////////////////*/
    
    address public owner;
    address public validator;  // Trusted validator for signature verification
    
    // Pool ID => Agreement Version => Agreement
    mapping(string => mapping(uint256 => Agreement)) public agreements;
    
    // Pool ID => Latest Version Number  
    mapping(string => uint256) public latestVersion;
    
    // User Phone Hash => Pool ID => Signature Array
    mapping(bytes32 => mapping(string => UserSignature[])) public userSignatures;
    
    // Pool ID => Total Signatures Count
    mapping(string => uint256) public totalSignatures;
    
    /*//////////////////////////////////////////////////////////////
                                EVENTS
    //////////////////////////////////////////////////////////////*/
    
    event AgreementCreated(
        string indexed poolId,
        uint256 indexed version,
        uint256 timestamp
    );
    
    event AgreementSigned(
        string indexed poolId,
        bytes32 indexed userPhoneHash,
        address indexed userWallet,
        uint256 investmentAmount,
        uint256 agreementVersion,
        uint256 timestamp
    );
    
    event SignatureVerified(
        string indexed poolId,
        bytes32 indexed userPhoneHash,
        uint256 timestamp
    );
    
    /*//////////////////////////////////////////////////////////////
                                ERRORS
    //////////////////////////////////////////////////////////////*/
    
    error NotOwner();
    error NotValidator();
    error AgreementNotFound();
    error InactiveAgreement();
    error InvalidInput();
    error AlreadySigned();
    
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
    
    /*//////////////////////////////////////////////////////////////
                                CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/
    
    constructor(address _validator) {
        require(_validator != address(0), "InvestmentAgreement: validator is zero address");
        owner = msg.sender;
        validator = _validator;
    }
    
    /*//////////////////////////////////////////////////////////////
                            ADMIN FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    
    /**
     * @notice Create a new investment agreement for a pool
     * @param poolId Unique identifier for the investment pool
     * @param agreementText Full agreement text to store on-chain
     * @param agreementHash IPFS hash for full document (optional)
     */
    function createAgreement(
        string calldata poolId,
        string calldata agreementText,
        string calldata agreementHash
    ) external onlyOwner {
        if (bytes(poolId).length == 0 || bytes(agreementText).length == 0) {
            revert InvalidInput();
        }
        
        uint256 newVersion = latestVersion[poolId] + 1;
        
        agreements[poolId][newVersion] = Agreement({
            agreementText: agreementText,
            agreementHash: agreementHash,
            version: newVersion,
            createdAt: block.timestamp,
            active: true
        });
        
        // Deactivate previous version
        if (newVersion > 1) {
            agreements[poolId][newVersion - 1].active = false;
        }
        
        latestVersion[poolId] = newVersion;
        
        emit AgreementCreated(poolId, newVersion, block.timestamp);
    }
    
    /**
     * @notice Update validator address
     * @param newValidator New validator address
     */
    function updateValidator(address newValidator) external onlyOwner {
        require(newValidator != address(0), "InvestmentAgreement: validator is zero address");
        validator = newValidator;
    }
    
    /**
     * @notice Transfer ownership
     * @param newOwner New owner address
     */
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "InvestmentAgreement: new owner is zero address");
        owner = newOwner;
    }
    
    /*//////////////////////////////////////////////////////////////
                            SIGNATURE FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    
    /**
     * @notice Record user's agreement signature (called by validator)
     * @param poolId Pool identifier
     * @param phoneNumber User's phone number
     * @param userWallet User's wallet address
     * @param investmentAmount Investment amount
     * @param ipAddress User's IP address (for audit trail)
     */
    function signAgreement(
        string calldata poolId,
        string calldata phoneNumber,
        address userWallet,
        uint256 investmentAmount,
        string calldata ipAddress
    ) external onlyValidator {
        uint256 currentVersion = latestVersion[poolId];
        if (currentVersion == 0) revert AgreementNotFound();
        if (!agreements[poolId][currentVersion].active) revert InactiveAgreement();
        
        bytes32 phoneHash = keccak256(abi.encodePacked(phoneNumber));
        bytes32 ipHash = keccak256(abi.encodePacked(ipAddress));
        
        // Check if user already signed current version
        UserSignature[] storage signatures = userSignatures[phoneHash][poolId];
        for (uint256 i = 0; i < signatures.length; i++) {
            if (signatures[i].agreementVersion == currentVersion && !signatures[i].verified) {
                revert AlreadySigned();
            }
        }
        
        // Record signature
        userSignatures[phoneHash][poolId].push(UserSignature({
            userWallet: userWallet,
            phoneNumber: string(abi.encodePacked(phoneHash)), // Store hash for privacy
            investmentAmount: investmentAmount,
            signedAt: block.timestamp,
            agreementVersion: currentVersion,
            ipAddress: string(abi.encodePacked(ipHash)),
            verified: false
        }));
        
        totalSignatures[poolId]++;
        
        emit AgreementSigned(
            poolId,
            phoneHash,
            userWallet,
            investmentAmount,
            currentVersion,
            block.timestamp
        );
    }
    
    /**
     * @notice Verify user's signature after OTP confirmation
     * @param poolId Pool identifier
     * @param phoneNumber User's phone number
     */
    function verifySignature(
        string calldata poolId,
        string calldata phoneNumber
    ) external onlyValidator {
        bytes32 phoneHash = keccak256(abi.encodePacked(phoneNumber));
        UserSignature[] storage signatures = userSignatures[phoneHash][poolId];
        
        require(signatures.length > 0, "No signatures found");
        
        // Find and verify the latest unverified signature
        for (uint256 i = signatures.length; i > 0; i--) {
            if (!signatures[i-1].verified) {
                signatures[i-1].verified = true;
                emit SignatureVerified(poolId, phoneHash, block.timestamp);
                break;
            }
        }
    }
    
    /*//////////////////////////////////////////////////////////////
                            VIEW FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    
    /**
     * @notice Get current active agreement for a pool
     * @param poolId Pool identifier
     * @return Agreement struct
     */
    function getCurrentAgreement(string calldata poolId) 
        external 
        view 
        returns (Agreement memory) 
    {
        uint256 currentVersion = latestVersion[poolId];
        if (currentVersion == 0) revert AgreementNotFound();
        return agreements[poolId][currentVersion];
    }
    
    /**
     * @notice Get specific agreement version
     * @param poolId Pool identifier
     * @param version Agreement version
     * @return Agreement struct
     */
    function getAgreement(string calldata poolId, uint256 version)
        external
        view
        returns (Agreement memory)
    {
        if (version == 0 || version > latestVersion[poolId]) revert AgreementNotFound();
        return agreements[poolId][version];
    }
    
    /**
     * @notice Check if user has signed current agreement version
     * @param poolId Pool identifier
     * @param phoneNumber User's phone number
     * @return bool Whether user has signed and verified
     */
    function hasUserSigned(string calldata poolId, string calldata phoneNumber)
        external
        view
        returns (bool)
    {
        bytes32 phoneHash = keccak256(abi.encodePacked(phoneNumber));
        uint256 currentVersion = latestVersion[poolId];
        
        UserSignature[] storage signatures = userSignatures[phoneHash][poolId];
        for (uint256 i = 0; i < signatures.length; i++) {
            if (signatures[i].agreementVersion == currentVersion && signatures[i].verified) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * @notice Get user's signature history for a pool
     * @param poolId Pool identifier
     * @param phoneNumber User's phone number
     * @return UserSignature array
     */
    function getUserSignatures(string calldata poolId, string calldata phoneNumber)
        external
        view
        returns (UserSignature[] memory)
    {
        bytes32 phoneHash = keccak256(abi.encodePacked(phoneNumber));
        return userSignatures[phoneHash][poolId];
    }
    
    /**
     * @notice Get total number of signatures for a pool
     * @param poolId Pool identifier
     * @return uint256 Total signatures count
     */
    function getSignatureCount(string calldata poolId) external view returns (uint256) {
        return totalSignatures[poolId];
    }
    
    /**
     * @notice Get agreement text for frontend display
     * @param poolId Pool identifier
     * @return string Agreement text
     */
    function getAgreementText(string calldata poolId) external view returns (string memory) {
        uint256 currentVersion = latestVersion[poolId];
        if (currentVersion == 0) revert AgreementNotFound();
        return agreements[poolId][currentVersion].agreementText;
    }
} 