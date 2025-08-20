# Local Besu Network – Quick Guide

> **Purpose**: Spin-up a multi-node Ethereum (Besu) network for testing Pend smart-contracts and relayer logic.
>
> This guide assumes you cloned the repo and have `besu-network/` assets checked-in (genesis JSON, static-nodes, scripts, docker compose, etc.).

---

## ⚡ TL;DR (Docker-Compose)
```bash
cd besu-network
docker compose up -d               # spins 4 validator nodes + 1 explorer
```

Services started:
| Service | Port | Purpose |
|---------|------|---------|
| node1   | 8545 | JSON-RPC (validator) |
| node2   | 8546 | JSON-RPC (validator) |
| node3   | 8547 | JSON-RPC (validator) |
| node4   | 8548 | JSON-RPC (validator) |
| explorer| 25000 | Block Explorer (optional) |

After the containers are **healthy**, point Hardhat, Relayer, or the dApp RPC to `http://127.0.0.1:8545`.

---

## 🏗️ Directory Layout
```
besu-network/
  docker-compose.yml       # 4 Besu nodes + explorer service
  genesis.json             # Clique PoA genesis (blockTime = 5s)
  node1/
    config.toml            # per-node keys + ports
    data/                  # chain data + keystore (persisted)
  node2/
  node3/
  node4/
```

> **Note**: `besu-bin/` is included for those who prefer running Besu without Docker.

---

## 🔧 Manual (Binary) Setup
1. Install Besu ≥ 23.x (`brew install hyperledger/besu/besu` or grab from Hyperledger site).
2. Initialise each node:
   ```bash
   besu --data-path=node1/data init genesis.json
   besu --data-path=node2/data init genesis.json
   # … repeat for node3 / node4
   ```
3. Start validator nodes in separate terminals:
   ```bash
   besu --config-file=node1/config.toml
   ```

---

## 🧩 Connecting Hardhat
`.env`
```
RPC_URL=http://127.0.0.1:8545
CHAIN_ID=1337
```
`hardhat.config.ts`
```ts
module.exports = {
  networks: {
    besu: {
      url: process.env.RPC_URL,
      chainId: parseInt(process.env.CHAIN_ID || '1337'),
      // account mnemonic / private keys here (prefunded from genesis)
    }
  }
}
```

Run deployments/tests:
```bash
npx hardhat deploy --network besu
```

---

## 🎯 Typical Workflow
1. `docker compose up`  – start chain.
2. `hardhat deploy`      – deploy contracts.
3. `server/` Relayer ENV – point to Besu RPC & contract addresses.
4. `wallet-ui`           – runs against `localhost:8545` via relayer.

---

## 🚨 Troubleshooting
| Symptom | Fix |
|---------|-----|
| `connection refused` | Wait for containers health-check or correct RPC port |
| `nonce too low`      | Reset chain (`docker compose down -v`) or bump account nonce |
| Explorer empty       | Check that explorer uses WS endpoint of **node1** |

---

## 📄 License
MIT 