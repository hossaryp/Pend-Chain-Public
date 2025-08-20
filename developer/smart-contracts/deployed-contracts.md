# Deployed Smart Contracts

## Network Information
- Network: Pend Local Network
- Chain ID: 7777
- RPC URL: http://127.0.0.1:8545

## Contract Addresses (Latest Deployment)

### Core Contracts
1. **Deployer Account**
   - Address: `0xeaf4197108Dd5810EC0f6036ee0e6E77621a2E39`

2. **ConsentManager**
   - Address: `0x5103f499A89127068c20711974572563c3dCb819`
   - Description: Manages user consents and verifications
   - Deployed by: Deployer Account

3. **SmartWalletFactory**
   - Address: `0x0f84B067f6C71861E705aA45233854F5Db33926d`
   - Description: Creates new smart wallets for users
   - Dependencies: ConsentManager
   - Deployed by: Deployer Account

4. **PendIdentityRegistry**
   - Address: `0x074C5a96106b2Dcefb74b174034bd356943b2723`
   - Description: Stores on-chain identity records with phone number registration and verification tiers
   - Dependencies: ConsentManager (reads consent tier)
   - Features: registerIdentity() function, updateVerification() for tier management, phone number integration

5. **InvestmentAgreement**
   - Address: `TBD - Not yet deployed`
   - Description: Stores investment agreement terms on-chain and records user consent signatures
   - Features: Version-controlled agreements, OTP-verified signatures, regulatory compliance (FRA + Reg S)
   - Dependencies: Validator address (for signature verification)
   - Documentation: [InvestmentAgreement.md](./InvestmentAgreement.md)

6. **AccessControlHub**
   - Address: `0x57Bee198a7148A94f27a71465216bB67f166b9F4`
   - Description: Centralized role management system for the PEND ecosystem
   - Features: 5 pre-defined roles (ASSET_ISSUER, KYC_CONFIRMER, CONSENT_AGENT, AUDITOR, DATA_VIEWER)
   - Capabilities: Batch role operations, role enumeration, pausable for emergencies
   - Documentation: [AccessControlHub.md](./AccessControlHub.md)

### Harvest Pool Contracts (V3 - Current)
7. **EGP StableCoin**
   - Address: `0xEF65B923fd050BcE414fe3f6E48CC43B05F25c29`
   - Description: Pend Egyptian Pound stablecoin with instant minting functionality
   - Symbol: pEGP
   - Features: Validator-controlled minting, 1:1 EGP peg, wallet UI integration
   - Previous Address: `0x0e62978a8237984fEB2c99E29A6283Cc1FDdA671` (legacy)

8. **HarvestToken V3**
   - Address: `0xa27E5ed810aaBe87373904Ac1Ae23B682ACDC4f6`
   - Description: ERC-20 LP token representing shares in Harvest Pool V3
   - Symbol: HVT

9. **HarvestPool V3 (Fixed NAV Bug)**
   - Address: `0xF6d94A2BC3Ed6d951b04dF7730A683A2316Ef208`
   - Description: Investment pool with FIXED NAV calculation and profit tracking
   - Features: Fixed NAV bug, dynamic pricing, automatic profit distribution
   - Status: ✅ Production Ready

### InterestOnlyAsset System (Pre-Launch Demand Validation)
10. **InterestOnlyAssetFactory**
   - Address: `0xb60C2d12DD5b4E707a5242525b5458750fE2DA89`
   - Description: Factory for deploying interest tracking contracts before full tokenization
   - Features: Asset manager authorization, consent integration, factory statistics
   - Dependencies: ConsentManager
   - Status: ✅ Production Ready

11. **Solar Farm Aswan Q1 2026 (Interest Asset)**
    - Address: `0x8bEDEBD55E9781162234629c7E4ffcc80aCf4153`
    - Description: Interest tracking for solar farm investment opportunity
    - Features: 100 user soft cap, 30-day deadline, investment intent collection
    - Category: Renewable Energy
    - Admin: 0xeaf4197108Dd5810EC0f6036ee0e6E77621a2E39

12. **Gold Fund Q3 2026 (Interest Asset)**
    - Address: `0x66E91E15b40bf8c9fAbc10ADBBf7Fb0d5c462FB8`
    - Description: Interest tracking for precious metals fund investment
    - Features: 50 user soft cap, 45-day deadline, investment intent collection
    - Category: Precious Metals
    - Admin: 0xeaf4197108Dd5810EC0f6036ee0e6E77621a2E39

### Dynamic Contracts
- **SmartWallet**
  - Description: Individual user wallet contracts
  - Note: New instances are deployed by SmartWalletFactory when users create wallets
  - Each user gets their own unique wallet address

## Environment Variables
Add these to your `.env` file:

```env
# Network Configuration
RPC_URL=http://127.0.0.1:8545
CHAIN_ID=7777

# Contract Addresses
CONSENT_MANAGER_ADDRESS=0x5103f499A89127068c20711974572563c3dCb819
SMART_WALLET_FACTORY_ADDRESS=0x0f84B067f6C71861E705aA45233854F5Db33926d
IDENTITY_REGISTRY_ADDRESS=0x074C5a96106b2Dcefb74b174034bd356943b2723
ACCESS_CONTROL_HUB_ADDRESS=0x57Bee198a7148A94f27a71465216bB67f166b9F4

# Harvest Pool V3 Addresses (Current)
EGP_STABLECOIN_ADDRESS=0xEF65B923fd050BcE414fe3f6E48CC43B05F25c29
HARVEST_POOL_ADDRESS=0xF6d94A2BC3Ed6d951b04dF7730A683A2316Ef208
HVT_ADDRESS=0xa27E5ed810aaBe87373904Ac1Ae23B682ACDC4f6

# InterestOnlyAsset System
INTEREST_ONLY_ASSET_FACTORY_ADDRESS=0xb60C2d12DD5b4E707a5242525b5458750fE2DA89

# Deployer Account (for testing/admin operations)
DEPLOYER_ADDRESS=0xeaf4197108Dd5810EC0f6036ee0e6E77621a2E39
```

## Deployment Script
The contracts were deployed using `scripts/deploy-all.js`. To redeploy the contracts:

```bash
npx hardhat run scripts/deploy-all.js --network pend
```

## Contract Verification
These contracts are deployed on a local network and do not require verification on a block explorer. 

*(Legacy `DummyTarget` test contract has been removed – no longer deployed.)* 

### Legacy Contracts (V2 - NAV Bug)
- **HarvestToken V2**: `0x8086CedD100FF478De73EE12023d058fB66998ea` (⚠️ Has NAV timing bug)
- **HarvestPool V2**: `0x782cD3c81A97dDe828f7E72e47245c9bE6EF5eF7` (⚠️ Has NAV timing bug)
- **Note**: V2 contracts have a NAV calculation bug. Use V3 for all new investments. 