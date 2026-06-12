# Track: Base Sepolia

Deploy the DeFi staking workshop on **Base Sepolia** (chainId `84532`).

## Quick start

```bash
cd tracks/base

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
- https://www.ethereum-ecosystem.com/faucets/base-sepolia
- https://bwarelabs.com/faucets/base-sepolia

## Network

| | |
|---|---|
| Chain ID | `84532` |
| RPC | `https://sepolia.base.org` |
| Explorer | https://sepolia.basescan.org |
| Wagmi chain | `baseSepolia` |

## Curriculum

See [`docs/README.md`](docs/README.md) for the full 8-session index.
