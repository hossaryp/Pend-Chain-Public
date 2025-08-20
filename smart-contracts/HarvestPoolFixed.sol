// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./HarvestToken.sol";

/**
 * @title Harvest Pool V2.1 - NAV Bug Fix
 * @notice Fixed pool with correct NAV calculation timing in deposit function
 * @dev    CRITICAL BUG FIX:
 *         - NAV is now calculated BEFORE transferring EGP to pool
 *         - Prevents inflation of NAV due to timing sequence
 *         - Ensures fair pricing for all investors
 */
contract HarvestPoolFixed {
    /*//////////////////////////////////////////////////////////////
                               IMMUTABLES
    //////////////////////////////////////////////////////////////*/
    address public immutable P_EGP;      // Address of the pEGP stablecoin (ERC-20)
    HarvestToken public immutable HVT;   // LP token

    /*//////////////////////////////////////////////////////////////
                                   STATE
    //////////////////////////////////////////////////////////////*/
    uint256 public nav; // LEGACY: Manual NAV (kept for compatibility)
    address public owner;
    
    // NEW: Profit tracking
    uint256 public totalProfitsDeposited; // Track cumulative profits added to pool
    bool public useDynamicNAV; // Toggle between manual and dynamic NAV

    /*//////////////////////////////////////////////////////////////
                                   EVENTS
    //////////////////////////////////////////////////////////////*/
    event Deposited(address indexed user, uint256 egpAmount, uint256 hvtMinted, uint256 navUsed);
    event Redeemed(address indexed user, uint256 egpAmount, uint256 hvtBurned, uint256 navUsed);
    event NAVUpdated(uint256 oldNav, uint256 newNav);
    
    // NEW EVENTS
    event ProfitDeposited(address indexed depositor, uint256 profitAmount, uint256 oldNAV, uint256 newNAV);
    event DynamicNAVToggled(bool enabled, uint256 currentNAV);

    /*//////////////////////////////////////////////////////////////
                                   ERRORS
    //////////////////////////////////////////////////////////////*/
    error NotOwner();
    error ZeroAmount();
    error InsufficientLiquidity();

    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    constructor(address _pEGP, address _hvt) {
        require(_pEGP != address(0) && _hvt != address(0), "zero address");
        P_EGP = _pEGP;
        HVT = HarvestToken(_hvt);
        owner = msg.sender;
        nav = 1e18; // initial NAV = 1 pEGP per HVT
        totalProfitsDeposited = 0;
        useDynamicNAV = true; // NEW: Enable dynamic NAV by default
    }

    /*//////////////////////////////////////////////////////////////
                             DEPOSIT / REDEEM
    //////////////////////////////////////////////////////////////*/
    /**
     * @notice FIXED DEPOSIT FUNCTION - Correct NAV calculation timing
     * @param egpAmount Amount of EGP to deposit
     * @dev   BUG FIX: NAV is calculated BEFORE transferring EGP to pool
     */
    function deposit(uint256 egpAmount) external {
        if (egpAmount == 0) revert ZeroAmount();
        
        // ✅ FIXED: Calculate NAV BEFORE transferring EGP to pool
        uint256 currentNAV = useDynamicNAV ? getDynamicNAV() : nav;
        
        // ✅ FIXED: Transfer pEGP from user to pool AFTER calculating NAV
        (bool s1, ) = P_EGP.call(
            abi.encodeWithSignature("transferFrom(address,address,uint256)", msg.sender, address(this), egpAmount)
        );
        require(s1, "EGP transfer failed");

        // Calculate HVT to mint = amount / nav (using PRE-transfer NAV)
        uint256 shares = (egpAmount * 1e18) / currentNAV;
        HVT.mint(msg.sender, shares);
        
        emit Deposited(msg.sender, egpAmount, shares, currentNAV);
    }

    function redeem(uint256 hvtAmount) external {
        if (hvtAmount == 0) revert ZeroAmount();
        
        // Use dynamic or manual NAV
        uint256 currentNAV = useDynamicNAV ? getDynamicNAV() : nav;
        
        // Calculate pEGP to return
        uint256 egpAmount = (hvtAmount * currentNAV) / 1e18;
        
        // Check pool liquidity
        uint256 poolBalance = _balanceOfToken(P_EGP, address(this));
        if (egpAmount > poolBalance) revert InsufficientLiquidity();
        
        // Burn HVT from user (pool is owner of token contract)
        HVT.burnFrom(msg.sender, hvtAmount);

        (bool s2, ) = P_EGP.call(
            abi.encodeWithSignature("transfer(address,uint256)", msg.sender, egpAmount)
        );
        require(s2, "EGP transfer failed");
        
        emit Redeemed(msg.sender, egpAmount, hvtAmount, currentNAV);
    }

    /*//////////////////////////////////////////////////////////////
                          PROFIT MANAGEMENT
    //////////////////////////////////////////////////////////////*/
    function depositProfits(uint256 profitAmount) external onlyOwner {
        if (profitAmount == 0) revert ZeroAmount();
        
        uint256 oldNAV = useDynamicNAV ? getDynamicNAV() : nav;
        
        // Transfer profit EGP to pool
        (bool success, ) = P_EGP.call(
            abi.encodeWithSignature("transferFrom(address,address,uint256)", msg.sender, address(this), profitAmount)
        );
        require(success, "Profit transfer failed");
        
        // Track total profits
        totalProfitsDeposited += profitAmount;
        
        uint256 newNAV = useDynamicNAV ? getDynamicNAV() : nav;
        
        // If using manual NAV, update it to reflect the profit
        if (!useDynamicNAV) {
            nav = getDynamicNAV(); // Update manual NAV to match new pool value
            newNAV = nav;
        }
        
        emit ProfitDeposited(msg.sender, profitAmount, oldNAV, newNAV);
    }

    /*//////////////////////////////////////////////////////////////
                               ADMIN FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function setNAV(uint256 newNav) external onlyOwner {
        require(newNav > 0, "nav = 0");
        emit NAVUpdated(nav, newNav);
        nav = newNav;
    }

    function setDynamicNAV(bool _useDynamic) external onlyOwner {
        useDynamicNAV = _useDynamic;
        uint256 currentNAV = _useDynamic ? getDynamicNAV() : nav;
        emit DynamicNAVToggled(_useDynamic, currentNAV);
    }

    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "zero address");
        owner = newOwner;
    }

    /*//////////////////////////////////////////////////////////////
                          DYNAMIC NAV CALCULATION
    //////////////////////////////////////////////////////////////*/
    function getDynamicNAV() public view returns (uint256) {
        uint256 supply = HVT.totalSupply();
        if (supply == 0) return 1e18; // Initial NAV = 1 EGP per HVT
        
        uint256 tvl = _balanceOfToken(P_EGP, address(this));
        return (tvl * 1e18) / supply;
    }

    /*//////////////////////////////////////////////////////////////
                               VIEW HELPERS
    //////////////////////////////////////////////////////////////*/
    function getNAV() external view returns (uint256) {
        return useDynamicNAV ? getDynamicNAV() : nav;
    }

    function getTVL() external view returns (uint256) {
        return _balanceOfToken(P_EGP, address(this));
    }

    function getUserShare(address user) external view returns (uint256 percE18, uint256 valueEgp) {
        uint256 supply = HVT.totalSupply();
        if (supply == 0) return (0, 0);
        uint256 userBal = HVT.balanceOf(user);
        percE18 = (userBal * 1e18) / supply;
        uint256 tvl = _balanceOfToken(P_EGP, address(this));
        valueEgp = (tvl * percE18) / 1e18;
    }

    function getPoolStats() external view returns (
        uint256 tvl,
        uint256 currentNAV,
        uint256 dynamicNAV,
        uint256 hvtSupply,
        uint256 totalProfits,
        bool isDynamic
    ) {
        tvl = _balanceOfToken(P_EGP, address(this));
        currentNAV = useDynamicNAV ? getDynamicNAV() : nav;
        dynamicNAV = getDynamicNAV();
        hvtSupply = HVT.totalSupply();
        totalProfits = totalProfitsDeposited;
        isDynamic = useDynamicNAV;
    }

    /*//////////////////////////////////////////////////////////////
                              INTERNAL UTIL
    //////////////////////////////////////////////////////////////*/
    function _balanceOfToken(address token, address account) internal view returns (uint256 bal) {
        (bool s, bytes memory data) = token.staticcall(
            abi.encodeWithSignature("balanceOf(address)", account)
        );
        require(s, "balanceOf failed");
        bal = abi.decode(data, (uint256));
    }
} 