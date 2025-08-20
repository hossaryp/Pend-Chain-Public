# FRA-Compliant PIN Authentication System

## Overview

The FRA-Compliant PIN Authentication System implements a secure 6-digit PIN setup and verification system that meets the Financial Regulatory Authority (FRA) requirements for digital identity authentication under Section Two of the decree.

## FRA Compliance Features

### Knowledge Factor Implementation
- **6-digit numeric PIN**: Meets FRA Knowledge Factor requirements
- **Argon2id hashing**: FRA-approved cryptographic algorithm with high security parameters
- **Weak PIN detection**: Prevents common patterns (111111, 123456, repeated sequences)
- **Multi-factor verification**: PIN (Knowledge) + OTP (Possession) + Device (Presence)

### Digital Identity Ledger
- **Comprehensive audit trail**: All PIN operations logged with timestamps
- **Device metadata collection**: IP address, user agent, device fingerprinting
- **Regulatory compliance markers**: FRA Section Two compliance flags
- **Blockchain persistence**: PIN hashes stored on ConsentManager contract

## API Endpoints

### POST /api/pin/set (FRA-Compliant)

**Purpose**: Set up a new 6-digit PIN after legal consent verification

**Request Body**:
```json
{
  "pin": "123789",              // 6-digit numeric PIN
  "phoneNumber": "+201234567890", // Verified phone number
  "otp": "567890",              // Valid OTP (Possession Factor)
  "deviceMetadata": {           // Optional device information
    "platform": "ios",
    "version": "1.0.0",
    "deviceId": "device-123"
  }
}
```

**Validation Rules**:
1. PIN must be exactly 6 numeric digits
2. OTP must be valid (Possession Factor verification)
3. Phone number must be verified identity
4. Weak PIN patterns are rejected:
   - All same digits (111111, 222222, etc.)
   - Sequential patterns (123456, 654321)
   - Repeated sequences (123123, 456456)
   - Common patterns (000000)

**Success Response (200 OK)**:
```json
{
  "success": true,
  "message": "PIN set successfully with FRA compliance",
  "txHash": "0x...",
  "blockNumber": 12345,
  "compliance": {
    "fraSection": "Section Two - Digital Identity Authentication",
    "knowledgeFactorSet": true,
    "possessionFactorVerified": true,
    "auditTrail": true,
    "digitalIdentityLedgerRef": "2024-12-30T16:51:29.644Z"
  }
}
```

**Error Responses**:
- **400 Bad Request**: Missing required fields, invalid PIN format, weak PIN
- **409 Conflict**: PIN already set (use change-pin for updates)
- **500 Internal Server Error**: Hashing failure, blockchain storage failure

### POST /api/pin/verify-pin (Enhanced)

**Purpose**: Verify PIN for authentication (supports both Argon2 and legacy PBKDF2)

**Request Body**:
```json
{
  "pin": "123789",
  "phoneNumber": "+201234567890",
  "deviceMetadata": {
    "platform": "ios",
    "sessionId": "session-123"
  }
}
```

**Success Response**:
```json
{
  "valid": true,
  "message": "PIN verified successfully",
  "compliance": {
    "fraSection": "Section Two - Digital Identity Authentication",
    "knowledgeFactorVerified": true,
    "verificationMethod": "argon2_fra_compliant",
    "auditTrail": true,
    "digitalIdentityLedgerRef": "2024-12-30T16:52:17.888Z"
  }
}
```

### POST /api/pin/check-pin-exists (Enhanced)

**Purpose**: Check if user has PIN set up (supports both formats)

**Response**:
```json
{
  "exists": true,
  "phoneNumber": "+20123456****",
  "pinFormat": "argon2_fra_compliant",
  "compliance": {
    "fraSection": "Section Two - Digital Identity Authentication",
    "knowledgeFactorCheck": true,
    "auditTrail": true
  }
}
```

## Security Implementation

### Argon2id Hashing Parameters
```javascript
{
  type: argon2.argon2id,
  memoryCost: 2^16,     // 64 MB memory usage
  timeCost: 3,          // 3 iterations
  parallelism: 1,       // Single-threaded
  saltLength: 16,       // 16-byte salt
  hashLength: 32        // 32-byte output
}
```

### Salt Generation
- **Deterministic salt**: Generated from phone number + 'FRA_PIN_SALT'
- **Consistent hashing**: Same PIN + phone always produces same hash
- **Cross-device compatibility**: PIN works across all user devices

### Weak PIN Detection
```javascript
const weakPatterns = [
  { pattern: /^(\d)\1{5}$/, name: 'all_same_digits' },
  { pattern: /^123456$/, name: 'sequential_ascending' },
  { pattern: /^654321$/, name: 'sequential_descending' },
  { pattern: /^000000$/, name: 'all_zeros' },
  { pattern: /^(\d{3})\1$/, name: 'repeated_pattern' }
];
```

## Digital Identity Ledger

### Audit Trail Format
```json
{
  "timestamp": "2024-12-30T16:51:29.644Z",
  "eventType": "pin_knowledge_factor_set",
  "identityHash": "0x...",
  "phoneNumber": "+20123456****",
  "deviceMetadata": {
    "platform": "ios",
    "userAgent": "Mozilla/5.0...",
    "ipAddress": "192.168.1.100"
  },
  "fraCompliance": {
    "knowledgeFactor": true,
    "possessionFactor": true,
    "presenceFactor": true,
    "legalConsentVerified": true,
    "auditTrail": true
  },
  "regulatoryFlags": ["FRA_SECTION_TWO", "DIGITAL_IDENTITY_LEDGER"]
}
```

