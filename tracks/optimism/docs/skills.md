# Bandung OP Builders — Session prerequisites (agent context)

> **Track:** `tracks/optimism/` (OP Sepolia, chainId `11155420`) — default cohort path.
> **Companion:** Always load [`system-prompt.md`](./system-prompt.md) or repo-root [`.cursorrules`](../../../.cursorrules) **in addition** to the section for your upcoming session.

---

## Cara import ke agent kamu

| Tool | Langkah |
| ---- | ------- |
| **Cursor** | Buka project → *Settings → Rules* → paste section sesi + `system-prompt.md`. Atau `@skills.md` di chat sebelum sesi. |
| **Continue / Cline / Aider** | Paste section sesi ke *system message* / *custom instructions*. |
| **GitHub Copilot Chat** | Paste section sesi ke *Instructions* di workspace settings. |
| **Claude / ChatGPT (project)** | Buat project "Bandung Builders" → paste `system-prompt.md` + section sesi sebagai project instructions. |

**Rutinitas:** Sebelum setiap Meet, copy **Global baseline** + **section Meet kamu** + **`system-prompt.md`**. Setelah sesi, ganti section ke Meet berikutnya.

**Verifikasi agent:** Tanya *"What network and track am I on, and what must I have done before today's session?"* — jawaban harus menyebut OP Sepolia / `tracks/optimism/` dan checklist sesi yang benar.

---

## Global baseline (before Meet 1 or combined Meet 1+2)

Load this block for **every** session until Meet 8.

### Hardware

- 8 GB RAM minimum (16 GB recommended).
- 10 GB free disk.
- Stable internet.

### Software — install and verify

| Tool | Target | Verify |
| ---- | ------ | ------ |
| Git | 2.40+ | `git --version` |
| Foundry | 0.2.0+ | `forge --version` |
| Node.js | 20.x or 22.x LTS | `node --version` |
| pnpm | 9.x | `pnpm --version` |
| Code editor | Cursor / VS Code / Zed | — |
| Wallet extension | MetaMask, Rabby, or Coinbase Wallet | fresh workshop wallet only |

**Windows:** prefer **WSL2 Ubuntu** for Foundry. Native Windows is a fallback path.

### Accounts (free)

| Account | URL | Needed by |
| ------- | --- | --------- |
| GitHub | github.com | Superchain Faucet (Meet 1 / combined session) |
| WalletConnect Cloud | cloud.walletconnect.com | Meet 6 (get `projectId` early if possible) |
| Etherscan API | etherscan.io/myapikey | Meet 8 (works for OP Sepolia verify) |

### Repo setup

```bash
git clone https://github.com/Fatihmaull/bandung-builders.git bandungbuildmaterial
cd bandungbuildmaterial/tracks/optimism
cp .env.example .env
cp frontend/.env.local.example frontend/.env.local
cd contracts
forge install
forge build
forge test -vvv
```

### Network constants (do not invent others)

```
chainId   : 11155420
RPC       : https://sepolia.optimism.io
Explorer  : https://sepolia-optimism.etherscan.io
Faucet    : https://console.optimism.io/faucet  (GitHub login)
Wagmi     : optimismSepolia
Work dir  : tracks/optimism/
```

### Agent rules for all sessions

- Target **OP Sepolia testnet only** — never suggest mainnet.
- Never hardcode contract addresses outside `frontend/src/lib/contracts.ts`.
- Every Solidity change requires a paired `forge test` change.
- Do not upgrade pinned stack versions unprompted (Solidity 0.8.24, OZ v5, Next 15, Wagmi v2).

---

## Combined Meet 1 + Meet 2 (2-hour cohort variant)

Use this section if your cohort runs **Meet 1 and Meet 2 in one 120-minute session**. Participant slides: [`meet-1-2-combined.html`](../../../presentations/optimism/meet-1-2-combined.html). Facilitator runbook: [`meet-1-2-combined-facilitator.html`](../../../presentations/optimism/meet-1-2-combined-facilitator.html).

### Before you arrive

**Must have:**

