# InvestmentService Implementation

## Overview

The InvestmentService module abstracts common deposit and sell API calls with consent checks, providing a centralized service for investment-related operations across the application. This eliminates code duplication and provides consistent error handling and validation.

## Service Architecture

### Core Functions

1. **`createDeposit()`** - Handles complete deposit flow with investment tracking
2. **`sellDeposit()`** - Handles complete asset redemption flow  
3. **`getInvestmentSummary()`** - Retrieves user's portfolio data and metrics

### Key Features

- **Centralized Consent Management**: All OTP and consent verification flows
- **Multi-Currency Support**: EGP, USD, USDC, HVT, ETH with appropriate validation
- **Asset-Specific Handling**: Different redemption paths for HVT vs generic assets
- **Live NAV Fetching**: Real-time pricing for accurate valuations
- **Investment Tracking**: Optional opportunity-based investment recording
- **Comprehensive Validation**: Amount limits, balance checks, lock period enforcement
- **Error Handling**: Consistent error messaging and recovery flows

## API Structure

### InvestmentService Class Methods

#### Public Methods

```typescript
// Deposit Operations
static async createDeposit(request: DepositRequest, otp: string, onProgress?: (step: string) => void): Promise<ApiResponse>
static async sendDepositOtp(phoneNumber: string): Promise<void>

// Sell Operations  
static async sellDeposit(request: SellRequest, otp: string, onProgress?: (step: string) => void): Promise<ApiResponse>
static async sendSellOtp(phoneNumber: string): Promise<void>

// Portfolio Operations
static async getInvestmentSummary(walletAddress: string, phoneNumber?: string): Promise<InvestmentSummary>
static async getCurrentNAV(holding: Holding): Promise<number>

// Validation Utilities
static validateDepositAmount(amount: string, currency: Currency): { isValid: boolean; error?: string }
static validateSellAmount(amount: string, holding: Holding): { isValid: boolean; error?: string }
static isAssetLocked(holding: Holding): boolean
static formatCurrency(amount: string | number, currency: Currency): string
```

#### Private Methods

```typescript
// Internal API Operations
private static async sendOtp(phoneNumber: string, action: string): Promise<void>
private static async verifyConsent(otp: string, phoneNumber: string, action: string): Promise<boolean>
private static async executeDeposit(request: DepositRequest): Promise<ApiResponse>
private static async executeSell(request: SellRequest, otp: string): Promise<ApiResponse>
private static async recordInvestment(...): Promise<void>
```

## Type Definitions

### Core Interfaces

```typescript
interface DepositRequest {
  amount: string;
  currency: Currency;
  paymentMethod: PaymentMethod;
  phoneNumber: string;
  walletAddress: string;
  opportunityId?: string; // For investment tracking
}

interface SellRequest {
  holding: Holding;
  amount: string;
  phoneNumber: string;
  walletAddress: string;
}

interface InvestmentSummary {
  totalValue: number;
  totalGain: number;
  gainPercentage: number;
  holdings: Holding[];
  recentTransactions: any[];
}

interface ApiResponse {
  success: boolean;
  data?: any;
  error?: string;
  txHash?: string;
  message?: string;
}
```

## Implementation Details

### Deposit Flow (`createDeposit`)

1. **OTP Verification**: Verifies consent using `invest_in_opportunity` action
2. **Currency Routing**: Routes to appropriate endpoint based on currency type:
   - EGP → `/api/deposit-egp`
   - USD → `/api/deposit-usd` 
   - USDC → `/api/deposit-usdc`
3. **Investment Recording**: Optional tracking in opportunity system via `/api/investment/record`
4. **Progress Callbacks**: Real-time status updates for UI

### Sell Flow (`sellDeposit`)

1. **OTP Verification**: Verifies consent using `redeem_asset_tokens` action
2. **Asset-Specific Routing**:
   - HVT tokens → `/api/pool/harvest/redeem` (existing harvest pool endpoint)
   - Other assets → `/api/assets/redeem` (new generic asset endpoint)
3. **Lock Period Enforcement**: Prevents redemption of locked assets
4. **Balance Validation**: Ensures sufficient holdings before redemption

### Portfolio Management (`getInvestmentSummary`)

1. **Holdings Aggregation**: Collects all user asset positions
2. **Live NAV Updates**: Fetches current pricing for accurate valuations
3. **Metrics Calculation**: Computes total value, gains, ROI percentages
4. **Transaction History**: Recent investment activities

### NAV Fetching (`getCurrentNAV`)

- **HVT Assets**: Live data from `/api/explorer/pool` (dynamicNAV field)
- **Other Assets**: Uses stored NAV from holding data
- **Fallback**: Defaults to 1.0 if fetching fails

## Validation Logic

### Deposit Amount Validation

```typescript
const limits: Record<Currency, { min: number; max: number }> = {
  EGP: { min: 100, max: 100000 },
  USD: { min: 10, max: 10000 },
  USDC: { min: 10, max: 10000 },
  HVT: { min: 1, max: 100000 },
  ETH: { min: 0.001, max: 100 }
};
```

