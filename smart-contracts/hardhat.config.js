const fs = require('fs');
const path = require('path');
require('dotenv').config();
require('@nomicfoundation/hardhat-toolbox');

let { DEPLOYER_PRIVATE_KEY } = process.env;
if (!DEPLOYER_PRIVATE_KEY) {
  const keyPath = path.resolve(__dirname, '../besu-network/node1/data/key');
  if (fs.existsSync(keyPath)) {
    DEPLOYER_PRIVATE_KEY = fs.readFileSync(keyPath, 'utf8').trim();
  }
}

module.exports = {
  solidity: {
    version: '0.8.20',
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
      viaIR: true,
    },
  },
  paths: {
    sources: './contracts',
  },
  networks: {
    localhost: {
      url: 'http://127.0.0.1:8545',
      chainId: 31337,
    },
    pend: {
      url: 'http://127.0.0.1:8545',
      chainId: 7777,
      accounts: DEPLOYER_PRIVATE_KEY ? [DEPLOYER_PRIVATE_KEY] : [],
      gasPrice: 0,
      // Alternatively supply EIP-1559 fields
      // maxFeePerGas: 0,
      // maxPriorityFeePerGas: 0,
    },
    besu: {
      url: 'http://127.0.0.1:8545',
      chainId: 7777,
      accounts: DEPLOYER_PRIVATE_KEY ? [DEPLOYER_PRIVATE_KEY] : [],
      gasPrice: 0,
    },
  },
}; 