- [ ] Global baseline software installed (`forge`, `node`, `pnpm`, `git`).
- [ ] Wallet extension installed; workshop wallet created (**not** mainnet keys).
- [ ] GitHub account active (for Superchain Faucet in-room).
- [ ] Repo cloned to `tracks/optimism/`.

**Strongly recommended (saves 40 min in Blok 5):**

- [ ] `cd tracks/optimism/contracts && forge install && forge test -vvv` passes locally.
- [ ] `.env` and `frontend/.env.local` copied from examples.

**Can wait until after session (homework):**

- Skill mapping questionnaire (`week-1/meet-1-skill-mapping.md`).
- Rules of the Game signed copy (`week-1/meet-1-rules-of-the-game.md`).
- Boilerplate file-per-file walkthrough (`week-1/meet-2-boilerplate-walkthrough.md`).
- WalletConnect `projectId` in `.env.local`.
- OP Sepolia Etherscan API key.

### Success criteria when you leave

1. Can say: **"EVM = deterministic state machine"** (same input → same output on every node).
2. Wallet has **OP Sepolia ETH** (from Superchain Faucet).
3. **`forge test -vvv` green** on your laptop.

### Verify before leaving the room

```bash
cast chain-id --rpc-url https://sepolia.optimism.io          # expect 11155420
cast balance YOUR_ADDRESS --rpc-url https://sepolia.optimism.io  # > 0
cd tracks/optimism/contracts && forge test -vvv              # all pass
```

### Agent focus this session

Help with: Foundry install, `forge install` / Git SSH errors, reading `cast` output, explaining EVM/gas/accounts, OP Stack one-liner.

Defer: full Superchain economics, opcode/Merkle deep dives, frontend setup, WalletConnect, contract authoring.

---

## Meet 1 — Kick-off and EVM blockchain mechanism

| | |
| --- | --- |
| **Type** | Non-technical |
| **Duration** | 2.5 hr (or first half of combined 2 hr) |
| **Slides** | [`presentations/optimism/meet-1.html`](../../../presentations/optimism/meet-1.html) |
| **Prior sessions** | None |

### Prerequisites

**Software:** Global baseline — at minimum wallet + browser + notebook. Foundry **not required** in-room for standalone Meet 1, but install before Meet 2.

**Accounts:** GitHub (for faucet homework).

**Knowledge:** None required. Mixed Web2/Web3 cohort.

**Materials to read after (not before):** `week-1/meet-1-kickoff-evm-narrative.md`, `week-1/meet-1-rules-of-the-game.md`, `week-1/meet-1-skill-mapping.md`.

### Deliverables after Meet 1

- [ ] Signed / photographed Rules of the Game.
- [ ] Completed skill mapping questionnaire.
- [ ] Can explain EVM as deterministic state machine + L2 rollup in own words.

### Agent focus

Help with: conceptual EVM/L2/OP Stack explanations, glossary, homework doc navigation.

Do not: write production Solidity yet, deploy contracts, or skip to frontend.

---

## Meet 2 — Fundamental EVM and Foundry setup

| | |
| --- | --- |
| **Type** | Technical |
| **Duration** | 2.5 hr (or second half of combined 2 hr) |
| **Slides** | [`presentations/optimism/meet-2.html`](../../../presentations/optimism/meet-2.html) |
| **Prior sessions** | Meet 1 concepts (or combined session Block 1) |

### Prerequisites

**Must have before session:**

- [ ] `forge --version`, `node --version`, `pnpm --version` all work.
- [ ] Repo cloned; `tracks/optimism/contracts/` exists.
- [ ] Wallet with OP Sepolia ETH (Superchain Faucet).
- [ ] MetaMask (or equivalent) on **OP Sepolia** (chainId `11155420`).

**Env files:**

```bash
cp tracks/optimism/.env.example tracks/optimism/.env
cp tracks/optimism/frontend/.env.local.example tracks/optimism/frontend/.env.local
# PRIVATE_KEY optional for Meet 2; required by Meet 8
```

**Verify:**

```bash
cd tracks/optimism/contracts
forge install
forge build
forge test -vvv

cast chain-id --rpc-url https://sepolia.optimism.io
cast block-number --rpc-url https://sepolia.optimism.io
```

