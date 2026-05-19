# Meet 8 — Demo Day & Deployment Checklist

> **Track:** Technical / Execution
> **Duration:** 2.5 hours
> **Companion:** [`meet-8-judging-rubric.md`](./meet-8-judging-rubric.md)

## Goal of the session

Every attendee leaves the room with:

1. A contract **deployed and verified** on Base Sepolia.
2. A frontend **deployed on Vercel** wired to that contract.
3. A pre-recorded demo video as a Demo Day backup.

This is the single most stressful session. Pace is deliberately slower than Meet 4 or Meet 6 — there is no new conceptual material, only execution under time pressure.

## Agenda (150 minutes)

| Time      | Block                                                                  |
| --------- | ---------------------------------------------------------------------- |
| 00:00–00:15 | Pre-flight, room-wide                                                |
| 00:15–00:45 | Block A — Deploy + verify the contract                               |
| 00:45–01:25 | Block B — Deploy the frontend to Vercel                              |
| 01:25–01:35 | Stretch break                                                         |
| 01:35–02:00 | Block C — End-to-end smoke test (real wallet, real Base Sepolia)     |
| 02:00–02:20 | Block D — Record the demo backup video                               |
| 02:20–02:30 | Final pitch logistics + Demo Day roll-call                           |

---

## Pre-flight (15 min)

Before any deploys, the room runs through this together. Don't skip — half the failures in this session come from missing pre-flight items.

- [ ] `git status` clean. All work committed and pushed to `main`.
- [ ] `cd contracts && forge test -vvv` passes.
- [ ] `cd frontend && pnpm build` succeeds locally.
- [ ] Repo-root `.env` filled:
  - `BASE_SEPOLIA_RPC_URL` (private RPC recommended for verification reliability)
  - `PRIVATE_KEY` (testnet only)
  - `BASESCAN_API_KEY`
- [ ] Deployer address has at least **0.05 ETH** on Base Sepolia. Top up at <https://www.coinbase.com/faucets/base-ethereum-sepolia-faucet>.
- [ ] `frontend/.env.local` has `NEXT_PUBLIC_WC_PROJECT_ID` filled.

## Block A — Deploy + verify the contract (30 min)

### A.1. The one-liner

From `contracts/`:

```bash
# Load env into the shell
source ../.env

# Broadcast + verify
forge script script/Deploy.s.sol:Deploy \
    --rpc-url $BASE_SEPOLIA_RPC_URL \
    --broadcast \
    --verify \
    --etherscan-api-key $BASESCAN_API_KEY \
    -vvvv
```

What this does, step by step:

1. Loads `script/Deploy.s.sol` and runs the `Deploy.run()` function locally to compute the txs that *would* be broadcast.
2. With `--broadcast`, actually sends them via `$BASE_SEPOLIA_RPC_URL`.
3. With `--verify`, submits each deployed contract's source + constructor args to the Etherscan-compatible API at `api-sepolia.basescan.org` (configured in [`foundry.toml`](../../contracts/foundry.toml)).

Expected output (truncated):

```
##### base-sepolia
✅  [Success]Hash: 0x...
Contract Address: 0xMockERC20StkAddress
...
✅  [Success]Hash: 0x...
Contract Address: 0xMockERC20RwdAddress
...
✅  [Success]Hash: 0x...
Contract Address: 0xStakingProtocolAddress
...

##### Submitting verification for [src/StakingProtocol.sol:StakingProtocol] ...
Contract successfully verified
```

### A.2. Capture the addresses

The script's `console2.log` lines print at the end:

```
StakingProtocol: 0xabc...
Staking Token  : 0xdef...
Reward Token   : 0x123...
```

Copy these into `frontend/.env.local`:

```
NEXT_PUBLIC_STAKING_CONTRACT_ADDRESS=0xabc...
NEXT_PUBLIC_STAKING_TOKEN_ADDRESS=0xdef...
NEXT_PUBLIC_REWARD_TOKEN_ADDRESS=0x123...
```

### A.3. Verification troubleshooting

If `--verify` failed but the deploy succeeded, you can retry verification stand-alone:

```bash
forge verify-contract \
  --chain-id 84532 \
  --watch \
  --etherscan-api-key $BASESCAN_API_KEY \
  --constructor-args $(cast abi-encode "constructor(address,address,address)" $STK_ADDR $RWD_ADDR $OWNER_ADDR) \
  --compiler-version v0.8.24+commit.e11b9ed9 \
  0xStakingProtocolAddress \
  src/StakingProtocol.sol:StakingProtocol
```

