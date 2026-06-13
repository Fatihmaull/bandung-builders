# Workshop presentations

Interactive scroll-presentation pages for the 8 Bandung Builders sessions.

**Default track:** [OP Sepolia (`optimism/`)](optimism/index.html) — opening [`index.html`](index.html) redirects here automatically. Use [`index.html?tracks=1`](index.html?tracks=1) to compare all tracks first.

## Structure

```
presentations/
├── index.html              Track picker (+ auto-redirect to optimism/)
├── optimism/               OP Sepolia — DEFAULT cohort track
│   ├── index.html
│   └── meet-1.html … meet-8.html
├── base/                   Base Sepolia (optional)
├── arbitrum/               Arbitrum Sepolia (optional)
└── assets/
```

## How to use

### Live site (participants)

**Production URL:** https://presentations-pi-blue.vercel.app

| Entry | URL |
| ----- | --- |
| Track picker (auto → OP) | https://presentations-pi-blue.vercel.app/ |
| OP Sepolia (default) | https://presentations-pi-blue.vercel.app/optimism/ |
| Combined Meet 1+2 (participants) | https://presentations-pi-blue.vercel.app/optimism/meet-1-2-combined.html |
| Combined Meet 1+2 (facilitator) | https://presentations-pi-blue.vercel.app/optimism/meet-1-2-combined-facilitator.html |
| Meet 1 slides | https://presentations-pi-blue.vercel.app/optimism/meet-1.html |
| Meet 2 slides | https://presentations-pi-blue.vercel.app/optimism/meet-2.html |

Redeploy after HTML changes (from repo root):

```bash
cd presentations
npx vercel deploy --prod
```

Or connect the GitHub repo in the [Vercel dashboard](https://vercel.com/fatihmaulls-projects/presentations/settings) with **Root Directory** = `presentations` for automatic deploys on push.

### Local

1. Open **`presentations/index.html`** — you'll land on **Optimism sessions** within ~1 second.
2. Use the **OP | Base | Arb** navbar on any page to switch tracks.
3. Click **All tracks** to return to the full comparison (`?tracks=1`).

Progress (`Mark complete`, checklists) is stored **per track** in `localStorage` (`bbb.v1.base.*`, `bbb.v1.optimism.*`, etc.).

### Local HTTP server (recommended)

```bash
npx serve presentations
# open http://localhost:3000
```

## Cross-references with repo docs

Each track's markdown curriculum lives under the matching monorepo folder:

| Track | Docs path |
| ----- | --------- |
| Base | [`tracks/base/docs/`](../tracks/base/docs/README.md) |
| Optimism | [`tracks/optimism/docs/`](../tracks/optimism/docs/README.md) |
| Arbitrum | [`tracks/arbitrum/docs/`](../tracks/arbitrum/docs/README.md) |

**Rule of thumb:** update markdown first, then mirror changes into the matching track's HTML.

## Network-specific slides

Sessions with the most track-specific content:

| Session | Base | Optimism | Arbitrum |
| ------- | ---- | -------- | -------- |
| Meet 1 | OP Stack + Base narrative | OP Stack + Superchain faucet | Arbitrum Nitro narrative |
| Meet 2 | cast on Base Sepolia | cast on OP Sepolia | cast on Arbitrum Sepolia |
| Meet 6 | `baseSepolia` Wagmi config | `optimismSepolia` | `arbitrumSepolia` |
| Meet 7–8 | Basescan deploy/GTM | OP Etherscan + Superchain | Arbiscan + ecosystem |

Meets 3–5 are largely chain-agnostic (design thinking, Solidity math, tokenomics).

## localStorage keys

Namespaced `bbb.v1.<track>.*` — e.g. `bbb.v1.optimism.done.meet-3`.

Clear via DevTools → Application → Local Storage.

## Tested in

Chrome / Edge / Firefox / Safari 17+ (desktop + mobile).
