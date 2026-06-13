# Workshop tracks

This monorepo ships **three parallel L2 tracks**. The **default cohort track is Optimism (OP Sepolia)**.

| Track | Folder | Network | Chain ID | Status |
| ----- | ------ | ------- | -------- | ------ |
| **Optimism** | [`optimism/`](optimism/) | OP Sepolia | `11155420` | **Default** — Superchain Faucet, OP Stack narrative |
| **Base** | [`base/`](base/) | Base Sepolia | `84532` | Optional — Coinbase ecosystem |
| **Arbitrum** | [`arbitrum/`](arbitrum/) | Arbitrum Sepolia | `421614` | Optional — deepest L2 docs |

## Start here (default)

```bash
cd tracks/optimism
```

Presentations: [`presentations/optimism/`](../presentations/optimism/) — [`presentations/index.html`](../presentations/index.html) redirects here automatically.

## Switch tracks

Use the **OP | Base | Arb** navbar in any presentation page, or open [`presentations/index.html?tracks=1`](../presentations/index.html?tracks=1) to compare all three.

Work **only inside one track** during the cohort — do not mix addresses or env files.

## Root scripts

```bash
pnpm dev:optimism    # default
pnpm test:optimism

pnpm dev:base
pnpm dev:arbitrum
```

Solidity source code is identical across tracks. Only network configuration differs.
