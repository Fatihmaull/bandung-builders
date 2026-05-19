# Meet 5 — DeFi Economics & Tokenomics

> **Track:** Non-Technical
> **Duration:** 2.5 hours
> **Companion:** [`meet-5-tokenomics-canvas.md`](./meet-5-tokenomics-canvas.md)

## Learning objectives

By the end of this session, every attendee can:

1. Derive `earned(account)` from first principles in 90 seconds.
2. Calculate an APR from a `rewardRate` and `totalStaked`.
3. Identify the four pillars of token design: Supply, Vesting, Utility, Yield.
4. Fill in the [Tokenomics Canvas](./meet-5-tokenomics-canvas.md) for their chosen problem.

## Why this session exists

> "Last Thursday you wrote a contract that says 'pay X tokens per second.' But X is a *parameter*. What should X actually be? How is it sustainable? Who funds it? How fast does the reward pool deplete? These are not Solidity questions. They are economics questions, and they are the questions that make or break a protocol on launch day."

## Agenda (150 minutes)

| Time      | Block                                                                  |
| --------- | ---------------------------------------------------------------------- |
| 00:00–00:10 | Recap Meet 4; today's question                                       |
| 00:10–00:45 | Block A — The math of automated staking, derived live                |
| 00:45–01:15 | Block B — APR vs APY, emissions schedules, sustainability            |
| 01:15–01:25 | Stretch break                                                         |
| 01:25–02:05 | Block C — The four pillars of tokenomics                             |
| 02:05–02:25 | Block D — Fill the Tokenomics Canvas (in pairs)                      |
| 02:25–02:30 | Commit & wrap                                                         |

---

## Block A — The math, derived live (35 min)

> "Last week we copied the formula. Today we earn it."

### A.1. The naive model

Whiteboard. Suppose:

- Total emission rate: `R` reward-tokens per second (globally).
- Two stakers: Alice with `a_A` staked tokens, Bob with `a_B`. Total `T = a_A + a_B`.
- Naively, Alice earns `R * (a_A / T)` per second.

Over `Δt` seconds, Alice earns `R * (a_A / T) * Δt`.

Easy. Two problems:

1. Bob might join or leave during the window. `T` is a function of time.
2. We can't iterate every staker on every transaction — it's O(n).

### A.2. The accumulator trick

Define:

```
rewardPerToken(t) = ∫₀ᵗ R/T(s) ds
```

> "*Reward earned per 1 staked token, since genesis.* This is a single global function of time."

Whatever Alice has earned from time `t₁` to `t₂`, regardless of how `T` fluctuated in between, is:

```
earned_A(t₁ → t₂) = a_A × (rewardPerToken(t₂) − rewardPerToken(t₁))
```

…assuming `a_A` was constant in the window. (If she changes her balance, we settle and start a new window.)

That's why the modifier in the contract settles `userRewardPerTokenPaid` *before* mutating `balanceOf`. The two are causally linked.

### A.3. From integral to discrete update

Solidity doesn't do calculus. We approximate the integral with piecewise constants:

```
rewardPerTokenStored ← rewardPerTokenStored + (Δt × R) / T_now
```

This is fired by the `updateReward` modifier whenever someone interacts. Between two consecutive interactions, `T` is constant — so the piecewise-constant approximation is *exact*, not an approximation. (Confirm the room follows this.)

### A.4. The `1e18` factor

`(Δt × R) / T_now` — if `R = 1` (one wei/sec) and `T = 100 ether = 1e20`, the integer division `Δt / 1e20` is 0 for any `Δt < 1e20` seconds (= 3 quadrillion years).

Fix: scale by `1e18` before dividing, then divide back when computing `earned`. The `PRECISION` factor is a *fixed-point trick*; it has nothing to do with token decimals.

Walk the room through the actual code:

```solidity
return rewardPerTokenStored + (elapsed * rewardRate * PRECISION) / totalStaked;
//                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//                              scaled up                       divided down
```

And then in `earned`:

```solidity
return (balanceOf[account] * delta) / PRECISION + rewards[account];
//      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//      scaled back to "raw reward tokens"
```

---

## Block B — APR, emissions schedules, sustainability (30 min)

### B.1. APR is a derived metric

```
APR (annual %) ≈ (rewardRate × seconds_per_year × reward_token_price)
               / (totalStaked × stake_token_price)
               × 100
```

If you want a "20% APR" on a $1 USDC stake against a $1 stable reward:

- `seconds_per_year = 365.25 × 24 × 3600 ≈ 3.156e7`
- want `rewardRate × 3.156e7 = 0.20` (annual emission per $1 staked, per year)
- => `rewardRate ≈ 6.34e-9` *per dollar staked, per second*

If you expect `totalStaked = $100,000`:
- `rewardRate ≈ 6.34e-4` USDC/sec ≈ ~55 USDC/day

That's how `rewardRate` becomes a *real number*, not a magic constant.

### B.2. APR vs APY

APR is linear ("simple interest"). APY is compounding. A staking protocol that *re-stakes* rewards yields APY; one that just pays out a stream yields APR.

Our contract: pays a stream, no auto-compound — so it's quoting APR. A v2 could auto-compound via an off-chain or contract-level reinvestment.

### B.3. Emissions schedules

Three common shapes:

1. **Flat rate** (what our contract does): `rewardRate` constant until the owner changes it. Simple, predictable, but goes to zero abruptly when the pool dries up.
2. **Linear decay**: `rewardRate(t) = R₀ × (1 - t/T)`. Smoothly approaches zero over `T`.
3. **Halving**: `rewardRate` halves every period. Bitcoin's model. Creates anchored milestones; useful narrative for marketing.

