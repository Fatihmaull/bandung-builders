# Meet 2 — Boilerplate Walkthrough

> Sister doc to [`meet-2-foundry-setup.md`](./meet-2-foundry-setup.md). Use this script for the 30-minute monorepo tour at the end of Meet 2.

## Goal

Make every attendee comfortable navigating the repo by the end of the session. They should know where to put things, what each top-level folder is for, and which files exist because the AI needs them.

## The tour (30 min, ~3 minutes per stop)

Open the project in Cursor (or VS Code) on the projector. Each step is a stop. Click open the file, narrate.

### Stop 1 — Repo root

```text
bandungbuildmaterial/
├── README.md
├── .cursorrules               <-- this is for your AI
├── docs/system-prompt.md      <-- mirror for non-Cursor AIs
├── .env.example
├── package.json               <-- pnpm workspaces config
├── contracts/                 <-- Foundry
├── frontend/                  <-- Next.js
└── docs/                      <-- curriculum
```

> "Monorepo. Two workspaces. One curriculum folder. That's the entire mental model. We picked monorepo specifically because the ABI is a build artifact of `contracts/` consumed by `frontend/`. Splitting them creates ABI drift, which is the most common bug in dApp work."

### Stop 2 — `.cursorrules`

Scroll through it on the projector.

> "This is the most important file in the repo from an AI-pairing perspective. It encodes everything that, if you forget to tell your AI, will result in subtly wrong code: the staking math, the `1e18` precision factor, the rule that addresses go in `lib/contracts.ts` not in components, the rule that we never deploy to mainnet.
>
> Cursor reads this automatically when you open the repo. If you use a different agent, paste `docs/system-prompt.md` into its system prompt. **Verify before you start coding.** Ask the agent: 'What network are we targeting?' If it doesn't say 'OP Sepolia, chain ID 11155420', your rules aren't loaded."

### Stop 3 — `contracts/foundry.toml`

(Covered in detail in the sister doc; here just point out the structure exists.)

### Stop 4 — `contracts/src/`

Open the folder.

```text
contracts/src/
├── StakingProtocol.sol            <-- the reference contract
├── StakingProtocol.exercise.sol   <-- the blank version (Meet 4)
├── MockERC20.sol                  <-- test tokens
└── interfaces/IStakingProtocol.sol
```

> "Two versions of the contract. The reference has the full implementation. The exercise has `// TODO:` blocks. In Meet 4 we live-code the exercise version; the reference is your answer key — *peek only after you have made an honest attempt*.
>
> The interface file is intentional. It documents what 'public surface area' means: external functions, events, custom errors. Frontend hooks key off these names. If you change the interface, you've broken the frontend — visible immediately on review."

Open `IStakingProtocol.sol`. Walk through the four user actions (`stake`, `withdraw`, `getReward`, `exit`) and three errors (`ZeroAmount`, `InsufficientBalance`, `InsufficientRewardLiquidity`).

### Stop 5 — `contracts/test/StakingProtocol.t.sol`

Briefly scroll. Don't explain the contents yet — that's Meet 4 territory.

> "Notice we already have a test file. Forge tests are written in Solidity, in this directory, with the `.t.sol` suffix. The test contract inherits from `Test` and uses cheatcodes like `vm.prank` and `vm.warp`. We'll go deep in Meet 4."

### Stop 6 — `contracts/script/Deploy.s.sol`

Briefly scroll.

> "Forge scripts are also Solidity. They use `vm.startBroadcast` to emit real transactions when run with `--broadcast`. This script deploys the tokens, the staking contract, funds rewards, and sets the rate — one command, full setup. We'll run it for real in Meet 8."

### Stop 7 — `frontend/package.json`

```text
frontend/
├── package.json       <-- pinned versions of Next/Wagmi/Viem/RainbowKit
├── tsconfig.json
├── tailwind.config.ts
├── postcss.config.mjs
├── next.config.ts
├── .env.local.example
└── src/...
```

> "Versions are pinned. Wagmi v2, Viem v2, RainbowKit v2 are the *current* stable Web3 stack. They had breaking changes from v1 — APIs are different. If you Google 'wagmi useContractRead' you'll find v1 docs that don't apply here. Always cross-check against `package.json`."

