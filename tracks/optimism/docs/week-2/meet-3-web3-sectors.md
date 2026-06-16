# Web3 Sector Map — Reference for Meet 3

> **Facilitator reference** for the `#web3-sectors` slide block in [`meet-3.html`](../../../presentations/optimism/meet-3.html).  
> **Duration in room:** ~12 minutes · **Do not deep-dive token prices or trading.**

## Why this block exists

Before EDIPT and Bandung problem briefs, participants need a **shared vocabulary of where Web3 businesses live**. Without it, ideation collapses into “another staking app.” This map answers: *which sector is your wrapper, and which primitive sits underneath?*

**Cohort anchor:** We build a **DeFi staking primitive** on OP Sepolia. Every sector below is a possible **product wrapper** — not a reason to rewrite the contract from scratch in Week 2.

---

## Sector overview (2025–2026 landscape)

Industry reports describe a shift from speculative cycles toward **utility-driven applications**: institutional-grade DeFi, tokenized real-world assets (RWAs), and consumer apps with Web2-like onboarding (account abstraction, gas sponsorship, stablecoin rails). Gaming and social cooled on pure airdrop models; retention and verifiable settlement matter more.

Sources used for this map (facilitator background only — do not assign as homework):

- [State of DeFi 2025](https://defillama.com/research/report/state-of-defi-2025) — stablecoins as monetary base, lending concentration, maturing market structure  
- [CoinGecko 2026 RWA Report](https://www.coingecko.com/research/publications/2026-rwa-report) — tokenized treasuries, equities, credit growth  
- [DWF Ventures 2026 Outlook](https://www.dwf-labs.com/research/2026-looking-forward) — composability, RWAs, AI × on-chain payments  
- Cointelegraph / TradingView 2026 DApp outlook — consumer lane, invisible gas, everyday use cases  

---

## The eight sectors (teach in this order)

### 1. DeFi (Decentralized Finance)

**What it is:** Financial services without a traditional intermediary — lending, borrowing, DEX trading, staking, yield, stablecoins.

**Business models:** Protocol fees, spread on liquidity, governance tokens (secondary), B2B integrations.

**2026 note:** DeFi is consolidating around **durable primitives** (lending, DEX, staking) rather than short-lived yield farms. Stablecoins are the **monetary base layer** for most on-chain activity.

**Cohort fit:** **Primary.** Our `StakingProtocol` is a DeFi primitive. Bandung briefs 2 (treasury), 4 (arisan), and 1 (loyalty tiers) map here.

**Trust insight pattern:** *“No single admin can change balances or payout rules.”*

---

### 2. RWA (Real World Assets)

**What it is:** On-chain representation of off-chain value — tokenized treasuries, bonds, real estate, commodities, private credit, equities.

**Business models:** Issuance fees, custody/servicing partnerships, distribution to DeFi liquidity.

**2026 note:** RWA TVL grew sharply; tokenized treasuries and equities are the headline use case. Regulatory progress is uneven but directionally supportive.

**Cohort fit:** **Wrapper, not rewrite.** Brief 3 (roastery co-op) uses **escrow + milestone release** — RWA-adjacent settlement without tokenizing a building.

**Trust insight pattern:** *“Settlement and ownership history are verifiable; no treasurer’s personal bank account.”*

---

### 3. Payments & Consumer Apps

**What it is:** Stablecoin checkout, remittance, neobank-style savings, QR-adjacent flows, in-app micro-payments on L2.

**Business models:** FX/spread, subscription, merchant fees, float on stablecoin balances.

**2026 note:** L2s (including OP Stack) win on **sub-cent fees** — critical for Indonesia-adjacent use cases where margin is thin.

**Cohort fit:** **Strong wrapper.** Brief 1 (pasar vendor + QRIS-adjacent user) and Brief 4 (driver remittance mindset).

**Trust insight pattern:** *“Users keep self-custody; merchant cannot silently change loyalty terms.”*

---

### 4. GameFi / Web3 Gaming

**What it is:** On-chain game assets, player-owned inventory, tournaments with on-chain prizes, interoperable items.

**Business models:** Primary sales, marketplace fees, season passes — shifting from play-to-earn hype to **retention and fun first**.

**2026 note:** BGA surveys emphasize **gameplay quality** and sustainable monetization over token emissions.

**Cohort fit:** **Optional wrapper.** Staking can represent **season pass deposits** or **guild treasury** — only if participant has genuine game-community access in Bandung.

**Trust insight pattern:** *“Prize pool and guild funds are contract-enforced, not Discord-trusted.”*

---

### 5. SocialFi & Creator Economy

**What it is:** On-chain social graphs, tipping, patronage, fan staking, decentralized content ownership (Farcaster, Lens-style patterns).

**Business models:** Direct fan payments (no 5–20% platform rake), milestone-based pledges, NFT-gated communities.

**2026 note:** Platforms that **deplatform** creators remain the centralized pain point smart contracts address.

**Cohort fit:** **Strong wrapper.** Brief 5 (creator patronage + vesting) is the canonical example.

**Trust insight pattern:** *“Fans pay creators directly; milestone unlocks are automatic, not platform-discretionary.”*

---

### 6. NFTs & Digital Membership

**What it is:** Collectibles, event tickets, credentials, proof-of-attendance, milestone receipts — not necessarily JPEG speculation.

**Business models:** Mint fees, royalty on secondary sales, membership access.

**2026 note:** NFT utility (access, reputation, proof) outlasted pure profile-picture cycles.

**Cohort fit:** **Accent layer.** Ambitious Brief 5 uses **milestone NFT** as unlock signal. Brief 1 could use **tier badge** off-chain with on-chain points.

**Trust insight pattern:** *“Redemption rights are tied to verifiable on-chain state, not a spreadsheet.”*

---

### 7. Infrastructure & Developer Tools

**What it is:** L2 rollups, bridges, wallets, account abstraction, indexers, oracles — the **rails**, not the passenger app.

**Business models:** Sequencer fees, SaaS for devtools, enterprise RPC.

**2026 note:** OP Stack / Superchain is **infrastructure** this cohort builds *on*, not the product to pitch on Demo Day.

**Cohort fit:** **Do not pick as product sector** unless attendee works for an infra company. Mention so they stop proposing “we build an L2.”

**Trust insight pattern:** N/A for Demo Day — defer.

---

### 8. AI × Web3 (emerging)

**What it is:** AI agents with wallets, autonomous payments, on-chain verification of AI outputs, agent-to-agent settlement.

**Business models:** API + gas sponsorship, verified inference markets, agent subscriptions.

**2026 note:** Early but real — agents need **payment rails**; stablecoins + L2 are the default stack.

**Cohort fit:** **Stretch goal only.** Could wrap Brief 2 (org treasury) with “AI summarizes proposals, humans sign on-chain” — off-chain AI, on-chain execution.

**Trust insight pattern:** *“Humans approve spend; AI only proposes — state changes stay on-chain.”*

---

## Mapping table — Bandung briefs → sectors

| Brief | Primary sector | Secondary | Staking primitive role |
| ----- | -------------- | --------- | ---------------------- |
| 1 Pasar loyalty | Payments & Consumer | DeFi | Stake points → tier rewards |
| 2 ITB treasury | DeFi | Infrastructure (multi-sig) | Stake dues → governance/visibility |
| 3 Roastery co-op | RWA-adjacent / DeFi | Payments | Stake USDC per batch → milestone release |
| 4 Arisan driver | DeFi | Payments & Consumer | Stake monthly → rotation payout |
| 5 Creator patronage | SocialFi | DeFi | Stake USDC → stream to creator |

---

## Facilitator script beats (12 min)

1. **(2 min)** “Web3 is not one industry — it is **sectors** sharing the same rails: wallet, chain, smart contract.”
2. **(6 min)** Walk tabs 1–6 on slide — **skip deep dive on 7–8** unless audience asks.
3. **(2 min)** Show mapping table — “Your homework problem probably lives in **one primary sector**.”
4. **(2 min)** Poll: “Which sector is your instinct?” — no commitment yet, just vocabulary.

**Push back:**

- “We’re building an L2” → Infrastructure, wrong session.  
- “NFT marketplace for everything” → ask **trust clause** and **user Tuesday afternoon**.  
- “AI trading bot” → not a product narrative for this cohort.

---

## Defer to home

- Token prices, TVL charts, per-protocol revenue  
- Regulatory detail per country  
- Full RWA legal stack  
- Implementing non-staking primitives (Meet 4–8 scope is staking engine)

---

*Bandung OP Builders · Meet 3 sector reference · OP Sepolia track*
