# Pend Chain - Hyperledger Besu Network

## 🌐 Network Overview

**Pend Chain** is a private Hyperledger Besu blockchain network running IBFT2 consensus with 5 validator nodes.

### Network Specifications
- **Network Name**: Pend Chain
- **Chain ID**: 7777
- **Consensus**: IBFT2 (Istanbul Byzantine Fault Tolerance)
- **Block Time**: 5 seconds
- **Validator Nodes**: 5 nodes
- **Network Type**: Private/Permissioned

## 🏗️ Network Architecture

### Node Configuration
| Node | Container | RPC Port | P2P Port | IP Address |
|------|-----------|----------|----------|------------|
| Node 1 | besu-node1 | 8545 | 30301 | 172.25.0.11 |
| Node 2 | besu-node2 | 8546 | 30302 | 172.25.0.12 |
| Node 3 | besu-node3 | 8547 | 30303 | 172.25.0.13 |
| Node 4 | besu-node4 | 8548 | 30304 | 172.25.0.14 |
| Node 5 | besu-node5 | 8549 | 30305 | 172.25.0.15 |

### IBFT2 Validators
The network uses 5 validator addresses extracted from the genesis extraData:
- `0x3137a8e097779467d7593ac821858a8e116188f7`
- `0xfe61938eaa9059e48c1be3b03a9e9f20b16f138b`
- `0xc77a1ab19c50ea6040f3033835f1ee3a7cd8693e`
- `0xecdbdcaf950e73a9fecde5102054022eb5e049ba`
- `0xeaf4197108dd5810ec0f6036ee0e6e77621a2e39`

## 🚀 Quick Start

### Option 1: Docker Compose (Recommended)
```bash
# Start all 5 nodes
cd besu-network
docker compose up -d

# Check node status
docker compose ps

# View logs
docker compose logs -f node1

# Stop network
docker compose down
```

### Option 2: Manual Binary Execution
```bash
# Install Besu using Homebrew (recommended)
brew install hyperledger/besu/besu

# Or download from official releases
# https://github.com/hyperledger/besu/releases/tag/25.4.1

# Then run with your genesis file
besu --data-path=node1/data --genesis-file=config/genesis.json
```

## 📁 Directory Structure

```
besu-network/
├── docker-compose.yml           # 5-node Docker configuration
├── config/
│   ├── genesis.json            # Network genesis (Chain ID 7777)
│   └── static-nodes.json       # Node discovery configuration
├── node1-5/                    # Individual node data directories
│   └── data/                   # Blockchain data, keys, and metadata
├── ibft-genesis/               # Validator key generation artifacts
│   ├── genesis.json           # Original IBFT genesis template
│   └── keys/                  # Validator private/public keys
└── scripts/                   # Network management scripts

Note: Besu binaries not included - install via Homebrew or download from:
https://github.com/hyperledger/besu/releases/tag/25.4.1
```

## ⚙️ Network Configuration Details

### Genesis Configuration
```json
{
  "config": {
    "chainId": 7777,
    "ibft2": {
      "blockperiodseconds": 5,
      "epochlength": 30000,
      "requesttimeoutseconds": 10
    },
    "zeroBaseFee": true
  },
  "gasLimit": "0x1fffffffffffff",
  "alloc": {
    "0x23aeda6cf6de70ecffe1c2486e2b7e095a70f393": {
      "balance": "0xD3C21BCECCEDA1000000"
    }
  }
}
```

### Docker Network
- **Subnet**: 172.25.0.0/16
- **Bridge Network**: Isolated container network
- **Static IPs**: Each node has a fixed IP address

### Node Features
- **RPC APIs**: ADMIN, ETH, NET, PERM, IBFT
- **Gas Configuration**: Zero gas prices for development
- **CORS**: Enabled for web application access
- **Host Allowlist**: Open for development (*)

## 🔧 Advanced Usage

### Individual Node Management
```bash
# Start specific node
docker compose up node1

# Execute commands on running node
docker exec -it besu-node1 besu --help

# View node-specific logs
docker logs besu-node1 -f
```

### Network Operations
```bash
# Connect to primary RPC endpoint
curl -X POST --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
  http://localhost:8545

# Check IBFT validator status
curl -X POST --data '{"jsonrpc":"2.0","method":"ibft_getValidatorsByBlockNumber","params":["latest"],"id":1}' \
  http://localhost:8545

# Get network peer information
curl -X POST --data '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":1}' \
  http://localhost:8545
```

### Data Persistence
- Node data persists in `./nodeX/data/` directories
- Blockchain state survives container restarts
- Database metadata and version tracking included

## 🔒 Security Configuration

### Validator Keys
- Each validator has cryptographic key pairs in `ibft-genesis/keys/`
- Private keys are embedded in node data directories
- Public keys define validator set in genesis extraData

### Network Isolation
- Private Docker bridge network (172.25.0.0/16)
- No external connectivity required for consensus
- RPC endpoints exposed only on localhost

### Development Security
⚠️ **Warning**: This configuration is for development only:
- Zero gas prices
- Open CORS policy
- Unrestricted host allowlist
- Private keys included in repository

## 📊 Monitoring & Debugging

### Health Checks
```bash
# Check all nodes are running
docker compose ps

# Verify consensus participation
for port in 8545 8546 8547 8548 8549; do
  echo "Node $port block height:"
  curl -s -X POST --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
    http://localhost:$port | jq -r '.result'
done
```

### Common Issues
1. **Port Conflicts**: Ensure ports 8545-8549 and 30301-30305 are available
2. **Permission Issues**: Check Docker daemon permissions
3. **Genesis Mismatch**: Verify all nodes use identical genesis.json
4. **Network Partitioning**: Ensure static-nodes.json is consistent

## 🔄 Maintenance

### Clean Reset
```bash
# Stop network and remove data
docker compose down
sudo rm -rf node*/data/database node*/data/caches

# Restart fresh network
docker compose up -d
```

### Updates
- Besu version: Update image tag in docker-compose.yml
- Configuration: Modify genesis.json (requires network reset)
- Validator set: Update extraData and static-nodes.json

## 🌐 Integration

### RPC Endpoints
- **Primary**: http://localhost:8545 (Node 1)
- **Load Balancing**: Use all endpoints 8545-8549
- **WebSocket**: Add `--rpc-ws-enabled` for real-time subscriptions

### Smart Contract Deployment
```bash
# Example using ethers.js
const provider = new ethers.JsonRpcProvider('http://localhost:8545');
const wallet = new ethers.Wallet(PRIVATE_KEY, provider);
const contract = await factory.connect(wallet).deploy();
```

---

**Production Note**: For production deployment, implement proper key management, access controls, monitoring, and backup strategies.
