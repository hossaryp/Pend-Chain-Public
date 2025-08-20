// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./FractionalBuyAsset.sol";
import "./IConsentManager.sol";

/**
 * @title AssetFactory
 * @dev Factory contract for deploying tokenized real-world asset contracts
 * @notice Allows authorized asset managers to deploy investment-ready asset contracts with comprehensive metadata
 */
contract AssetFactory {
    /*//////////////////////////////////////////////////////////////
                                 STRUCTS
    //////////////////////////////////////////////////////////////*/
    struct AssetInfo {
        address contractAddress;
        string name;
        string symbol;
        address assetManager;
        string metadataUrl;
        string legalAgreementUrl;
        bytes32 legalAgreementHash;
        uint256 tokenPrice;
        uint256 maxSupply;
        uint256 lockupEndTimestamp;
        uint256 minimumInvestment;
        uint256 deployedAt;
        string category;              // e.g., "Agriculture", "Real Estate", "Equipment"
        bool active;
    }

    /*//////////////////////////////////////////////////////////////
                                STORAGE
    //////////////////////////////////////////////////////////////*/
    address public owner;
    address public consentManager;
    
    // Role-based access control
    mapping(address => bool) public authorizedAssetManagers;
    mapping(address => string) public assetManagerNames;  // For display purposes
    
    // Asset registry
    address[] public deployedAssets;
    mapping(address => AssetInfo) public assetRegistry;
    mapping(string => address[]) public assetsByCategory;
    mapping(address => address[]) public assetsByManager;
    
    // Asset manager metrics
    mapping(address => uint256) public managerAssetCount;
    mapping(address => uint256) public managerTotalValue;  // Total value of assets deployed
    
    // Factory statistics
    uint256 public totalAssetsDeployed;
    uint256 public totalValueDeployed;
    
    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/
    event AssetDeployed(
        address indexed contractAddress,
        address indexed assetManager,
        string indexed category,
        string name,
        string symbol,
        string metadataUrl,
        string legalAgreementUrl,
        bytes32 legalAgreementHash,
        uint256 tokenPrice,
        uint256 maxSupply,
        uint256 lockupEndTimestamp,
        uint256 minimumInvestment,
        uint256 deployedAt
    );
    
    event AssetManagerAuthorized(address indexed manager, string name);
    event AssetManagerRevoked(address indexed manager);
    event AssetDeactivated(address indexed contractAddress, address indexed assetManager);
    event ConsentManagerUpdated(address indexed oldManager, address indexed newManager);
    
    /*//////////////////////////////////////////////////////////////
                                 ERRORS
    //////////////////////////////////////////////////////////////*/
    error NotOwner();
    error NotAuthorizedAssetManager();
    error AssetManagerAlreadyAuthorized();
    error AssetNotFound();
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
        
        emit AssetManagerAuthorized(manager, name);
    }
    
    function revokeAssetManager(address manager) external onlyOwner {
        authorizedAssetManagers[manager] = false;
        delete assetManagerNames[manager];
        
        emit AssetManagerRevoked(manager);
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
                          ASSET DEPLOYMENT FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function deployAsset(
        string calldata name,
        string calldata symbol,
        string calldata metadataUrl,
        string calldata legalAgreementUrl,
        bytes32 legalAgreementHash,
        uint256 tokenPrice,
        uint256 maxSupply,
        uint256 lockupEndTimestamp,
        uint256 minimumInvestment,
        string calldata category
    ) external onlyAuthorizedAssetManager returns (address) {
        return _deployAsset(
            name,
            symbol,
            metadataUrl,
            legalAgreementUrl,
            legalAgreementHash,
            tokenPrice,
            maxSupply,
            lockupEndTimestamp,
            minimumInvestment,
            category
        );
    }
    
    function _deployAsset(
        string calldata name,
        string calldata symbol,
        string calldata metadataUrl,
        string calldata legalAgreementUrl,
        bytes32 legalAgreementHash,
        uint256 tokenPrice,
        uint256 maxSupply,
        uint256 lockupEndTimestamp,
        uint256 minimumInvestment,
        string calldata category
    ) internal returns (address) {
        // Validate parameters
        if (bytes(name).length == 0 || bytes(symbol).length == 0) revert InvalidParameters();
        if (bytes(metadataUrl).length == 0 || bytes(legalAgreementUrl).length == 0) revert InvalidParameters();
        if (tokenPrice == 0 || maxSupply == 0) revert InvalidParameters();
        if (legalAgreementHash == bytes32(0)) revert InvalidParameters();
        
        // Deploy new FractionalBuyAsset contract
        FractionalBuyAsset newAsset = new FractionalBuyAsset(
            name,
            symbol,
            msg.sender,              // assetManager
            address(this),           // factory
            metadataUrl,
            legalAgreementUrl,
            legalAgreementHash,
            tokenPrice,
            maxSupply,
            lockupEndTimestamp,
            minimumInvestment,
            consentManager
        );
        
        address assetAddress = address(newAsset);
        
        // Create asset info
        AssetInfo memory assetInfo = AssetInfo({
            contractAddress: assetAddress,
            name: name,
            symbol: symbol,
            assetManager: msg.sender,
            metadataUrl: metadataUrl,
            legalAgreementUrl: legalAgreementUrl,
            legalAgreementHash: legalAgreementHash,
            tokenPrice: tokenPrice,
            maxSupply: maxSupply,
            lockupEndTimestamp: lockupEndTimestamp,
            minimumInvestment: minimumInvestment,
            deployedAt: block.timestamp,
            category: category,
            active: true
        });
        
        // Update registry
        deployedAssets.push(assetAddress);
        assetRegistry[assetAddress] = assetInfo;
        assetsByCategory[category].push(assetAddress);
        assetsByManager[msg.sender].push(assetAddress);
        
        // Update metrics
        managerAssetCount[msg.sender]++;
        uint256 assetValue = tokenPrice * maxSupply;
        managerTotalValue[msg.sender] += assetValue;
        totalAssetsDeployed++;
        totalValueDeployed += assetValue;
        
        // Emit comprehensive event for indexing
        emit AssetDeployed(
            assetAddress,
            msg.sender,
            category,
            name,
            symbol,
            metadataUrl,
            legalAgreementUrl,
            legalAgreementHash,
            tokenPrice,
            maxSupply,
            lockupEndTimestamp,
            minimumInvestment,
            block.timestamp
        );
        
        return assetAddress;
    }
    
    function deployAssetWithConsent(
        string calldata name,
        string calldata symbol,
        string calldata metadataUrl,
        string calldata legalAgreementUrl,
        bytes32 legalAgreementHash,
        uint256 tokenPrice,
        uint256 maxSupply,
        uint256 lockupEndTimestamp,
        uint256 minimumInvestment,
        string calldata category,
        bytes calldata rawInput,
        string calldata phoneNumber,
        string calldata action
    ) external onlyAuthorizedAssetManager returns (address) {
        // Verify consent first
        if (consentManager != address(0)) {
            bool consentValid = IConsentManager(consentManager).verifyConsent(rawInput, phoneNumber, action);
            require(consentValid, "AssetFactory: consent verification failed");
        }
        
        // Deploy asset using internal function (this will skip the authorization check since we already checked it)
        return _deployAsset(
            name,
            symbol,
            metadataUrl,
            legalAgreementUrl,
            legalAgreementHash,
            tokenPrice,
            maxSupply,
            lockupEndTimestamp,
            minimumInvestment,
            category
        );
    }

    /*//////////////////////////////////////////////////////////////
                            ASSET MANAGEMENT FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function deactivateAsset(address assetAddress) external {
        AssetInfo storage asset = assetRegistry[assetAddress];
        if (asset.contractAddress == address(0)) revert AssetNotFound();
        
        // Only owner or asset manager can deactivate
        require(msg.sender == owner || msg.sender == asset.assetManager, "AssetFactory: not authorized");
        
        asset.active = false;
        emit AssetDeactivated(assetAddress, asset.assetManager);
    }
    
    function updateAssetMetadata(address assetAddress, string calldata newMetadataUrl) external {
        AssetInfo storage asset = assetRegistry[assetAddress];
        if (asset.contractAddress == address(0)) revert AssetNotFound();
        require(msg.sender == asset.assetManager, "AssetFactory: not asset manager");
        
        asset.metadataUrl = newMetadataUrl;
        
        // Also update on the asset contract
        FractionalBuyAsset(payable(assetAddress)).updateMetadata(newMetadataUrl);
    }

    /*//////////////////////////////////////////////////////////////
                              VIEW FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function getAssetInfo(address assetAddress) external view returns (AssetInfo memory) {
        return assetRegistry[assetAddress];
    }
    
    function getAllAssets() external view returns (address[] memory) {
        return deployedAssets;
    }
    
    function getActiveAssets() external view returns (address[] memory) {
        uint256 activeCount = 0;
        
        // Count active assets
        for (uint256 i = 0; i < deployedAssets.length; i++) {
            if (assetRegistry[deployedAssets[i]].active) {
                activeCount++;
            }
        }
        
        // Create array of active assets
        address[] memory activeAssets = new address[](activeCount);
        uint256 currentIndex = 0;
        
        for (uint256 i = 0; i < deployedAssets.length; i++) {
            if (assetRegistry[deployedAssets[i]].active) {
                activeAssets[currentIndex] = deployedAssets[i];
                currentIndex++;
            }
        }
        
        return activeAssets;
    }
    
    function getAssetsByCategory(string calldata category) external view returns (address[] memory) {
        return assetsByCategory[category];
    }
    
    function getAssetsByManager(address manager) external view returns (address[] memory) {
        return assetsByManager[manager];
    }
    
    function getManagerInfo(address manager) external view returns (
        string memory name,
        bool authorized,
        uint256 assetCount,
        uint256 totalValue
    ) {
        return (
            assetManagerNames[manager],
            authorizedAssetManagers[manager],
            managerAssetCount[manager],
            managerTotalValue[manager]
        );
    }
    
    function getFactoryStats() external view returns (
        uint256 _totalAssetsDeployed,
        uint256 _totalValueDeployed,
        uint256 _totalActiveAssets,
        uint256 _totalAuthorizedManagers
    ) {
        // Count active assets
        uint256 activeCount = 0;
        for (uint256 i = 0; i < deployedAssets.length; i++) {
            if (assetRegistry[deployedAssets[i]].active) {
                activeCount++;
            }
        }
        
        // Count authorized managers (this is a simplified approach)
        // In production, you might want to maintain a separate counter
        uint256 managerCount = 0;
        // Note: This is not efficient for large numbers of managers
        // Consider maintaining a separate array or counter
        
        return (
            totalAssetsDeployed,
            totalValueDeployed,
            activeCount,
            managerCount  // For now, this will be 0. Implement proper counting if needed
        );
    }
    
    function isAssetDeployed(address assetAddress) external view returns (bool) {
        return assetRegistry[assetAddress].contractAddress != address(0);
    }
    
    function getAssetsByPriceRange(uint256 minPrice, uint256 maxPrice) external view returns (address[] memory) {
        uint256 matchingCount = 0;
        
        // Count matching assets
        for (uint256 i = 0; i < deployedAssets.length; i++) {
            AssetInfo memory asset = assetRegistry[deployedAssets[i]];
            if (asset.active && asset.tokenPrice >= minPrice && asset.tokenPrice <= maxPrice) {
                matchingCount++;
            }
        }
        
        // Create array of matching assets
        address[] memory matchingAssets = new address[](matchingCount);
        uint256 currentIndex = 0;
        
        for (uint256 i = 0; i < deployedAssets.length; i++) {
            AssetInfo memory asset = assetRegistry[deployedAssets[i]];
            if (asset.active && asset.tokenPrice >= minPrice && asset.tokenPrice <= maxPrice) {
                matchingAssets[currentIndex] = deployedAssets[i];
                currentIndex++;
            }
        }
        
        return matchingAssets;
    }
} 