Common failure modes:

- **"Source code already verified"** — you're done. No action needed.
- **"Constructor args mismatch"** — re-encode with `cast abi-encode`, make sure addresses are in the same order as the constructor signature.
- **"Pending in queue"** — Basescan sometimes lags ~30 seconds; the `--watch` flag will keep polling.
- **"Compiler version mismatch"** — must match the EXACT solc version Foundry used. Find it in `out/StakingProtocol.sol/StakingProtocol.json` → `metadata.compiler.version`.

### A.4. Open Basescan, confirm

Visit `https://sepolia.basescan.org/address/0xStakingProtocolAddress` (your address). You should see:

- A green "Contract" badge.
- A "Read Contract" tab with all your `view` functions callable.
- A "Write Contract" tab with `stake`, `withdraw`, `getReward`, `exit`, `setRewardRate`, `fundRewards` callable via Connect Wallet.

Click "Read Contract" → `totalStaked` → should return `0`. *That's* what "deployed and verified" looks like.

> "Take a screenshot. This is the slide-quality artifact you put in your pitch."

---

## Block B — Deploy the frontend to Vercel (40 min)

### B.1. Push the repo to GitHub

Vercel deploys from a Git repo. If your monorepo isn't already on GitHub:

```bash
gh repo create bandungbuildmaterial --public --source=. --remote=origin --push
```

(Or use the GitHub web UI.)

### B.2. Import to Vercel

Web UI: <https://vercel.com/new>.

1. **Select your GitHub repo.**
2. **Root directory:** click "Edit" → set to `frontend/`. *(Critical for monorepos — Vercel defaults to repo root.)*
3. **Framework preset:** Next.js (auto-detected).
4. **Build & dev commands:** leave defaults (`next build` / `next dev`).
5. **Environment variables:** add these three:
   ```
   NEXT_PUBLIC_WC_PROJECT_ID=<your wc projectId>
   NEXT_PUBLIC_STAKING_CONTRACT_ADDRESS=<from Block A>
   NEXT_PUBLIC_STAKING_TOKEN_ADDRESS=<from Block A>
   NEXT_PUBLIC_REWARD_TOKEN_ADDRESS=<from Block A>
   NEXT_PUBLIC_BASE_SEPOLIA_RPC_URL=<optional, your private RPC>
   ```
6. **Deploy.**

First build typically completes in 60–90 seconds. Vercel issues you a URL like `bandungbuildmaterial.vercel.app`.

### B.3. The custom domain (optional)

For Demo Day polish, a custom domain is worth the 15 minutes. Vercel → Project → Settings → Domains → Add. Either:

- Use a subdomain Vercel issues (`yourname.vercel.app`) — free, instant.
- Buy a domain (`yourproject.xyz` on Namecheap — ~$10) and point its DNS to Vercel.

### B.4. Hot-fix loop on Vercel

Every push to `main` deploys automatically. If you push a broken build, Vercel keeps the previous deploy live. Practical implication for Demo Day: **do not push code in the hour before your pitch.** If you must, push to a `demo` branch and configure Vercel to deploy from that.

---

## Block C — End-to-end smoke test (25 min)

Open your deployed URL in **two windows** — one as the deployer/owner, one as a fresh test wallet you create just for this.

The end-to-end script:

| Step | As                    | Action                                                  | Confirm                                                            |
| ---- | --------------------- | ------------------------------------------------------- | ------------------------------------------------------------------ |
| 1    | Test wallet           | Visit URL, connect wallet                               | RainbowKit modal works, account shows on page                      |
| 2    | Test wallet           | Get Base Sepolia ETH from faucet                        | Wallet balance > 0.01 ETH                                          |
| 3    | Test wallet           | Call `STK.faucet()` via Basescan Write Contract → connect wallet → submit | STK balance = 1,000                                |
| 4    | Test wallet           | Approve STK to staking contract (cohort builds this hook in Meet 6) | Tx confirms, allowance is set                          |
| 5    | Test wallet           | Stake 100 STK on your dApp                              | Tx confirms, staked balance shows 100, earned starts ticking       |
| 6    | (wait 1–2 minutes)    | Refresh / observe earned rewards accruing               | Earned > 0                                                         |
| 7    | Test wallet           | Claim rewards                                           | Tx confirms, RWD shows in wallet                                   |
| 8    | Test wallet           | Withdraw 50 STK                                         | Tx confirms, staked balance shows 50                               |
| 9    | Test wallet           | Open Basescan → contract address → Events tab            | See `Staked`, `RewardPaid`, `Withdrawn` events                     |

