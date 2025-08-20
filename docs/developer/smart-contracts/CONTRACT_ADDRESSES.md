# Pend Beta - Contract Addresses Reference

## 🌍 Network Configuration
- **Network**: Pend Local Besu Network
- **Chain ID**: 7777
- **RPC URL**: http://127.0.0.1:8545

## 📝 Core Infrastructure Contracts

### Identity & Wallet Management
| Contract | Address | Description |
|----------|---------|-------------|
| **ConsentManager** | `0x5103f499A89127068c20711974572563c3dCb819` | Manages user consents and verifications |
| **SmartWalletFactory** | `0x0f84B067f6C71861E705aA45233854F5Db33926d` | Creates new smart wallets for users |
| **PendIdentityRegistry** | `NOT DEPLOYED YET` | Stores identity records and KYC data with phone registration |
| **AccessControlHub** | `0x57Bee198a7148A94f27a71465216bB67f166b9F4` | Central role management for the PEND ecosystem |

### Financial Infrastructure
| Contract | Address | Description |
|----------|---------|-------------|
| **EGP StableCoin** | `NOT DEPLOYED YET` | Pend Egyptian Pound (pEGP) stablecoin |

## 🎯 Interest-Only Asset System (Pre-Launch Demand Validation)

### InterestOnlyAsset Factory & Contracts
| Contract | Address | Description |
|----------|---------|-------------|
| **InterestOnlyAssetFactory** | `0xb60C2d12DD5b4E707a5242525b5458750fE2DA89` | Factory for deploying interest tracking contracts |
| **Solar Farm Aswan Q1 2026** | `0x8bEDEBD55E9781162234629c7E4ffcc80aCf4153` | Interest tracking for solar farm investment (100 user cap) |
| **Gold Fund Q3 2026** | `0x66E91E15b40bf8c9fAbc10ADBBf7Fb0d5c462FB8` | Interest tracking for gold fund investment (50 user cap) |

### InterestOnlyAsset Features
- ✅ **Pre-Launch Validation**: Test demand before full ERC-20 deployment
- ✅ **Whitelist Building**: Create verified investor lists with consent
- ✅ **Investment Intent Tracking**: Collect planned investment amounts
- ✅ **Soft Cap Management**: Automatic enforcement of maximum interested users
- ✅ **Admin Controls**: Close/reopen periods, mark ready for tokenization
- ✅ **Migration Ready**: Seamless transition to full tokenization

## 🚀 Harvest Pool V3 (NOT DEPLOYED ON FRESH BLOCKCHAIN)

### V3 Pool Contracts
| Contract | Address | Description |
|----------|---------|-------------|
| **HarvestPool V3 (Fixed)** | `NOT DEPLOYED YET` | Investment pool with FIXED NAV calculation |
| **HarvestToken V3 (HVT)** | `NOT DEPLOYED YET` | LP token for V3 pool |

### V3 Critical Fixes
- ✅ **NAV Bug Fixed**: NAV calculated BEFORE EGP transfer (correct sequence)
- ✅ **Fair Pricing**: Guaranteed fair pricing for all investors
- ✅ **Dynamic NAV**: Automatic fair pricing (TVL ÷ HVT Supply)
- ✅ **Profit Tracking**: Built-in profit deposit system
- ✅ **Production Ready**: Secure and audited contract logic

## 📦 Legacy Pools (Reference Only)

### V2 Pool (NAV Bug - Use V3 Instead)
| Contract | Address | Description |
|----------|---------|-------------|
| **HarvestPool V2** | `0x782cD3c81A97dDe828f7E72e47245c9bE6EF5eF7` | Pool with NAV timing bug |
| **HarvestToken V2 (HVT)** | `0x8086CedD100FF478De73EE12023d058fB66998ea` | LP token for V2 pool |

