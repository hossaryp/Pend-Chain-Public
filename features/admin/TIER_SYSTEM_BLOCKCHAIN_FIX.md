# Tier System Blockchain Integration Fix

## Overview
Fixed critical issues with the identity tier system to ensure all tier data is read from the blockchain smart contract instead of local storage, and implemented proper OTP consent verification for all tier upgrades.

## Key Issues Fixed

### 1. Blockchain Tier Reading
- **Problem**: `getCurrentTier()` was falling back to local storage calculations, causing UI to show incorrect tiers
- **Solution**: Modified to always read from blockchain, return 0 if blockchain unavailable
- **Impact**: UI now shows accurate blockchain-verified tier status

### 2. Wallet Creation Flow
- **Problem**: Attempting to store consent on blockchain during wallet creation with reused OTP
- **Solution**: Wallet creation now only stores consent locally; blockchain storage happens during proper tier upgrade
- **Impact**: Prevents OTP reuse errors and ensures proper consent flow

### 3. Device Registration Flow
- **Problem**: Direct device registration without OTP consent verification
- **Solution**: All device registrations now use `DeviceRegistrationModal` with OTP step
- **Impact**: Proper blockchain consent verification for Tier 1 upgrades

### 4. Consent Verification Endpoint
- **Problem**: `/api/consent/verify-consent` only verified without storing consent first
- **Solution**: Endpoint now calls `storeConsent()` before `verifyConsent()`
- **Impact**: Consent actions properly recorded on blockchain

### 5. Biometric Registration
- **Problem**: Direct biometric registration without consent flow
- **Solution**: Biometric registration now opens tier upgrade modal with OTP verification
- **Impact**: Proper Tier 2 upgrade with blockchain verification

## Technical Implementation

### Consent Flow Requirements
```
Tier 1 (Device) = OTP consent only
Tier 2 (Biometric) = OTP + device verification  
Tier 3 (KYC) = OTP + device + biometric verification
Tier 4 (Location) = OTP + all previous requirements
```

### Smart Contract Integration
- ConsentManager stores verified actions: `register_device`, `verify_biometric`, `submit_kyc`, `verify_location`
- Each OTP can only be used once (marked as `used` in contract)
- Tier calculation based on verified actions count

### User Journey
1. **Wallet Creation**: Creates wallet at Tier 0, stores device/biometric/location locally only
2. **Settings Upgrade**: User initiates upgrade → OTP sent → Verify consent → Store on blockchain → Execute action → Tier updated

## Files Modified
- `server/routes/consent.js`: Added consent storage before verification
- `wallet-ui/src/services/tierUpgradeService.ts`: Removed local storage fallback
- `wallet-ui/src/app/components/SettingsTab.tsx`: Added proper modal flows
- `wallet-ui/src/shared/components/DeviceRegistrationModal.tsx`: Added OTP verification step
- `wallet-ui/src/App.tsx`: Removed blockchain storage during wallet creation
- `wallet-ui/src/features/harvest/components/HarvestInvestModal.tsx`: Use TierUpgradeService for accurate tier

## Testing Checklist
- [ ] Wallet creation completes at Tier 0
- [ ] Device registration requires OTP and upgrades to Tier 1
- [ ] Biometric registration requires OTP and upgrades to Tier 2
- [ ] Investment modals show correct tier requirements
- [ ] Settings page shows blockchain tier, not local calculations 