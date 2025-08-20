# Harvest Pool V3 – Pend Beta (Current Production)

This suite contains two contracts deployed together:

| Contract | Address | Purpose |
|----------|---------|---------|
| `HarvestToken V3` (HVT) | `0x0829E73bEA7d0d07FAFA3A3a6883c568DAf76098` | ERC-20 LP token representing a share in the Harvest Pool V3 |
| `HarvestPool V3` | `0xe4de484028097fA25f7a5893843325385812AD70` | Manages deposits & redemptions in pEGP with FIXED NAV calculation |

## V3 Key Features (Bug Fixes)

1. **Fixed NAV Calculation**  
   ✅ **CRITICAL FIX**: NAV is now calculated **BEFORE** EGP transfer, ensuring fair pricing for all investors. This fixes the timing bug present in V2.

2. **Dynamic NAV System**  
   NAV automatically adjusts based on pool performance: `NAV = TVL ÷ HVT Supply`. When profits are added, all token holders benefit proportionally.

3. **Deposits**  
   Users deposit `pEGP` into `HarvestPool.deposit(uint256 amount)` after approving the contract. The pool mints `amount / NAV` HVT to the user at fair market price.

4. **Redemptions**  
   Users call `HarvestPool.redeem(uint256 hvtAmount)` to burn their HVT and receive `hvtAmount × NAV` pEGP in return at current market price.

5. **Profit Distribution**
   Pool owner can add profits using `depositProfits(uint256 amount)`, which increases NAV for all token holders.

## Current Pool Status

- **Pool Address**: `0xe4de484028097fA25f7a5893843325385812AD70`
- **HVT Token**: `0x0829E73bEA7d0d07FAFA3A3a6883c568DAf76098`
- **Current NAV**: Dynamic (starts at 1.0 EGP/HVT)
- **Bug Status**: ✅ Fixed in V3

## Key Concepts

1. **Net-Asset-Value (NAV)**  
   NAV represents how many pEGP one HVT is worth. It starts at **1 pEGP** and can be adjusted by the contract owner (the Pend admin) with `setNAV(uint256 newNAV)`.

2. **Deposits**  
   Users deposit `pEGP` into `HarvestPool.deposit(uint256 amount)` after approving the contract. The pool mints `amount / NAV` HVT to the user.

3. **Redemptions**  
   Users call `HarvestPool.redeem(uint256 hvtAmount)` to burn their HVT and receive `hvtAmount × NAV` pEGP in return.

4. **Ownership Transfers**  
   After deployment the script transfers ownership of `HarvestToken` to `HarvestPool`, making the pool the **sole minter/burner** of HVT.

## Events

| Event | Emitted When | Parameters |
|-------|--------------|------------|
| `Deposited` | User deposits pEGP | `user`, `egpAmount`, `hvtMinted` |
| `Redeemed`  | User redeems HVT  | `user`, `egpAmount`, `hvtBurned` |
| `NAVUpdated`| Owner changes NAV | `oldNav`, `newNav` |

## Quick Start

1. **Compile & test**

```bash
cd hardhat
npm install
npx hardhat test test/harvestPool.t.js
```

2. **Deploy to Besu**

```bash
# Make sure your Besu node (chainId 7777) is running and account unlocked / private key in .env
npx hardhat run scripts/deploy-harvest.js --network besu
```

3. **Interact**

```solidity
// Solidity examples
HarvestPool pool = HarvestPool(<address_from_deploy>);

// Check NAV & TVL
uint nav = pool.getNAV();
uint tvl = pool.getTVL();

// Deposit 100 pEGP
IERC20(pEGP).approve(address(pool), 100 ether);
pool.deposit(100 ether);

// Redeem 10 HVT
pool.redeem(10 ether);
```

## Security Notes

* The pool is ** NOT** upgradeable. Audit before production use.
* `setNAV` is owner-only. Ensure the owner EOA / multisig is secured. 