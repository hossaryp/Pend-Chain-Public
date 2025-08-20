# Cypress E2E Tests for Pend Wallet

## Overview

This directory contains comprehensive end-to-end tests for the Pend Wallet application using Cypress. The tests verify critical user flows including navigation, investment processes, and selling positions.

## Test Files

### 1. `01-mypend-tab.cy.ts` - MyPend Tab Tests
Verifies that the mypend tab:
- ✅ Loads and shows profile section
- ✅ Displays total investment amount without deposit buttons
- ✅ Shows current positions/holdings
- ✅ Handles loading states gracefully
- ✅ Is responsive on mobile viewport

### 2. `02-explore-investment-flow.cy.ts` - Explore & Investment Flow
Tests the complete investment journey:
- ✅ Loads explore tab with investment opportunities
- ✅ Opens opportunity details via "View Details"
- ✅ Completes full investment flow via "Invest Now" button
- ✅ Validates investment amounts and payment methods
- ✅ Handles tier requirements and error states

### 3. `03-sell-position-flow.cy.ts` - Sell Position Flow
Verifies selling functionality:
- ✅ Shows sell buttons on asset cards
- ✅ Opens sell modal and completes full sell flow
- ✅ Updates total investment after successful sell
- ✅ Validates sell amounts against holdings
- ✅ Handles locked assets and error states

### 4. `04-routing-redirects.cy.ts` - Routing & Redirects
Tests navigation and URL handling:
- ✅ Redirects deprecated routes (/wallet, /profile, /pool)
- ✅ Handles unknown routes with fallback to /explore
- ✅ Preserves valid routes (opportunities, admin)
- ✅ Maintains app state during navigation

## Setup & Installation

### Prerequisites
- Node.js 18+
- npm or yarn
- Running development server (localhost:5173)
- Running API server (localhost:3001)

### Install Dependencies
```bash
cd wallet-ui
npm install
```

### Running Tests

#### Interactive Mode (Recommended for Development)
```bash
npm run cypress:open
# or
npm run test:e2e:open
```

#### Headless Mode (CI/CD)
```bash
npm run cypress:run
# or
npm run test:e2e
```

#### Headless with Video Recording
```bash
npm run cypress:run:headless
```

## Test Configuration

### Environment Variables
Tests use the following environment variables (configured in `cypress.config.ts`):
- `API_BASE_URL`: http://localhost:3001
- `CHAIN_ID`: 7777
- `TEST_PHONE`: +201234567890
- `TEST_OTP`: 123456

### Viewport Settings
- Default: 375x667 (iPhone SE size)
- Tests include responsive viewport testing

## Test Data & Mocking

### Mock Data Strategy
Tests use extensive API mocking to ensure:
- Consistent test data
- Fast execution
- Isolation from backend changes
- Reliable CI/CD execution

### Key Mocked APIs
- `GET /api/wallet/info/**` - Wallet balance and holdings
- `GET /api/opportunities` - Investment opportunities
- `POST /api/otp/send-otp` - OTP sending
- `POST /api/consent/verify-consent` - Consent verification
- `POST /api/investment/create` - Investment creation
- `POST /api/pool/harvest/redeem` - Asset selling

### Test User Setup
Tests automatically set up a test user with:
- Wallet address: `0x1234567890123456789012345678901234567890`
- Phone number: `+201234567890`
- Consent tier: 3
- Mock holdings: HVT and other assets

## Required Component Updates

To ensure tests work correctly, the following `data-testid` attributes should be added to components:

### WalletTab Component
```tsx
<div data-testid="mypend-tab">
  {/* existing content */}
</div>
```

### ProfileSection Component
```tsx
<div data-testid="profile-section">
  {/* existing content */}
</div>
```

### BottomNavBar Component
```tsx
<nav data-testid="bottom-nav">
  {/* existing nav items */}
</nav>
```

### ExploreCard Component
```tsx
<div data-testid="opportunity-card">
  {/* existing card content */}
</div>
```

### AssetCard Component
```tsx
<div data-testid="asset-card">
  {/* existing asset content */}
</div>
```

## Test Patterns & Best Practices

### 1. Setup & Teardown
- Each test file has a `beforeEach` hook that sets up the test environment
- Tests use localStorage to simulate an existing authenticated user
- API responses are mocked consistently

### 2. Waiting Strategies
- Tests wait for loading spinners to disappear
- API calls are intercepted and waited for explicitly
- Generous timeouts for complex flows

### 3. Error Handling
- Tests verify both success and error scenarios
- API errors are mocked to test error handling
- Loading states and edge cases are covered

### 4. Mobile-First Testing
- Default viewport is mobile (375x667)
- Tests include responsive behavior verification
- Touch interactions are properly handled

## Debugging Tests

### Interactive Debugging
1. Run `npm run cypress:open`
2. Select a test file
3. Use Cypress Test Runner's time travel debugging
4. Inspect DOM, network requests, and console logs

### Screenshots & Videos
- Screenshots are automatically captured on test failures
- Videos are recorded for all test runs
- Files are saved in `cypress/screenshots/` and `cypress/videos/`

### Common Issues
1. **Element not found**: Check if component has correct `data-testid`
2. **API timeout**: Verify mock API responses are set up correctly
3. **Navigation issues**: Ensure router setup matches test expectations

## CI/CD Integration

### GitHub Actions Example
```yaml
- name: Run E2E Tests
  run: |
    npm run dev &
    npm run cypress:run
  env:
    CYPRESS_baseUrl: http://localhost:5173
```

### Test Reports
- Cypress generates detailed test reports
- Screenshots and videos are available for failed tests
- Test results can be integrated with CI/CD dashboards

## Contributing

### Adding New Tests
1. Create test file in `cypress/e2e/`
2. Follow existing naming convention: `##-feature-name.cy.ts`
3. Include comprehensive test coverage for the feature
4. Add required `data-testid` attributes to components
5. Update this README with new test descriptions

### Test Maintenance
- Update mocked API responses when backend changes
- Keep test data consistent with actual application data
- Review and update tests when UI components change
- Ensure tests remain fast and reliable

## Troubleshooting

### Common Solutions
- **Tests failing locally**: Ensure dev server is running on port 5173
- **API mocks not working**: Check intercept patterns in test files
- **Element selectors failing**: Verify `data-testid` attributes are present
- **Timeout issues**: Increase timeout values in cypress.config.ts

### Getting Help
- Check Cypress documentation: https://docs.cypress.io/
- Review test patterns in existing test files
- Use Cypress Test Runner for interactive debugging 