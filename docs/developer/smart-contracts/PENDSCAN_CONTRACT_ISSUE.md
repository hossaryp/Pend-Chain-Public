# PendScan Initialization Failure: Smart Wallet Factory Contract Missing Required Functions

## Issue Description

PendScan blockchain explorer fails to initialize with the following error:

```
Failed to initialize PendScan: execution reverted (no data present; likely require(false) occurred 
(action="call", data="0x", reason="require(false)", 
  transaction={ "data": "0x745bd5a2", "to": "0x0f84B067f6C71861E705aA45233854F5Db33926d" }, 
invocation=null, revert=null, code=CALL_EXCEPTION, version=6.14.1)
```

## Root Cause

The PendScan explorer expects the Smart Wallet Factory contract to have several view functions for wallet discovery and tracking, but the deployed contract doesn't implement these functions.

### Expected Functions (per PendScan ABI):
```javascript
// In server/utils/walletLinker.js
const smartWalletFactoryABI = [
    "function createWallet(bytes32 identityHash, bytes32 phoneHash) returns (address)",
    "function walletOfIdentity(bytes32 identityHash) view returns (address)",
    "function identityOfWallet(address wallet) view returns (bytes32)",
    "function getWalletCount() view returns (uint256)",              // ← Missing, selector: 0x745bd5a2
    "function getWalletByIndex(uint256 index) view returns (address)", // ← Missing
    "event WalletCreated(...)"
];
```

### Actually Deployed Contract:
```solidity
// In hardhat/contracts/SmartWalletFactory.sol
contract SmartWalletFactory {
    mapping(bytes32 => address) public walletOfIdentity;  // ✓ Exists
    
    function createWallet(bytes32 ownerIdentityHash) external returns (address wallet)  // ✓ Exists
    function createWallet(bytes32, bytes, string, string) external returns (address)    // ✓ Exists
    
    // Missing: getWalletCount()
    // Missing: getWalletByIndex()
    // Missing: identityOfWallet()
}
```

## Proposed Solution (Option 1 - Recommended)

Update the Smart Wallet Factory contract to include the missing tracking functions:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./SmartWallet.sol";
import "./IConsentManager.sol";

contract SmartWalletFactory {
    // ... existing code ...
    
    /// @notice Array to track all created wallets for enumeration
    address[] private allWallets;
    
    /// @notice Reverse mapping from wallet address to identity hash
    mapping(address => bytes32) public identityOfWallet;
    
    // ... existing code ...
    
    /**
     * @notice Returns the total number of wallets created
     * @return count The number of wallets
     */
    function getWalletCount() external view returns (uint256) {
        return allWallets.length;
    }
    
    /**
     * @notice Returns the wallet address at a specific index
     * @param index The index to query
     * @return wallet The wallet address at that index
     */
    function getWalletByIndex(uint256 index) external view returns (address) {
        require(index < allWallets.length, "SmartWalletFactory: index out of bounds");
        return allWallets[index];
    }
    
    // Update createWallet functions to maintain the arrays/mappings:
    function createWallet(bytes32 ownerIdentityHash) external returns (address wallet) {
        require(walletOfIdentity[ownerIdentityHash] == address(0), "SmartWalletFactory: wallet already exists");
        wallet = address(new SmartWallet(ownerIdentityHash, validator, consentManager));
        
        // Update mappings and array
        walletOfIdentity[ownerIdentityHash] = wallet;
        identityOfWallet[wallet] = ownerIdentityHash;
        allWallets.push(wallet);
        
        emit WalletCreated(ownerIdentityHash, wallet);
    }
    
    // Similar update for the other createWallet function...
}
```

## Implementation Steps

1. **Update Contract**:
   - Add the `allWallets` array and `identityOfWallet` mapping
   - Implement `getWalletCount()` and `getWalletByIndex()` functions
   - Update both `createWallet` functions to maintain the new data structures

2. **Test Contract**:
   - Write tests for the new functions
   - Ensure gas costs are still reasonable
   - Test enumeration with many wallets

3. **Deploy Updated Contract**:
   - Deploy new Smart Wallet Factory
   - Update environment variables with new address
   - Migrate any existing wallet data if needed

4. **Update Configuration**:
   - Update `SMART_WALLET_FACTORY_ADDRESS` in all `.env` files
   - Restart services

## Alternative Solution (Option 2 - Quick Fix)

If contract upgrade is not feasible, modify PendScan to work without these functions:
- Remove dependency on `getWalletCount()` and `getWalletByIndex()`
- Rely solely on `WalletCreated` events for wallet discovery
- This is already partially implemented in the `scanAllWallets()` method

## Impact

- **Critical**: PendScan explorer cannot initialize
- **Affected Systems**: Blockchain explorer, wallet analytics, transaction tracking
- **User Impact**: Cannot view blockchain data through web interface

## Priority

**High** - Core functionality of blockchain explorer is broken

## Labels

- `bug`
- `smart-contract`
- `pendscan`
- `blockchain`
- `enhancement` 