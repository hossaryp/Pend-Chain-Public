# InvestmentAgreement Contract Documentation

## Overview

The InvestmentAgreement contract is a core component of the Pend ecosystem, designed to store investment agreement terms on-chain and record user consent signatures. It provides immutable proof of agreement acceptance for regulatory compliance (FRA + Reg S) and ensures all investment transactions are backed by verifiable user consent.

## Contract Address

```
// Address to be updated after deployment
TBD
```

## Key Features

### 1. Agreement Management
- Version-controlled investment agreements
- On-chain storage of agreement terms
- IPFS hash support for full document storage
- Active/inactive agreement status tracking

### 2. Signature Recording
- Cryptographically signed user consent
- Phone number and wallet address verification
- Investment amount tracking at signature time
- IP address logging for audit trail

### 3. Regulatory Compliance
- Immutable signature records
- Timestamp verification
- OTP-based signature verification
- Comprehensive audit trail

### 4. Multi-Pool Support
- Pool-specific investment agreements
- Separate signature tracking per pool
- Pool-level statistics and analytics

## Contract Interface

### Events

```solidity
event AgreementCreated(
    string indexed poolId,
    uint256 indexed version,
    uint256 timestamp
);

event AgreementSigned(
    string indexed poolId,
    bytes32 indexed userPhoneHash,
    address indexed userWallet,
    uint256 investmentAmount,
    uint256 agreementVersion,
    uint256 timestamp
);

event SignatureVerified(
    string indexed poolId,
    bytes32 indexed userPhoneHash,
    uint256 timestamp
);
```

### Structs

```solidity
struct Agreement {
    string agreementText;           // Full agreement text stored on-chain
    string agreementHash;           // IPFS hash for full document (optional)
    uint256 version;                // Agreement version number
    uint256 createdAt;              // Timestamp when agreement was created
    bool active;                    // Whether this agreement version is active
}

struct UserSignature {
    address userWallet;             // User's wallet address
    string phoneNumber;             // User's phone number (hashed for privacy)
    uint256 investmentAmount;       // Investment amount at time of signature
    uint256 signedAt;               // Timestamp when user signed
    uint256 agreementVersion;       // Version of agreement signed
    string ipAddress;               // IP address (hashed for audit trail)
    bool verified;                  // Whether signature was verified via OTP
}
```

### Functions

#### Admin Functions
```solidity
function createAgreement(
    string calldata poolId,
    string calldata agreementText,
    string calldata agreementHash
) external onlyOwner;

function updateValidator(address newValidator) external onlyOwner;

function transferOwnership(address newOwner) external onlyOwner;
```

#### Signature Functions
```solidity
function signAgreement(
    string calldata poolId,
    string calldata phoneNumber,
    address userWallet,
    uint256 investmentAmount,
    string calldata ipAddress
) external onlyValidator;

function verifySignature(
    string calldata poolId,
    string calldata phoneNumber
) external onlyValidator;
```

#### View Functions
```solidity
function getCurrentAgreement(string calldata poolId) 
    external view returns (Agreement memory);

function getAgreement(string calldata poolId, uint256 version)
    external view returns (Agreement memory);

function hasUserSigned(string calldata poolId, string calldata phoneNumber)
    external view returns (bool);

function getUserSignatures(string calldata poolId, string calldata phoneNumber)
    external view returns (UserSignature[] memory);

function getSignatureCount(string calldata poolId) external view returns (uint256);

function getAgreementText(string calldata poolId) external view returns (string memory);
```

## Integration Guide

### 1. Creating Investment Agreements

```typescript
// Create new investment agreement for a pool
await investmentAgreement.createAgreement(
    "harvest-pool-v1",
    "Full legal agreement text...",
    "QmHash123..." // IPFS hash (optional)
);
```

### 2. Recording User Signatures

```typescript
// Record user signature (called by validator)
await investmentAgreement.signAgreement(
    "harvest-pool-v1",
    "+1234567890",
    userWalletAddress,
    ethers.utils.parseEther("1000"), // Investment amount
    "192.168.1.1" // IP address
);
```

### 3. Verifying Signatures

