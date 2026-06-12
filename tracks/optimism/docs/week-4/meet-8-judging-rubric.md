# Demo Day — Judge's Scoring Rubric

> Used by Meet 8 judges. Distribute to attendees *at the start of Week 4* so they can self-score and prioritize. Use again live on Demo Day.

## Format

Each project is scored across **4 dimensions**, weighted as shown. Each dimension scored **0–10**. Final score is the weighted sum (max 10.0).

| Dimension                    | Weight  |
| ---------------------------- | ------- |
| 1. Technical Execution        | **35%** |
| 2. Originality & Insight      | **20%** |
| 3. UI / UX                    | **20%** |
| 4. Business Viability         | **25%** |
| **Total**                    | **100%** |

## How to score 0–10 (rubric anchors)

For each dimension, the judges use these anchors. Don't pick "7 because the project felt like a 7." Pick the anchor sentence that best describes what you saw.

---

## 1. Technical Execution (weight 35%)

| Score | Anchor                                                                                                                                    |
| ----- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| 10    | Contract is deployed, verified on OP Sepolia Etherscan, fully tested with `forge test`. Demo flows work first try. Code shows mastery (gas, errors, modifiers correctly placed). |
| 8     | Contract deployed + verified. Demo works. Tests exist but light coverage. Some smells (missing nonReentrant, hardcoded values).            |
| 6     | Contract deployed but NOT verified, or verified but tests are placeholders. Demo works after a retry.                                     |
| 4     | Contract not deployed to OP Sepolia; only local. Demo via anvil/screenshot. Recognizable Solidity but with obvious bugs.                 |
| 2     | Contract compiles only. No tests. No live demo possible.                                                                                  |
| 0     | Forked or boilerplate code presented as own with no modification.                                                                          |

### Sub-criteria to consider when scoring this dimension

- ☐ Contract deployed to OP Sepolia? (Block: address visible on OP Sepolia Etherscan.)
- ☐ Contract **verified** on OP Sepolia Etherscan? (Read tab works.)
- ☐ `forge test` runs green locally? (Demo this in the room if asked.)
- ☐ Uses OpenZeppelin (`ReentrancyGuard`, `SafeERC20`, `Ownable`) correctly?
- ☐ Custom errors (not just `require` strings)?
- ☐ `vm.prank` and `vm.warp` in the test suite?
- ☐ No hardcoded contract addresses in the frontend?
- ☐ TypeScript strict, no `any` litter?

---

## 2. Originality & Insight (weight 20%)

| Score | Anchor                                                                                                                                                  |
| ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 10    | Problem framing is novel and *specifically Bandung*; the smart-contract framing reveals an insight a Web2 incumbent could not easily replicate.        |
| 8     | Familiar problem domain but with a Bandung twist and a clear "why blockchain" answer.                                                                  |
| 6     | A standard staking application (e.g., a generic LP rewarder) without obvious Bandung specificity, but well executed.                                   |
| 4     | A literal Synthetix / Sushibar copy with a new logo.                                                                                                   |
| 2     | Project description does not match the demoed product.                                                                                                 |
| 0     | Pure tutorial code, unmodified, with new branding.                                                                                                     |

### Sub-criteria

- ☐ Problem statement names a specific user persona (not "users")?
- ☐ The "trust insight" clause is articulated and credible?
- ☐ The solution would *not* trivially exist as a Web2 SaaS?
- ☐ Local relevance: would this make sense to a non-cohort Bandung resident?

---

## 3. UI / UX (weight 20%)

| Score | Anchor                                                                                                                                                  |
| ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 10    | First-time user can complete the primary action (stake/save/pledge) without a guide. Transaction lifecycle visible. Errors are surfaced and actionable. |
| 8     | UI is polished. Lifecycle visible. Onboarding has 1–2 friction points but recoverable.                                                                  |
| 6     | UI works but has rough edges: confusing labels, no loading states, errors are raw JSON.                                                                  |
| 4     | UI is functional only after explanation. Required actions are obscure.                                                                                  |
| 2     | UI exists but the demo had to be conducted via cast / OP Sepolia Etherscan to actually function.                                                                    |
| 0     | No UI presented.                                                                                                                                        |

### Sub-criteria

- ☐ Connect-wallet flow uses RainbowKit (or equivalent), not raw `window.ethereum`.
- ☐ Tx states (sign / pending / confirming / success / error) all visible.
- ☐ User can find the contract on OP Sepolia Etherscan from the UI in ≤ 2 clicks.
- ☐ Mobile-responsive at minimum (Safari iOS smoke-checked)?
- ☐ Error messages are user-readable (not `0xUNKNOWN_ERROR_TYPE`).

---

## 4. Business Viability (weight 25%)

| Score | Anchor                                                                                                                                                  |
| ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 10    | Concrete first-100-user channel identified. Monetization mechanism wired to the contract. Tokenomics canvas filled, runway numbers honest, moat plausible. |
| 8     | GTM plan exists with specific channels and a 30-day milestone. Tokenomics covered Slide 6.                                                              |
| 6     | "We'll go viral on X" or "We'll do influencer marketing." Vague but not absent.                                                                          |
| 4     | No mention of users, monetization, or sustainability. Pitched as a science project.                                                                     |
| 2     | Pitch slide 6 was skipped or fluffed.                                                                                                                   |
| 0     | Project openly described as "just a hackathon exercise; not intended to be used."                                                                       |

### Sub-criteria

- ☐ Pitch named a specific first-100 channel?
- ☐ Activation event was defined numerically?
- ☐ Revenue mechanism wired into the contract (fee, performance, treasury)?
- ☐ Runway calculation honest?
- ☐ Moat statement defensible against a follow-up question?

---

## Tie-breakers

If two projects tie within 0.1 of each other:

1. **Higher Technical Execution score wins.** This is a *builders'* cohort.
2. If still tied: **higher Originality & Insight score wins.**
3. If still tied: judges' panel deliberates briefly; majority vote.

## Judge's score sheet (one per project)

```
PROJECT NAME : __________________________________________
JUDGE        : __________________________________________

Technical Execution   ____ / 10  × 0.35 = ____
Originality & Insight ____ / 10  × 0.20 = ____
UI / UX               ____ / 10  × 0.20 = ____
Business Viability    ____ / 10  × 0.25 = ____
                                  ------
Total                                    ____ / 10

One thing this team did better than anyone else:
________________________________________________________

One thing this team should fix before submitting to a real hackathon:
________________________________________________________
```

## How attendees should use this rubric *before* Demo Day

The rubric is published with the cohort during Week 4 deliberately. Treat it as a checklist:

- For every "☐" sub-criterion above, can you tick it on your own project?
- Where can't you? That's your highest-leverage work for the next 48 hours.

This is not "teaching to the test" — the rubric *is* the test of whether you built something defensible.

## Special category: Best Bandung Story

Each judging round, one project is selected (by panel vote) for **Best Bandung Story** — the team whose problem framing and solution best embody a local insight the global Web3 ecosystem hasn't already saturated. Carries a separate prize from the overall scoring. Encourages truly local thinking over generic DeFi.