### Sell Amount Validation

- Positive amount check
- Balance sufficiency verification
- Lock period enforcement

### Lock Period Logic

```typescript
static isAssetLocked(holding: Holding): boolean {
  return Boolean(holding.lockupEndTimestamp && holding.lockupEndTimestamp > Date.now() / 1000);
}
```

## Refactored Components

### DepositOptionsModal

**Before**: Direct API calls, manual consent flow, currency-specific handling
```typescript
// Old approach - duplicated across components
const response = await fetch(`${config.API_BASE_URL}/api/otp/send-otp`, {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ phone: phoneNumber, action: 'invest_in_opportunity' })
});
```

**After**: Centralized service calls
```typescript
// New approach - clean abstraction
await InvestmentService.sendDepositOtp(phoneNumber);
const result = await InvestmentService.createDeposit(depositRequest, otp, onProgress);
```

### SellDepositModal

**Before**: Manual consent verification, asset-specific routing logic
```typescript
// Old approach - complex conditional logic
if (holding.tokenSymbol === 'HVT') {
  redemptionResponse = await fetch(`${config.API_BASE_URL}/api/pool/harvest/redeem`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ hvtAmount: sellAmount, otp, phone: phoneNumber, poolId: 'harvest-pool' })
  });
} else {
  // Generic asset redemption logic...
}
```

**After**: Service abstraction handles routing
```typescript
// New approach - service handles complexity
const sellRequest: SellRequest = { holding, amount: sellAmount, phoneNumber, walletAddress };
const result = await InvestmentService.sellDeposit(sellRequest, otp, onProgress);
```

### WalletTab

**Before**: Mock data, manual state management
```typescript
// Old approach - static mock data
const mockHoldings: Holding[] = [...];
useEffect(() => {
  const timer = setTimeout(() => {
    setHoldings(mockHoldings);
    setIsLoading(false);
  }, 1000);
}, []);
```

**After**: Service-based data fetching
```typescript
// New approach - service integration
const fetchInvestmentSummary = async () => {
  const summary = await InvestmentService.getInvestmentSummary(walletAddress, phoneNumber);
  setInvestmentSummary(summary);
};
```

## Error Handling

### Consistent Error Patterns

- **Network Errors**: Automatic retry suggestions
- **Validation Errors**: Clear user-friendly messages
- **Consent Errors**: Specific OTP/verification guidance
- **Business Logic Errors**: Contextual explanations (e.g., insufficient balance, locked assets)

### Error Recovery

- **OTP Failures**: Return to OTP step for retry
- **Network Issues**: Provide retry buttons
- **Validation Errors**: Clear field-specific messaging

## Security Features

### Consent Verification

- **Action-Specific**: Different actions for deposits vs redemptions
- **Phone Number Verification**: Links OTP to registered phone
- **Blockchain Consent**: On-chain consent verification before transactions

### Lock Period Enforcement

- **Client-Side**: UI prevents locked asset sales
- **Server-Side**: Backend validates lock periods
- **Real-Time**: Dynamic lock status checking

## Benefits Achieved

### Code Quality

- **DRY Principle**: Eliminated duplicate API calling code
- **Single Responsibility**: Each component focuses on UI, service handles business logic
- **Type Safety**: Comprehensive TypeScript interfaces
- **Error Handling**: Consistent patterns across all investment operations

### Maintainability

- **Centralized Logic**: All investment flows in one service
- **Easy Testing**: Service methods can be unit tested independently
- **Future Extensions**: New investment types easily added to service
- **API Changes**: Only service needs updates, not multiple components

### User Experience

- **Consistent Flows**: Same UX patterns for all investment operations
- **Progress Feedback**: Real-time status updates during operations
- **Error Recovery**: Clear paths to resolve issues
- **Performance**: Parallel operations where possible

## Future Enhancements

### Planned Features

1. **Offline Support**: Cache investment data for offline viewing
2. **Advanced Analytics**: Portfolio performance tracking, benchmarking
3. **Automated Rebalancing**: Smart portfolio management features
4. **Multi-Wallet Support**: Handle multiple wallet addresses per user
5. **Push Notifications**: Real-time investment updates

### API Improvements

1. **Batch Operations**: Multiple investments in single transaction
2. **Scheduled Investments**: Recurring investment automation
3. **Cross-Chain Support**: Multi-blockchain asset management
4. **Advanced Orders**: Stop-loss, take-profit functionality

## Testing Strategy

### Unit Tests

- Service method validation
- Error handling scenarios
- Currency conversion logic
- Lock period calculations

### Integration Tests

- Full deposit/sell flows
- OTP verification processes
- Portfolio data accuracy
- Cross-component communication

### E2E Tests

- Complete user journeys
- Error recovery flows
- Multi-device consistency
- Performance benchmarks

This InvestmentService implementation provides a robust, scalable foundation for all investment-related operations in the application, with clean abstractions that improve both developer experience and code maintainability. 