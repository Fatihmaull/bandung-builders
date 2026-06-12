# Go-To-Market — Low-Gas Consumer dApps on OP Sepolia

> Companion to [`meet-7-pitch-deck.md`](./meet-7-pitch-deck.md). Use this framework to fill in Slide 6 (Tokenomics + GTM) of your pitch, and to answer judge questions of the form *"how will you get users?"*

## Why Base demands a different GTM than mainnet

A mainnet GTM is forced into one of two corners:

1. **DeFi-degens-first:** target users who already have ETH, already use wallets, and tolerate $5–$50 fees. Tiny TAM, mature competition.
2. **TVL mercenaries:** offer 100%+ APRs to attract liquidity that leaves the day the subsidy ends.

Base flips both. Sub-cent fees + Coinbase distribution means:

- A *consumer* user can plausibly do their first 50 transactions before fees become a concern.
- The acquisition channel can be Coinbase's existing 110M+ users instead of Twitter degens.
- You can afford to *subsidize gas entirely* (sponsorship via Paymasters / account abstraction) for the first 10,000 users without breaking the budget.

## The Base GTM stack (5 layers)

### Layer 1 — Channel

Where do your *first 100 users* come from? Pick **one**.

| Channel                       | Plausible for                                              | Friction                              |
| ----------------------------- | ---------------------------------------------------------- | ------------------------------------- |
| **Coinbase Wallet discovery** | Consumer-facing dApps with broad appeal                    | Need to be featured                   |
| **Farcaster / Frames**        | Social-native dApps; viral coefficient potential           | Need Farcaster-native UX              |
| **Direct community outreach** | Vertical-specific dApps (Pasar vendors, ITB orgs, etc.)    | Slow, but high-trust                  |
| **Existing crypto community** | DeFi tooling, infra, dev tools                             | Crowded, high CAC                     |
| **Influencer / KOL**          | Memetic / brand-driven                                     | Expensive, attribution unclear        |
| **Hackathon → grant pipeline** | All; this is your channel for the workshop                | Selection-by-judges, not market       |

For most workshop projects, **direct community outreach** is right. You're solving a specific Bandung problem; your first users are 10–50 specific Bandung people you can name.

### Layer 2 — Activation

What does "activated" mean for your dApp? Define it as a numeric event.

Examples:

- "User completed first stake of ≥1 STK." (PasarPoints)
- "User joined a savings pool with ≥3 other members." (Arisan-on-Base)
- "User pledged toward a creator with milestone unlocks." (Patronage app)

This is the metric you optimize for in the first 30 days. *Not* sign-ups. *Not* wallet connects. The real action that proves engagement.

### Layer 3 — Retention loop

What makes a user come back next week?

Web2 says: notifications, email digests. Both apply on OP Sepolia — but the unique Web3 retention loop is *yield accrual*. If their position keeps earning while they're away, the dApp pulls them back to claim.

Three patterns:

1. **Notification on milestone:** push when claimable balance hits a threshold.
2. **Social leaderboard:** show top stakers / top earners (especially within a community).
3. **Time-locked unlocks:** vesting cliffs that surface "you have funds unlocking on Friday" hooks.

### Layer 4 — Monetization

Three legal ways to capture value on OP Sepolia:

| Mechanism                  | Example                                                    | Pros                          | Cons                          |
| -------------------------- | ---------------------------------------------------------- | ----------------------------- | ----------------------------- |
| **Transaction fee**         | 0.1% per stake/withdraw → treasury                        | Aligned with usage            | Discourages large stakes      |
| **Performance fee**         | 10% of accrued rewards on claim                            | Aligned with success          | Reduces user APR              |
| **Spread / market-making**  | Buy STK at one price, redeem at slightly higher             | Hidden from users             | Trust-eroding if discovered   |
| **Token appreciation**       | Treasury holds protocol token; price ↑ over time          | Aligned with all stakeholders | Reflexive on token launch     |
| **Sponsored gas / B2B**     | Sell "stake-pool-as-a-service" to vendors                  | High margin                   | Slow sales cycle              |

