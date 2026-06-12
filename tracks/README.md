# Workshop tracks

This monorepo ships **three parallel L2 tracks**. Each track is a self-contained workspace with its own `contracts/`, `frontend/`, and `docs/`.

| Track | Folder | Network | Chain ID | Best for |
| ----- | ------ | ------- | -------- | -------- |
| **Base** | [`base/`](base/) | Base Sepolia | `84532` | Original cohort branding; OP Stack via Coinbase |
| **Optimism** | [`optimism/`](optimism/) | OP Sepolia | `11155420` | Superchain Faucet (GitHub); OP Stack narrative |
| **Arbitrum** | [`arbitrum/`](arbitrum/) | Arbitrum Sepolia | `421614` | Richest L2 docs; ethfaucet.com |

## Pick your track

1. Choose one folder under `tracks/`.
2. Follow that track's [`README.md`](base/README.md).
3. Work **only inside your track** during the workshop — do not mix addresses or env files across tracks.

## Shared assets

- [`presentations/`](../presentations/) — slide decks (network-specific details may differ; follow your track's docs for RPC/faucet/explorer links)
- Root [`README.md`](../README.md) — monorepo overview

## Root scripts

From the repo root:

```bash
pnpm dev:base
pnpm dev:optimism
pnpm dev:arbitrum

pnpm test:base
pnpm test:optimism
pnpm test:arbitrum
```

Solidity source code is identical across tracks. Only network configuration, env vars, and curriculum network references differ.
