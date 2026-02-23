# Flash-Triangle Arbitrage Bot 🚀

A high-performance, MEV-resistant triangular arbitrage engine built with **Foundry** and **Node.js**. This system utilizes **Flash Swaps** on the BNB Smart Chain (BSC) to execute risk-free triangular trades without requiring upfront capital.

## 🏗 System Architecture
* **The Engine (Solidity)**: `src/FlashTriangle.sol` - A gas-optimized smart contract that handles the flashloan callback, triangular swaps, and profit distribution.
* **The Brain (Node.js)**: `bot/brain.js` - A low-latency bot that monitors the blockchain via WebSockets and triggers the engine when a profitable gap is detected.
* **The Servant (Gas Wallet)**: A dedicated wallet with a small BNB balance ($7) used strictly for transaction fees.
* **The Boss (Profit Wallet)**: Your secure cold wallet that receives all generated profits automatically.

---

## 🛠 Prerequisites
* [Foundry](https://book.getfoundry.sh/getting-started/installation) (Forge & Cast)
* [Node.js](https://nodejs.org/) (v18+)
* [PM2](https://pm2.keymetrics.io/) (`npm install -g pm2`)
* [Alchemy](https://www.alchemy.com/) API Key for BNB Mainnet

---

## 🚀 Installation & Setup

### 1. Initialize Environment
Create a `.env` file in the root directory:
```env
# RPC & WSS Configuration
RPC_URL=[https://bnb-mainnet.g.alchemy.com/v2/YOUR_API_KEY](https://bnb-mainnet.g.alchemy.com/v2/YOUR_API_KEY)
ALCHEMY_WSS_URL=wss://[bnb-mainnet.g.alchemy.com/v2/YOUR_API_KEY](https://bnb-mainnet.g.alchemy.com/v2/YOUR_API_KEY)

# Wallet Configuration (Ensure 0x prefix for Private Key)
SERVANT_PRIVATE_KEY=0x...
SERVANT_ADDRESS=0x...
BOSS_ADDRESS=0x...

# Deployment Address (Fill after Step 2)
CONTRACT_ADDRESS=0x...

##2. Deploy the Arb-Engine
Deploy the smart contract to the BNB Mainnet:
```
source .env
forge script script/Deploy.s.sol --rpc-url $RPC_URL --broadcast --verify
```

##3. Simulation & Local Testing (Anvil)
To test without spending real BNB, use a Mainnet Fork:
```
# Terminal 1: Start the Fork
anvil --fork-url $RPC_URL --chain-id 56

# Terminal 2: Test Deployment
forge script script/Deploy.s.sol --rpc-url [http://127.0.0.1:8545](http://127.0.0.1:8545) --broadcast
```

##4. Launch the Bot
Run the bot independently in the background using PM2:
```
npm install
pm2 start bot/brain.js --name "arb-bot"
pm2 logs arb-bot
```

###🛡 Security Logic
Atomic Protection: The contract uses a require(profit > 0) guard to revert loss-making trades.

Access Control: Only the servant can trigger trades; only the boss can receive funds.

MEV Safety: Uses private RPCs to bypass the public mempool.

```
---

### 2. Environment Template (`.env.example`)
Include this so you know which variables to fill without exposing your real keys.

```markdown
# RPC Links
RPC_URL=https://bnb-mainnet.g.alchemy.com/v2/YOUR_API_KEY
ALCHEMY_WSS_URL=wss://bnb-mainnet.g.alchemy.com/v2/YOUR_API_KEY

# Wallets
SERVANT_PRIVATE_KEY=0x_YOUR_PRIVATE_KEY_HERE
SERVANT_ADDRESS=0x_YOUR_PUBLIC_ADDRESS_HERE
BOSS_ADDRESS=0x_YOUR_BOSS_ADDRESS_HERE

# Deployment
CONTRACT_ADDRESS=0x_FILL_AFTER_DEPLOYMENT
```

### 3. Git Ignore (.gitignore)
This is the most important file. It prevents you from accidentally leaking your private keys to GitHub.
```
# Layout
.env
.env.local
.env.*.local

# Foundry
out/
cache/
broadcast/
/lib

# Node
node_modules/
npm-debug.log*

# OS
.DS_Store
Thumbs.db
```

###4. Deployment Script (script/Deploy.s.sol)
The finalized script for your specific constructor.

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {FlashTriangle} from "../src/FlashTriangle.sol";

contract DeployFlashTriangle is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("SERVANT_PRIVATE_KEY");
        address servant = vm.envAddress("SERVANT_ADDRESS");
        address boss = vm.envAddress("BOSS_ADDRESS");

        vm.startBroadcast(deployerPrivateKey);
        new FlashTriangle(servant, boss);
        vm.stopBroadcast();
    }
}
```

## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
