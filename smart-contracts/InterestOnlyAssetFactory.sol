// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./InterestOnlyAsset.sol";
import "./IConsentManager.sol";

/**
 * @title InterestOnlyAssetFactory
 * @dev Factory contract for deploying interest-only asset contracts for pre-launch demand gauging
 * @notice Allows authorized asset managers to deploy interest tracking contracts before full tokenization
 */
contract InterestOnlyAssetFactory {
    /*//////////////////////////////////////////////////////////////
                                 STRUCTS
    //////////////////////////////////////////////////////////////*/
    struct InterestAssetInfo {
        address contractAddress;
        string name;
        address assetManager;
        string metadataUrl;
        string agreementUrl;
        bytes32 agreementHash;
        uint256 softCap;
        uint256 deadline;
        uint256 deployedAt;
        string category;              // e.g., "Agriculture", "Real Estate", "Equipment"
        bool active;
        bool readyForTokenization;    // Whether ready to move to full ERC-20
    }

    /*//////////////////////////////////////////////////////////////
                                STORAGE
    //////////////////////////////////////////////////////////////*/
    address public owner;
    address public consentManager;
    
    // Role-based access control
    mapping(address => bool) public authorizedAssetManagers;
    mapping(address => string) public assetManagerNames;
    
    // Asset registry
    address[] public deployedInterestAssets;
    mapping(address => InterestAssetInfo) public interestAssetRegistry;
    mapping(string => address[]) public interestAssetsByCategory;
    mapping(address => address[]) public interestAssetsByManager;
    
    // Factory statistics
    uint256 public totalInterestAssetsDeployed;
    mapping(address => uint256) public managerInterestAssetCount;
    
    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/
    event InterestAssetDeployed(
        address indexed contractAddress,
        address indexed assetManager,
        string indexed category,
        string name,
        string metadataUrl,
        string agreementUrl,
        bytes32 agreementHash,
        uint256 softCap,
        uint256 deadline,
        uint256 deployedAt
    );
    
    event InterestAssetManagerAuthorized(address indexed manager, string name);
    event InterestAssetManagerRevoked(address indexed manager);
    event InterestAssetDeactivated(address indexed contractAddress, address indexed assetManager);
    event InterestAssetReadyForTokenization(address indexed contractAddress, bool ready);
    event ConsentManagerUpdated(address indexed oldManager, address indexed newManager);
    
    /*//////////////////////////////////////////////////////////////
                                 ERRORS
    //////////////////////////////////////////////////////////////*/
    error NotOwner();
    error NotAuthorizedAssetManager();
    error AssetManagerAlreadyAuthorized();
    error InterestAssetNotFound();
    error InvalidParameters();
    error ZeroAddress();

    /*//////////////////////////////////////////////////////////////
                                MODIFIERS
    //////////////////////////////////////////////////////////////*/
    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }
    
    modifier onlyAuthorizedAssetManager() {
        if (!authorizedAssetManagers[msg.sender]) revert NotAuthorizedAssetManager();
        _;
    }

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/
    constructor(address _consentManager) {
        owner = msg.sender;
        consentManager = _consentManager;
    }

    /*//////////////////////////////////////////////////////////////
                          ACCESS CONTROL FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function authorizeAssetManager(address manager, string calldata name) external onlyOwner {
        if (manager == address(0)) revert ZeroAddress();
        if (authorizedAssetManagers[manager]) revert AssetManagerAlreadyAuthorized();
        
        authorizedAssetManagers[manager] = true;
        assetManagerNames[manager] = name;
        
        emit InterestAssetManagerAuthorized(manager, name);
    }
    
    function revokeAssetManager(address manager) external onlyOwner {
        authorizedAssetManagers[manager] = false;
        delete assetManagerNames[manager];
        
        emit InterestAssetManagerRevoked(manager);
    }
    
    function updateConsentManager(address newConsentManager) external onlyOwner {
        address oldManager = consentManager;
        consentManager = newConsentManager;
        emit ConsentManagerUpdated(oldManager, newConsentManager);
    }
    
    function transferOwnership(address newOwner) external onlyOwner {
        if (newOwner == address(0)) revert ZeroAddress();
        owner = newOwner;
    }

    /*//////////////////////////////////////////////////////////////
                      INTEREST ASSET DEPLOYMENT FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function deployInterestAsset(
        string calldata name,
        string calldata metadataUrl,
        string calldata agreementUrl,
        bytes32 agreementHash,
        uint256 softCap,
        uint256 deadline,
        string calldata category
    ) external onlyAuthorizedAssetManager returns (address) {
        return _deployInterestAsset(
            name,
            metadataUrl,
            agreementUrl,
            agreementHash,
            softCap,
            deadline,
            category
        );
    }
    
    function _deployInterestAsset(
        string calldata name,
        string calldata metadataUrl,
        string calldata agreementUrl,
        bytes32 agreementHash,
        uint256 softCap,
        uint256 deadline,
        string calldata category
    ) internal returns (address) {
        // Validate parameters
        if (bytes(name).length == 0) revert InvalidParameters();
        if (bytes(metadataUrl).length == 0) revert InvalidParameters();
        if (bytes(agreementUrl).length == 0) revert InvalidParameters();
        if (agreementHash == bytes32(0)) revert InvalidParameters();
        if (softCap == 0) revert InvalidParameters();
        
        // Deploy new InterestOnlyAsset contract
        InterestOnlyAsset newInterestAsset = new InterestOnlyAsset(
            name,
            metadataUrl,
            agreementUrl,
            agreementHash,
            softCap,
            deadline,
            consentManager
        );
        
        address assetAddress = address(newInterestAsset);
        
        // Transfer admin role to the asset manager
        newInterestAsset.transferAdmin(msg.sender);
        
        // Create asset info
        InterestAssetInfo memory assetInfo = InterestAssetInfo({
            contractAddress: assetAddress,
            name: name,
            assetManager: msg.sender,
            metadataUrl: metadataUrl,
            agreementUrl: agreementUrl,
            agreementHash: agreementHash,
            softCap: softCap,
            deadline: deadline,
            deployedAt: block.timestamp,
            category: category,
            active: true,
            readyForTokenization: false
        });
        
        // Update registry
        deployedInterestAssets.push(assetAddress);
        interestAssetRegistry[assetAddress] = assetInfo;
        interestAssetsByCategory[category].push(assetAddress);
        interestAssetsByManager[msg.sender].push(assetAddress);
        
        // Update metrics
        managerInterestAssetCount[msg.sender]++;
        totalInterestAssetsDeployed++;
        
        // Emit comprehensive event for indexing
        emit InterestAssetDeployed(
            assetAddress,
            msg.sender,
            category,
            name,
            metadataUrl,
            agreementUrl,
            agreementHash,
            softCap,
            deadline,
            block.timestamp
        );
        
        return assetAddress;
    }
    
    function deployInterestAssetWithConsent(
        string calldata name,
        string calldata metadataUrl,
        string calldata agreementUrl,
        bytes32 agreementHash,
        uint256 softCap,
        uint256 deadline,
        string calldata category,
        bytes calldata rawInput,
        string calldata phoneNumber,
        string calldata action
    ) external onlyAuthorizedAssetManager returns (address) {
        // Verify consent first
        if (consentManager != address(0)) {
            bool consentValid = IConsentManager(consentManager).verifyConsent(rawInput, phoneNumber, action);
            require(consentValid, "InterestOnlyAssetFactory: consent verification failed");
        }
        
        // Deploy asset using internal function
        return _deployInterestAsset(
            name,
            metadataUrl,
            agreementUrl,
            agreementHash,
            softCap,
            deadline,
            category
        );
    }

    /*//////////////////////////////////////////////////////////////
                        INTEREST ASSET MANAGEMENT FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function deactivateInterestAsset(address assetAddress) external {
        InterestAssetInfo storage asset = interestAssetRegistry[assetAddress];
        if (asset.contractAddress == address(0)) revert InterestAssetNotFound();
        
        // Only owner or asset manager can deactivate
        require(msg.sender == owner || msg.sender == asset.assetManager, "InterestOnlyAssetFactory: not authorized");
        
        asset.active = false;
        emit InterestAssetDeactivated(assetAddress, asset.assetManager);
    }
    
    function markReadyForTokenization(address assetAddress, bool ready) external {
        InterestAssetInfo storage asset = interestAssetRegistry[assetAddress];
        if (asset.contractAddress == address(0)) revert InterestAssetNotFound();
        require(msg.sender == asset.assetManager, "InterestOnlyAssetFactory: not asset manager");
        
        asset.readyForTokenization = ready;
        emit InterestAssetReadyForTokenization(assetAddress, ready);
    }
    
    function updateInterestAssetMetadata(address assetAddress, string calldata newMetadataUrl) external {
        InterestAssetInfo storage asset = interestAssetRegistry[assetAddress];
        if (asset.contractAddress == address(0)) revert InterestAssetNotFound();
        require(msg.sender == asset.assetManager, "InterestOnlyAssetFactory: not asset manager");
        
        asset.metadataUrl = newMetadataUrl;
        
        // Also update on the asset contract
        InterestOnlyAsset(assetAddress).updateMetadata(newMetadataUrl);
    }

    /*//////////////////////////////////////////////////////////////
                              VIEW FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function getInterestAssetInfo(address assetAddress) external view returns (InterestAssetInfo memory) {
        return interestAssetRegistry[assetAddress];
    }
    
    function getAllInterestAssets() external view returns (address[] memory) {
        return deployedInterestAssets;
    }
    
    function getActiveInterestAssets() external view returns (address[] memory) {
        uint256 activeCount = 0;
        
        // Count active assets
        for (uint256 i = 0; i < deployedInterestAssets.length; i++) {
            if (interestAssetRegistry[deployedInterestAssets[i]].active) {
                activeCount++;
            }
        }
        
        // Create array of active assets
        address[] memory activeAssets = new address[](activeCount);
        uint256 currentIndex = 0;
        
        for (uint256 i = 0; i < deployedInterestAssets.length; i++) {
            if (interestAssetRegistry[deployedInterestAssets[i]].active) {
                activeAssets[currentIndex] = deployedInterestAssets[i];
                currentIndex++;
            }
        }
        
        return activeAssets;
    }
    
    function getInterestAssetsByCategory(string calldata category) external view returns (address[] memory) {
        return interestAssetsByCategory[category];
    }
    
    function getInterestAssetsByManager(address manager) external view returns (address[] memory) {
        return interestAssetsByManager[manager];
    }
    
    function getReadyForTokenization() external view returns (address[] memory) {
        uint256 readyCount = 0;
        
        // Count ready assets
        for (uint256 i = 0; i < deployedInterestAssets.length; i++) {
            if (interestAssetRegistry[deployedInterestAssets[i]].readyForTokenization && 
                interestAssetRegistry[deployedInterestAssets[i]].active) {
                readyCount++;
            }
        }
        
        // Create array of ready assets
        address[] memory readyAssets = new address[](readyCount);
        uint256 currentIndex = 0;
        
        for (uint256 i = 0; i < deployedInterestAssets.length; i++) {
            InterestAssetInfo memory asset = interestAssetRegistry[deployedInterestAssets[i]];
            if (asset.readyForTokenization && asset.active) {
                readyAssets[currentIndex] = deployedInterestAssets[i];
                currentIndex++;
            }
        }
        
        return readyAssets;
    }
    
    function getManagerInfo(address manager) external view returns (
        string memory name,
        bool authorized,
        uint256 interestAssetCount
    ) {
        return (
            assetManagerNames[manager],
            authorizedAssetManagers[manager],
            managerInterestAssetCount[manager]
        );
    }
    
    function getFactoryStats() external view returns (
        uint256 _totalInterestAssetsDeployed,
        uint256 _totalActiveInterestAssets,
        uint256 _totalReadyForTokenization
    ) {
        // Count active assets
        uint256 activeCount = 0;
        uint256 readyCount = 0;
        
        for (uint256 i = 0; i < deployedInterestAssets.length; i++) {
            InterestAssetInfo memory asset = interestAssetRegistry[deployedInterestAssets[i]];
            if (asset.active) {
                activeCount++;
                if (asset.readyForTokenization) {
                    readyCount++;
                }
            }
        }
        
        return (
            totalInterestAssetsDeployed,
            activeCount,
            readyCount
        );
    }
    
    function isInterestAssetDeployed(address assetAddress) external view returns (bool) {
        return interestAssetRegistry[assetAddress].contractAddress != address(0);
    }
    
    function getInterestAssetsSummary() external view returns (
        address[] memory addresses,
        string[] memory names,
        string[] memory categories,
        uint256[] memory softCaps,
        uint256[] memory interestedCounts,
        bool[] memory activeStatus,
        bool[] memory readyForTokenization
    ) {
        uint256 length = deployedInterestAssets.length;
        addresses = new address[](length);
        names = new string[](length);
        categories = new string[](length);
        softCaps = new uint256[](length);
        interestedCounts = new uint256[](length);
        activeStatus = new bool[](length);
        readyForTokenization = new bool[](length);
        
        for (uint256 i = 0; i < length; i++) {
            address assetAddress = deployedInterestAssets[i];
            InterestAssetInfo memory info = interestAssetRegistry[assetAddress];
            
            addresses[i] = assetAddress;
            names[i] = info.name;
            categories[i] = info.category;
            softCaps[i] = info.softCap;
            interestedCounts[i] = InterestOnlyAsset(assetAddress).interestedCount();
            activeStatus[i] = info.active;
            readyForTokenization[i] = info.readyForTokenization;
        }
        
        return (addresses, names, categories, softCaps, interestedCounts, activeStatus, readyForTokenization);
    }
} 