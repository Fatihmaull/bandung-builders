# Tokenomics Canvas

> Fill this template in pairs during Meet 5. Submit a copy to the cohort chat. Becomes the "Tokenomics" slide of your Demo Day deck.

```
Project name : _______________________________________________
Team        : _______________________________________________
Date        : _______________________________________________
```

---

## 1. Supply

| Field                           | Value                       | Notes                                  |
| ------------------------------- | --------------------------- | -------------------------------------- |
| Max supply                      |                             | fixed / elastic / uncapped             |
| Initial supply at TGE           |                             | "Token Generation Event"               |
| Circulating supply at TGE       |                             | initial − locked (cliffs + vests)      |
| Reward-token supply (separate?) |                             | same token? distinct?                  |
| Inflation rate (yr 1)           |                             | %, as planned                          |
| Tail emission rate (yr 5+)      |                             | %, the long-term floor                 |

**Allocation table (must sum to 100%):**

| Bucket                  | %   | Cliff (months) | Linear vest (months) | Unlocks held by                |
| ----------------------- | --- | -------------- | -------------------- | ------------------------------ |
| Team                    |     |                |                      | multi-sig / vest contract      |
| Investors / strategic   |     |                |                      |                                |
| Community / airdrop     |     |                |                      |                                |
| Staking rewards pool    |     |                |                      | the StakingProtocol contract   |
| Liquidity / market-make |     |                |                      |                                |
| Treasury / ecosystem    |     |                |                      | DAO multi-sig                  |
| **Total**               | 100 | —              | —                    | —                              |

---

## 2. Vesting

For each bucket above with a cliff/vest, fill in:

| Bucket | Recipients (count) | Lockup contract (if known) | Schedule type (cliff+linear / step / custom) |
| ------ | ------------------ | -------------------------- | -------------------------------------------- |
|        |                    |                            |                                              |
|        |                    |                            |                                              |
|        |                    |                            |                                              |

**Credibility check:** does the team allocation have at least a 12-month cliff and a 24-month total vest? If not, write one sentence explaining why a sophisticated investor would still find this credible.

> _______________________________________________________________
> _______________________________________________________________

---

## 3. Utility

Tick every box that applies; fill in the specifics.

- ☐ **Governance** — vote on: ____________________________________
- ☐ **Fee discount** — discount of ___% on: ______________________
- ☐ **Staking** — pays out: ______________________________________
- ☐ **Access** — token-gated feature: ____________________________
- ☐ **Burn** — buyback-and-burn funded by: _______________________
- ☐ **Other** — _________________________________________________

**Reality check:** *"Why would I hold this token instead of selling immediately?"*

> _______________________________________________________________
> _______________________________________________________________

---

## 4. Yield rate (the formulas)

Use the symbols you derived in Block A of Meet 5. Fill in numbers.

```
rewardRate          (reward tokens / second)        = ______________
seconds_per_year    = 31_557_600                    (constant)
emission_per_year   = rewardRate × seconds_per_year = ______________
reward_token_price  (USD, assumed)                  = ______________
stake_token_price   (USD, assumed)                  = ______________

expected totalStaked at month 1 (USD)               = ______________
=> APR_month_1 = (emission_per_year × reward_token_price)
                 / (totalStaked × stake_token_price)
                 × 100                              = ______________ %

reward pool at launch (reward tokens)               = ______________
=> runway_in_seconds  = rewardPool / rewardRate     = ______________
   runway_in_days     = runway_in_seconds / 86400   = ______________
```

**Sustainability statement (≤ 2 sentences):** when the launch reward pool is depleted, where do further rewards come from?

> _______________________________________________________________
> _______________________________________________________________

---

## 5. The honest test (must answer)

**5.1.** *"If 10× the expected TVL stakes on day one, what happens?"*

> _______________________________________________________________

**5.2.** *"If TVL drops by 90% in month two, what happens?"*

> _______________________________________________________________

**5.3.** *"What is the single biggest economic risk to this protocol?"*

> _______________________________________________________________

---

## 6. Wire it to your contract

Once you've committed to numbers above, edit the live-coded constants in your Foundry deploy script:

```solidity
// contracts/script/Deploy.s.sol
uint256 internal constant INITIAL_REWARD_FUNDING = ___ ether;
uint256 internal constant INITIAL_REWARD_RATE    = ___ ether; // = rewardRate above, scaled to 1e18
```

> NOTE: Solidity's `1 ether == 1e18`. If your rewardRate is `0.01` reward tokens per second, that is `0.01 ether = 1e16` in contract units. Double-check the scale before you broadcast.
