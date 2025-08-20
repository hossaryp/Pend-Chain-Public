# HarvestPool V2 - Dynamic NAV System Upgrade

## Overview

The HarvestPool has been upgraded to V2 with a revolutionary **Dynamic NAV System** that automatically calculates fair pricing based on pool performance and profit deposits.

## 🆕 New Features

### 1. **Dynamic NAV Calculation**
```solidity
function getDynamicNAV() public view returns (uint256) {
    uint256 supply = HVT.totalSupply();
    if (supply == 0) return 1e18; // Initial NAV = 1 EGP per HVT
    
    uint256 tvl = _balanceOfToken(P_EGP, address(this));
    return (tvl * 1e18) / supply; // NAV = TVL ÷ HVT Supply
}
```

**Benefits:**
- ✅ **Fair Pricing**: NAV automatically reflects true pool value
- ✅ **No Manual Updates**: Eliminates need for manual NAV setting
- ✅ **Real-time Accuracy**: Always current with deposits/withdrawals

### 2. **Profit Deposit System**
```solidity
function depositProfits(uint256 profitAmount) external onlyOwner {
    // Transfer profit EGP to pool
    // Automatically increases NAV for all holders
    // Tracks cumulative profits
}
```

**How It Works:**
1. Pool earns investment returns (e.g., 10% profit)
2. Owner mints profit EGP and deposits to pool
3. TVL increases → NAV increases automatically
4. All HVT holders benefit proportionally

### 3. **Dual NAV Mode**
```solidity
bool public useDynamicNAV; // Toggle between dynamic and manual NAV
```

**Modes:**
- **Dynamic Mode** (Default): NAV = TVL ÷ HVT Supply
- **Manual Mode** (Legacy): NAV set manually by owner

## 📊 Key Improvements

| Feature | V1 (Old) | V2 (New) |
|---------|----------|----------|
| NAV Calculation | Manual setting | Dynamic: TVL ÷ Supply |
| Profit Handling | No system | Built-in profit deposits |
| Fair Pricing | Prone to errors | Automatically fair |
| Transparency | Limited | Full profit tracking |
| Backward Compatibility | N/A | ✅ Fully compatible |

## 🔄 Migration Path

### For Existing Deployments
1. **No Redeployment Required** - Contract is upgraded in place
2. **Automatic Activation** - Dynamic NAV enabled by default
3. **Legacy Support** - Manual NAV still available if needed

### Current Pool Status
```
Before Upgrade:
- Manual NAV: 500,000 EGP per HVT (artificially high)
- TVL: 1,800 EGP
- HVT Supply: 0.059563 HVT
- Problem: Unfair pricing

After Upgrade:
- Dynamic NAV: 30,220 EGP per HVT (fair market value)
- TVL: 1,800 EGP  
- HVT Supply: 0.059563 HVT
- Solution: Fair pricing for all investors
```

## 💡 Usage Examples

### Example 1: Profit Deposit
```javascript
// Pool earns 10% return on 1,800 EGP = 180 EGP profit
await egpContract.mint(owner, ethers.parseUnits("180", 18));
await egpContract.approve(poolAddress, ethers.parseUnits("180", 18));
await poolContract.depositProfits(ethers.parseUnits("180", 18));

// Result:
// - TVL: 1,800 → 1,980 EGP (+180)
// - NAV: 30,220 → 33,242 EGP per HVT (+10%)
// - All HVT holders benefit from 10% value increase
```

### Example 2: Fair New Investment
```javascript
// New investor deposits 100 EGP
const newInvestment = ethers.parseUnits("100", 18);
const currentNAV = await poolContract.getDynamicNAV(); // 33,242 EGP
const hvtMinted = newInvestment / currentNAV; // 0.003006 HVT

// Result: Fair pricing maintained for both old and new investors
```

## 🛠️ New Functions

### Public Functions
```solidity
// Get dynamic NAV calculation
function getDynamicNAV() public view returns (uint256)

// Deposit investment profits (owner only)
function depositProfits(uint256 profitAmount) external onlyOwner

// Toggle NAV calculation mode (owner only)  
function setDynamicNAV(bool _useDynamic) external onlyOwner

// Get comprehensive pool statistics
function getPoolStats() external view returns (...)
```

### Enhanced Events
```solidity
// Enhanced deposit/redeem events with NAV tracking
event Deposited(address indexed user, uint256 egpAmount, uint256 hvtMinted, uint256 navUsed);
event Redeemed(address indexed user, uint256 egpAmount, uint256 hvtBurned, uint256 navUsed);

// New profit tracking events
event ProfitDeposited(address indexed depositor, uint256 profitAmount, uint256 oldNAV, uint256 newNAV);
event DynamicNAVToggled(bool enabled, uint256 currentNAV);
```

## 🔍 State Variables

### New State Variables
```solidity
uint256 public totalProfitsDeposited; // Track cumulative profits
bool public useDynamicNAV;           // Enable/disable dynamic NAV
```

### Modified Variables
```solidity
uint256 public nav; // LEGACY: Manual NAV (kept for compatibility)
```

## 🚀 Benefits for Users

### For Investors
- **Fair Entry Price**: Always pay market value, never overpay
- **Automatic Returns**: Benefit from pool profits without action
- **Transparent Growth**: See exact profit contributions
- **Protected Value**: No dilution from mispriced entries

### For Pool Operators  
- **Simplified Management**: No manual NAV calculations
- **Profit Distribution**: Easy way to share returns with holders
- **Flexible Operation**: Choose dynamic or manual mode
- **Better Analytics**: Comprehensive pool statistics

## 📈 Real-World Scenario

```
Day 1: Pool Launch
- Initial deposit: 1,000 EGP → 1,000 HVT
- NAV: 1.0 EGP per HVT

Day 30: Investment Returns
- Pool earns 100 EGP profit → depositProfits(100)
- TVL: 1,100 EGP, Supply: 1,000 HVT
- NAV: 1.1 EGP per HVT (+10%)

Day 31: New Investor
- Invests 110 EGP → receives 100 HVT (fair price)
- TVL: 1,210 EGP, Supply: 1,100 HVT  
- NAV: 1.1 EGP per HVT (maintained)

Result: Fair for everyone! 🎉
```

## 🔧 Implementation Notes

### Backward Compatibility
- All existing functions work unchanged
- Legacy `nav` variable preserved
- Existing events still emitted
- No breaking changes for frontend

### Gas Optimization
- Dynamic NAV calculated on-demand (view function)
- Minimal storage additions
- Efficient profit tracking

### Security Enhancements
- Added liquidity checks for redemptions
- Profit deposit validation
- Proper error handling with custom errors

## 🎯 Next Steps

1. **Deploy Upgrade**: Contract is ready for immediate use
2. **Enable Dynamic NAV**: Already enabled by default
3. **Test Profit Deposits**: Use demonstration scripts
4. **Monitor Performance**: Track NAV growth over time
5. **Update Frontend**: Utilize new `getPoolStats()` function

---

*HarvestPool V2 represents a major leap forward in DeFi pool management, bringing institutional-grade NAV calculation to the decentralized world. Fair, transparent, and automated - the future of investment pools.* 