# Bandung Base L2 — DeFi Staking Workshop Monorepo

> **The Single Source of Truth** for a 1-month, 8-session intensive workshop in Bandung, Indonesia, training top-tier developers to ship a hackathon-ready DeFi Staking Protocol on **Base Sepolia (L2)**.

---

## 0. Who This Repo Is For

You are one of 10–15 builders selected for the Bandung Base Builders cohort. By the end of Week 4, you will:

1. Understand Base L2 rollup mechanics at the EVM level.
2. Have authored, tested (with `forge`), deployed, and **verified on Basescan** a non-trivial Solidity staking protocol.
3. Have a Next.js frontend wired to your contract via Wagmi/Viem/RainbowKit.
4. Have a hackathon-grade pitch deck and Go-To-Market plan ready for Demo Day.

You should leave this workshop able to walk into any global Base hackathon and ship.

---

## 1. Quick Start (5-Minute Path)

```bash
# 1. Clone
git clone <YOUR_FORK_URL> bandungbuildmaterial
cd bandungbuildmaterial

# 2. Configure env (copy + fill)
cp .env.example .env
cp frontend/.env.local.example frontend/.env.local

# 3. Contracts (Foundry)
cd contracts
forge install
forge build
forge test -vvv

# 4. Frontend (Next.js)
cd ../frontend
pnpm install   # or: npm install
pnpm dev
```

Detailed OS-agnostic setup lives in [`docs/00-prerequisites.md`](docs/00-prerequisites.md).

---

## 2. Repository Layout

```
bandungbuildmaterial/
├── .cursorrules                    AI agent contract (Cursor reads automatically)
├── docs/system-prompt.md           Same content, for non-Cursor AI agents
├── contracts/                      Foundry project — Solidity, tests, scripts
├── frontend/                       Next.js 15 App Router — Wagmi + Viem + RainbowKit
└── docs/                           Curriculum, speaker notes, frameworks, rubrics
```

The repo is intentionally a **monorepo** because the contract ABI is a build artifact consumed by the frontend. Splitting them creates drift; keeping them together is one of the most important practical lessons of the workshop.

---

## 3. Curriculum Index (4 Weeks, 8 Sessions, 2.5 hr each)

| Week | Meet | Track          | Title                                          | Doc                                                                                              |
| ---- | ---- | -------------- | ---------------------------------------------- | ------------------------------------------------------------------------------------------------ |
| 1    | 1    | Non-Technical  | Kick-Off & EVM Blockchain Mechanism            | [docs/week-1/meet-1-kickoff-evm-narrative.md](docs/week-1/meet-1-kickoff-evm-narrative.md)       |
| 1    | 2    | Technical      | Fundamental EVM & Foundry Setup                | [docs/week-1/meet-2-foundry-setup.md](docs/week-1/meet-2-foundry-setup.md)                       |
| 2    | 3    | Non-Technical  | Ideasi Proyek & Design Thinking                | [docs/week-2/meet-3-design-thinking.md](docs/week-2/meet-3-design-thinking.md)                   |
| 2    | 4    | Technical      | Smart Contract Development (Solidity + Forge)  | [docs/week-2/meet-4-solidity-staking.md](docs/week-2/meet-4-solidity-staking.md)                 |
| 3    | 5    | Non-Technical  | DeFi Economics & Tokenomics Canvas             | [docs/week-3/meet-5-defi-tokenomics.md](docs/week-3/meet-5-defi-tokenomics.md)                   |
| 3    | 6    | Technical      | Frontend Connection (Viem, Wagmi, RainbowKit)  | [docs/week-3/meet-6-frontend-integration.md](docs/week-3/meet-6-frontend-integration.md)         |
| 4    | 7    | Non-Technical  | Pitching & Base Go-To-Market Strategy          | [docs/week-4/meet-7-pitch-deck.md](docs/week-4/meet-7-pitch-deck.md)                             |
| 4    | 8    | Technical      | Demo Day & Infrastructure                      | [docs/week-4/meet-8-deployment-checklist.md](docs/week-4/meet-8-deployment-checklist.md)         |

Full index with supporting artifacts (rubrics, canvases, questionnaires) lives in [`docs/README.md`](docs/README.md).

---

## 4. Tech Stack (Pinned)

| Layer            | Tool                                                   |
| ---------------- | ------------------------------------------------------ |
| L2               | **Base Sepolia** (chainId `84532`)                     |
| Contracts        | **Foundry** (forge, cast, anvil) + Solidity `^0.8.24`  |
| Standards        | **OpenZeppelin Contracts v5** (ReentrancyGuard, ERC20) |
| Frontend         | **Next.js 15** (App Router) + TypeScript + Tailwind v3 |
| Web3 integration | **Wagmi v2** + **Viem v2** + **RainbowKit v2**         |
| Async state      | **TanStack Query v5**                                  |
| Package manager  | `pnpm` recommended, `npm` supported                    |

Versions are intentionally pinned. Do not "upgrade to the latest" mid-workshop — it breaks reproducibility for everyone else.

---

## 5. AI Agent Instructions (Important)

This repo ships with [`.cursorrules`](.cursorrules) (also mirrored as [`docs/system-prompt.md`](docs/system-prompt.md)). Every attendee should keep these loaded by their local agent during coding sessions. They encode:

- The pinned tech stack & versions.
- Base Sepolia network constants.
- The Staking Protocol math invariants (so the AI does not invent reward formulas).
- File-placement rules (so the AI does not scatter contracts/hooks).
- Security guardrails (so the AI defaults to `SafeERC20`, `ReentrancyGuard`, etc.).

If you use Cursor, the file is read automatically. If you use Copilot / Cline / Continue, paste `docs/system-prompt.md` into your agent's system-prompt slot.

---

## 6. Workshop Rules of the Game (TL;DR)

Full document: [`docs/week-1/meet-1-rules-of-the-game.md`](docs/week-1/meet-1-rules-of-the-game.md).

1. **Ship over polish** in Weeks 1–3, **polish over ship** in Week 4.
2. **Every PR is reviewed by one peer** — no solo merges to `main`.
3. **Every contract change ships with a `forge test`** that proves the new behavior.
4. **No mainnet anything.** Base Sepolia only.
5. **AI is a co-pilot, not the pilot** — you must be able to explain every line you commit.

---

## 7. License

MIT for code (see [LICENSE](LICENSE) when added). Curriculum docs are CC-BY-4.0 — please credit the Bandung Base Builders cohort if you remix.