If any step fails:

- **Tx reverts** → check `cast call` against the same function with the same args; reproduces in the terminal? Bug in contract. Doesn't reproduce? Bug in frontend args encoding.
- **Approve required but I just approved** → Vercel cached an old build of the page. Hard-refresh, or check the URL is from the *latest* deploy.
- **Earned shows 0 forever** → did the owner call `setRewardRate(...)` after deploy? If not, the rate is still 0. Use Basescan Write Contract → connect as owner → call `setRewardRate(0.01 ether)`.

---

## Block D — Record the demo video (20 min)

Your live demo at the pitch *will* fail in some way. Record a backup.

### Tooling

- **macOS:** built-in Screen Recording (Cmd+Shift+5) → "Record Selected Portion". Free.
- **Windows:** Xbox Game Bar (Win+G) → Capture. Free.
- **Linux:** `peek` or `OBS Studio`. Free.

### Script

Re-record the 90-second demo script from [`meet-7-pitch-deck.md`](./meet-7-pitch-deck.md). Take 2–3 takes. Pick the cleanest one.

- Speak slowly. You'll feel rushed; resist it.
- Show on-screen what you're about to do (point with the cursor) before doing it.
- Keep the mouse cursor visible at all times.

### Export + backup

- Export to MP4, 1080p, < 100MB.
- Save to: laptop SSD + iCloud/Drive + a USB stick. Three copies, three locations.
- Practice playing it back on the actual Demo Day projector.

---

## Final 10 min — Demo Day logistics + roll-call

### Read aloud — Demo Day day-of checklist

- [ ] Slide deck exported to PDF (in case Keynote/Slides corrupt).
- [ ] PDF on laptop + iCloud + USB.
- [ ] Demo video saved to laptop + iCloud + USB.
- [ ] Laptop *fully* charged. Charger packed.
- [ ] HDMI / USB-C adapter packed. (Test it on the actual venue display if possible.)
- [ ] Wallet seed phrase NOT on the demo laptop. (Use a clean dev wallet only.)
- [ ] Backup hotspot from your phone in case venue WiFi dies.
- [ ] Pitch rehearsed end-to-end at least 5 times.
- [ ] Bottle of water on stage.
- [ ] Slept 7+ hours the night before. Yes really.

### Roll-call

Go around the room. Each attendee announces:

- "My project is named ____."
- "It is deployed at ____."
- "It is verified at https://sepolia.basescan.org/address/____."
- "My demo URL is https://____.vercel.app."
- "I am ready for Demo Day."

If any line cannot be confidently said: facilitator stays after with that attendee until it can.

---

## Common last-minute disasters and recoveries

| Disaster                                                  | Recovery                                                                                                  |
| --------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- |
| Forgot to set `rewardRate` after deploy.                   | Basescan Write Contract → `setRewardRate(0.01 ether)`. Takes 10 seconds.                                  |
| RPC throttling kills the demo at the worst moment.         | Switch to a private Alchemy/Infura RPC in `NEXT_PUBLIC_BASE_SEPOLIA_RPC_URL`, redeploy Vercel (60s).      |
| Vercel build fails on the day-of because of a typo.         | Roll back to last good deploy: Vercel dashboard → Deployments → previous → "Promote to Production".      |
| Wallet pre-funded with STK got drained by a teammate testing. | Call `STK.faucet()` again from the deployer wallet. 5 seconds.                                          |
| Deployed to wrong chain accidentally.                      | Redeploy on Base Sepolia (Block A), update env, redeploy frontend. Total: 5–10 minutes.                  |
| Contract is verified but reads-tab is empty.                | Basescan caches; wait 60 seconds, hard-refresh. If still empty, check that constructor args matched.    |

---

## Final word

You are about to walk into Demo Day with:

- A contract deployed on a real L2.
- A frontend live on a real domain.
- A pitch rehearsed five times.
- A backup video for when the demo gods are angry.

Two months ago, none of this existed. You made it. Be proud, be calm, and own the room.

> "When you stand up to pitch, remember: you have done more than 99% of people who talk about 'getting into Web3.' Talk like the builder you now are."
