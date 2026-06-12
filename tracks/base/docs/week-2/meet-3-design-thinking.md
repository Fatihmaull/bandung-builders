# Meet 3 — Ideasi Proyek & Design Thinking

> **Track:** Non-Technical
> **Duration:** 2.5 hours
> **Companion doc:** [`meet-3-bandung-problems.md`](./meet-3-bandung-problems.md) — five concrete problem briefs

## Learning objectives

By the end of this session, every attendee can:

1. Walk through the five EDIPT phases (Empathize, Define, Ideate, Prototype, Test) in plain language.
2. Apply EDIPT specifically to a *Web3 product* (where assumptions about identity, custody, and incentives change the design).
3. Pick a Bandung-flavored problem from [`meet-3-bandung-problems.md`](./meet-3-bandung-problems.md) (or propose their own) and write a one-paragraph problem statement.
4. Articulate why "staking" is a *primitive*, not a product — and how to wrap it in something humans care about.

## Why this session exists (read aloud)

> "We are halfway to Week 2. By Meet 4 you will write Solidity. But Solidity is a means to an end. The hardest problem in Web3 is not 'how do I write a reward accumulator' — that's mechanical, and we'll teach you on Thursday. The hardest problem is: *what should the dApp actually do?*
>
> If your answer to 'what does it do' is 'it's a staking protocol,' you have built nothing. Staking is a *primitive*. It is the verb. What is the noun? Who stakes, why do they stake, what do they get?
>
> Today we slow down and answer that question."

## Agenda (150 minutes)

| Time      | Block                                                                    |
| --------- | ------------------------------------------------------------------------ |
| 00:00–00:10 | Recap Meet 2; open the question above                                  |
| 00:10–00:40 | Block A — EDIPT, the Web3 dialect                                      |
| 00:40–01:10 | Block B — Empathize: identifying a *real* Bandung user                 |
| 01:10–01:20 | Stretch break                                                          |
| 01:20–01:50 | Block C — Define + Ideate: 5 problems, 5 directions                    |
| 01:50–02:20 | Block D — Prototype + Test (paper, then wallet)                        |
| 02:20–02:30 | Each attendee commits to ONE problem statement for Meet 4              |

---

## Block A — EDIPT, the Web3 dialect (30 min)

Draw on the board:

```
EMPATHIZE  ->  DEFINE  ->  IDEATE  ->  PROTOTYPE  ->  TEST
   ^                                                   |
   +---------------------------------------------------+
                  (loop, not a line)
```

Walk through each phase. For each, give the **standard definition**, then the **Web3 twist**.

### A.1. Empathize

- **Standard:** observe a real user; understand their context, frustrations, workarounds.
- **Web3 twist:** your user has *additional* friction layers — wallet creation, seed phrases, gas, RPC errors, mental model of "approval" vs "transfer." If you don't empathize with this, you'll ship something only the cohort can use.
- **Bandung specifics:** the candidate users typically already own a wallet (Coinbase Wallet or Metamask) via the e-commerce/crypto wave, but they may have zero DeFi experience. Optimize for their first dApp interaction being *yours*.

### A.2. Define

- **Standard:** synthesize the empathy data into a problem statement of the form: *"<user> needs <need> because <insight>."*
- **Web3 twist:** add an explicit clause: *"…and the trust assumption that makes a smart-contract solution materially better than a centralized one is <X>."* If you can't fill in `<X>`, you don't have a Web3 problem; you have a regular SaaS problem with extra steps.

> "This clause is the test. If you cannot articulate the trust insight, you are forcing a square peg into a Web3 hole. Pick a different problem."

### A.3. Ideate

