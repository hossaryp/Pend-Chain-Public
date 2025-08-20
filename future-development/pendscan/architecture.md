# PendScan Architecture - Modern Blockchain Explorer

## 🏗️ **Architecture Overview**

Transformation of PendScan from a basic HTML interface to a modern React/Next.js blockchain explorer with advanced analytics, real-time monitoring, and seamless integration with the admin panel and PostgreSQL database.

## 📊 **Current State Analysis**

### **Existing PendScan Infrastructure**
```typescript
// Current Implementation (server/)
├── pendscan.html              # Static HTML interface (69KB, 1726 lines)
├── data-collector.js          # Blockchain data collection (27KB, 717 lines)
├── explorer-data/             # Live data storage
│   ├── data-backup.json       # Analytics backup
│   ├── enhanced-historical-data.json  # Historical blockchain data
│   ├── live-stats.json        # Real-time network statistics
│   ├── persistent-transactions.json   # Transaction history
│   ├── transactions-log.json  # Transaction processing log
│   └── wallets-directory.json # Complete wallet directory
└── routes/explorer.js         # API endpoints (46KB, 1156 lines)
```

### **Current Capabilities & Limitations**
```typescript
// Production Data (December 2024)
Current Capabilities: {
  blocks_processed: 74000,
  wallets_tracked: 139,
  transactions_logged: "Thousands",
  real_time_monitoring: true,
  wallet_directory: true,
  transaction_search: "Basic"
}

Current Limitations: {
  ui_framework: "Static HTML/JavaScript",
  mobile_experience: "Limited responsiveness",
  data_visualization: "Basic charts",
  search_capabilities: "Simple text matching",
  analytics: "Basic statistics only",
  export_options: "None",
  api_documentation: "Minimal"
}
```

### **Integration Points**
- **Server Integration**: Direct file-based data access via `data-collector.js`
- **Blockchain**: Real-time connection to 5-node Besu IBFT network
- **Data Storage**: JSON files with manual refresh mechanisms
- **API Layer**: Basic REST endpoints for data access

## 🚀 **Target Architecture**

### **Modern Frontend Architecture**

```typescript
// Next.js PendScan Application Structure
pendscan/
├── app/                          # Next.js App Router
│   ├── (explorer)/               # Explorer route group
│   │   ├── blocks/
│   │   │   ├── page.tsx          # Blocks list view
│   │   │   └── [number]/
│   │   │       └── page.tsx      # Block details
│   │   ├── transactions/
│   │   │   ├── page.tsx          # Transactions list
│   │   │   └── [hash]/
│   │   │       └── page.tsx      # Transaction details
│   │   ├── wallets/
│   │   │   ├── page.tsx          # Wallet directory
│   │   │   └── [address]/
│   │   │       └── page.tsx      # Wallet details
│   │   ├── pools/
│   │   │   ├── page.tsx          # Investment pools
│   │   │   └── [id]/
│   │   │       └── page.tsx      # Pool analytics
│   │   ├── analytics/
│   │   │   └── page.tsx          # Network analytics
│   │   └── layout.tsx            # Explorer layout
│   ├── api/                      # API routes (proxy to server)
│   │   ├── blocks/
│   │   ├── transactions/
│   │   ├── wallets/
│   │   ├── pools/
│   │   └── analytics/
│   ├── globals.css
│   ├── layout.tsx
│   └── page.tsx                  # Explorer home
├── components/
│   ├── ui/                       # Shadcn/ui components
│   ├── explorer/
│   │   ├── block-card.tsx
│   │   ├── transaction-table.tsx
│   │   ├── wallet-directory.tsx
│   │   ├── pool-monitor.tsx
│   │   └── network-stats.tsx
│   ├── charts/
│   │   ├── time-series-chart.tsx
│   │   ├── network-health-chart.tsx
│   │   ├── transaction-volume-chart.tsx
│   │   └── pool-performance-chart.tsx
│   └── layout/
│       ├── explorer-header.tsx
│       ├── search-bar.tsx
│       └── navigation.tsx
├── lib/
│   ├── api.ts                    # API client for blockchain data
│   ├── utils.ts                  # Utility functions
│   ├── formatters.ts             # Data formatting utilities
│   └── validations.ts            # Input validation schemas
├── hooks/
│   ├── use-blockchain-data.ts    # Real-time blockchain data hooks
│   ├── use-search.ts             # Search functionality
│   └── use-websocket.ts          # WebSocket connection management
├── types/
│   ├── blockchain.ts             # Blockchain data types
│   ├── explorer.ts               # Explorer-specific types
│   └── api.ts                    # API response types
└── stores/
    ├── blockchain.ts             # Blockchain data store
    ├── search.ts                 # Search state management
    └── preferences.ts            # User preferences
```

