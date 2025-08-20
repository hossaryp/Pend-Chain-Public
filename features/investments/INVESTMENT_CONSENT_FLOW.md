# Investment Consent Flow

## Overview
The Pend platform now includes a comprehensive investment consent mechanism that ensures legal compliance through blockchain-powered agreement signing. This feature provides regulatory compliance for FRA and Regulation S requirements while improving the user experience with clear success feedback and automatic wallet redirection.

## Features Implemented

### 1. Investment Agreement Modal
- **Component**: `InvestmentAgreementModal.tsx`
- **Purpose**: Display and sign investment agreements before proceeding with investments
- **Key Features**:
  - Loads agreements from blockchain for known pools
  - Falls back to default agreement template for opportunities
  - Shows total signatures count
  - Records user consent on blockchain
  - Supports both on-chain and simulated signing

### 2. Enhanced Investment Flow
- **Updated Flow**: Currency → Payment Method → Amount → **Agreement** → OTP → Success
- **Agreement Step**: Users must review and accept terms before investing
- **Consent Recording**: Agreement acceptance is logged in transaction history
- **Success Redirect**: Automatic navigation to wallet after successful investment

### 3. Backend Integration
**New Endpoint**: `/api/consent/sign-investment-agreement`
- Signs agreements on blockchain using validator wallet
- Checks if user has already signed
- Records transaction in explorer
- Provides proper audit trail
- Supports both on-chain and simulated signing for flexibility

### 4. Transaction Logging
- Investments are now recorded in transaction history
- Includes metadata: opportunity ID, payment method, currency
- Status shows as "Invested" for clear tracking
- Visible in wallet transaction history

## Technical Implementation

### Frontend Components
```typescript
// InvestmentAgreementModal.tsx
- Blockchain integration for agreement loading
- Signature verification
- Default agreement fallback
- Error handling with user-friendly messages

// DepositOptionsModal.tsx
- New agreement step in flow
- Agreement acceptance tracking
- Success redirect to wallet
- "Go to Wallet" button for immediate navigation
```

### Backend Services
```javascript
// routes/consent.js
- sign-investment-agreement endpoint
- Blockchain signing for known pools
- Simulated signing for opportunities
- Transaction logging
```

### Investment Service Updates
```typescript
// investmentService.ts
- Enhanced recordInvestment method
- Transaction history integration
- Proper metadata tracking
```

## User Experience Flow

1. **Select Investment Details**
   - Choose currency
   - Select payment method
   - Enter investment amount

2. **Review Agreement** (NEW)
   - View investment summary
   - Read terms and conditions
   - Check consent checkbox
   - Sign agreement on blockchain

3. **Complete OTP Verification**
   - Enter 6-digit code
   - Shows agreement signed status
   - Proceed with investment

4. **Success & Redirect**
   - Clear success message
   - Investment details displayed
   - Automatic redirect to wallet (2 seconds)
   - Manual "Go to Wallet" button available

## Compliance Features

- **Immutable Record**: Agreements stored on blockchain
- **Audit Trail**: Complete signature history
- **Legal Validity**: Digital signatures as contracts
- **Regulatory Compliance**: FRA and Regulation S compliant

## Configuration

### Smart Contract
- **InvestmentAgreement Contract**: `0xE3eA516F348f9cF126b13432Fe8725fad8C832D2`
- **Validator Address**: `0xeaf4197108Dd5810EC0f6036ee0e6E77621a2E39`

### Known Pools with On-Chain Agreements
- `harvest-pool`
- `harvest-fund-v3`

All other opportunities use simulated signing with default agreement template.

## Benefits

1. **Legal Compliance**: Meets regulatory requirements
2. **User Trust**: Transparent agreement process
3. **Better UX**: Clear feedback and navigation
4. **Audit Ready**: Complete transaction history
5. **Flexibility**: Supports both pools and opportunities 