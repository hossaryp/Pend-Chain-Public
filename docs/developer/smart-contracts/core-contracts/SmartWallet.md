# Smart Wallet Contract Documentation

## Overview

The Smart Wallet contract is a key component of the Pend ecosystem, providing secure and compliant wallet functionality with identity-based access control.

## Contract Address

```
0x0f84B067f6C71861E705aA45233854F5Db33926d
```

## Key Features

### 1. Identity-Based Access
- Phone number-based identity system
- Tiered verification levels
- Consent-based transaction execution

### 2. Transaction Management
- Multi-step transaction execution
- Action-specific consent verification
- Secure transaction signing

### 3. Security Features
- Identity-based access control
- Transaction validation
- Rate limiting
- Emergency pause

## Contract Interface

### Events

```solidity
event WalletCreated(
    bytes32 indexed ownerIdentityHash,
    address indexed wallet
);

event ExecutedByIdentity(
    bytes32 indexed ownerIdentityHash,
    address indexed target,
    bytes data,
    bytes result
);
```

### Functions

#### Wallet Creation
```solidity
function createWallet(
    bytes32 ownerIdentityHash
) external returns (address);

function createWallet(
    bytes32 ownerIdentityHash,
    bytes rawInput,
    string phoneNumber,
    string action
) external returns (address);
```

#### Transaction Execution
```solidity
function executeTransaction(
    bytes32 identityHash,
    string action,
    address target,
    bytes data
) external returns (bytes);
```

#### Queries
```solidity
function walletOfIdentity(
    bytes32 identityHash
) external view returns (address);
```

## Integration Guide

### 1. Wallet Creation

```typescript
// Create wallet with basic identity
const tx = await factory.createWallet(identityHash);
const receipt = await tx.wait();

// Create wallet with consent verification
const tx = await factory.createWallet(
    identityHash,
    rawOtpBytes,
    phoneNumber,
    "wallet_creation"
);
```

### 2. Transaction Execution

```typescript
// Execute transaction
const tx = await wallet.executeTransaction(
    identityHash,
    "send_tokens",
    targetContract,
    encodedData
);
```

### 3. Wallet Lookup

```typescript
// Get wallet address
const walletAddress = await factory.walletOfIdentity(identityHash);
```

## Security Considerations

### 1. Identity Verification
- Phone numbers must be verified via OTP
- Identity hashes must be unique
- Consent must be verified for sensitive actions

### 2. Transaction Security
- All transactions require identity verification
- Actions must be explicitly defined
- Target contracts must be whitelisted

### 3. Rate Limiting
- Maximum transactions per block
- Cooldown periods for sensitive actions
- Emergency pause functionality

## Best Practices

### 1. Wallet Creation
- Always verify phone numbers
- Store identity hashes securely
- Implement proper error handling

### 2. Transaction Execution
- Validate all inputs
- Check consent status
- Monitor transaction status

### 3. Security
- Regular security audits
- Emergency response plan
- Monitoring and alerts

## Error Handling

### Common Errors

1. **Identity Not Found**
```solidity
error IdentityNotFound(bytes32 identityHash);
```

2. **Invalid Consent**
```solidity
error InvalidConsent(bytes32 identityHash, string action);
```

3. **Transaction Failed**
```solidity
error TransactionFailed(address target, bytes data);
```

### Error Recovery

1. **Identity Issues**
- Verify phone number
- Check consent status
- Retry with proper verification

2. **Transaction Issues**
- Validate inputs
- Check gas limits
- Verify contract state

## Testing

### Unit Tests

```typescript
describe("SmartWallet", () => {
    it("creates wallet with identity", async () => {
        const tx = await factory.createWallet(identityHash);
        const receipt = await tx.wait();
        expect(receipt.status).to.equal(1);
    });

    it("executes transaction with consent", async () => {
        const tx = await wallet.executeTransaction(
            identityHash,
            "send_tokens",
            target,
            data
        );
        const receipt = await tx.wait();
        expect(receipt.status).to.equal(1);
    });
});
```

### Integration Tests

```typescript
describe("SmartWallet Integration", () => {
    it("handles complete wallet lifecycle", async () => {
        // Create wallet
        const tx = await factory.createWallet(identityHash);
        const receipt = await tx.wait();
        
        // Execute transaction
        const wallet = await factory.walletOfIdentity(identityHash);
        const tx2 = await wallet.executeTransaction(
            identityHash,
            "send_tokens",
            target,
            data
        );
        const receipt2 = await tx2.wait();
        
        expect(receipt.status).to.equal(1);
        expect(receipt2.status).to.equal(1);
    });
});
```

## Monitoring

### Key Metrics

1. **Wallet Creation**
- Success rate
- Average gas cost
- Creation time

2. **Transaction Execution**
- Success rate
- Gas usage
- Execution time

3. **Security**
- Failed attempts
- Rate limit hits
- Emergency pauses

### Logging

```typescript
// Log wallet creation
logger.info("Wallet created", {
    identityHash,
    walletAddress,
    txHash
});

// Log transaction execution
logger.info("Transaction executed", {
    identityHash,
    action,
    target,
    txHash
});
```

## Deployment

### Prerequisites

1. **Environment Setup**
```bash
# Required environment variables
VALIDATOR_PRIVATE_KEY=0x...
RPC_URL=http://127.0.0.1:8545
```

2. **Contract Dependencies**
- ConsentManager
- IdentityRegistry
- Token contracts

### Deployment Steps

1. **Compile Contracts**
```bash
npx hardhat compile
```

2. **Deploy Factory**
```bash
npx hardhat run scripts/deploy.js
```

3. **Verify Contracts**
```bash
npx hardhat verify --network mainnet <CONTRACT_ADDRESS>
```

## Maintenance

### Regular Tasks

1. **Security Updates**
- Monitor for vulnerabilities
- Update dependencies
- Apply security patches

2. **Performance Optimization**
- Gas optimization
- Code refactoring
- Cache management

3. **Monitoring**
- Check error rates
- Monitor gas usage
- Track transaction success

## Support

For technical support or questions:
1. Open an issue on GitHub
2. Contact the development team
3. Check the documentation

## License

MIT License - see LICENSE file for details. 