### Stop 8 — `frontend/src/lib/`

```text
frontend/src/lib/
├── wagmi.ts          <-- single Wagmi config, optimismSepolia only
└── contracts.ts      <-- addresses (env-driven) + ABI imports
```

> "Two files, both single-purpose, both load-bearing.
>
> `wagmi.ts` is the chain + connector setup. It's pinned to `[optimismSepolia]`. If you ever find yourself wanting to add another chain, that's a workshop policy violation — push back.
>
> `contracts.ts` is the ONLY place addresses or ABIs are referenced. The rule is: if you're writing code that wants to know the staking contract's address, you import it from here. **Never paste a hex address into a component.** Why? Because when you redeploy after fixing a bug — and you will — you change ONE env var, not 14 files."

Open `lib/contracts.ts`. Point out the `requireAddress` runtime guard.

> "Notice the runtime check. If the env var is missing, the app refuses to start. If it's malformed, same. This is deliberate: a *loud* error at boot is a hundred times better than a *silent* call to the zero address that returns mysterious zeros."

### Stop 9 — `frontend/src/hooks/`

```text
frontend/src/hooks/
├── useStakingBalance.ts    <-- read: balanceOf(account)
├── useEarnedRewards.ts     <-- read: earned(account)
├── useStakeTokens.ts       <-- write: stake(amount)
├── useWithdraw.ts          <-- write: withdraw(amount)
└── useClaimRewards.ts      <-- write: getReward()
```

> "Five custom hooks. Each does *one thing*. Each lives in its own file.
>
> Reads use `useReadContract` from Wagmi. Writes use `useWriteContract` + `useWaitForTransactionReceipt`. We'll write the *sixth* hook — `useApproveStake` — together in Meet 6. It's deliberately not here so you have something to build that night."

Open one read hook and one write hook side-by-side. Note the shape symmetry.

### Stop 10 — `frontend/src/app/`

```text
frontend/src/app/
├── layout.tsx       <-- root layout, mounts <Providers>
├── providers.tsx    <-- Wagmi + RainbowKit + React Query
├── page.tsx         <-- intentionally minimal example
└── globals.css      <-- Tailwind
```

> "Open `providers.tsx`. This is where the three contexts get nested correctly. The order matters: WagmiProvider on the outside, then QueryClientProvider, then RainbowKitProvider. Don't reorder; you'll get hydration warnings.
>
> Open `page.tsx`. This is intentionally a minimal demo — one read, one write, the connect button. In Meet 6 you're going to build the real UI on top of this."

### Stop 11 — `docs/`

```text
docs/
├── README.md
├── 00-prerequisites.md
├── system-prompt.md
├── week-1/  week-2/  week-3/  week-4/
```

> "All curriculum lives here. Each meet has its own file. There is no 'central handout' — each session is self-contained and can be re-read offline. The `system-prompt.md` mirrors `.cursorrules` for non-Cursor agents."

---

## Wrap-up exercise (5 min)

Tell the room:

> "Open your AI agent right now. Ask it: 'In this repo, where do contract addresses live? Cite the file path.' If the answer is anything other than `frontend/src/lib/contracts.ts`, your `.cursorrules` isn't loaded. Fix it now, before you leave the room."

## Common questions during this walkthrough

**Q: Why pnpm instead of npm?**
A: pnpm uses a content-addressable store, so monorepo installs are 3–10x faster and disk-efficient. npm works too — `npm install` will resolve from `frontend/package.json`. But CI and the README assume pnpm.

**Q: Why is `contracts/` not in the pnpm workspace?**
A: Foundry is not a Node project. Mixing it into pnpm workspaces creates confusion. They live side-by-side; the integration point is the ABI JSON file that gets copied from `contracts/out/` into `frontend/src/abi/`.

**Q: Why is the ABI committed to git instead of generated?**
A: Two reasons. First, it makes the frontend buildable without running `forge build` — useful for designers, reviewers, Vercel deploys. Second, an ABI change in version control is *visible* in a PR diff — it forces the reviewer to think about whether the frontend should change too.
