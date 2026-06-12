# Workshop presentations

Interactive scroll-presentation pages for the 8 Bandung Builders sessions — available in **three L2 tracks**.

## Structure

```
presentations/
├── index.html              Track selector (start here)
├── base/                   Base Sepolia track
│   ├── index.html          Session grid + progress
│   └── meet-1.html … meet-8.html
├── optimism/               OP Sepolia track
│   ├── index.html
│   └── meet-1.html … meet-8.html
├── arbitrum/               Arbitrum Sepolia track
│   ├── index.html
│   └── meet-1.html … meet-8.html
└── assets/
    ├── styles.css
    └── main.js
```

## How to use

1. Open **`presentations/index.html`** in a browser.
2. Pick **Base**, **Optimism**, or **Arbitrum**.
3. Work through Meet 1–8 inside that track folder.

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