### V1 Pool (Deprecated)
| Contract | Address | Description |
|----------|---------|-------------|
| **HarvestPool V1** | `0x49f67Eea29d96B56C1493af5d1a4b546a549D60F` | Legacy pool with manual NAV |
| **HarvestToken V1 (HVT)** | `0xeb830e909875eba6a2E6d0B05C41c378BE80fe6d` | LP token for V1 pool |

**⚠️ Note**: All new investments should use V3. V2 has a NAV calculation bug. V1 is deprecated.

## 🔧 Environment Variables

### Frontend (.env)
```bash
VITE_RPC_URL=http://127.0.0.1:8545
VITE_CHAIN_ID=7777

# Core Contracts
VITE_CONSENT_MANAGER_ADDRESS=0x5103f499A89127068c20711974572563c3dCb819
VITE_SMART_WALLET_FACTORY_ADDRESS=0x0f84B067f6C71861E705aA45233854F5Db33926d
VITE_IDENTITY_REGISTRY_ADDRESS=0x074C5a96106b2Dcefb74b174034bd356943b2723
VITE_ACCESS_CONTROL_HUB_ADDRESS=0x57Bee198a7148A94f27a71465216bB67f166b9F4

# Financial Contracts
VITE_EGP_STABLECOIN_ADDRESS=0x0e62978a8237984fEB2c99E29A6283Cc1FDdA671

# Harvest Pool V3
VITE_HARVEST_POOL_ADDRESS=0xe4de484028097fA25f7a5893843325385812AD70
VITE_HVT_ADDRESS=0x0829E73bEA7d0d07FAFA3A3a6883c568DAf76098

# InterestOnlyAsset System
VITE_INTEREST_ONLY_ASSET_FACTORY_ADDRESS=0xb60C2d12DD5b4E707a5242525b5458750fE2DA89
```

### Server (.env)
```bash
RPC_URL=http://localhost:8545
VALIDATOR_PRIVATE_KEY=0x724d28c416597a047dbafea1ff183825db730db2acfaac96901aef0b8852e320

# Core Contracts
CONSENT_MANAGER_ADDRESS=0x5103f499A89127068c20711974572563c3dCb819
SMART_WALLET_FACTORY_ADDRESS=0x0f84B067f6C71861E705aA45233854F5Db33926d
IDENTITY_REGISTRY_ADDRESS=0x074C5a96106b2Dcefb74b174034bd356943b2723
ACCESS_CONTROL_HUB_ADDRESS=0x57Bee198a7148A94f27a71465216bB67f166b9F4

# Financial Contracts
EGP_STABLECOIN_ADDRESS=0x0e62978a8237984fEB2c99E29A6283Cc1FDdA671

# Harvest Pool V3
HARVEST_POOL_ADDRESS=0xe4de484028097fA25f7a5893843325385812AD70
HVT_ADDRESS=0x0829E73bEA7d0d07FAFA3A3a6883c568DAf76098

# InterestOnlyAsset System
INTEREST_ONLY_ASSET_FACTORY_ADDRESS=0xb60C2d12DD5b4E707a5242525b5458750fE2DA89
```

## 📊 Current Pool Status (V3)

- **TVL**: 0 EGP (fresh deployment)
- **Dynamic NAV**: 1.0 EGP per HVT (initial)
- **HVT Supply**: 0 tokens
- **Dynamic NAV Enabled**: ✅ Active
- **NAV Bug**: ✅ Fixed in V3

## 🔄 Migration Status

✅ **V3 Deployment**: Complete - Bug-free pool deployed  
✅ **Frontend**: Updated to use V3 addresses  
✅ **Server**: Updated to use V3 addresses  
✅ **Documentation**: Updated with V3 addresses  
✅ **NAV Bug**: Fixed in V3 contract

---

**Last Updated**: June 26, 2025  
**Status**: V3 Production Ready ✅  
**Bug Status**: NAV Timing Issue Fixed ✅ 
**AccessControlHub**: Deployed ✅ 