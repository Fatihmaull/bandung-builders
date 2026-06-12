# Track: Arbitrum Sepolia

Deploy the DeFi staking workshop on **Arbitrum Sepolia** (chainId `421614`).

## Quick start

```bash
cd tracks/arbitrum

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

## Faucet (no mainnet activity required)

- https://ethfaucet.com/
- https://faucet.zalalena.com/arbitrum

## Network

| | |
|---|---|
| Chain ID | `421614` |
| RPC | `https://sepolia-rollup.arbitrum.io/rpc` |
| Explorer | https://sepolia.arbiscan.io |
| Wagmi chain | `arbitrumSepolia` |

## Curriculum

See [`docs/README.md`](docs/README.md) for the full 8-session index (network references updated for this track).