```typescript
// Verify signature after OTP confirmation
await investmentAgreement.verifySignature(
    "harvest-pool-v1",
    "+1234567890"
);

// Check if user has signed
const hasSigned = await investmentAgreement.hasUserSigned(
    "harvest-pool-v1",
    "+1234567890"
);
```

### 4. Retrieving Agreement Data

```typescript
// Get current agreement
const agreement = await investmentAgreement.getCurrentAgreement("harvest-pool-v1");

// Get agreement text for display
const agreementText = await investmentAgreement.getAgreementText("harvest-pool-v1");

// Get user signature history
const signatures = await investmentAgreement.getUserSignatures(
    "harvest-pool-v1",
    "+1234567890"
);
```

## Security Considerations

### 1. Privacy Protection
- Phone numbers are hashed before storage
- IP addresses are hashed for audit trail
- Personal data is never stored in plain text

### 2. Access Control
- Only owner can create agreements
- Only validator can record signatures
- Validator role is updateable by owner

### 3. Signature Integrity
- Cryptographic hashing ensures data integrity
- Timestamps prevent replay attacks
- OTP verification prevents unauthorized signatures

### 4. Agreement Versioning
- Previous versions are automatically deactivated
- Version history is maintained for audit
- Users must sign current version only

## Best Practices

### 1. Agreement Management
- Always include comprehensive legal text
- Use IPFS for large documents
- Version agreements for legal updates
- Maintain clear audit trail

### 2. Signature Verification
- Always verify signatures via OTP
- Check user eligibility before signing
- Validate investment amounts
- Log all signature attempts

### 3. Privacy Compliance
- Hash sensitive data before storage
- Minimize data collection
- Implement data retention policies
- Follow GDPR/privacy regulations

## Error Handling

### Custom Errors

```solidity
error NotOwner();
error NotValidator();
error AgreementNotFound();
error InactiveAgreement();
error InvalidInput();
error AlreadySigned();
```

### Error Recovery

1. **Agreement Issues**
   - Verify pool ID exists
   - Check agreement is active
   - Validate input parameters

2. **Signature Issues**
   - Check user hasn't already signed
   - Verify agreement version
   - Validate user eligibility

3. **Access Control Issues**
   - Verify caller permissions
   - Check contract ownership
   - Validate validator role

## Frontend Integration

### React Component Example

```typescript
import { useInvestmentAgreement } from '../hooks/useInvestmentAgreement';

const AgreementModal = ({ poolId, onAccept }) => {
    const { agreement, signAgreement, isLoading } = useInvestmentAgreement();
    
    const handleAccept = async () => {
        try {
            await signAgreement(poolId, phoneNumber, investmentAmount);
            onAccept();
        } catch (error) {
            console.error('Signature failed:', error);
        }
    };
    
    return (
        <div className="agreement-modal">
            <h2>Investment Agreement</h2>
            <div className="agreement-text">
                {agreement?.agreementText}
            </div>
            <button onClick={handleAccept} disabled={isLoading}>
                Accept Agreement
            </button>
        </div>
    );
};
```

### Service Layer Example

```typescript
export class InvestmentAgreementService {
    async getUserAgreementStatus(poolId: string, phoneNumber: string) {
        return await this.contract.hasUserSigned(poolId, phoneNumber);
    }
    
    async getAgreementForDisplay(poolId: string) {
        return await this.contract.getCurrentAgreement(poolId);
    }
    
    async recordSignature(poolId: string, userData: UserSignatureData) {
        return await this.contract.signAgreement(
            poolId,
            userData.phoneNumber,
            userData.walletAddress,
            userData.investmentAmount,
            userData.ipAddress
        );
    }
}
```

## Testing

### Unit Tests

