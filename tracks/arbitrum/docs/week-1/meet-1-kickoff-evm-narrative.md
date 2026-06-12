# Meet 1 — Kick-Off & EVM Blockchain Mechanism

> **Track:** Non-Technical
> **Duration:** 2.5 hours
> **Audience:** 10–15 tech-savvy developers; mixed Web2/Web3 experience
> **Facilitator role:** Builders Lead — set the bar, frame the mission, level the floor

## Learning objectives

By the end of this session, every attendee can:

1. Describe the EVM as a deterministic state machine in their own words.
2. Explain why an L2 rollup is cheaper than L1 without saying "magic" or "compression" without elaborating.
3. State exactly what Base is, who runs it, and what its relationship to OP Stack / Ethereum is.
4. Articulate the cohort's mission, success criteria, and personal commitments.

## Materials

- Projector + slides (use the [slide outline](#slide-outline) below).
- Whiteboard or large notepad for diagrams.
- Printed copy of [`meet-1-rules-of-the-game.md`](./meet-1-rules-of-the-game.md) per attendee.
- Printed copy of [`meet-1-skill-mapping.md`](./meet-1-skill-mapping.md) per attendee.
- Snacks. Always snacks.

## Agenda (150 minutes)

| Time      | Block                                                                  |
| --------- | ---------------------------------------------------------------------- |
| 00:00–00:15 | Welcome, room intros, the Bandung Builders mission                   |
| 00:15–00:50 | Block A — Ethereum & EVM: the deterministic state machine            |
| 00:50–01:00 | Stretch break                                                         |
| 01:00–01:40 | Block B — Why L2? Rollup mechanics & Base specifics                  |
| 01:40–01:50 | Stretch break                                                         |
| 01:50–02:15 | Block C — The Bandung vision & the cohort contract                   |
| 02:15–02:30 | Skill mapping questionnaire + closing                                |

---

## Speaker narrative

### Opening (15 min) — Why we are here

> "Welcome. You are sitting in this room because somebody — maybe me, maybe a peer — believes you can ship a hackathon-grade dApp in four weeks. Not 'understand' one. Not 'tweak a tutorial' into one. **Ship** one. Deployed on Arbitrum Sepolia, verified on Arbiscan, with a frontend, and a pitch.
>
> This is not a Solidity 101 class. There are a million of those on YouTube. This is a builders' room. The bar for the next four weeks is: at the end, you walk into any global hackathon — ETHGlobal, Base Around the World, anywhere — and you ship.
>
> Before we touch code, we have to agree on what is true. Today is about three truths: what the EVM actually is, what Base actually is, and what we as a cohort actually owe each other."

Round-the-room intros (1 minute each, hard cap):
- Name + handle
- One Web2 thing you've shipped that you are proud of
- One Web3 thing you've used as a *user*
- What "shipping" at Demo Day means to you

Time-discipline matters here. Cut someone off at 60 seconds politely. You are setting the tempo for four weeks.

---

### Block A (35 min) — Ethereum & the EVM as a deterministic state machine

#### A.1. The mental model — 10 min

Draw on the whiteboard:

```
   [ Transactions ]  ->  [ EVM state machine ]  ->  [ new state ]
       (input)              (deterministic)             (output)
```

> "Forget cryptocurrency for a moment. The Ethereum Virtual Machine is one thing: a global, deterministic state machine. Given the same starting state and the same input, every node on Earth must compute the same next state. That is the entire trick.
>
> *Determinism* is the word that does the heavy lifting. The EVM forbids non-determinism: no system clock you can read, no `Math.random()`, no network calls, no file I/O. The only things a contract knows are: its own state, the global state available to it, the transaction calling it, and the block headers. That's it. That constraint is what lets thousands of independent nodes agree without trusting each other."

#### A.2. The EVM mechanism — 15 min

Cover, in this order:

1. **Accounts:** two types — *Externally Owned Accounts (EOAs)*, controlled by a private key; *Contract Accounts*, controlled by code stored at their address. Both have a balance in wei. Contracts also have persistent storage (a `mapping(bytes32 => bytes32)` conceptually).
2. **State:** the global state of Ethereum is a giant key-value store: address → `{balance, nonce, codeHash, storageRoot}`. A Merkle-Patricia trie commits to the whole thing.
3. **Transactions:** a signed message from an EOA that says "from `addr`, pay `gasPrice`, do `calldata` against `to`." The signature proves authorization; gas pays for compute.
4. **Gas:** every EVM opcode has a fixed gas cost. Gas is a metering primitive — it bounds compute per transaction so the network cannot be DoS'd by infinite loops.
5. **Opcodes:** the EVM is a stack machine with ~150 opcodes. `ADD`, `SSTORE` (write storage), `CALL` (external call), `KECCAK256`, etc. Solidity compiles down to these opcodes.
6. **Storage vs memory vs calldata:** storage is *persistent and expensive* (`SSTORE` is 22.1k gas for a zero→non-zero write on mainnet). Memory is RAM-like, dies at end of call. Calldata is read-only input, cheapest.

A useful sentence to repeat: *"Solidity is a thin language wrapped around opcodes. Every line you write maps to gas."*

#### A.3. Determinism + gas → why we need scaling — 10 min

> "Here is the punchline. Because every node on Earth has to execute every transaction, you cannot just throw more compute at Ethereum. Adding a faster machine doesn't help — every other node still has to follow along.
>
> So Ethereum scaled to the L1's natural limit: ~15 transactions per second, $2–$50 per swap during demand spikes. That is unshippable for a consumer dApp. A coffee app cannot ask its user to pay $7 in gas to claim a loyalty stamp.
>
> The solution is **rollups**. That's what Base is. We get there next."

---

### Block B (40 min) — Why L2? Rollup mechanics & Base

#### B.1. The rollup pattern in one diagram — 10 min

Draw on the whiteboard:

```
  L2 USERS  ->  L2 SEQUENCER  ->  EXECUTION ON L2  ->  STATE ROOT  ->  L1 CONTRACT
   (txs)         (orderer)         (cheap, fast)        (commit)        (verify/store)
```

> "A rollup does two things. First, it *executes* transactions off the main chain — at its own pace, with its own cheap fees. Second, and crucially, it *posts a compressed summary* back to Ethereum L1. The L1 contract is the truth source. The rollup borrows L1's security."

Two flavors:

- **Optimistic rollups** (Base, Optimism, Arbitrum): assume the sequencer is honest, allow anyone to dispute via a *fraud proof* during a ~7-day challenge window. Cheap on the happy path, slow to finally withdraw to L1.
- **Zero-knowledge rollups** (zkSync, Scroll, Linea, Polygon zkEVM): post a cryptographic proof that the new state root is correct. Faster finality, more compute-expensive to generate the proof.

Base is **optimistic**. The 7-day window only affects withdrawal-to-L1; intra-L2 activity is instant.

#### B.2. The OP Stack & Base specifically — 15 min

> "Base is an L2 built by Coinbase using the OP Stack — the open-source rollup framework maintained by Optimism. Base is not its own protocol invention; it's a *deployment* of the OP Stack with Coinbase as the sequencer.
>
> Why does that matter to you? Three things:
>
> 1. **EVM-equivalence.** Base is bytecode-identical to Ethereum L1. The same Solidity, the same opcodes, the same tools. Anything you learn here transfers to OP Mainnet, Zora, Mode, all the other OP-Stack chains.
>
> 2. **Coinbase distribution.** Base has ~110M+ Coinbase users one tap away. For a consumer dApp, that is the largest captive Web3 audience on Earth. We will design with that in mind — see Meet 7 on GTM.
>
> 3. **Fee economics.** Base typically settles transactions for *cents*. The cost lives almost entirely in the L1 data posting, which Base amortizes across many transactions, then further compresses via EIP-4844 blobs. Real-world Arbitrum Sepolia operations during this workshop will cost you fractions of a cent in test ETH."

Numbers to put on a slide:

| Property            | Ethereum L1      | Base                       |
| ------------------- | ---------------- | -------------------------- |
| Chain ID            | 1                | 8453 (Sepolia: **421614**)  |
| Block time          | ~12 s            | ~2 s                       |
| TPS (effective)     | ~15              | ~70+ steady-state          |
| Avg fee (USD)       | $0.30–$50        | $0.001–$0.05               |
| Sequencer           | None (decentral.) | Coinbase (today)           |
| Finality to L1      | ~12 s (justified) | ~7-day challenge window    |
| Bytecode parity     | —                | 100% EVM-equivalent        |

#### B.3. The Arbitrum Sepolia testnet — 15 min

> "We are not deploying to mainnet. Mainnet costs real money and is unforgiving. We are deploying to **Arbitrum Sepolia** — the testnet that mirrors Base's behavior, settling to Ethereum's Sepolia testnet.
>
> Concretely:
> - Chain ID: **421614**
> - Public RPC: `https://sepolia-rollup.arbitrum.io/rpc`
> - Explorer: `https://sepolia.arbiscan.io`
> - Faucet: Coinbase faucet, link in `docs/00-prerequisites.md`
>
> Everything we build runs here. The economic difference between Sepolia and mainnet is zero technical change — you flip an RPC URL. That is the point. Build cheap, iterate fast, then promote when ready (and you will *not* promote during this workshop)."

Walk through, live on the projector:

1. Open `https://sepolia.arbiscan.io`.
2. Show a recent block, a recent transaction. Point out: gas used, gas price (~0.001 gwei), the address types (EOA vs contract).
3. Click into a verified contract. Show "Read Contract" / "Write Contract" tabs. *"This is what your contract will look like in week 4."*

---

### Block C (25 min) — The Bandung vision & the cohort contract

#### C.1. Why Bandung, why now — 10 min

> "Bandung punches above its weight in software. The university density (ITB, UNPAD, TELU), the agency ecosystem, the cost of living — it has every ingredient of a great builders' city. What it doesn't yet have, on the global stage, is a critical mass of Web3 protocol talent.
>
> The thesis behind this cohort: *Web3 doesn't get built where capital is. It gets built where talent is.* The capital flies to the talent. Lens, Aave, Vyper, dYdX — none of those teams originated in Silicon Valley. The Bandung answer is to make this room one of the densest concentrations of Base-native builders in Southeast Asia.
>
> Within four weeks, you will:
> - Ship the staking protocol.
> - Deploy & verify it.
> - Pitch it.
>
> Within four months — if you choose — you ride that into ETHGlobal Bangkok, into Base Around the World, into a real protocol launch. This room is the seed of that."

#### C.2. The four-week arc — 8 min

Draw on the board the syllabus arc:

```
Week 1     Week 2          Week 3              Week 4
ALIGN  ->  BUILD CORE  ->  CONNECT & MODEL  ->  PITCH & SHIP
M1: EVM    M3: Ideate      M5: Tokenomics      M7: Pitch + GTM
M2: Tools  M4: Solidity    M6: Frontend        M8: Demo Day
```

> "By the end of Week 2 you have a contract on testnet that compiles and tests pass. By the end of Week 3 you have a UI talking to it. By the end of Week 4 you have a pitch and a story.
>
> Notice the cadence. Each week opens with strategy and closes with code. The Monday session frames the *why*. The Thursday session ships the *what*."

(Substitute your actual day-of-week cadence.)

#### C.3. The cohort contract — 7 min

Hand out [`meet-1-rules-of-the-game.md`](./meet-1-rules-of-the-game.md). Walk through the five rules in detail (script in that file). Have every attendee sign the bottom and submit to the facilitator.

> "These rules don't exist because I want to discipline you. They exist because the difference between cohorts that ship and cohorts that don't is *one habit*: showing up, on time, with last week's work done. The rules are the load-bearing part of the cohort."

---

### Closing (15 min) — Skill mapping & next session

#### Skill mapping

Hand out [`meet-1-skill-mapping.md`](./meet-1-skill-mapping.md). Five-minute fill-out. Collect physically *or* via a Google Form mirror. Use the results to pair-up attendees in Meet 2.

#### Next session preview

> "Meet 2 is technical. Before Thursday, you need:
> - Foundry installed (`forge --version` works).
> - Node 20+ installed (`node --version`).
> - The repo cloned.
> - `forge test` passing locally.
>
> All documented in `docs/00-prerequisites.md`. If you hit a wall, post in the cohort chat — don't suffer alone. We are explicitly judged on whether *the whole cohort* arrives at Meet 2 ready, not just the fastest 3 of you."

Adjourn.

---

## Slide outline (drop into Keynote/Slides)

1. **Bandung Arbitrum Builders — Cohort 01**
   - Date, your name, your handle
2. **Why you're here**
   - "In 4 weeks you ship a DeFi staking protocol on Arbitrum Sepolia"
   - 3 personal goals (fill in cohort-by-cohort)
3. **Three truths**
   - The EVM
   - The L2
   - The cohort
4. **What is the EVM?**
   - "A deterministic state machine, executed by every node"
   - Diagram: input → state machine → state
5. **EVM internals (1)**
   - EOAs vs Contract accounts
   - State = mapping(address → account)
6. **EVM internals (2)**
   - Gas = compute budget
   - Storage > memory > calldata in cost
7. **The scaling problem**
   - ~15 TPS, $$$ fees at peak
   - Solution: roll computation off-chain, post commitment on-chain
8. **Rollups in one picture**
   - L2 execute → state root → L1 verify/store
9. **Optimistic vs ZK**
   - Base = Optimistic
10. **What is Base?**
    - Coinbase-built, OP Stack, EVM-equivalent
    - Chain ID 8453 (Sepolia: 421614)
11. **Arbitrum Sepolia stats**
    - Block time, fees, faucet, explorer
12. **The Bandung vision**
    - 1 slide: "Talent attracts capital, not the other way around"
13. **The 4-week arc**
    - Week 1: Align · Week 2: Build · Week 3: Connect · Week 4: Pitch
14. **The Rules of the Game**
    - 5 rules, large type
15. **Your homework**
    - Prereqs done by Thursday
    - Skill-mapping form submitted before leaving today
16. **Q&A**

---

## Take-home checklist (issued to attendees)

- [ ] Skill-mapping questionnaire submitted.
- [ ] Rules of the Game signed.
- [ ] Prereqs installed per [`docs/00-prerequisites.md`](../00-prerequisites.md).
- [ ] Repo cloned, `forge test` passing.
- [ ] Joined the cohort chat (Telegram/Discord — facilitator's call).
- [ ] Arbitrum Sepolia ETH in your dev wallet.

---

## Facilitator pre-flight

Run these checks *before* the session starts:

- [ ] Repo URL projected and copy-pasteable.
- [ ] Whiteboard markers actually work (try them).
- [ ] Power strips for laptops in the room.
- [ ] Print 20 copies of Rules + Skill Mapping (5 extra for stragglers).
- [ ] Snacks + water out before doors open.
- [ ] Side conversation: identify your strongest 2–3 attendees in advance; they will be your peer reviewers next week.
