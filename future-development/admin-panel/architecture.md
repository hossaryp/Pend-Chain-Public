# Admin Panel - Technical Architecture

## 🏗️ **System Architecture Overview**

The Next.js admin panel will be a separate application from the wallet-ui, designed for specialized admin workflows with enhanced performance, security, and scalability.

## 📊 **Current State Analysis**

### **Existing Admin Infrastructure**
```typescript
// Current Structure (wallet-ui/src/features/admin/)
├── components/
│   ├── AdminPanel.tsx           # Main admin interface (3 tabs)
│   ├── KycVerificationTab.tsx   # KYC review and approval
│   ├── OpportunityDeploymentForm.tsx # Asset deployment
│   ├── TierManagementTab.tsx    # User tier management
│   └── PendAdminPanel.tsx       # Enhanced admin UI
├── services/
│   ├── adminService.ts          # API integration layer
│   └── blockchainService.ts     # Blockchain interactions
├── hooks/
│   ├── useWalletConnection.ts   # MetaMask integration
│   ├── useTierManagement.ts     # Tier operations
│   └── useOpportunityDeployment.ts # Asset deployment
└── types/
    └── index.ts                 # TypeScript definitions
```

### **Backend API Capabilities**
```javascript
// Current APIs (server/routes/)
├── admin.js                     # Opportunity CRUD, stats, logs
├── kyc.js                       # KYC admin endpoints (/admin/*)
├── wallet.js                    # User/wallet management
├── explorer.js                  # Blockchain data
├── pool.js                      # Investment pool management
└── consent.js                   # Tier and consent management
```

### **Data Storage (Current)**
```json
// JSON File Storage
├── admin-opportunities.json     # Asset opportunities
├── admin-logs.json              # Admin action logs
├── wallet-db.json               # User wallet mappings
├── uploads/kyc/metadata.json    # KYC document metadata
└── explorer-data/               # Live blockchain data
```

## 🚀 **Next.js Admin Panel Architecture**

### **Frontend Architecture**

#### **Technology Stack**
```typescript
// Core Framework
Next.js 14              // React framework with App Router
TypeScript              // Type safety and developer experience
React 18                // Latest React with concurrent features

// Styling & UI
Tailwind CSS            // Utility-first CSS framework
Shadcn/ui               // Modern component library
Radix UI                // Accessible component primitives
Lucide Icons            // Consistent icon library

// State Management
React Query (TanStack)  // Server state management
Zustand                 // Client state management
React Hook Form         // Form state and validation

// Data Visualization
Recharts                // React charting library
D3.js                   // Advanced custom visualizations
React Table             // Data table management

// Development
ESLint                  // Code linting
Prettier                // Code formatting
Husky                   // Git hooks
```

#### **Project Structure**
```
admin-panel/
├── app/                        # Next.js App Router
│   ├── (auth)/                 # Auth route group
│   │   ├── login/
│   │   └── layout.tsx
│   ├── (dashboard)/            # Main dashboard group
│   │   ├── assets/             # Asset management
│   │   ├── kyc/                # KYC verification
│   │   ├── users/              # User management
│   │   ├── analytics/          # Analytics dashboard
│   │   ├── settings/           # Admin settings
│   │   └── layout.tsx
│   ├── api/                    # API routes (proxy to server)
│   ├── globals.css
│   ├── layout.tsx
│   └── page.tsx
├── components/
│   ├── ui/                     # Shadcn/ui components
│   ├── forms/                  # Form components
│   ├── charts/                 # Chart components
│   ├── tables/                 # Data table components
│   └── layout/                 # Layout components
├── lib/
│   ├── api.ts                  # API client
│   ├── auth.ts                 # Authentication
│   ├── utils.ts                # Utilities
│   └── validations.ts          # Zod schemas
├── hooks/
│   ├── use-api.ts              # API hooks
│   ├── use-auth.ts             # Auth hooks
│   └── use-blockchain.ts       # Blockchain hooks
├── types/
│   ├── api.ts                  # API types
│   ├── auth.ts                 # Auth types
│   └── admin.ts                # Admin types
└── stores/
    ├── auth.ts                 # Auth store
    └── admin.ts                # Admin store
```

### **Backend Integration**