### Deliverables after Meet 2

- [ ] `forge test -vvv` passes locally.
- [ ] Completed `cast` field trip (chain-id, block-number, WETH `totalSupply`, own balance).
- [ ] Read boilerplate walkthrough (`week-1/meet-2-boilerplate-walkthrough.md`).

### Agent focus

Help with: `foundry.toml` (profile, rpc_endpoints, etherscan only), `cast` commands, `forge install` failures, interpreting test output.

Do not: rewrite staking contract logic (Meet 4), add frontend hooks (Meet 6).

---

## Meet 3 — Project ideation and design thinking

| | |
| --- | --- |
| **Type** | Non-technical |
| **Duration** | 2.5 hr |
| **Slides** | [`presentations/optimism/meet-3.html`](../../../presentations/optimism/meet-3.html) |
| **Prior sessions** | Meet 1 + Meet 2 complete |

### Prerequisites

**Must have:**

- [ ] `forge test -vvv` green (proves toolchain healthy).
- [ ] OP Sepolia wallet funded.
- [ ] Rules of the Game acknowledged.
- [ ] Basic comfort with repo layout (`tracks/optimism/contracts/`, `frontend/`, `docs/`).

**No new installs** required.

**Read before session (recommended):** `week-2/meet-3-bandung-problems.md` — skim the five Bandung problem briefs.

### Deliverables after Meet 3

- [ ] **One problem statement** (one paragraph) committed for Meet 4.
- [ ] EDIPT applied to a Web3 product (not just Web2 UX).
- [ ] Answer: staking is a **primitive**, not the product — what is the noun?

### Agent focus

Help with: problem framing, EDIPT, Bandung use cases, product narrative, pitch angles.

Do not: implement full staking contract during ideation session unless explicitly in homework.

---

## Meet 4 — Smart contract development (Solidity + Forge)

| | |
| --- | --- |
| **Type** | Technical |
| **Duration** | 2.5 hr |
| **Slides** | [`presentations/optimism/meet-4.html`](../../../presentations/optimism/meet-4.html) |
| **Prior sessions** | Meet 3 problem statement committed |

### Prerequisites

**Must have:**

- [ ] All Meet 2 toolchain checks passing.
- [ ] `forge test -vvv` green on **reference** repo state before editing.
- [ ] OpenZeppelin v5 in `contracts/lib/` (`forge install` done).
- [ ] Problem statement from Meet 3 written down (guides product story, not contract API).

**Files you will edit:**

- `contracts/src/StakingProtocol.exercise.sol` (or equivalent exercise file)
- `contracts/test/StakingProtocol.t.sol`

**Verify:**

```bash
cd tracks/optimism/contracts
forge build
forge test -vvv
```

### Deliverables after Meet 4

- [ ] `stake`, `withdraw`, `getReward` implemented with `updateReward`, `SafeERC20`, `ReentrancyGuard`, OZ v5 `Ownable`.
- [ ] Tests using `vm.prank`, `vm.warp`, `vm.expectRevert`.
- [ ] `forge test -vvv` green on **your** implementation.

### Agent focus

Help with: Synthetix-style reward math (`rewardPerTokenStored`, `1e18` precision), modifier order, Foundry tests, reading traces.

Hard rules: keep `1e18` precision factor; `nonReentrant` on balance mutators; `updateReward` before balance changes; pair every contract change with tests.

Do not: remove ReentrancyGuard, use raw `IERC20.transfer`, or target mainnet.

---

## Meet 5 — DeFi economics and tokenomics

| | |
| --- | --- |
| **Type** | Non-technical |
| **Duration** | 2.5 hr |
| **Slides** | [`presentations/optimism/meet-5.html`](../../../presentations/optimism/meet-5.html) |
| **Prior sessions** | Meet 4 contract + tests passing |

### Prerequisites

**Must have:**

- [ ] Working staking contract locally (`forge test` green).
- [ ] Can explain `earned(account)` at a high level (even if Meet 4 was guided).
- [ ] Meet 3 problem statement still valid for your project direction.