### Compliance Markers
- **FRA_SECTION_TWO_COMPLIANT**: Meets FRA Section Two requirements
- **KNOWLEDGE_FACTOR_SET**: PIN (Knowledge Factor) successfully configured
- **POSSESSION_FACTOR_VERIFIED**: OTP (Possession Factor) validated
- **LEGAL_CONSENT_VERIFIED**: User consent obtained before PIN setup
- **ARGON2_SECURED**: Industry-standard cryptographic protection

## Blockchain Storage

### ConsentManager Integration
- **Contract**: Enhanced ConsentManager with `getConsent()` method
- **Storage**: PIN hashes stored as consent records
- **Action identifier**: `pin_set_{phoneHash}` for new format
- **Persistence**: Cross-device PIN synchronization
- **Immutability**: Blockchain-based audit trail

### Transaction Logging
```json
{
  "type": "pin_set",
  "subType": "fra_knowledge_factor_setup",
  "identityHash": "0x...",
  "txHash": "0x...",
  "timestamp": "2024-12-30T16:51:29.644Z",
  "metadata": {
    "description": "FRA-compliant PIN (Knowledge Factor) set",
    "complianceFlags": [
      "FRA_SECTION_TWO_COMPLIANT",
      "KNOWLEDGE_FACTOR_SET",
      "ARGON2_SECURED"
    ],
    "fraCompliant": true
  }
}
```

## Backward Compatibility

### Legacy PBKDF2 Support
- **Automatic detection**: System checks both Argon2 and PBKDF2 formats
- **Seamless migration**: Existing users continue using PBKDF2 until PIN change
- **No service interruption**: All existing PINs continue to work
- **Format identification**: API responses indicate hash format used

## Error Handling

### Validation Errors
- **FRA_VALIDATION_ERROR**: Missing required fields
- **FRA_PIN_FORMAT_ERROR**: Invalid PIN format (not 6 digits)
- **FRA_WEAK_PIN_REJECTED**: PIN doesn't meet security standards
- **FRA_POSSESSION_FACTOR_FAILED**: OTP verification failed

### System Errors
- **FRA_HASHING_ERROR**: Argon2 hashing failed
- **FRA_BLOCKCHAIN_STORAGE_ERROR**: Blockchain persistence failed
- **FRA_VERIFICATION_ERROR**: PIN verification system error

## Integration Points

### Frontend Integration
```typescript
// PIN Setup
const response = await fetch('/api/pin/set', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    pin: userPin,
    phoneNumber: verifiedPhone,
    otp: validOtp,
    deviceMetadata: {
      platform: 'web',
      userAgent: navigator.userAgent
    }
  })
});

// PIN Verification
const verification = await fetch('/api/pin/verify-pin', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    pin: userPin,
    phoneNumber: userPhone,
    deviceMetadata: { sessionId: currentSession }
  })
});
```

### Authentication Flow
1. **User enters phone number** → OTP verification (Possession Factor)
2. **Legal consent acceptance** → Terms and conditions agreed
3. **PIN setup request** → 6-digit PIN entry with validation
4. **FRA compliance check** → Weak PIN detection, format validation
5. **Argon2 hashing** → Secure PIN hash generation
6. **Blockchain storage** → ConsentManager stores PIN hash
7. **Audit logging** → Digital Identity Ledger updated
8. **Success confirmation** → User receives FRA compliance confirmation

## Monitoring and Logs

### Key Metrics
- **PIN setup rate**: Track successful PIN configurations
- **Weak PIN rejections**: Monitor security policy effectiveness
- **Verification success rate**: Authentication performance
- **Format distribution**: Argon2 vs PBKDF2 usage

### Log Levels
- **FRA_DIGITAL_IDENTITY_LEDGER**: Audit trail entries
- **FRA_PIN_SET_SUCCESS**: Successful PIN configurations
- **FRA_AUTH_SUCCESS**: Successful PIN verifications
- **FRA_WEAK_PIN_REJECTED**: Security policy violations
- **FRA_ENDPOINT_ERROR**: System errors requiring attention

## Compliance Statement

This implementation satisfies the following FRA requirements:

1. **Section Two Compliance**: Digital Identity Authentication framework
2. **Knowledge Factor**: 6-digit PIN meets cognitive authentication requirements  
3. **Multi-Factor Authentication**: PIN + OTP + Device verification
4. **Audit Trail**: Comprehensive Digital Identity Ledger
5. **Data Security**: Argon2 encryption, blockchain persistence
6. **Legal Consent**: OTP-verified consent before PIN setup
7. **Regulatory Logging**: FRA-compliant audit markers and timestamps

## Testing

### Test Scenarios
1. **Valid PIN setup**: 6-digit PIN with valid OTP
2. **Weak PIN rejection**: Test all weak patterns
3. **Format validation**: Non-numeric, wrong length PINs
4. **Duplicate PIN**: Attempt to set PIN when already exists
5. **Verification flow**: Both Argon2 and PBKDF2 PIN verification
6. **Audit logging**: Verify Digital Identity Ledger entries

### Example Test Requests
```bash
# Test weak PIN rejection
curl -X POST http://localhost:3001/api/pin/set \
  -H "Content-Type: application/json" \
  -d '{"pin":"123456","phoneNumber":"+201234567890","otp":"123456"}'

# Test format validation  
curl -X POST http://localhost:3001/api/pin/set \
  -H "Content-Type: application/json" \
  -d '{"pin":"12345","phoneNumber":"+201234567890","otp":"123456"}'

# Test missing fields
curl -X POST http://localhost:3001/api/pin/set \
  -H "Content-Type: application/json" \
  -d '{"phoneNumber":"+201234567890"}'
```

This FRA-compliant PIN system provides enterprise-grade security while meeting all regulatory requirements for digital identity authentication in the Egyptian financial sector. 