#### **API Architecture**
```typescript
// API Client Design
class AdminApiClient {
  // Asset Management
  async getAssets(filters?: AssetFilters): Promise<Asset[]>
  async createAsset(data: CreateAssetRequest): Promise<Asset>
  async updateAsset(id: string, data: UpdateAssetRequest): Promise<Asset>
  async deleteAsset(id: string): Promise<void>
  async getAssetAnalytics(id: string): Promise<AssetAnalytics>

  // KYC Management
  async getKycApplications(status?: KycStatus): Promise<KycApplication[]>
  async getKycApplication(id: string): Promise<KycApplication>
  async verifyKycApplication(id: string, action: VerificationAction): Promise<void>
  async getKycStats(): Promise<KycStats>
  async downloadKycDocument(id: string, type: string): Promise<Blob>

  // User Management
  async getUsers(filters?: UserFilters): Promise<User[]>
  async getUser(id: string): Promise<User>
  async updateUserTier(id: string, tier: number): Promise<void>
  async getUserAnalytics(): Promise<UserAnalytics>
  async searchUsers(query: string): Promise<User[]>

  // Analytics
  async getOverviewMetrics(): Promise<OverviewMetrics>
  async getRevenueAnalytics(period: TimePeriod): Promise<RevenueData>
  async getUserEngagementMetrics(): Promise<EngagementMetrics>
  async getAssetPerformanceMetrics(): Promise<PerformanceMetrics>

  // Blockchain Integration
  async getBlockchainStats(): Promise<BlockchainStats>
  async getTransactionHistory(filters?: TxFilters): Promise<Transaction[]>
  async deployAsset(data: DeploymentData): Promise<DeploymentResult>
}
```

#### **Authentication & Authorization**
```typescript
// Role-Based Access Control
enum AdminRole {
  SUPER_ADMIN = 'super_admin',
  ASSET_MANAGER = 'asset_manager',
  KYC_VERIFIER = 'kyc_verifier',
  AUDITOR = 'auditor',
  VIEWER = 'viewer'
}

interface AdminUser {
  id: string;
  email: string;
  name: string;
  role: AdminRole;
  permissions: Permission[];
  blockchainAddress?: string;
  isActive: boolean;
  lastLogin: Date;
}

// JWT-based authentication with role verification
// Blockchain address verification for sensitive operations
// Session management with automatic refresh
```

### **Database Architecture Migration**

#### **Current → Future Data Flow**
```typescript
// Phase 1: Hybrid Approach
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   JSON Files    │───▶│  API Gateway    │───▶│   PostgreSQL    │
│   (Current)     │    │  (Transition)   │    │   (Future)      │
└─────────────────┘    └─────────────────┘    └─────────────────┘

// Phase 2: Full Migration
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Admin Panel   │───▶│   PostgreSQL    │───▶│   Redis Cache   │
│   (Next.js)     │    │   (Primary)     │    │   (Performance) │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

#### **Database Schema Design**
```sql
-- Users & Identity
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  phone_hash VARCHAR(64) UNIQUE NOT NULL,
  blockchain_address VARCHAR(42) UNIQUE NOT NULL,
  tier INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE user_profiles (
  user_id UUID REFERENCES users(id),
  phone_number_masked VARCHAR(20),
  country_code VARCHAR(3),
  registration_date TIMESTAMP,
  last_activity TIMESTAMP,
  status VARCHAR(20) DEFAULT 'active'
);

-- Assets & Opportunities
CREATE TABLE assets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  contract_address VARCHAR(42) UNIQUE NOT NULL,
  type VARCHAR(20) NOT NULL, -- 'investment' | 'interest'
  title VARCHAR(255) NOT NULL,
  description TEXT,
  category VARCHAR(50),
  status VARCHAR(20) DEFAULT 'active',
  created_by UUID REFERENCES users(id),
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE asset_metrics (
  asset_id UUID REFERENCES assets(id),
  total_invested DECIMAL(18,6) DEFAULT 0,
  investor_count INTEGER DEFAULT 0,
  performance_data JSONB,
  last_updated TIMESTAMP DEFAULT NOW()
);

-- KYC & Compliance
CREATE TABLE kyc_applications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  status VARCHAR(20) DEFAULT 'pending_review',
  submitted_at TIMESTAMP DEFAULT NOW(),
  verified_at TIMESTAMP,
  verified_by UUID REFERENCES admin_users(id),
  rejection_reason TEXT
);

CREATE TABLE kyc_documents (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  application_id UUID REFERENCES kyc_applications(id),
  document_type VARCHAR(20) NOT NULL,
  file_path VARCHAR(500),
  file_size INTEGER,
  mime_type VARCHAR(100),
  uploaded_at TIMESTAMP DEFAULT NOW()
);

