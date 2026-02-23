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
