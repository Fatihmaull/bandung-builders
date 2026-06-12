# Track: OP Sepolia (Optimism)

Deploy the DeFi staking workshop on **OP Sepolia** (chainId `11155420`) — OP Stack / Superchain.

## Quick start

```bash
cd tracks/optimism

cp .env.example .env
cp frontend/.env.local.example frontend/.env.local
# Fill PRIVATE_KEY, API keys, WalletConnect projectId

cd contracts
forge install
forge build
forge test -vvv

cd ../frontend
pnpm install
pnpm dev
```

## Faucet (GitHub login, no mainnet ETH required)

- https://console.optimism.io/faucet

## Network

| | |
|---|---|
| Chain ID | `11155420` |
| RPC | `https://sepolia.optimism.io` |
| Explorer | https://sepolia-optimism.etherscan.io |
| Wagmi chain | `optimismSepolia` |

## Curriculum

See [`docs/README.md`](docs/README.md) for the full 8-session index (network references updated for this track).