**Bring:** calculator or spreadsheet app.

**Read (recommended):** `week-3/meet-5-tokenomics-canvas.md`.

### Deliverables after Meet 5

- [ ] Completed **Tokenomics Canvas** for your problem (Supply, Vesting, Utility, Yield).
- [ ] Can derive `earned()` and APR from `rewardRate` + `totalStaked` on whiteboard.
- [ ] Chosen sustainable `rewardRate` rationale documented.

### Agent focus

Help with: APR/APY math, emissions runway, token supply schedules, economic sustainability critique.

Do not: change core accumulator math without explicit request; do not conflate APY marketing numbers with on-chain `rewardRate`.

---

## Meet 6 — Frontend connection (Viem, Wagmi, RainbowKit)

| | |
| --- | --- |
| **Type** | Technical |
| **Duration** | 2.5 hr |
| **Slides** | [`presentations/optimism/meet-6.html`](../../../presentations/optimism/meet-6.html) |
| **Prior sessions** | Meet 4 contract tests green; Meet 5 tokenomics direction set |

### Prerequisites

**Must have:**

- [ ] `pnpm install` succeeds in `tracks/optimism/frontend/`.
- [ ] **`NEXT_PUBLIC_WC_PROJECT_ID`** in `frontend/.env.local` (from WalletConnect Cloud).
- [ ] Contract tests still passing (`forge test -vvv`).
- [ ] Node 20+ and pnpm 9+.

**Optional but helpful:**

- Deployed contract addresses on OP Sepolia (can use placeholder addresses until Meet 8).
- `NEXT_PUBLIC_*_ADDRESS` vars in `.env.local` if already deployed.

**Verify:**

```bash
cd tracks/optimism/frontend
pnpm install
pnpm build
```

**Key files (do not duplicate config elsewhere):**

- `frontend/src/lib/wagmi.ts` — Wagmi config only here.
- `frontend/src/lib/contracts.ts` — addresses + ABIs only here.
- `frontend/src/hooks/use*.ts` — one hook, one concern.

### Deliverables after Meet 6

- [ ] Providers wired (`WagmiProvider`, `QueryClientProvider`, `RainbowKitProvider`).
- [ ] Read hooks for `balanceOf`, `earned`, `rewardRate`.
- [ ] Write flow for stake / withdraw / getReward with tx lifecycle UI.
- [ ] **`useApproveStake`** hook implemented by attendee.

### Agent focus

Help with: Wagmi v2 hooks, bigint end-to-end, `parseUnits`/`formatUnits` at UI boundary, RainbowKit on OP Sepolia only.

Hard rules: no `window.ethereum` direct calls; chain array pinned to `[optimismSepolia]`; no hardcoded addresses in components.

---

## Meet 7 — Pitching and OP Stack go-to-market

| | |
| --- | --- |
| **Type** | Non-technical |
| **Duration** | 2.5 hr |
| **Slides** | [`presentations/optimism/meet-7.html`](../../../presentations/optimism/meet-7.html) |
| **Prior sessions** | Meet 6 frontend runnable locally (`pnpm dev`) |

### Prerequisites

**Must have:**

- [ ] Local dApp demo path: `pnpm dev` → connect wallet → at least one tx flow rehearsed.
- [ ] Problem statement + tokenomics canvas from Meets 3 and 5.
- [ ] 7-slide pitch draft started (Google Slides / Keynote / Canva).

**Read:** `week-4/meet-7-pitch-deck.md`, `week-4/meet-7-gtm-base.md`.

**No new installs.**

### Deliverables after Meet 7

- [ ] 5-minute pitch script with 7-slide structure.
- [ ] ≤ 90 second live demo rehearsed twice with partner feedback.
- [ ] Single closing **ask** memorized.

### Agent focus

Help with: slide copy, demo script, GTM for low-gas L2 apps, Superchain narrative, judge-facing clarity.

Do not: scope-creep new features before Meet 8 deploy.

---

## Meet 8 — Demo day and deployment

