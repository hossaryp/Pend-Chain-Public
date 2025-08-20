# Pend Ecosystem - Quick Start Guide

## 🚀 Get Started in 5 Minutes

This guide will get the complete Pend ecosystem running with live blockchain data, pool analytics, and mobile wallet functionality.

## 📋 Prerequisites

- **Node.js** (v16+): [Download here](https://nodejs.org/)
- **Git**: [Download here](https://git-scm.com/)
- **Terminal/Command Prompt**: Built into macOS/Linux, PowerShell on Windows

## ⚡ Quick Setup

### 1. Clone and Setup (2 minutes)

```bash
# Clone the repository
git clone <repository-url>
cd "Beta 4"

# Install server dependencies
cd server
npm install

# Install frontend dependencies  
cd ../wallet-ui
npm install
```

### 2. Start the Blockchain Network (1 minute)

```bash
# Start Besu blockchain (in a new terminal)
cd besu-network
./start-network.sh

# Wait for "Block mined" messages - network is ready when you see blocks being mined
```

### 3. Start the API Server (1 minute)

```bash
# In a new terminal, start the server
cd server
node index.js

# ✅ Server ready when you see:
# "API server listening on port 3001"
# "🔍 Pend Chain Explorer initialized"
# "✅ Real data collected from advanced explorer"
```

### 4. Start the Mobile Wallet UI (1 minute)

```bash
# In a new terminal, start the frontend
cd wallet-ui
npm run dev

# ✅ Frontend ready when you see:
# "Local: http://localhost:5173"
```

## 🎯 Access Your Running System

### 📱 Mobile Wallet
**URL**: http://localhost:5173

**Features**:
- Create wallet with phone number
- Invest in harvest pools 
- Send tokens by phone number
- View transaction history

### 📊 Advanced Explorer
**URL**: http://localhost:3001/explorer/advanced

**Features**:
- Live pool analytics (TVL: 95,170+ EGP)
- Complete wallet directory (78 wallets)
- Real-time transaction monitoring
- Network performance metrics

### 🔧 API Endpoints
**Base URL**: http://localhost:3001

**Test API**:
```bash
# Check pool analytics
curl http://localhost:3001/api/explorer/pool

# Check wallet directory
curl http://localhost:3001/api/explorer/wallets

# Network overview
curl http://localhost:3001/api/explorer/advanced
```

## 📊 What You'll See (Live Data)

### Current Network Status
- **Pool TVL**: 95,170.00004 EGP
- **Dynamic NAV**: 1.3 EGP/HVT
- **Total Wallets**: 78 wallets
- **Active Investors**: 15 wallets
- **Block Height**: 44,000+ (live updates)

### Sample Wallet Data
- **Top Investor**: 50,000 EGP + 3,846.2 HVT
- **Phone Numbers**: 20+ wallets with masked phone numbers (+1234567****)
- **Transaction History**: 300+ real transactions

## 🎮 Try These Features

### 1. Create a Wallet
1. Go to http://localhost:5173
2. Enter phone number: `+1234567890`
3. Enter OTP: `123456` (development mode)
4. Wallet automatically created!

### 2. Invest in Pool
1. Click "Pool" tab
2. Enter amount: `100` EGP
3. Enter OTP: `123456`
4. View real-time NAV and returns

### 3. Send Tokens
1. Click "Send" button
2. Enter recipient phone: `+1555123456`
3. Select token and amount
4. Confirm with OTP

### 4. Explore Analytics
1. Visit http://localhost:3001/explorer/advanced
2. View live pool metrics
3. Browse wallet directory
4. Search transactions

## 🔧 Configuration (Optional)

### Environment Variables
The system works with defaults, but you can customize:

```bash
# In server/.env (optional)
RPC_URL=http://127.0.0.1:8545
CHAIN_ID=7777

# Contract addresses (already configured)
EGP_STABLECOIN_ADDRESS=0x0e62978a8237984fEB2c99E29A6283Cc1FDdA671
HARVEST_POOL_ADDRESS=0xe4de484028097fA25f7a5893843325385812AD70
# ... other contracts
```

### For SMS Integration (Production)
```bash
# Add to server/.env for real SMS
TWILIO_SID=your_twilio_sid
TWILIO_TOKEN=your_twilio_token
TWILIO_FROM=your_phone_number
```

## 🚨 Troubleshooting

### Common Issues

**Server won't start**:
```bash
# Kill existing processes
lsof -ti:3001 | xargs kill -9
cd server && node index.js
```

**Frontend shows errors**:
```bash
# Restart with clean cache
cd wallet-ui
rm -rf node_modules package-lock.json
npm install
npm run dev
```

**No blockchain data**:
```bash
# Check if Besu is running
curl http://localhost:8545 -X POST \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'
```

**Explorer shows empty data**:
```bash
# Force refresh
curl -X POST http://localhost:3001/api/live/refresh
```

## 📚 Next Steps

### Explore the System
- **Pool Analytics**: Monitor real-time TVL and NAV changes
- **Wallet Directory**: Browse all 78 wallets with balances
- **Transaction History**: View complete transaction log
- **API Integration**: Build custom applications using the APIs

### Development
- **Smart Contracts**: Located in `/hardhat/contracts/`
- **API Endpoints**: Full REST API documentation
- **Frontend Components**: React components in `/wallet-ui/src/`
- **Database**: JSON files in `/server/explorer-data/`

### Documentation
- **[README.md](README.md)**: Complete project overview
- **[PendChainExplorer.md](docs/PendChainExplorer.md)**: Explorer documentation
- **[PEND_ECOSYSTEM_STATUS_DECEMBER_2025.md](PEND_ECOSYSTEM_STATUS_DECEMBER_2025.md)**: Complete status report

## 🎉 Success!

You now have a complete blockchain ecosystem running with:

✅ **Mobile Wallet**: Phone-based identity and payments  
✅ **DeFi Pool**: Investment pool with 120% returns  
✅ **Live Analytics**: Real-time blockchain monitoring  
✅ **78 Wallets**: Complete wallet directory with phone numbers  
✅ **Advanced Explorer**: Comprehensive network analytics  

**🌐 Access Points**:
- Mobile Wallet: http://localhost:5173
- Advanced Explorer: http://localhost:3001/explorer/advanced
- API Base: http://localhost:3001

**💡 Pro Tip**: Keep all three terminals running (blockchain, server, frontend) for the best experience!

---

*Need help? Check the troubleshooting section above or review the complete documentation in the docs/ folder.* 