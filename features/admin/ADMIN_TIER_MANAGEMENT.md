# Admin Panel Tier Management System

## Overview
The Admin Panel now includes comprehensive tier management functionality that allows authorized administrators to directly interact with smart contracts for user tier management and pool configuration.

## Features

### 1. Three-Tab Admin Interface

#### **Deploy Opportunities Tab**
- Original asset deployment functionality
- Investment opportunity creation
- Interest-only campaign deployment
- Smart contract interaction for asset factories

#### **Tier Management Tab** (New)
- **User Tier Lookup**: Query any user's current tier by phone number
- **Tier Upgrades**: Directly upgrade user tiers through smart contract interaction
- **Tier Analytics**: View user distribution across all tier levels
- **Smart Contract Integration**: Direct blockchain interaction with ConsentManager

#### **Pool Settings Tab** (New)
- **Dynamic Pool Configuration**: Set tier requirements for any pool
- **Real-time Updates**: Immediately update pool restrictions
- **Access Statistics**: View eligibility percentages for each tier
- **Persistent Storage**: Settings saved and synchronized across backend

### 2. Tier Management Capabilities

#### **User Tier Lookup**
```typescript
// Check user's current tier
GET /api/consent/tier
Body: { phoneNumber: "+201234567890" }
Response: { success: true, tier: 1 }
```

#### **Tier Upgrade Process**
1. Admin connects MetaMask wallet
2. Enters user phone number and target tier
3. System adds required consent actions to ConsentManager contract
4. Blockchain transaction confirms tier upgrade
5. User immediately gains new access level

#### **Consent Actions by Tier**
```
Tier 1: register_phone
Tier 2: register_phone, register_device  
Tier 3: register_phone, register_device, verify_biometric
Tier 4: register_phone, register_device, verify_biometric, submit_kyc
Tier 5: register_phone, register_device, verify_biometric, submit_kyc, verify_location
```

### 3. Pool Configuration Management

#### **Dynamic Requirements**
- Set tier requirements for any pool via admin interface
- No code changes needed to add new pools
- Immediate synchronization across frontend and backend

#### **Configuration Storage**
- Persistent storage in `admin-pool-tiers.json`
- Automatic synchronization with `pool.js` runtime configuration
- Backup and restore capabilities

#### **Access Statistics**
```
Harvest Pool (Tier 1): 140 users eligible (85% of registered)
Premium Pools (Tier 2+): 51 users eligible (31% of registered)
```

## Technical Implementation

### Backend Endpoints

#### Tier Management
```javascript
GET /api/admin/pool-tiers          // Get pool tier requirements
POST /api/admin/pool-tiers         // Update pool tier requirement  
GET /api/admin/tier-analytics      // Get tier distribution
POST /api/admin/upgrade-user-tier  // Admin tier upgrade
GET /api/admin/user-tiers          // Get user tier information
```

#### Pool Configuration
```javascript
// Update pool tier requirement
POST /api/admin/pool-tiers
{
  "poolId": "solar-farm-aswan",
  "requiredTier": 2
}
```

### Frontend Components

#### Core Components
- `PendAdminPanel.tsx` - Main admin interface with three tabs
- `TierManagementForm` - User tier lookup and upgrade controls
- `PoolSettingsForm` - Pool tier requirement configuration
- `TierAnalytics` - Visual tier distribution display

#### State Management
```typescript
const [activeTab, setActiveTab] = useState<'deploy' | 'tiers' | 'pools'>('deploy');
const [tierManagementForm, setTierManagementForm] = useState({
  phoneNumber: '',
  selectedTier: '1',
  poolId: '',
  requiredTier: '1'
});
```

### Smart Contract Integration

#### ConsentManager Interaction
```solidity
// Get user's current tier
function getConsentTier(bytes32 identityHash) external view returns (uint8)

// Store consent action (admin upgrade)
function storeConsent(bytes32 identityHash, bytes32 consentHash, string action) external
```

#### Authorization
- Only authorized asset managers can perform tier upgrades
- MetaMask wallet connection required
- Transaction confirmation for all blockchain operations

## Security & Authorization

### Admin Access Control
- **MetaMask Integration**: Admin wallet connection required
- **Contract Authorization**: Only authorized asset managers can upgrade tiers
- **Transaction Logging**: All admin actions recorded on blockchain

### Multi-Layer Validation
1. **Frontend Validation**: UI controls and user guidance
2. **Backend Validation**: API endpoint authorization
3. **Smart Contract Validation**: On-chain permission checks

### Audit Trail
- Complete logging of all tier changes
- Blockchain transaction records
- Access attempt logging for compliance

## Usage Examples

### Check User Tier
1. Navigate to "Tier Management" tab
2. Enter phone number: `+201234567890`
3. Click "Check Tier"
4. System displays: "User tier: 1"

### Upgrade User Tier
1. Enter phone number and select target tier
2. Click "Upgrade Tier"
3. MetaMask prompts for transaction confirmation
4. System adds required consent actions to blockchain
5. Success notification: "User tier upgraded to 2"

### Configure Pool Requirements
1. Navigate to "Pool Settings" tab
2. Enter pool ID: `gold-vault`
3. Select required tier: `Tier 2`
4. Click "Update Requirement"
5. System updates storage and runtime configuration

## Benefits

### For Administrators
- **Direct Control**: Manage tiers without code changes
- **Real-time Updates**: Immediate effect of configuration changes
- **Complete Visibility**: View tier distribution and access statistics
- **Audit Compliance**: Full logging of all administrative actions

### For Users
- **Immediate Access**: Tier upgrades take effect immediately
- **Transparent Requirements**: Clear visibility of tier requirements
- **Progressive Access**: Logical progression through tier levels

### For Platform
- **Regulatory Compliance**: Supports KYC/AML requirements
- **Flexible Configuration**: Easy addition of new pools and requirements
- **Scalable Management**: Handles large user bases efficiently

## Configuration Files

### Pool Tier Requirements
```json
// admin-pool-tiers.json
{
  "harvest-pool": 1,
  "solar-farm-aswan": 2,
  "gold-vault": 2,
  "real-estate-cairo": 2
}
```

### Analytics Data
```json
// Tier distribution
{
  "tierDistribution": {
    "0": 156,
    "1": 89, 
    "2": 34,
    "3": 12,
    "4": 5
  },
  "totalUsers": 296
}
```

## Future Enhancements

### Planned Features
- **Bulk Tier Management**: Process multiple users simultaneously
- **Automated Tier Rules**: Automatic upgrades based on criteria
- **Enhanced Analytics**: Detailed reporting and insights
- **Tier Benefits**: Additional privileges for higher tiers

### Technical Improvements
- **Caching Layer**: Reduce smart contract calls
- **Background Sync**: Periodic tier updates
- **Enhanced UI**: More intuitive management interface
- **API Rate Limiting**: Prevent abuse of tier checking

This admin tier management system provides comprehensive control over user access levels while maintaining security, compliance, and ease of use. 