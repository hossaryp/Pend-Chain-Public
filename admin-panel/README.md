# Pend Admin Panel

A modern Next.js administrative interface for comprehensive management of the Pend ecosystem.

## 🚀 Features

### Phase 1 - Core Functionality
- **Analytics Dashboard** - Real-time system metrics and insights
- **Opportunity Deployment** - Deploy investment opportunities and interest-only campaigns
- **Tier Management** - Manage user tiers and permissions
- **KYC Verification** - Review and approve user KYC applications
- **User Management** - Comprehensive user account administration
- **System Health** - Monitor system performance and health metrics

### Phase 2 - Enhanced Features
- Real-time WebSocket updates
- Advanced analytics and reporting
- Bulk operations and batch processing
- Audit trail and activity logging
- Export capabilities

## 🛠️ Tech Stack

- **Next.js 14** - React framework with App Router
- **TypeScript** - Type safety and developer experience
- **Tailwind CSS** - Utility-first styling
- **Heroicons** - Beautiful SVG icons
- **Recharts** - Data visualization
- **Headless UI** - Unstyled, accessible UI components

## 📦 Installation

```bash
# Install dependencies
npm install

# Run development server
npm run dev

# Build for production
npm run build

# Start production server
npm start
```

## 🌐 Development

The admin panel runs on `http://localhost:3002` to avoid conflicts with the main server (port 3001) and wallet UI (port 3000).

### API Integration

The admin panel connects to the main Pend server via:
- Local development: `http://localhost:3001`
- Production: `https://api.pend.com`

API routes are proxied through Next.js configuration for seamless integration.

## 🔐 Authentication

The admin panel uses wallet-based authentication:
- Connect MetaMask or compatible wallet
- Verify Asset Manager role via AccessControlHub smart contract
- Verify KYC Verifier role for KYC management features

## 📊 Available Tabs

1. **Analytics** - System overview and key metrics
2. **Deploy Opportunities** - Create new investment opportunities
3. **Tier Management** - User tier lookup and upgrades
4. **KYC Verification** - Review pending KYC applications
5. **User Management** - Search, filter, and manage users
6. **System Health** - Monitor system performance

## 🚨 Requirements

- Node.js 18+ 
- npm or yarn
- MetaMask or compatible Web3 wallet
- Access to Pend backend server

## 📝 Development Status

- ✅ **Phase 1 Complete** - Core admin functionality implemented
- 🔄 **Phase 2 In Progress** - Enhanced features and real-time updates
- 📋 **Phase 3 Planned** - Advanced automation and AI insights

## 🔗 Related

- [Main Server](../server/) - Backend API and services
- [Wallet UI](../wallet-ui/) - User-facing wallet interface
- [Smart Contracts](../hardhat/) - Blockchain contracts
- [Documentation](../docs/) - Project documentation 