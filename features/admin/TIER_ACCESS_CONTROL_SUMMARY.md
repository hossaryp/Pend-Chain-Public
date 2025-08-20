# Identity Tier-Based Access Control System

## Overview
This system implements comprehensive identity tier-based access control for blockchain investment pools. It provides both user-facing tier validation and admin management capabilities, all integrated with smart contracts.

## Core Features

### 1. **Frontend Tier Validation**
- **Tier Badges**: Visual indicators on pool/explore cards showing required tier levels
- **Investment Blocking**: Prevents low-tier users from accessing high-tier pools
- **Tier Insufficient Modal**: Clear messaging and upgrade path guidance
- **Real-time Validation**: Checks user tier before allowing investment actions

### 2. **Smart Contract Integration**
- **ConsentManager Contract**: Stores consent actions and calculates tier levels
- **Tier Calculation**: Based on completed actions (phone, device, biometric, KYC, location)
- **Blockchain Enforcement**: On-chain validation prevents bypassing of restrictions

### 3. **Admin Panel Tier Management**
The admin panel now includes comprehensive tier management functionality:

#### **Tier Management Tab**
- **User Tier Lookup**: Query any user's current tier by phone number
- **Tier Upgrade**: Directly upgrade user tiers by adding consent actions
- **Tier Analytics**: View distribution of users across all tier levels
- **Smart Contract Integration**: Direct interaction with ConsentManager contract

#### **Pool Settings Tab**
- **Dynamic Pool Requirements**: Configure tier requirements for any pool
- **Requirement Updates**: Real-time updates to pool tier restrictions
- **Access Statistics**: View eligibility stats for each tier level
- **Configuration Management**: Persistent storage of pool tier settings

## Technical Implementation

### Tier Levels
```
Tier 0: Phone Only (156 users)
Tier 1: Phone + Device Registration (89 users)
Tier 2: + Biometric Verification (34 users)
Tier 3: + KYC Submission (12 users)
Tier 4: + Location Verification (5 users)
```

### Smart Contract Actions
- `register_phone`: Basic phone verification
- `register_device`: Device fingerprinting
- `verify_biometric`: Biometric authentication
- `submit_kyc`: KYC document submission
- `verify_location`: Geographic verification

### API Endpoints

#### User Tier Management
- `POST /api/consent/tier`: Get user's current tier
- `POST /api/admin/upgrade-user-tier`: Admin tier upgrade

#### Pool Configuration
- `GET /api/admin/pool-tiers`: Get pool tier requirements
- `POST /api/admin/pool-tiers`: Update pool tier requirements
- `GET /api/admin/tier-analytics`: Get tier distribution analytics

### Frontend Components

#### New Components
- `TierBadge.tsx`: Reusable tier requirement display
- `TierInsufficientModal.tsx`: Modal for insufficient tier cases
- `TierService.ts`: Service for tier operations

#### Updated Components
- `PendAdminPanel.tsx`: Added tier management tabs
- `PoolsTab.tsx`: Added tier validation and badges
- `ExploreCard.tsx`: Added tier requirement display
- `HarvestInvestModal.tsx`: Integrated tier checking

### Pool Configuration
Pool tier requirements are now configurable:

```typescript
// Dynamic configuration (editable via admin panel)
const POOL_TIER_REQUIREMENTS = {
  'harvest-pool': 1,        // Tier 1 Required
  'solar-farm-aswan': 2,    // Tier 2 Required
  'gold-vault': 2,          // Tier 2 Required
  'real-estate-cairo': 2    // Tier 2 Required
};
```

## Admin Panel Features

### 1. **Three-Tab Interface**
- **Deploy Opportunities**: Original asset deployment functionality
- **Tier Management**: User tier lookup, upgrade, and analytics
- **Pool Settings**: Configure pool tier requirements and view statistics

### 2. **Tier Management Capabilities**
- **Check User Tier**: Query any user's current tier level
- **Upgrade User Tier**: Add consent actions to upgrade users
- **Tier Analytics**: View user distribution across all tiers
- **Smart Contract Integration**: Direct blockchain interaction

### 3. **Pool Configuration**
- **Dynamic Requirements**: Set tier requirements for any pool
- **Real-time Updates**: Immediately update restrictions
- **Access Statistics**: View eligibility percentages
- **Persistent Storage**: Settings saved and synchronized

## Security & Compliance

### Multi-Layer Validation
1. **Frontend Validation**: User experience and guidance
2. **Backend Validation**: API endpoint enforcement
3. **Smart Contract Validation**: On-chain verification

### Access Control
- **403 Forbidden**: Returned for insufficient tier access
- **Clear Error Messages**: Detailed tier requirement information
- **Audit Logging**: All access attempts logged for compliance

### Admin Authorization
- **MetaMask Integration**: Admin wallet connection required
- **Contract Authorization**: Only authorized asset managers can upgrade tiers
- **Transaction Logging**: All admin actions recorded on blockchain

## Usage Examples

### User Experience
1. User sees tier badge on pool card: "Tier 1 Required"
2. User attempts investment with Tier 0 access
3. System blocks investment and shows modal
4. Modal explains requirement and provides upgrade path
5. User can upgrade tier or explore other opportunities

### Admin Management
1. Admin connects MetaMask wallet
2. Navigates to Tier Management tab
3. Looks up user tier: `+201234567890` → `Tier 1`
4. Upgrades user to Tier 2 via smart contract
5. Updates pool requirements as needed

### Pool Configuration
1. Admin navigates to Pool Settings tab
2. Sets new pool tier requirement: `gold-vault` → `Tier 3`
3. System updates both storage and runtime configuration
4. Users immediately see updated requirements

## Benefits

### For Users
- **Clear Requirements**: Transparent tier system
- **Upgrade Guidance**: Clear path to access higher tiers
- **Legal Compliance**: Meets regulatory requirements
- **Better UX**: Helpful error messages and navigation

### For Admins
- **Direct Control**: Manage tiers from admin interface
- **Real-time Analytics**: View tier distribution and eligibility
- **Flexible Configuration**: Easily adjust pool requirements
- **Audit Trail**: Complete logging of all tier changes

### for Compliance
- **Regulatory Alignment**: Supports FRA/Reg S compliance
- **Identity Verification**: Progressive KYC/AML compliance
- **Access Restrictions**: Prevents unauthorized high-value investments
- **Audit Trail**: Complete record of access control decisions

## Future Enhancements

### Planned Features
- **Automatic Tier Detection**: Background tier checking
- **Tier Benefits**: Additional privileges for higher tiers
- **Bulk Tier Management**: Admin tools for user groups
- **Tier Analytics**: Advanced reporting and insights

### Technical Improvements
- **Caching Layer**: Reduce smart contract calls
- **Background Sync**: Periodic tier updates
- **Enhanced UI**: More intuitive tier management interface
- **API Rate Limiting**: Prevent abuse of tier checking endpoints

This tier-based access control system provides a robust, flexible, and compliant solution for managing investment access based on identity verification levels. 