### **Technology Stack**

#### **Frontend Stack**
```typescript
// Core Technologies
Next.js 14                // React framework with App Router
TypeScript               // Type safety and development experience
React 18                 // Latest React with concurrent features

// Styling & UI
Tailwind CSS            // Utility-first CSS framework
Shadcn/ui               // Modern component library
Framer Motion           // Animations and transitions
Lucide Icons            // Consistent iconography

// Data Management
React Query             // Server state management and caching
Zustand                 // Client-side state management
WebSocket               // Real-time data connections

// Data Visualization
Recharts                // React charting library
D3.js                   // Advanced custom visualizations
React Table             // Data table with sorting/filtering
React Virtualized       // Performance for large datasets

// Development & Quality
ESLint                  // Code linting
Prettier                // Code formatting
Jest                    // Unit testing
Playwright              // E2E testing
```

#### **Backend Enhancement**
```typescript
// Enhanced Server Architecture
server/
├── routes/
│   ├── explorer.js              # Enhanced with PostgreSQL integration
│   ├── blockchain.js            # New dedicated blockchain endpoints
│   ├── analytics.js             # Advanced analytics endpoints
│   └── websocket.js             # Real-time data streaming
├── services/
│   ├── blockchainService.js     # Enhanced blockchain data service
│   ├── explorerService.js       # PendScan-specific business logic
│   ├── analyticsService.js      # Advanced analytics processing
│   └── websocketService.js      # Real-time data broadcasting
├── collectors/
│   ├── blockCollector.js        # Enhanced block data collection
│   ├── transactionCollector.js  # Transaction monitoring
│   ├── poolCollector.js         # Investment pool monitoring
│   └── networkCollector.js      # Network health metrics
└── models/
    ├── Block.js                 # Block data model
    ├── Transaction.js           # Transaction data model
    ├── Wallet.js                # Wallet data model
    └── Pool.js                  # Investment pool model
```

## 🗄️ **Data Architecture Integration**

### **Database Integration with TimescaleDB**

