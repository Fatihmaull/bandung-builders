# Bandung L2 — DeFi Staking Workshop Monorepo

> **Multi-track monorepo** for a 1-month, 8-session intensive workshop in Bandung, Indonesia. The **default cohort track is OP Sepolia** (Optimism / Superchain). Base and Arbitrum tracks remain available for exploration.

---

## Default track: OP Sepolia

New builders start here:

| | |
|---|---|
| **Code** | [`tracks/optimism/`](tracks/optimism/) |
| **Presentations** | [Live slides](https://presentations-pi-blue.vercel.app/optimism/) · [`presentations/optimism/`](presentations/optimism/) |
| **Faucet** | [Superchain Faucet](https://console.optimism.io/faucet) (GitHub login) |
| **Chain ID** | `11155420` |

---

## Other tracks (optional)

| Track | Folder | Network | Chain ID |
| ----- | ------ | ------- | -------- |
| **Optimism** (default) | [`tracks/optimism/`](tracks/optimism/) | OP Sepolia | `11155420` |
| **Base** | [`tracks/base/`](tracks/base/) | Base Sepolia | `84532` |
| **Arbitrum** | [`tracks/arbitrum/`](tracks/arbitrum/) | Arbitrum Sepolia | `421614` |

Each track contains its own `contracts/`, `frontend/`, and `docs/`. Solidity code is identical; only network config differs.

Full comparison and faucet links: [`tracks/README.md`](tracks/README.md).

---

## Quick start (default: Optimism track)

```bash
git clone <YOUR_FORK_URL> bandungbuildmaterial
cd bandungbuildmaterial/tracks/optimism

cp .env.example .env
cp frontend/.env.local.example frontend/.env.local

cd contracts && forge install && forge build && forge test -vvv
cd ../frontend && pnpm install && pnpm dev
```

Presentations: open [`presentations/index.html`](presentations/index.html) — redirects to the OP Sepolia learning path by default. Use `?tracks=1` to compare all tracks first.

From repo root:

```bash
pnpm dev:optimism   # default
pnpm dev:base
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
├── presentations/               Slide decks — default: presentations/optimism/ (index auto-redirects)
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

**Facilitators:** read [`guide.md`](guide.md) for pre-session checklist, live URLs, and agent setup on a new machine.

---

## License

MIT for code. Curriculum docs CC-BY-4.0.
