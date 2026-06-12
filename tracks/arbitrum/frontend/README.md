# `frontend/` — Bandung Base Builders dApp

Next.js 15 (App Router) + TypeScript + Tailwind CSS, wired to Base Sepolia via Wagmi v2, Viem v2, and RainbowKit v2.

## Quick start

```bash
# from frontend/
cp .env.local.example .env.local       # fill in WC project id + addresses
pnpm install                            # or: npm install
pnpm dev                                # http://localhost:3000
```

## Layout

```
frontend/
├── package.json
├── next.config.ts
├── tsconfig.json
├── tailwind.config.ts
├── postcss.config.mjs
├── .env.local.example
└── src/
    ├── app/
    │   ├── layout.tsx          Root layout, fonts, providers wrapper
    │   ├── providers.tsx       Wagmi + RainbowKit + React Query setup
    │   ├── page.tsx            Minimal example wiring one read + one write hook
    │   └── globals.css         Tailwind directives + base styles
    ├── lib/
    │   ├── wagmi.ts            getDefaultConfig for [baseSepolia]
    │   └── contracts.ts        Addresses (env-driven) + typed ABI imports
    ├── hooks/
    │   ├── useStakingBalance.ts
    │   ├── useEarnedRewards.ts
    │   ├── useStakeTokens.ts
    │   ├── useWithdraw.ts
    │   └── useClaimRewards.ts
    └── abi/
        └── StakingProtocol.json
```

## What is intentionally NOT here

A full Staking UI. Attendees build forms, balances, and tx state UI during **Meet 6 — Frontend Integration**, using the provided hooks as the lego pieces. See [`docs/week-3/meet-6-frontend-integration.md`](../docs/week-3/meet-6-frontend-integration.md).

## Regenerating the ABI

After any change to `contracts/src/StakingProtocol.sol`:

```bash
cd contracts
forge build
# Copy the freshly built ABI into the frontend.
jq '.abi' out/StakingProtocol.sol/StakingProtocol.json > ../frontend/src/abi/StakingProtocol.json
```

(There is no automatic build step linking the two workspaces — keep ABI changes deliberate.)
