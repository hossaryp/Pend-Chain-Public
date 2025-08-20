// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../IAccessControlHub.sol";

/**
 * @title AccessControlIntegrationExample
 * @dev Example contract demonstrating how to integrate with AccessControlHub
 * @notice Shows best practices for using centralized role management in other contracts
 */
contract AccessControlIntegrationExample {
    /*//////////////////////////////////////////////////////////////
                                STORAGE
    //////////////////////////////////////////////////////////////*/
    
    IAccessControlHub public immutable accessControlHub;
    
    // Example state variables
    mapping(address => uint256) public assetIssuances;
    mapping(address => bool) public kycApprovals;
    uint256 public totalAssetsIssued;
    
    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/
    
    event AssetIssued(address indexed issuer, uint256 amount);
    event KYCApproved(address indexed user, address indexed approver);
    event DataAccessed(address indexed viewer, string dataType);
    
    /*//////////////////////////////////////////////////////////////
                                 ERRORS
    //////////////////////////////////////////////////////////////*/
    
    error Unauthorized();
    error InvalidAmount();
    error AlreadyApproved();
    
    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/
    
    constructor(address _accessControlHub) {
        require(_accessControlHub != address(0), "Invalid AccessControlHub address");
        accessControlHub = IAccessControlHub(_accessControlHub);
    }
    
    /*//////////////////////////////////////////////////////////////
                                MODIFIERS
    //////////////////////////////////////////////////////////////*/
    
    /**
     * @dev Modifier to check if caller has ASSET_ISSUER_ROLE
     */
    modifier onlyAssetIssuer() {
        if (!accessControlHub.isAssetIssuer(msg.sender)) revert Unauthorized();
        _;
    }
    
    /**
     * @dev Modifier to check if caller has KYC_CONFIRMER_ROLE
     */
    modifier onlyKYCConfirmer() {
        if (!accessControlHub.isKYCConfirmer(msg.sender)) revert Unauthorized();
        _;
    }
    
    /**
     * @dev Modifier to check if caller has DATA_VIEWER_ROLE
     */
    modifier onlyDataViewer() {
        if (!accessControlHub.isDataViewer(msg.sender)) revert Unauthorized();
        _;
    }
    
    /**
     * @dev Generic modifier to check any role
     */
    modifier onlyRole(bytes32 role) {
        if (!accessControlHub.hasRole(role, msg.sender)) revert Unauthorized();
        _;
    }
    
    /*//////////////////////////////////////////////////////////////
                          ASSET ISSUER FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    
    /**
     * @notice Issue new assets (only ASSET_ISSUER_ROLE)
     * @param amount Amount of assets to issue
     */
    function issueAssets(uint256 amount) external onlyAssetIssuer {
        if (amount == 0) revert InvalidAmount();
        
        assetIssuances[msg.sender] += amount;
        totalAssetsIssued += amount;
        
        emit AssetIssued(msg.sender, amount);
    }
    
    /*//////////////////////////////////////////////////////////////
                         KYC CONFIRMER FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    
    /**
     * @notice Approve KYC for a user (only KYC_CONFIRMER_ROLE)
     * @param user Address to approve KYC for
     */
    function approveKYC(address user) external onlyKYCConfirmer {
        if (kycApprovals[user]) revert AlreadyApproved();
        
        kycApprovals[user] = true;
        emit KYCApproved(user, msg.sender);
    }
    
    /*//////////////////////////////////////////////////////////////
                          DATA VIEWER FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    
    /**
     * @notice View sensitive data (only DATA_VIEWER_ROLE)
     * @param dataType Type of data being accessed
     * @return Example sensitive data
     */
    function viewSensitiveData(string calldata dataType) external onlyDataViewer returns (uint256) {
        emit DataAccessed(msg.sender, dataType);
        
        // Example: Return different data based on type
        if (keccak256(bytes(dataType)) == keccak256(bytes("totalAssets"))) {
            return totalAssetsIssued;
        }
        
        return 0;
    }
    
    /*//////////////////////////////////////////////////////////////
                        MULTI-ROLE FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    
    /**
     * @notice Function requiring either ASSET_ISSUER_ROLE or AUDITOR_ROLE
     * @return Array of all asset issuers and their amounts
     */
    function getAssetIssuanceReport() external view returns (address[] memory, uint256[] memory) {
        // Check if caller has either role
        bytes32 ASSET_ISSUER_ROLE = accessControlHub.ASSET_ISSUER_ROLE();
        bytes32 AUDITOR_ROLE = accessControlHub.AUDITOR_ROLE();
        
        bool hasAccess = accessControlHub.hasRole(ASSET_ISSUER_ROLE, msg.sender) ||
                        accessControlHub.hasRole(AUDITOR_ROLE, msg.sender);
        
        if (!hasAccess) revert Unauthorized();
        
        // Return report data (simplified for example)
        address[] memory issuers = new address[](1);
        uint256[] memory amounts = new uint256[](1);
        
        return (issuers, amounts);
    }
    
    /*//////////////////////////////////////////////////////////////
                            VIEW FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    
    /**
     * @notice Check if a user has been KYC approved
     * @param user Address to check
     * @return approved Whether the user is KYC approved
     */
    function isKYCApproved(address user) external view returns (bool) {
        return kycApprovals[user];
    }
    
    /**
     * @notice Get total assets issued by a specific issuer
     * @param issuer Address of the issuer
     * @return amount Total assets issued
     */
    function getAssetIssuanceByIssuer(address issuer) external view returns (uint256) {
        return assetIssuances[issuer];
    }
    
    /**
     * @notice Get the AccessControlHub address
     * @return hub Address of the AccessControlHub contract
     */
    function getAccessControlHub() external view returns (address) {
        return address(accessControlHub);
    }
} 