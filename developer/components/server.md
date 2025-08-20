# Pend Smart Wallet API Server

A secure and compliant API server for managing smart wallets with phone-based identity verification and consent management.

## 🌟 Overview

The server provides a complete API for:
- Phone-based identity verification (OTP)
- Smart wallet creation and management
- Transaction execution with consent verification
- Real-time blockchain data collection
- Comprehensive logging and monitoring

## 🚀 Quick Start

1. Install dependencies:
```bash
cd server
npm install
```

2. Configure environment variables:
```bash
# Create .env file with required variables
PORT=3001
RPC_URL=http://127.0.0.1:8545
VALIDATOR_PRIVATE_KEY=your_validator_key
SMART_WALLET_FACTORY_ADDRESS=0x0f84B067f6C71861E705aA45233854F5Db33926d
CONSENT_MANAGER_ADDRESS=0x5103f499A89127068c20711974572563c3dCb819
IDENTITY_REGISTRY_ADDRESS=0x074C5a96106b2Dcefb74b174034bd356943b2723
```

3. Start the server:
```bash
npm start
```

## 📡 API Endpoints

### Identity & Wallet Management

#### 1. Send OTP
```http
POST /api/send-otp
Content-Type: application/json

{
  "phone": "+201001234567"
}
```
Response:
```json
{
  "success": true
}
```

#### 2. Verify OTP
```http
POST /api/verify-otp
Content-Type: application/json

{
  "phone": "+201001234567",
  "code": "123456"
}
```
Response:
```json
{
  "success": true
}
```

#### 3. Create Wallet
```http
POST /api/create-wallet
Content-Type: application/json

{
  "identityHash": "0x...",  // Or provide phoneNumber
  "phoneNumber": "+201001234567"  // Optional
}
```
Response:
```json
{
  "walletAddress": "0x...",
  "txHash": "0x...",
  "alreadyExists": false
}
```

#### 4. Execute Transaction
```http
POST /api/execute-transaction
Content-Type: application/json

{
  "identityHash": "0x...",
  "action": "send_tokens",
  "target": "0x...",
  "data": "0x..."
}
```
Response:
```json
{
  "txHash": "0x..."
}
```

### Explorer & Analytics

#### 1. Get Network Stats
```http
GET /api/explorer/stats
```
Response:
```json
{
  "blockHeight": 44000,
  "totalWallets": 78,
  "poolTVL": "95170.00004",
  "nav": "1.3"
}
```

#### 2. Get Wallet Directory
```http
GET /api/explorer/wallets
```
Response:
```json
{
  "wallets": [
    {
      "address": "0x...",
      "identityHash": "0x...",
      "phoneNumber": "+1234****",
      "balance": "100.0"
    }
  ]
}
```

## 🔒 Security Features

1. **Phone Verification**
   - OTP-based verification
   - Rate limiting
   - Phone number hashing

2. **Consent Management**
   - Explicit consent for all actions
   - On-chain consent storage
   - Action-specific verification

3. **Wallet Security**
   - Identity-based access control
   - Transaction validation
   - Secure key management

## 📊 Data Storage

The server maintains two JSON databases:

1. `wallet-db.json`: Maps identity hashes to wallet addresses
2. `consents-db.json`: Stores user consent records

Both files are automatically backed up and validated.

## 🔍 Logging & Monitoring

### Log Types
- `API_CALL`: All HTTP requests
- `BLOCKCHAIN_TX`: On-chain transactions
- `OTP`: Verification events
- `ERROR`: Error tracking

### View Logs
```http
GET /api/logs
```
Response:
```json
{
  "logs": [
    {
      "timestamp": "2024-03-21T10:30:15.123Z",
      "type": "API_CALL",
      "data": {
        "endpoint": "/api/create-wallet",
        "phoneNumber": "+1234****"
      }
    }
  ]
}
```

## 🛠️ Development

### Available Scripts
```bash
npm start          # Start production server
npm run dev        # Start development server
npm test          # Run tests
npm run lint      # Run linting
```

### Environment Variables

Required:
```env
PORT=3001
RPC_URL=http://127.0.0.1:8545
VALIDATOR_PRIVATE_KEY=your_key
SMART_WALLET_FACTORY_ADDRESS=0x...
CONSENT_MANAGER_ADDRESS=0x...
IDENTITY_REGISTRY_ADDRESS=0x...
```

Optional:
```env
TWILIO_SID=your_sid
TWILIO_TOKEN=your_token
TWILIO_FROM=your_number
```

## 📚 Documentation

Additional documentation available in `/docs/`:
- [SmartWallet.md](docs/SmartWallet.md)
- [ConsentManager.md](docs/ConsentManager.md)
- [IdentityRegistry.md](docs/identity-registry.md)

## 🤝 Contributing

1. Fork the repository
2. Create feature branch
3. Commit changes
4. Push to branch
5. Open Pull Request

## 📄 License

MIT License - see LICENSE file for details. 