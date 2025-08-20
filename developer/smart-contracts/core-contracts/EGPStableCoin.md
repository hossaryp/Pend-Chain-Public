# EGPStableCoin Documentation

## Overview

The `EGPStableCoin` contract is an ERC-20 token implementation representing the Pend Egyptian Pound (pEGP). It is pegged 1:1 to the Egyptian Pound and is controlled by the contract owner (validator).

## Contract Details

- **Name:** Pend Egyptian Pound
- **Symbol:** pEGP
- **Decimals:** 18
- **Network:** Pend Local Network (Chain ID: 7777)
- **Current Deployment:** 0xEF65B923fd050BcE414fe3f6E48CC43B05F25c29

## Key Features

- **Validator-Controlled:** Only the validator (contract owner) can mint or burn tokens
- **1:1 Peg:** Each pEGP token represents 1 Egyptian Pound
- **Instant Minting:** Users can instantly mint EGP tokens through the wallet interface
- **No External Dependencies:** The contract operates independently without relying on external price feeds

## 💰 User Deposit Flow

### Frontend (Wallet UI)
Users can add EGP tokens to their wallet through two paths:

1. **Primary Deposit Flow:**
   - Click "Deposit" button in wallet tab
   - Select "EGP" from currency options
   - Enter amount to deposit
   - Confirm transaction

2. **Quick Access Flow:**
   - Click "More" actions button
   - Select "Add EGP" option
   - Enter amount to deposit
   - Confirm transaction

### Backend Processing
1. User submits deposit request via `/api/deposit-egp` endpoint
2. Backend validates:
   - Phone number matches wallet address
   - Amount is valid
   - User has proper consent
3. Validator mints pEGP tokens directly to user's wallet
4. Transaction is confirmed on-chain
5. Wallet balance updates in real-time

## Smart Contract Functions

### `transferOwnership`
Transfers ownership of the contract to a new address.

- **Parameters:**
  - `newOwner` (address): The address of the new owner

### `mint`
Mints new tokens to a specified address. Only callable by contract owner (validator).

- **Parameters:**
  - `to` (address): The address to receive the minted tokens
  - `amount` (uint256): The amount of tokens to mint (in wei, 18 decimals)

### `burn`
Burns a specified amount of tokens from the caller's balance.

- **Parameters:**
  - `amount` (uint256): The amount of tokens to burn

### Standard ERC-20 Functions
- `balanceOf(address)`: Get token balance
- `transfer(address, uint256)`: Transfer tokens
- `approve(address, uint256)`: Approve spending
- `transferFrom(address, address, uint256)`: Transfer on behalf

## Events

- **Transfer:** Emitted when tokens are transferred, including minting
- **Approval:** Emitted when spending allowance is set
- **OwnershipTransferred:** Emitted when contract ownership changes

## API Integration

### Deposit Endpoint
```javascript
POST /api/deposit-egp
{
  "amount": "1000.00",
  "phone": "+201234567890",
  "wallet": "0x742d35Cc6634C0532925a3b8D0b2A"
}
```

### Balance Check
```javascript
GET /api/egp/balance/:walletAddress
```

### Total Supply
```javascript
GET /api/egp/supply
```

## Deployment Information

**Deployer:** 0xeaf4197108Dd5810EC0f6036ee0e6E77621a2E39  
**Contract:** 0xEF65B923fd050BcE414fe3f6E48CC43B05F25c29  
**Network:** Pend Local Network (Chain ID: 7777)  
**RPC:** http://127.0.0.1:8545  

**Previous Deployment:** 0x0e62978a8237984fEB2c99E29A6283Cc1FDdA671 (legacy)

## Security Features

1. **Owner-Only Minting:** Only the validator can mint new tokens
2. **Phone Verification:** Deposits require verified phone number
3. **Wallet Validation:** Ensures tokens are minted to correct user wallet
4. **Transaction Logging:** All minting operations are logged for audit

## Integration with Wallet UI

The EGP stablecoin is fully integrated with the Pend wallet interface:

- Real-time balance display
- Instant deposit functionality  
- Transaction history tracking
- Portfolio value calculation
- Send/receive operations

## Development

### Local Testing
```bash
# Deploy EGP contract
npx hardhat run scripts/deploy-stablecoin.js --network pend

# Test minting
npx hardhat run scripts/test-egp-mint.js --network pend
```

### Environment Setup
```env
EGP_STABLECOIN_ADDRESS=0xEF65B923fd050BcE414fe3f6E48CC43B05F25c29
```