| | |
| --- | --- |
| **Type** | Technical / execution |
| **Duration** | 2.5 hr |
| **Slides** | [`presentations/optimism/meet-8.html`](../../../presentations/optimism/meet-8.html) |
| **Prior sessions** | Meets 4, 6, 7 complete |

### Prerequisites

**Must have — pre-flight checklist:**

- [ ] `git status` clean; work pushed to remote.
- [ ] `cd tracks/optimism/contracts && forge test -vvv` passes.
- [ ] `cd tracks/optimism/frontend && pnpm build` succeeds.
- [ ] `tracks/optimism/.env` filled:
  - `OP_SEPOLIA_RPC_URL`
  - `PRIVATE_KEY` (testnet only)
  - `OP_ETHERSCAN_API_KEY`
- [ ] Deployer wallet ≥ **0.05 ETH** on OP Sepolia (Superchain Faucet).
- [ ] `frontend/.env.local`:
  - `NEXT_PUBLIC_WC_PROJECT_ID`
  - deployed `NEXT_PUBLIC_*_ADDRESS` values (updated after deploy)

**Accounts:**

- [ ] Vercel account (GitHub login) for frontend deploy.
- [ ] Etherscan API key for contract verification.

**Verify before deploy:**

```bash
cd tracks/optimism/contracts
source ../.env   # or equivalent on Windows
forge test -vvv

cd ../frontend
pnpm build
```

### Deliverables after Meet 8

- [ ] Contract **deployed and verified** on OP Sepolia Etherscan.
- [ ] Frontend **deployed on Vercel** pointing to deployed addresses.
- [ ] End-to-end smoke test on real OP Sepolia with real wallet.
- [ ] Backup demo video recorded.
- [ ] Demo Day pitch ready (`week-4/meet-8-judging-rubric.md`).

### Agent focus

Help with: `forge script` broadcast + verify flags, Vercel env vars, smoke test triage, verification failures.

Hard rules: OP Sepolia only; never commit `.env` or private keys; update `contracts.ts` after deploy.

---

## Quick reference — verify commands by session

| Session | Minimum green checks |
| ------- | -------------------- |
| Combined 1+2 | `forge test -vvv` + `cast balance` > 0 |
| Meet 1 | Conceptual (no terminal required) |
| Meet 2 | `forge test -vvv` + `cast chain-id` = 11155420 |
| Meet 3 | `forge test -vvv` still green |
| Meet 4 | `forge test -vvv` on **your** staking implementation |
| Meet 5 | Same + tokenomics canvas filled |
| Meet 6 | `pnpm build` + wallet connect locally |
| Meet 7 | `pnpm dev` demo rehearsed |
| Meet 8 | deploy + verify + Vercel + smoke test |

---

## Troubleshooting — agent triage cheatsheet

| Symptom | Likely fix |
| ------- | ---------- |
| `forge: command not found` | Install Foundry (`foundryup`); on Windows use WSL2 |
| `forge install` fails | Git/SSH — `forge install OpenZeppelin/openzeppelin-contracts@v5.0.2 --no-commit` |
| Tests fail after fresh clone | Run `forge install` in `contracts/` first |
| Faucet shows 0 balance | Wrong network in wallet — switch to OP Sepolia (11155420) |
| `pnpm` not found | `corepack enable && corepack prepare pnpm@9 --activate` |
| RainbowKit won't connect | Missing `NEXT_PUBLIC_WC_PROJECT_ID` in `.env.local` |
| Verify fails on deploy | Check `OP_ETHERSCAN_API_KEY` and `chain = 11155420` in `foundry.toml` |

---

## Other L2 tracks

Same session structure applies to **`tracks/base/`** and **`tracks/arbitrum/`** — swap network constants, faucet, and env var names only. Do not mix addresses or RPC URLs across tracks.

| Track | chainId | Faucet |
| ----- | ------- | ------ |
| optimism (default) | 11155420 | console.optimism.io/faucet |
| base | 84532 | ethfaucet.com |
| arbitrum | 421614 | ethfaucet.com |

---

*Bandung OP Builders · Cohort 01 · Update this file when session prerequisites change.*