- **Standard:** divergent thinking. Sketch lots of solutions, judge later.
- **Web3 twist:** every idea must answer four questions before it's even considered:
  1. **Who pays gas?** (Sponsored? Subsidized? User?)
  2. **Who custodies value?** (Self-custody? Smart-wallet abstraction? Treasury?)
  3. **What does on-chain look like? What does off-chain look like?** (Don't try to put everything on-chain.)
  4. **What is the failure mode if the front-end disappears?** (Can users still recover funds?)

### A.4. Prototype

- **Standard:** lowest fidelity that lets you test the riskiest assumption.
- **Web3 twist:** the riskiest assumption is almost always *user behavior*, not the smart contract. Prototype the user journey on paper or in Figma *before* you write Solidity. The Solidity is the cheap part.

> "Counter-intuitive: the contract is easier than the UX. We have the staking primitive done by Meet 4. The hard work is figuring out who actually wants to use it and why."

### A.5. Test

- **Standard:** put the prototype in front of real users; observe.
- **Web3 twist:** *test on testnet*. Get 3–5 humans through your dApp on Base Sepolia before Demo Day. Watch them. Note where they get stuck. Time how long it takes them to do one transaction. This is more valuable than any code review.

---

## Block B — Empathize: identifying a real Bandung user (30 min)

Format: small groups of 3. Each group spends:

- **10 min** brainstorming user archetypes specifically grounded in Bandung life. Examples to seed the conversation (do not give them as answers — let them generate):
  - The Tokopedia/Shopee small-seller who already accepts QRIS.
  - The Gojek/Grab driver who sends remittance home weekly.
  - The campus organizer at ITB running a 200-person student event budget.
  - The freelance designer who occasionally takes USDC on Twitter from foreign clients.
  - The boba-shop owner running a paper loyalty stamp card.

- **15 min** picking ONE archetype and writing a "day-in-the-life" paragraph that includes: what their week looks like financially, what frustration they experience that *might* be Web3-shaped.

- **5 min** each group reads their paragraph aloud (1 minute hard cap).

> "If a paragraph reads like 'they want to earn passive income from crypto' — that's not Web3-empathy, that's wishful thinking. Push back. What does *Tuesday afternoon* look like for this person?"

---

## Block C — Define + Ideate: 5 problems, 5 directions (30 min)

Hand out [`meet-3-bandung-problems.md`](./meet-3-bandung-problems.md). It contains five concrete problem briefs. Each brief contains:

- The user
- The current workaround
- Why this is plausibly Web3-shaped
- A "naive" staking-protocol angle to spark ideation
- An "ambitious" version

Format: same groups of 3.

- **10 min** silent read of all five briefs.
- **15 min** group picks ONE brief (not necessarily the same one their empathy paragraph pointed to). Writes a problem statement in the structured form:

  > *"<user> needs <need> because <insight>. The trust assumption that makes a smart-contract solution better is <X>."*

  Then writes three solution sketches (one sentence each). Bad sketches are encouraged; this is divergence.
- **5 min** read-around. Each group's facilitator-chosen "best" sketch is read.

---

## Block D — Prototype + Test (paper, then wallet) (30 min)

The point of this block is to teach: *cheap, fast, embarrassing prototypes beat polished ones*.

Two-step exercise:

### D.1. Paper prototype (15 min)

Each attendee, individually:

- Draws on paper their dApp's three core screens: landing, primary action (stake/something), success state.
- Annotates: where does the wallet connect? Where does gas appear in the UX? What error states are you designing for?

> "Show your screen to your neighbor. Without explaining it, see if they can guess what your dApp does in 10 seconds. If they can't, the prototype has failed its first test."

### D.2. Wallet walk-through (15 min)

In groups of 3, one attendee plays "user" and walks through their imagined flow using only their actual wallet. The other two watch silently. Then a 5-minute debrief: where did the imaginary user get confused?

> "We just did a usability test with zero code. Notice the value-to-effort ratio. Do this with five real users in Week 4 — that's the bar before Demo Day."

---

## Closing (10 min) — Problem statement commitment

Each attendee writes — on a sticky note or in the cohort chat — their committed problem statement for Meet 4. It must contain:

- The user archetype.
- The need.
- The trust insight.

Format:

```
USER:    <who>
NEED:    <what>
INSIGHT: <why a smart-contract solution is materially better>
```

These are *not* permanent — they can refine. But they have to exist by the end of today, because Meet 4's staking contract is the *engine* underneath this product. You need to know what the product *is* before you tune the engine.

---

## Slide outline

1. **Meet 3 — Design Thinking, Web3 Edition**
2. **Why this matters** — "Solidity is the easy part. The product is the hard part."
3. **EDIPT diagram** — the 5 phases, looped
4. **Empathize — the Web3 twist** — added friction layers, wallet/gas reality
5. **Define — the trust clause** — *"and the trust assumption that makes Web3 better is…"*
6. **Ideate — 4 mandatory questions** — gas, custody, on/off-chain, failure mode
7. **Prototype — paper before Solidity** — counter-intuitive
8. **Test — on Sepolia, with humans** — 3–5 testers minimum
9. **Bandung users** — 5 archetypes
10. **5 problem briefs (preview)** — see companion doc
11. **Exercise: commit your problem statement** — sticky-note template
12. **Homework before Meet 4** — read the staking contract once, write your problem statement once

## Take-home checklist

- [ ] Submitted a one-paragraph problem statement.
- [ ] Read [`meet-3-bandung-problems.md`](./meet-3-bandung-problems.md) cover to cover.
- [ ] Skimmed [`contracts/src/StakingProtocol.sol`](../../contracts/src/StakingProtocol.sol) once; do not try to understand it yet.
- [ ] Read OpenZeppelin's docs on `ReentrancyGuard` and `Ownable` (v5) — 15 minutes.