```sql
-- Enhanced Blockchain Data Schema (TimescaleDB)
-- Optimized for PendScan queries and analytics

-- Blocks Table (Hypertable)
CREATE TABLE blocks (
  number BIGINT NOT NULL,
  hash VARCHAR(66) UNIQUE NOT NULL,
  parent_hash VARCHAR(66),
  timestamp TIMESTAMPTZ NOT NULL,
  miner VARCHAR(42),
  difficulty DECIMAL(36,0),
  total_difficulty DECIMAL(36,0),
  gas_limit BIGINT,
  gas_used BIGINT,
  size BIGINT,
  transaction_count INTEGER DEFAULT 0,
  uncle_count INTEGER DEFAULT 0,
  extra_data TEXT,
  logs_bloom TEXT,
  receipts_root VARCHAR(66),
  state_root VARCHAR(66),
  transactions_root VARCHAR(66),
  nonce VARCHAR(18),
  sha3_uncles VARCHAR(66),
  metadata JSONB DEFAULT '{}'
);

SELECT create_hypertable('blocks', 'timestamp');

-- Transactions Table (Hypertable) 
CREATE TABLE transactions (
  hash VARCHAR(66) NOT NULL,
  block_number BIGINT NOT NULL,
  block_hash VARCHAR(66),
  transaction_index INTEGER,
  timestamp TIMESTAMPTZ NOT NULL,
  from_address VARCHAR(42),
  to_address VARCHAR(42),
  value DECIMAL(36,18),
  gas_used BIGINT,
  gas_price BIGINT,
  input_data TEXT,
  nonce INTEGER,
  status INTEGER, -- 0 = failed, 1 = success
  transaction_type VARCHAR(20), -- 'transfer', 'contract_call', 'contract_creation'
  contract_address VARCHAR(42), -- for contract creation
  logs JSONB DEFAULT '[]',
  metadata JSONB DEFAULT '{}'
);

SELECT create_hypertable('transactions', 'timestamp');

-- Network Metrics (Hypertable)
CREATE TABLE network_metrics (
  timestamp TIMESTAMPTZ NOT NULL,
  block_number BIGINT,
  blocks_per_minute DECIMAL(10,2),
  transactions_per_second DECIMAL(10,2),
  average_gas_price BIGINT,
  network_hash_rate BIGINT,
  active_miners INTEGER,
  total_difficulty DECIMAL(36,0),
  network_health_score DECIMAL(5,2), -- 0-100
  metadata JSONB DEFAULT '{}'
);

SELECT create_hypertable('network_metrics', 'timestamp');

-- Pool Analytics (Hypertable)
CREATE TABLE pool_analytics (
  timestamp TIMESTAMPTZ NOT NULL,
  pool_address VARCHAR(42),
  pool_name VARCHAR(255),
  total_value_locked DECIMAL(18,6),
  participant_count INTEGER,
  transaction_volume_24h DECIMAL(18,6),
  apy DECIMAL(8,4),
  risk_score DECIMAL(5,2),
  performance_metrics JSONB DEFAULT '{}'
);

SELECT create_hypertable('pool_analytics', 'timestamp');

-- Wallet Analytics (Regular Table with Time Partitioning)
CREATE TABLE wallet_analytics (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  address VARCHAR(42) NOT NULL,
  balance_eth DECIMAL(36,18),
  balance_tokens JSONB DEFAULT '{}',
  transaction_count INTEGER DEFAULT 0,
  first_seen TIMESTAMPTZ,
  last_active TIMESTAMPTZ,
  wallet_type VARCHAR(20), -- 'user', 'contract', 'pool', 'system'
  risk_score DECIMAL(5,2),
  labels JSONB DEFAULT '[]',
  metadata JSONB DEFAULT '{}',
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for Performance
CREATE INDEX idx_blocks_number ON blocks(number DESC);
CREATE INDEX idx_blocks_miner ON blocks(miner);
CREATE INDEX idx_blocks_timestamp ON blocks(timestamp DESC);

CREATE INDEX idx_transactions_from ON transactions(from_address);
CREATE INDEX idx_transactions_to ON transactions(to_address);
CREATE INDEX idx_transactions_block ON transactions(block_number DESC);
CREATE INDEX idx_transactions_type ON transactions(transaction_type);

CREATE INDEX idx_wallet_analytics_address ON wallet_analytics(address);
CREATE INDEX idx_wallet_analytics_type ON wallet_analytics(wallet_type);
CREATE INDEX idx_wallet_analytics_last_active ON wallet_analytics(last_active DESC);
```

### **Real-time Data Pipeline**