> "For Demo Day, flat is fine. The judges care more about whether you *thought* about it than which curve you chose. The bad answer is 'we'll figure it out later.'"

### B.4. Sustainability: rewardPool / rewardRate = runway

Trivial but critical: the contract's `rewardToken.balanceOf(address(this))` divided by `rewardRate` gives the *runway in seconds*. If you fund 100k RWD at 0.01 RWD/sec, your runway is `100_000 / 0.01 = 10,000,000` seconds ≈ 116 days.

The protocol must either:

- Top up before runway hits zero (centralized funding source);
- Generate yield from *protocol revenue* (fee-on-stake, fee-on-trade if part of a larger AMM, etc.);
- Or accept that staking ends at runway zero and pivot the product.

> "There is no free lunch. If your dApp 'pays' 20% APR with no revenue source, you are subsidizing it from a treasury that depletes. Be honest with the judges about where the money comes from."

---

## Block C — The four pillars of tokenomics (40 min)

This is the structure of [`meet-5-tokenomics-canvas.md`](./meet-5-tokenomics-canvas.md). Walk through each pillar with one example each, then send them to pair-fill the canvas.

### Pillar 1 — Supply (10 min)

- **Max supply:** fixed (BTC: 21M), elastic (rebase tokens), or uncapped (most ERC20s).
- **Initial supply** vs **circulating supply** at TGE (Token Generation Event).
- **Inflation rate:** how many new tokens enter circulation per year.

Question to provoke: *"If you printed 1M of your token today, what would one token be worth?"* Most attendees blank — the answer is "whatever someone will pay," which means: utility and scarcity.

### Pillar 2 — Vesting (10 min)

Who gets tokens, when do they unlock?

- **Team:** typically 1-year cliff + 3-year linear vest.
- **Investors:** 6–12-month cliff + 2–3-year vest.
- **Community/airdrops:** often unlocked immediately or with short cliffs.
- **Treasury:** owned by a multi-sig or DAO; spent on programmatic emissions (your staking rewards).

The vesting schedule is the protocol's *single most important credibility signal*. A 0-vest team allocation reads "we plan to dump"; an industry-standard schedule reads "we are here to stay."

### Pillar 3 — Utility (10 min)

What does the token *do*? Common buckets:

- **Governance** — vote on parameters (e.g., `rewardRate`). Useful but often weak alone.
- **Fee discount** — holding the token gives discounted protocol fees.
- **Staking** — what we just built. Receive a share of emissions and/or protocol revenue.
- **Access** — token-gates premium features.
- **Burn** — protocol revenue buys back & burns the token, reducing supply.

> "Real tokens use multiple. Pick at least two for your project; one is hand-wavy."

### Pillar 4 — Yield rate (10 min)

The formula attendees must internalize:

```
emission_per_year   = rewardRate × seconds_per_year
APR                  = (emission_per_year × reward_token_price) /
                       (totalStaked     × stake_token_price)
runway_in_seconds    = rewardToken.balanceOf(contract) / rewardRate
sustainable_rate     = (annual_protocol_revenue) / (totalStaked × stake_token_price)
```

> "If your *target APR* is higher than your *sustainable rate*, the difference is funded from your treasury. That's fine for launch (the 'subsidy phase'), but you must have a plan for the day subsidies end."

---

## Block D — Fill the Tokenomics Canvas (20 min)

In pairs (use Meet 1 pairings). Each pair fills [`meet-5-tokenomics-canvas.md`](./meet-5-tokenomics-canvas.md) for *their* chosen Bandung problem (from Meet 3). Facilitator rotates between pairs, asks hard questions.

Hard questions to ask:

- "Where does the reward token come from on day one?"
- "If I'm the user, why do I hold this token instead of just selling immediately?"
- "If you 10x your TVL, what happens to APR?"

---

## Closing (5 min) — Commit

Each pair posts a one-paragraph "tokenomics summary" in the cohort chat. Format:

```
PROJECT:        <one-liner>
STAKE TOKEN:    <what users deposit>
REWARD TOKEN:   <what they earn>
TARGET APR:     <%>
FUNDING SOURCE: <where reward emissions come from>
RUNWAY:         <days>
```

This becomes the "Tokenomics" slide of your Week 7 pitch deck.

---

## Slide outline

1. **Meet 5 — DeFi Economics**
2. **Today's question** — "Last week we copied formulas. Today we earn them."
3. **Naive earnings** — `R × (a/T) × Δt`, the two problems
4. **The accumulator** — `rewardPerToken(t) = ∫₀ᵗ R/T(s) ds`
5. **Piecewise update** — settle on every interaction
6. **The PRECISION trick** — `1e18` fixed-point
7. **APR formula** — derivation
8. **Emissions schedules** — flat / decay / halving
9. **Runway** — `pool / rate`, the brutal arithmetic
10. **Four pillars of tokenomics** — Supply, Vesting, Utility, Yield
11. **Vesting credibility** — the team-allocation litmus test
12. **Tokenomics Canvas** — preview of the template
13. **Exercise** — fill canvas with your pair, 20 min
14. **Commit** — one-paragraph summary in cohort chat

## Take-home checklist

- [ ] Tokenomics Canvas completed for your project.
- [ ] One-paragraph summary posted in cohort chat.
- [ ] You can derive `earned()` on a whiteboard for a friend.
- [ ] You have a number — in token units per second — for your `rewardRate`.
