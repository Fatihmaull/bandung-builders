# Bandung L2 — DeFi Staking Workshop Monorepo

> **Multi-track monorepo** for a 1-month, 8-session intensive workshop in Bandung, Indonesia. Builders ship a hackathon-ready DeFi Staking Protocol on **one of three L2 testnets**.

---

## Choose your track

| Track | Folder | Network | Chain ID |
| ----- | ------ | ------- | -------- |
| **Base** | [`tracks/base/`](tracks/base/) | Base Sepolia | `84532` |
| **Optimism** | [`tracks/optimism/`](tracks/optimism/) | OP Sepolia | `11155420` |
| **Arbitrum** | [`tracks/arbitrum/`](tracks/arbitrum/) | Arbitrum Sepolia | `421614` |

Each track contains its own `contracts/`, `frontend/`, and `docs/`. Solidity code is identical; only network config differs.

Full comparison and faucet links: [`tracks/README.md`](tracks/README.md).

---

## Quick start (example: Base track)

```bash
git clone <YOUR_FORK_URL> bandungbuildmaterial
cd bandungbuildmaterial/tracks/base

cp .env.example .env
cp frontend/.env.local.example frontend/.env.local

cd contracts && forge install && forge build && forge test -vvv
cd ../frontend && pnpm install && pnpm dev
```

Swap `tracks/base` for `tracks/optimism` or `tracks/arbitrum` for other tracks.

From repo root you can also run:

```bash
pnpm dev:base
pnpm dev:optimism
pnpm dev:arbitrum
```

---

## Repository layout

```
bandungbuildmaterial/
├── .cursorrules                 Multi-track AI agent contract
├── tracks/
│   ├── base/                    Base Sepolia track
│   ├── optimism/                OP Sepolia track
│   └── arbitrum/                Arbitrum Sepolia track
├── presentations/               Slide decks — open presentations/index.html to pick a track
└── docs/                        (moved into each track)
```

---

## Curriculum (per track)

| Week | Meet | Track          | Title                                         |
| ---- | ---- | -------------- | --------------------------------------------- |
| 1    | 1    | Non-Technical  | Kick-Off & EVM Blockchain Mechanism           |
| 1    | 2    | Technical      | Fundamental EVM & Foundry Setup               |
| 2    | 3    | Non-Technical  | Ideasi Proyek & Design Thinking                 |
| 2    | 4    | Technical      | Smart Contract Development (Solidity + Forge) |
| 3    | 5    | Non-Technical  | DeFi Economics & Tokenomics Canvas            |
| 3    | 6    | Technical      | Frontend Connection (Viem, Wagmi, RainbowKit)   |
| 4    | 7    | Non-Technical  | Pitching & Go-To-Market Strategy              |
| 4    | 8    | Technical      | Demo Day & Infrastructure                     |

Index with rubrics and frameworks: `tracks/<your-track>/docs/README.md`.

---

## Tech stack (pinned)

| Layer            | Tool                                                   |
| ---------------- | ------------------------------------------------------ |
| L2               | Base / OP / Arbitrum Sepolia (pick one track)          |
| Contracts        | Foundry + Solidity `^0.8.24` + OpenZeppelin v5         |
| Frontend         | Next.js 15 + TypeScript + Tailwind v3                  |
| Web3             | Wagmi v2 + Viem v2 + RainbowKit v2                     |
| Async state      | TanStack Query v5                                      |

---

## AI agent instructions

Load [`.cursorrules`](.cursorrules) in Cursor (automatic). For other agents, paste the matching track's `docs/system-prompt.md`.

---

## License

MIT for code. Curriculum docs CC-BY-4.0.
