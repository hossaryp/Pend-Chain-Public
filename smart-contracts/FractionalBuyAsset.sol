// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IConsentManager.sol";

/**
 * @title FractionalBuyAsset
 * @dev ERC-20 token representing fractional ownership of a real-world asset
 * @notice Each deployed contract represents a unique investment opportunity with metadata, legal agreements, and lock-up periods
 */
contract FractionalBuyAsset {
    /*//////////////////////////////////////////////////////////////
                               ERC-20 DATA
    //////////////////////////////////////////////////////////////*/
    string public name;
    string public symbol;
    uint8 public constant decimals = 18;
    uint256 private _totalSupply;
    uint256 public maxSupply;
    
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    /*//////////////////////////////////////////////////////////////
                            ASSET METADATA
    //////////////////////////////////////////////////////////////*/
    address public assetManager;
    address public factory;
    string public metadataUrl;          // JSON metadata URL
    string public legalAgreementUrl;    // PDF/HTML legal agreement URL
    bytes32 public legalAgreementHash;  // Hash of legal agreement for auditability
    uint256 public tokenPrice;          // Price per token in wei (pEGP)
    uint256 public lockupEndTimestamp;  // When tokens become transferable
    uint256 public minimumInvestment;   // Minimum tokens required per purchase
    bool public redeemable;             // Whether tokens can be redeemed
    
    /*//////////////////////////////////////////////////////////////
                            CONSENT INTEGRATION
    //////////////////////////////////////////////////////////////*/
    address public consentManager;
    mapping(address => bool) public requiresConsent;  // Per-user consent requirements
    
    /*//////////////////////////////////////////////////////////////
                              LOCK-UP LOGIC
    //////////////////////////////////////////////////////////////*/
    mapping(address => uint256) public purchaseTimestamp;  // When user first purchased
    mapping(address => uint256) public totalPurchased;     // Total tokens purchased by user
    
    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event TokensPurchased(address indexed buyer, uint256 amount, uint256 totalCost);
    event TokensRedeemed(address indexed redeemer, uint256 amount, uint256 redemptionValue);
    event LockupUpdated(uint256 newLockupEndTimestamp);
    event MetadataUpdated(string newMetadataUrl);
    event ConsentRequired(address indexed user, bool required);
    
    /*//////////////////////////////////////////////////////////////
                                 ERRORS
    //////////////////////////////////////////////////////////////*/
    error NotAssetManager();
    error NotFactory();
    error InsufficientPayment();
    error BelowMinimumInvestment();
    error TokensLocked();
    error MaxSupplyExceeded();
    error NotRedeemable();
    error ConsentNotProvided();
    error ZeroAddress();
    error InvalidAmount();

    /*//////////////////////////////////////////////////////////////
                                MODIFIERS
    //////////////////////////////////////////////////////////////*/
    modifier onlyAssetManager() {
        if (msg.sender != assetManager) revert NotAssetManager();
        _;
    }
    
    modifier onlyFactory() {
        if (msg.sender != factory) revert NotFactory();
        _;
    }
    
    modifier checkConsent(address user, string memory action) {
        if (requiresConsent[user] && consentManager != address(0)) {
            // Note: In practice, consent verification would be done off-chain
            // and verified through the ConsentManager before calling this function
            _;
        } else {
            _;
        }
    }

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/
    constructor(
        string memory _name,
        string memory _symbol,
        address _assetManager,
        address _factory,
        string memory _metadataUrl,
        string memory _legalAgreementUrl,
        bytes32 _legalAgreementHash,
        uint256 _tokenPrice,
        uint256 _maxSupply,
        uint256 _lockupEndTimestamp,
        uint256 _minimumInvestment,
        address _consentManager
    ) {
        if (_assetManager == address(0)) revert ZeroAddress();
        if (_factory == address(0)) revert ZeroAddress();
        if (_maxSupply == 0) revert InvalidAmount();
        if (_tokenPrice == 0) revert InvalidAmount();
        
        name = _name;
        symbol = _symbol;
        assetManager = _assetManager;
        factory = _factory;
        metadataUrl = _metadataUrl;
        legalAgreementUrl = _legalAgreementUrl;
        legalAgreementHash = _legalAgreementHash;
        tokenPrice = _tokenPrice;
        maxSupply = _maxSupply;
        lockupEndTimestamp = _lockupEndTimestamp;
        minimumInvestment = _minimumInvestment;
        consentManager = _consentManager;
        redeemable = false; // Default to not redeemable
    }

    /*//////////////////////////////////////////////////////////////
                                ERC-20 LOGIC
    //////////////////////////////////////////////////////////////*/
    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }
    
    function balanceOf(address account) external view returns (uint256) {
        return _balances[account];
    }
    
    function allowance(address owner, address spender) external view returns (uint256) {
        return _allowances[owner][spender];
    }
    
    function transfer(address to, uint256 amount) external returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }
    
    function approve(address spender, uint256 amount) external returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }
    
    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        uint256 currentAllowance = _allowances[from][msg.sender];
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
            unchecked {
                _approve(from, msg.sender, currentAllowance - amount);
            }
        }
        _transfer(from, to, amount);
        return true;
    }

    /*//////////////////////////////////////////////////////////////
                            PURCHASE LOGIC
    //////////////////////////////////////////////////////////////*/
    function purchaseTokens(uint256 tokenAmount) external payable checkConsent(msg.sender, "purchase_asset_tokens") {
        if (tokenAmount == 0) revert InvalidAmount();
        if (tokenAmount < minimumInvestment) revert BelowMinimumInvestment();
        if (_totalSupply + tokenAmount > maxSupply) revert MaxSupplyExceeded();
        
        uint256 totalCost = tokenAmount * tokenPrice;
        if (msg.value < totalCost) revert InsufficientPayment();
        
        // Record purchase timestamp for first-time buyers
        if (_balances[msg.sender] == 0) {
            purchaseTimestamp[msg.sender] = block.timestamp;
        }
        
        totalPurchased[msg.sender] += tokenAmount;
        _totalSupply += tokenAmount;
        _balances[msg.sender] += tokenAmount;
        
        // Return excess payment
        if (msg.value > totalCost) {
            payable(msg.sender).transfer(msg.value - totalCost);
        }
        
        emit Transfer(address(0), msg.sender, tokenAmount);
        emit TokensPurchased(msg.sender, tokenAmount, totalCost);
    }

    /*//////////////////////////////////////////////////////////////
                            REDEMPTION LOGIC
    //////////////////////////////////////////////////////////////*/
    function redeem(uint256 tokenAmount) external checkConsent(msg.sender, "redeem_asset_tokens") {
        if (!redeemable) revert NotRedeemable();
        if (tokenAmount == 0) revert InvalidAmount();
        if (_balances[msg.sender] < tokenAmount) revert InvalidAmount();
        
        uint256 redemptionValue = tokenAmount * tokenPrice;
        
        _balances[msg.sender] -= tokenAmount;
        _totalSupply -= tokenAmount;
        
        // Transfer redemption value to user
        payable(msg.sender).transfer(redemptionValue);
        
        emit Transfer(msg.sender, address(0), tokenAmount);
        emit TokensRedeemed(msg.sender, tokenAmount, redemptionValue);
    }

    /*//////////////////////////////////////////////////////////////
                              TRANSFER LOGIC
    //////////////////////////////////////////////////////////////*/
    function _transfer(address from, address to, uint256 amount) internal {
        if (from == address(0) || to == address(0)) revert ZeroAddress();
        
        // Check lock-up period for transfers (not purchases)
        if (from != address(0) && block.timestamp < lockupEndTimestamp) {
            revert TokensLocked();
        }
        
        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[from] = fromBalance - amount;
        }
        _balances[to] += amount;
        
        emit Transfer(from, to, amount);
    }
    
    function _approve(address owner, address spender, uint256 amount) internal {
        if (owner == address(0) || spender == address(0)) revert ZeroAddress();
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /*//////////////////////////////////////////////////////////////
                            ADMIN FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function updateMetadata(string memory newMetadataUrl) external onlyAssetManager {
        metadataUrl = newMetadataUrl;
        emit MetadataUpdated(newMetadataUrl);
    }
    
    function updateLockup(uint256 newLockupEndTimestamp) external onlyAssetManager {
        lockupEndTimestamp = newLockupEndTimestamp;
        emit LockupUpdated(newLockupEndTimestamp);
    }
    
    function setRedeemable(bool _redeemable) external onlyAssetManager {
        redeemable = _redeemable;
    }
    
    function setConsentRequired(address user, bool required) external onlyAssetManager {
        requiresConsent[user] = required;
        emit ConsentRequired(user, required);
    }
    
    function withdrawFunds() external onlyAssetManager {
        payable(assetManager).transfer(address(this).balance);
    }
    
    function transferAssetManagement(address newAssetManager) external onlyAssetManager {
        if (newAssetManager == address(0)) revert ZeroAddress();
        assetManager = newAssetManager;
    }

    /*//////////////////////////////////////////////////////////////
                              VIEW FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function getAssetInfo() external view returns (
        string memory _name,
        string memory _symbol,
        address _assetManager,
        string memory _metadataUrl,
        string memory _legalAgreementUrl,
        bytes32 _legalAgreementHash,
        uint256 _tokenPrice,
        uint256 _maxSupply,
        uint256 _currentTotalSupply,
        uint256 _lockupEndTimestamp,
        uint256 _minimumInvestment,
        bool _redeemable
    ) {
        return (
            name,
            symbol,
            assetManager,
            metadataUrl,
            legalAgreementUrl,
            legalAgreementHash,
            tokenPrice,
            maxSupply,
            _totalSupply,
            lockupEndTimestamp,
            minimumInvestment,
            redeemable
        );
    }
    
    function getUserInfo(address user) external view returns (
        uint256 balance,
        uint256 _purchaseTimestamp,
        uint256 _totalPurchased,
        bool _requiresConsent
    ) {
        return (
            _balances[user],
            purchaseTimestamp[user],
            totalPurchased[user],
            requiresConsent[user]
        );
    }
    
    function isTransferable() external view returns (bool) {
        return block.timestamp >= lockupEndTimestamp;
    }
    
    // Receive function to accept ETH payments
    receive() external payable {}
} 