Workshop default: a 1–3% transaction fee on stake or withdraw, routed to the reward pool. This is the **simplest** funding loop and the most defensible. Avoid: "We'll figure out monetization later."

### Layer 5 — Compounding moat

What asymmetry accumulates in your favor as you grow? On Base specifically:

- **Liquidity:** more stakers = more revenue = higher reward funding = more stakers. Reflexive.
- **Reputation graph:** if your dApp issues SBTs / on-chain reputation, every interaction strengthens user lock-in.
- **Distribution partnership:** an exclusive deal with a Bandung organization (e.g., the Pasar Baru vendor association) is a moat that doesn't show up in code.
- **Open-source effect:** if your contract is the canonical "X-on-Base," developers fork and depend on it; you become the standard.

> "If your only moat is 'we shipped first', you don't have a moat. If your only moat is 'we have a token,' you don't have a moat. The judges will probe this — have an answer."

## A 30-day GTM plan (template)

Fill this in for your project. This is what Slide 6 of your pitch is summarizing.

```
PROJECT             : __________________________________________
TARGET FIRST 100    : (specific community / channel)
                      __________________________________________

ACTIVATION EVENT    : (numerically defined)
                      __________________________________________

WEEK 1 (post-launch):
  Goal           : ___ users complete activation event
  Channel push   : ____________________________________________
  Friction list  : ____________________________________________ (top 3)

WEEK 2:
  Goal           : ___ activated users + first retention metric > X%
  Iteration       : ____________________________________________

WEEK 3:
  Goal           : monetization toggled on (1% fee?), first $$ to treasury

WEEK 4:
  Goal           : public retro published; ask community for feedback
  Decide        : continue / pivot / sunset (be ruthless)

MOAT IN 30 DAYS  : (what does the competitor have to overcome to copy us?)
                      __________________________________________
```

## Base-specific advantages to mention in pitches

When a judge asks *"why Base, specifically?"* — your answer should NOT be "low fees." Every L2 has low fees. Better answers:

1. **Coinbase Smart Wallet** — passkey-based onboarding, no seed phrases. Massive UX advantage for non-crypto-native users (your Bu Tati persona).
2. **Coinbase distribution** — featured-in-app placement, Coinbase Wallet's dApp browser. No other L2 has the equivalent.
3. **Onramps** — Coinbase Onramp lets users buy ETH/USDC with IDR via local rails. Reduces "I need crypto first" friction.
4. **Fee subsidies / Paymasters** — Base's Smart Wallet Paymaster sponsors first-N transactions. You can plausibly offer a *literally free* first transaction.
5. **EVM-equivalence** — your contract code is portable to Optimism, Mode, Zora, Worldchain. Hedge-by-default.

## Anti-patterns to avoid in pitches

- *"We will airdrop to drive adoption."* — Acceptable as one tactic among many. **Not** an entire GTM.
- *"We will go viral on Twitter."* — Hope is not a strategy.
- *"We will partner with Coinbase."* — Coinbase doesn't partner with hackathon projects. They feature winners.
- *"We are pre-revenue but post-meme."* — Don't.

## Questions a judge will ask (be ready)

Drill these in pairs during Meet 7:

1. **"What's your CAC?"** — Cost to Acquire a Customer. Estimate from your channel mix.
2. **"What's your runway?"** — From [Meet 5](../week-3/meet-5-defi-tokenomics.md), `pool / rate` in days.
3. **"What stops a fork?"** — Address from Layer 5 above (moat).
4. **"Why hasn't this been done already?"** — Either *"it has, but on the wrong chain"* or *"it has, but the unit economics didn't work until L2 fees dropped"*.
5. **"Who's on the team?"** — Names + roles + most relevant prior shipped product, each.
6. **"What happens if Base goes down for a week?"** — Your contract is non-custodial, users can withdraw via Etherscan/OP Sepolia Etherscan or a forked frontend. Be ready.

If you can answer all six in under 30 seconds each, you'll outperform 80% of hackathon submissions.