-- Admin & Audit
CREATE TABLE admin_users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) UNIQUE NOT NULL,
  name VARCHAR(255) NOT NULL,
  role VARCHAR(50) NOT NULL,
  blockchain_address VARCHAR(42),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE admin_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  admin_id UUID REFERENCES admin_users(id),
  action VARCHAR(100) NOT NULL,
  resource_type VARCHAR(50),
  resource_id VARCHAR(255),
  details JSONB,
  ip_address INET,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Analytics & Metrics
CREATE TABLE analytics_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  event_type VARCHAR(50) NOT NULL,
  user_id UUID REFERENCES users(id),
  event_data JSONB,
  timestamp TIMESTAMP DEFAULT NOW()
);

-- Indexes for Performance
CREATE INDEX idx_users_phone_hash ON users(phone_hash);
CREATE INDEX idx_users_blockchain_address ON users(blockchain_address);
CREATE INDEX idx_assets_contract_address ON assets(contract_address);
CREATE INDEX idx_kyc_applications_status ON kyc_applications(status);
CREATE INDEX idx_admin_logs_created_at ON admin_logs(created_at);
CREATE INDEX idx_analytics_events_timestamp ON analytics_events(timestamp);
```

### **Security Architecture**

#### **Authentication Flow**
```typescript
// Multi-layer Authentication
1. Email/Password Login → JWT Token
2. Role-based Permission Check
3. Blockchain Address Verification (for sensitive operations)
4. Session Management with Refresh Tokens
5. API Rate Limiting & Request Validation

// Security Headers
app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      scriptSrc: ["'self'"],
      imgSrc: ["'self'", "data:", "https:"],
      connectSrc: ["'self'", process.env.API_BASE_URL]
    }
  }
}));
```

#### **Data Protection**
```typescript
// Encryption & Privacy
- Phone numbers hashed (SHA-256)
- KYC documents encrypted at rest
- API communication over HTTPS only
- Database connections encrypted (TLS)
- Audit trail for all admin actions
- GDPR compliance features
```

### **Performance Optimization**

#### **Caching Strategy**
```typescript
// Multi-level Caching
1. Browser Cache (Static Assets)
2. CDN Cache (Images, Documents)
3. Redis Cache (API Responses)
4. Database Query Optimization
5. Real-time Data via WebSocket

// Cache Implementation
const cacheConfig = {
  staticAssets: '1 year',
  apiResponses: '5 minutes',
  userSessions: '24 hours',
  blockchainData: '30 seconds'
};
```

#### **Data Loading Strategies**
```typescript
// Optimized Data Loading
- Server-side rendering for initial load
- Incremental Static Regeneration for dashboard
- Infinite scrolling for large data sets
- Virtual scrolling for tables
- Progressive data loading
- Real-time updates via WebSocket
```

## 🔄 **Migration Strategy**

### **Phase 1: Foundation (Week 1-2)**
1. **Project Setup**: Next.js application with basic structure
2. **Authentication**: JWT-based admin authentication
3. **API Integration**: Connect to existing server endpoints
4. **Basic UI**: Core layout and navigation

### **Phase 2: Core Features (Week 3-4)**
1. **Asset Management**: Enhanced opportunity management
2. **KYC Workflow**: Improved verification interface
3. **User Management**: Comprehensive user directory
4. **Data Migration**: Begin PostgreSQL transition

### **Phase 3: Analytics & Polish (Week 5-6)**
1. **Analytics Dashboard**: Real-time metrics and insights
2. **Advanced Features**: Bulk operations, export capabilities
3. **Performance Optimization**: Caching and optimization
4. **Testing & Deployment**: Comprehensive testing suite

## 🔗 **Integration Points**

### **Existing System Integration**
- **Server APIs**: Maintain compatibility with current endpoints
- **Blockchain**: Continue using existing smart contract integrations
- **File Storage**: Transition KYC documents to secure cloud storage
- **Authentication**: Integrate with current wallet-based auth system

### **Future Enhancements**
- **Real-time Updates**: WebSocket integration for live data
- **Mobile Support**: Responsive design for mobile admin access
- **API Platform**: RESTful APIs for third-party integrations
- **Audit Compliance**: Enhanced logging and compliance features

---

*This architecture provides a scalable foundation for the Next.js admin panel while maintaining compatibility with existing systems and enabling future growth.* 