```typescript
describe("InvestmentAgreement", () => {
    it("creates and retrieves agreement", async () => {
        await investmentAgreement.createAgreement(
            "test-pool",
            "Test agreement text",
            "QmTestHash"
        );
        
        const agreement = await investmentAgreement.getCurrentAgreement("test-pool");
        expect(agreement.agreementText).to.equal("Test agreement text");
        expect(agreement.version).to.equal(1);
        expect(agreement.active).to.be.true;
    });
    
    it("records and verifies signatures", async () => {
        await investmentAgreement.signAgreement(
            "test-pool",
            "+1234567890",
            userAddress,
            ethers.utils.parseEther("1000"),
            "192.168.1.1"
        );
        
        await investmentAgreement.verifySignature(
            "test-pool",
            "+1234567890"
        );
        
        const hasSigned = await investmentAgreement.hasUserSigned(
            "test-pool",
            "+1234567890"
        );
        expect(hasSigned).to.be.true;
    });
});
```

### Integration Tests

```typescript
describe("InvestmentAgreement Integration", () => {
    it("handles complete agreement flow", async () => {
        // Create agreement
        await investmentAgreement.createAgreement(
            "integration-pool",
            "Full agreement text",
            "QmIntegrationHash"
        );
        
        // Sign agreement
        await investmentAgreement.signAgreement(
            "integration-pool",
            "+1234567890",
            userAddress,
            ethers.utils.parseEther("1000"),
            "192.168.1.1"
        );
        
        // Verify signature
        await investmentAgreement.verifySignature(
            "integration-pool",
            "+1234567890"
        );
        
        // Check final state
        const signatures = await investmentAgreement.getUserSignatures(
            "integration-pool",
            "+1234567890"
        );
        expect(signatures.length).to.equal(1);
        expect(signatures[0].verified).to.be.true;
    });
});
```

## Monitoring

### Key Metrics

1. **Agreement Management**
   - Total agreements created
   - Active agreements count
   - Version distribution

2. **Signature Activity**
   - Signatures per pool
   - Verification success rate
   - Average signature processing time

3. **Compliance Metrics**
   - Signature coverage percentage
   - Agreement version adoption
   - Audit trail completeness

### Logging

```typescript
// Log agreement creation
logger.info("Agreement created", {
    poolId,
    version,
    timestamp: new Date().toISOString()
});

// Log signature recording
logger.info("Signature recorded", {
    poolId,
    userPhoneHash: keccak256(phoneNumber),
    investmentAmount,
    timestamp: new Date().toISOString()
});
```

## Deployment

### Prerequisites

1. **Environment Setup**
```bash
# Required environment variables
VALIDATOR_PRIVATE_KEY=0x...
OWNER_PRIVATE_KEY=0x...
RPC_URL=http://127.0.0.1:8545
```

2. **Dependencies**
```bash
npm install @openzeppelin/contracts
```

### Deployment Steps

1. **Compile Contract**
```bash
npx hardhat compile
```

2. **Deploy Contract**
```bash
npx hardhat run scripts/deploy-investment-agreement.js --network mainnet
```

3. **Verify Contract**
```bash
npx hardhat verify --network mainnet <CONTRACT_ADDRESS> <VALIDATOR_ADDRESS>
```

### Deployment Script

```javascript
async function main() {
    const [deployer] = await ethers.getSigners();
    const validatorAddress = process.env.VALIDATOR_ADDRESS;
    
    const InvestmentAgreement = await ethers.getContractFactory("InvestmentAgreement");
    const investmentAgreement = await InvestmentAgreement.deploy(validatorAddress);
    
    await investmentAgreement.deployed();
    
    console.log("InvestmentAgreement deployed to:", investmentAgreement.address);
}
```

## Maintenance

### Regular Tasks

1. **Agreement Updates**
   - Monitor regulatory changes
   - Update agreement text as needed
   - Maintain version history

2. **Signature Monitoring**
   - Check verification rates
   - Monitor signature patterns
   - Identify failed signatures

3. **Security Audits**
   - Regular code audits
   - Penetration testing
   - Compliance reviews

### Troubleshooting

1. **Signature Issues**
   - Check validator permissions
   - Verify agreement status
   - Validate input data

2. **Agreement Issues**
   - Verify pool ID format
   - Check agreement version
   - Validate text content

## Support

For technical support or questions:
1. Check the troubleshooting section
2. Review the integration examples
3. Contact the development team
4. Open an issue on GitHub

## License

MIT License - see LICENSE file for details. 