```typescript
// Enhanced Data Collection Architecture
class BlockchainDataPipeline {
  constructor() {
    this.wsConnections = new Map(); // WebSocket connections to frontend
    this.dataQueue = new Queue();   // Processing queue for blockchain events
    this.metricsCalculator = new NetworkMetricsCalculator();
  }

  // Real-time block processing
  async processNewBlock(block) {
    try {
      // Store block in TimescaleDB
      await this.storeBlock(block);
      
      // Process all transactions in the block
      for (const tx of block.transactions) {
        await this.processTransaction(tx, block);
      }
      
      // Update network metrics
      await this.updateNetworkMetrics(block);
      
      // Update wallet analytics
      await this.updateWalletAnalytics(block);
      
      // Broadcast to connected clients
      this.broadcastUpdate('new_block', {
        block: this.formatBlockForClient(block),
        networkStats: await this.getLatestNetworkStats()
      });
      
    } catch (error) {
      console.error('Block processing error:', error);
    }
  }

  // Transaction processing with classification
  async processTransaction(tx, block) {
    // Classify transaction type
    const txType = this.classifyTransaction(tx);
    
    // Enhanced transaction object
    const enhancedTx = {
      ...tx,
      timestamp: block.timestamp,
      transaction_type: txType,
      value_usd: await this.convertToUSD(tx.value),
      gas_fee_usd: await this.convertToUSD(tx.gasUsed * tx.gasPrice)
    };

    // Store in TimescaleDB
    await db.query(`
      INSERT INTO transactions (
        hash, block_number, block_hash, transaction_index, timestamp,
        from_address, to_address, value, gas_used, gas_price,
        transaction_type, status, logs, metadata
      ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14)
    `, [
      tx.hash, block.number, block.hash, tx.transactionIndex, block.timestamp,
      tx.from, tx.to, tx.value, tx.gasUsed, tx.gasPrice,
      txType, tx.status, JSON.stringify(tx.logs), JSON.stringify(enhancedTx)
    ]);

    // Update wallet analytics
    await this.updateWalletForTransaction(tx.from, tx);
    if (tx.to) await this.updateWalletForTransaction(tx.to, tx);

    // Broadcast transaction update
    this.broadcastUpdate('new_transaction', enhancedTx);
  }

  // Network metrics calculation
  async updateNetworkMetrics(block) {
    const metrics = await this.metricsCalculator.calculate(block);
    
    await db.query(`
      INSERT INTO network_metrics (
        timestamp, block_number, blocks_per_minute, transactions_per_second,
        average_gas_price, network_hash_rate, total_difficulty, network_health_score
      ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
    `, [
      block.timestamp, block.number, metrics.blocksPerMinute, metrics.tps,
      metrics.avgGasPrice, metrics.hashRate, metrics.totalDifficulty, metrics.healthScore
    ]);
  }

  // WebSocket broadcasting
  broadcastUpdate(event, data) {
    const message = JSON.stringify({ event, data, timestamp: Date.now() });
    
    this.wsConnections.forEach((ws, clientId) => {
      if (ws.readyState === WebSocket.OPEN) {
        ws.send(message);
      } else {
        this.wsConnections.delete(clientId);
      }
    });
  }
}
```

## 📊 **Component Architecture**

### **Core Explorer Components**

#### **Block Explorer Components**
```typescript
// components/explorer/BlockList.tsx
export function BlockList() {
  const { data: blocks, isLoading } = useQuery({
    queryKey: ['blocks', { page: 1, limit: 25 }],
    queryFn: ({ queryKey }) => api.getBlocks(queryKey[1]),
    refetchInterval: 5000 // Real-time updates every 5 seconds
  });

  return (
    <Card>
      <CardHeader>
        <CardTitle>Latest Blocks</CardTitle>
      </CardHeader>
      <CardContent>
        <DataTable
          columns={blockColumns}
          data={blocks?.data || []}
          loading={isLoading}
          pagination={blocks?.pagination}
        />
      </CardContent>
    </Card>
  );
}

// components/explorer/BlockDetails.tsx
export function BlockDetails({ blockNumber }: { blockNumber: string }) {
  const { data: block } = useQuery({
    queryKey: ['block', blockNumber],
    queryFn: () => api.getBlock(blockNumber)
  });

  const { data: transactions } = useQuery({
    queryKey: ['block-transactions', blockNumber],
    queryFn: () => api.getBlockTransactions(blockNumber),
    enabled: !!block
  });

  return (
    <div className="space-y-6">
      {/* Block Information */}
      <Card>
        <CardHeader>
          <CardTitle>Block #{block?.number}</CardTitle>
        </CardHeader>
        <CardContent>
          <BlockInfoGrid block={block} />
        </CardContent>
      </Card>

      {/* Block Transactions */}
      <Card>
        <CardHeader>
          <CardTitle>Transactions ({transactions?.length || 0})</CardTitle>
        </CardHeader>
        <CardContent>
          <TransactionTable transactions={transactions} />
        </CardContent>
      </Card>
    </div>
  );
}
```

#### **Transaction Explorer Components**
```typescript
// components/explorer/TransactionTable.tsx
export function TransactionTable({ transactions, loading = false }) {
  const columns = [
    {
      accessorKey: 'hash',
      header: 'Transaction Hash',
      cell: ({ row }) => (
        <Link href={`/transactions/${row.original.hash}`}>
          <code className="text-blue-600 hover:underline">
            {truncateHash(row.original.hash)}
          </code>
        </Link>
      )
    },
    {
      accessorKey: 'from_address',
      header: 'From',
      cell: ({ row }) => (
        <AddressLink address={row.original.from_address} />
      )
    },
    {
      accessorKey: 'to_address', 
      header: 'To',
      cell: ({ row }) => (
        <AddressLink address={row.original.to_address} />
      )
    },
    {
      accessorKey: 'value',
      header: 'Value',
      cell: ({ row }) => (
        <div>
          <div>{formatEther(row.original.value)} ETH</div>
          <div className="text-sm text-gray-500">
            ${formatUSD(row.original.value_usd)}
          </div>
        </div>
      )
    },
    {
      accessorKey: 'status',
      header: 'Status',
      cell: ({ row }) => (
        <StatusBadge status={row.original.status} />
      )
    },
    {
      accessorKey: 'timestamp',
      header: 'Age',
      cell: ({ row }) => (
        <TimeAgo timestamp={row.original.timestamp} />
      )
    }
  ];

  return (
    <DataTable
      columns={columns}
      data={transactions}
      loading={loading}
      searchable
      exportable
    />
  );
}

// components/explorer/TransactionDetails.tsx
export function TransactionDetails({ hash }: { hash: string }) {
  const { data: transaction } = useQuery({
    queryKey: ['transaction', hash],
    queryFn: () => api.getTransaction(hash)
  });

  const { data: receipt } = useQuery({
    queryKey: ['transaction-receipt', hash],
    queryFn: () => api.getTransactionReceipt(hash),
    enabled: !!transaction
  });

  return (
    <div className="space-y-6">
      {/* Transaction Overview */}
      <Card>
        <CardHeader>
          <CardTitle>Transaction Details</CardTitle>
        </CardHeader>
        <CardContent>
          <TransactionInfoGrid transaction={transaction} />
        </CardContent>
      </Card>

      {/* Transaction Receipt */}
      {receipt && (
        <Card>
          <CardHeader>
            <CardTitle>Execution Details</CardTitle>
          </CardHeader>
          <CardContent>
            <TransactionReceiptGrid receipt={receipt} />
          </CardContent>
        </Card>
      )}

      {/* Event Logs */}
      {receipt?.logs && receipt.logs.length > 0 && (
        <Card>
          <CardHeader>
            <CardTitle>Event Logs</CardTitle>
          </CardHeader>
          <CardContent>
            <EventLogsTable logs={receipt.logs} />
          </CardContent>
        </Card>
      )}
    </div>
  );
}
```

#### **Wallet Directory Components**
```typescript
// components/explorer/WalletDirectory.tsx
export function WalletDirectory() {
  const [filters, setFilters] = useState({
    type: 'all',
    minBalance: '',
    sortBy: 'balance'
  });

  const { data: wallets, isLoading } = useQuery({
    queryKey: ['wallets', filters],
    queryFn: ({ queryKey }) => api.getWallets(queryKey[1])
  });

  return (
    <div className="space-y-6">
      {/* Wallet Stats */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <StatsCard
          title="Total Wallets"
          value={wallets?.stats.total || 0}
          icon={Wallet}
        />
        <StatsCard
          title="Active (24h)"
          value={wallets?.stats.active24h || 0}
          icon={Activity}
        />
        <StatsCard
          title="Contract Wallets"
          value={wallets?.stats.contracts || 0}
          icon={Code}
        />
        <StatsCard
          title="Total Balance"
          value={formatEther(wallets?.stats.totalBalance || 0)}
          icon={DollarSign}
        />
      </div>

      {/* Filters */}
      <Card>
        <CardContent className="pt-6">
          <WalletFilters filters={filters} onFiltersChange={setFilters} />
        </CardContent>
      </Card>

      {/* Wallet Table */}
      <Card>
        <CardContent>
          <WalletTable wallets={wallets?.data || []} loading={isLoading} />
        </CardContent>
      </Card>
    </div>
  );
}

// components/explorer/WalletDetails.tsx
export function WalletDetails({ address }: { address: string }) {
  const { data: wallet } = useQuery({
    queryKey: ['wallet', address],
    queryFn: () => api.getWallet(address)
  });

  const { data: transactions } = useQuery({
    queryKey: ['wallet-transactions', address],
    queryFn: () => api.getWalletTransactions(address)
  });

  const { data: tokenBalances } = useQuery({
    queryKey: ['wallet-tokens', address],
    queryFn: () => api.getWalletTokens(address)
  });

  return (
    <div className="space-y-6">
      {/* Wallet Overview */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center space-x-2">
            <Wallet className="w-5 h-5" />
            <span>Wallet Overview</span>
          </CardTitle>
        </CardHeader>
        <CardContent>
          <WalletOverview wallet={wallet} />
        </CardContent>
      </Card>

      {/* Token Balances */}
      <Card>
        <CardHeader>
          <CardTitle>Token Balances</CardTitle>
        </CardHeader>
        <CardContent>
          <TokenBalanceTable balances={tokenBalances} />
        </CardContent>
      </Card>

      {/* Transaction History */}
      <Card>
        <CardHeader>
          <CardTitle>Transaction History</CardTitle>
        </CardHeader>
        <CardContent>
          <TransactionTable transactions={transactions} />
        </CardContent>
      </Card>
    </div>
  );
}
```

### **Analytics & Visualization Components**

#### **Network Analytics Dashboard**
```typescript
// components/analytics/NetworkDashboard.tsx
export function NetworkDashboard() {
  const { data: networkStats } = useQuery({
    queryKey: ['network-stats'],
    queryFn: api.getNetworkStats,
    refetchInterval: 30000 // Update every 30 seconds
  });

  const { data: chartData } = useQuery({
    queryKey: ['network-charts', '24h'],
    queryFn: () => api.getNetworkChartData('24h')
  });

  return (
    <div className="space-y-6">
      {/* Real-time Network Stats */}
      <div className="grid grid-cols-1 md:grid-cols-5 gap-4">
        <StatsCard
          title="Latest Block"
          value={networkStats?.latestBlock || 0}
          change={`+${networkStats?.blocksLast24h || 0}`}
          icon={Blocks}
        />
        <StatsCard
          title="Block Time"
          value={`${networkStats?.avgBlockTime || 0}s`}
          change={networkStats?.blockTimeChange}
          icon={Clock}
        />
        <StatsCard
          title="TPS"
          value={networkStats?.transactionsPerSecond || 0}
          change={networkStats?.tpsChange}
          icon={Zap}
        />
        <StatsCard
          title="Gas Price"
          value={formatGwei(networkStats?.avgGasPrice || 0)}
          change={networkStats?.gasPriceChange}
          icon={Fuel}
        />
        <StatsCard
          title="Network Health"
          value={`${networkStats?.healthScore || 100}%`}
          change={networkStats?.healthChange}
          icon={Shield}
        />
      </div>

      {/* Charts */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <Card>
          <CardHeader>
            <CardTitle>Block Production</CardTitle>
          </CardHeader>
          <CardContent>
            <TimeSeriesChart
              data={chartData?.blockProduction}
              xKey="timestamp"
              yKey="blocksPerHour"
              color="#3B82F6"
            />
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Transaction Volume</CardTitle>
          </CardHeader>
          <CardContent>
            <TimeSeriesChart
              data={chartData?.transactionVolume}
              xKey="timestamp"
              yKey="transactionsPerHour"
              color="#10B981"
            />
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Gas Usage</CardTitle>
          </CardHeader>
          <CardContent>
            <AreaChart
              data={chartData?.gasUsage}
              xKey="timestamp"
              yKey="gasUsed"
              color="#F59E0B"
            />
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Network Difficulty</CardTitle>
          </CardHeader>
          <CardContent>
            <LineChart
              data={chartData?.difficulty}
              xKey="timestamp"
              yKey="difficulty"
              color="#8B5CF6"
            />
          </CardContent>
        </Card>
      </div>

      {/* Network Health Details */}
      <Card>
        <CardHeader>
          <CardTitle>Network Health Metrics</CardTitle>
        </CardHeader>
        <CardContent>
          <NetworkHealthGrid stats={networkStats} />
        </CardContent>
      </Card>
    </div>
  );
}
```

## 🔄 **Integration Architecture**

### **Admin Panel Integration**

```typescript
// Shared Data Sources Between Admin Panel and PendScan
class SharedDataService {
  // Blockchain data shared between admin panel and PendScan
  async getBlockchainOverview() {
    return {
      latestBlock: await this.getLatestBlock(),
      networkStats: await this.getNetworkStats(),
      recentTransactions: await this.getRecentTransactions(10),
      poolMetrics: await this.getPoolMetrics(),
      userActivity: await this.getUserActivity()
    };
  }

  // Investment pool data for both interfaces
  async getPoolAnalytics(poolId?: string) {
    const query = poolId 
      ? 'WHERE pool_address = $1' 
      : '';
    
    const params = poolId ? [poolId] : [];

    return await db.query(`
      SELECT 
        pool_address,
        pool_name,
        total_value_locked,
        participant_count,
        transaction_volume_24h,
        apy,
        performance_metrics
      FROM pool_analytics 
      ${query}
      ORDER BY timestamp DESC
      LIMIT 1
    `, params);
  }

  // User analytics for admin panel user management
  async getUserBlockchainActivity(userAddress) {
    return await db.query(`
      SELECT 
        DATE_TRUNC('day', timestamp) as date,
        COUNT(*) as transaction_count,
        SUM(value) as total_value,
        AVG(gas_used) as avg_gas_used
      FROM transactions 
      WHERE from_address = $1 OR to_address = $1
      GROUP BY DATE_TRUNC('day', timestamp)
      ORDER BY date DESC
      LIMIT 30
    `, [userAddress]);
  }
}
```

### **Real-time Data Synchronization**

```typescript
// WebSocket service for real-time updates across applications
class WebSocketService {
  constructor() {
    this.connections = new Map();
    this.rooms = new Map(); // Group connections by interest
  }

  // Subscribe clients to specific data streams
  subscribe(clientId, room, websocket) {
    this.connections.set(clientId, websocket);
    
    if (!this.rooms.has(room)) {
      this.rooms.set(room, new Set());
    }
    this.rooms.get(room).add(clientId);

    // Send initial data
    this.sendInitialData(clientId, room);
  }

  // Broadcast updates to subscribed clients
  broadcast(room, event, data) {
    const roomConnections = this.rooms.get(room);
    
    if (roomConnections) {
      roomConnections.forEach(clientId => {
        const ws = this.connections.get(clientId);
        if (ws && ws.readyState === WebSocket.OPEN) {
          ws.send(JSON.stringify({ event, data, timestamp: Date.now() }));
        }
      });
    }
  }

  // Room-based data streaming
  async sendInitialData(clientId, room) {
    const ws = this.connections.get(clientId);
    if (!ws) return;

    let initialData;
    
    switch (room) {
      case 'blocks':
        initialData = await api.getLatestBlocks(10);
        break;
      case 'transactions':
        initialData = await api.getRecentTransactions(25);
        break;
      case 'network-stats':
        initialData = await api.getNetworkStats();
        break;
      case 'pools':
        initialData = await api.getPoolMetrics();
        break;
    }

    ws.send(JSON.stringify({
      event: 'initial_data',
      room,
      data: initialData,
      timestamp: Date.now()
    }));
  }
}
```

---

*This architecture provides a modern, scalable foundation for PendScan that integrates seamlessly with the admin panel and database infrastructure while delivering enhanced user experience and advanced analytics capabilities.* 