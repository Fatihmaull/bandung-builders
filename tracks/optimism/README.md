# Track: OP Sepolia (Optimism) — **Default cohort track**

Deploy the DeFi staking workshop on **OP Sepolia** (chainId `11155420`) — OP Stack / Superchain. This is the recommended path for Bandung Builders Cohort 01.

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

## Presentations

Interactive slides: [`presentations/optimism/`](../presentations/optimism/)

Entry point [`presentations/index.html`](../presentations/index.html) redirects to the Optimism track by default. Append `?tracks=1` to compare all tracks first.
