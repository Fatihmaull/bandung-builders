# Meet 7 — Pitching: The 5-Minute Hackathon Pitch

> **Track:** Non-Technical
> **Duration:** 2.5 hours
> **Companion:** [`meet-7-gtm-base.md`](./meet-7-gtm-base.md)

## Learning objectives

By the end of this session, every attendee can:

1. Deliver a 5-minute pitch with a 7-slide deck mapped to the structure below.
2. Open with a hook that lands in 15 seconds.
3. Demo the dApp live for ≤ 90 seconds without losing the room.
4. Close with a single, memorable ask.

## Agenda (150 minutes)

| Time      | Block                                                          |
| --------- | -------------------------------------------------------------- |
| 00:00–00:10 | Why pitching is engineering, not theatre                     |
| 00:10–00:40 | Block A — the 7-slide structure                              |
| 00:40–01:15 | Block B — the live demo (the make-or-break)                  |
| 01:15–01:25 | Stretch break                                                 |
| 01:25–02:10 | Block C — rehearsal in pairs, 2 cycles                       |
| 02:10–02:30 | Block D — final critique + commit ones                       |

---

## Opening (10 min) — Pitching is engineering

> "If you're a builder, pitching feels gross. You'd rather your code spoke for itself. The judges agree — they hate slick pitches with nothing under them.
>
> But here is the truth: **a pitch is a compression algorithm.** You have 5 minutes to transfer the most important 5% of your project into a stranger's head. That is a hard engineering problem, with a specification (judges' rubric) and constraints (time, attention). Treat it that way and you will out-perform every team that 'just winged it.'"

The good news: hackathon judges are kind. They want you to win. They will lean in if you give them an excuse to.

---

## Block A — The 7-slide structure (30 min)

Total time budget: 5 minutes. Roughly:

| Slide | Title                | Time      | Goal                                       |
| ----- | -------------------- | --------- | ------------------------------------------ |
| 1     | Hook                 | 0:00–0:30 | Stop the judges scrolling Twitter          |
| 2     | Problem              | 0:30–1:15 | "We're talking about [a real, painful thing]" |
| 3     | Solution             | 1:15–2:00 | One sentence, one diagram                  |
| 4     | Demo                 | 2:00–3:30 | 90 seconds, live, on OP Sepolia          |
| 5     | How it works         | 3:30–4:15 | The technical primitive, briefly           |
| 6     | Tokenomics + GTM     | 4:15–4:45 | Why this isn't a science project           |
| 7     | Ask + thanks         | 4:45–5:00 | One thing you want from the judges         |

### Slide 1 — Hook (30 seconds)

Three formats that work:

- **Surprising stat:** "33% of Bandung wet-market vendors have lost loyalty-card revenue to torn or wet paper."
- **A user quote:** "'I stopped doing arisan with my old friends because Bu Tati ran off with the pot.' — Pak Andi, GoCar driver."
- **A blunt question:** "What if a $0.001 transaction fee changed who you trust?"

**Bad hooks:** "We are building a dApp on OP Sepolia…", "Our team has been working on this for…", "Hello, I'm…".

> "The opening sentence is the most important sentence in the pitch. Judges decide in 10 seconds whether they're listening or refreshing. Earn the 10 seconds."

### Slide 2 — Problem (45 seconds)

Specific and human. Use a named persona, not "users."

- Bad: "DeFi has a UX problem."
- Good: "Bu Tati runs a kios in Pasar Baru. Twice this year her paper loyalty book got wet, and she lost data on 80 of her best customers. She tried switching to an app — Tokopedia's loyalty tools — but they take 12% off every reward and changed terms twice in 2024."

End the problem slide with one number that captures stakes:
- Bu Tati's monthly customer-loyalty revenue: $X.
- Wet-market vendors in greater Bandung: ~Y.
- Total annual paper-loyalty waste, conservatively: $Z.

### Slide 3 — Solution (45 seconds)

One sentence. One diagram. One bold claim.

> "PasarPoints is an on-chain loyalty pool any Bandung vendor can join for free, with sub-cent transaction fees and no central party that can change the rules."

Diagram: a 3-actor picture (customer ↔ contract ↔ vendor) with arrows labeled "stake", "earn", "redeem". Whiteboard-sketch quality is *better* than over-polished.

### Slide 4 — Live demo (90 seconds — the crux)

The slot is 90 seconds, and the rule is: it works the first time, in front of judges, on OP Sepolia. Detailed script lives in [Block B](#block-b--the-live-demo-the-make-or-break-35-min) below.

### Slide 5 — How it works (45 seconds)

Show the architecture in one diagram:

```
[Next.js dApp]  --Wagmi-->  [StakingProtocol.sol on OP Sepolia]  --SafeERC20-->  [STK, RWD tokens]
                                          ^
                                          | OZ ReentrancyGuard + Ownable
```

Mention exactly three things, no more:

1. The staking primitive (Synthetix-style accumulator).
2. The L2 (OP Sepolia, ~$0.001/tx, EVM-equivalent).
3. The wallet UX (RainbowKit, Coinbase Wallet first).

> "Judges have seen 30 pitches today. They don't want depth here — they want confidence that you know what you built."

### Slide 6 — Tokenomics + GTM (30 seconds)

Two lines, one bullet per:

- **Tokenomics:** "RWD pool funded by 3% transaction fee on stake/withdraw; subsidy ends at month 9 by current model."
- **GTM:** "Distribution: partnering with 1 named pilot vendor in Pasar Baru, expanding to 10 in Q2 via direct outreach."

Both lines should make a sophisticated listener nod, not raise their eyebrows. Avoid: "We'll go viral on Twitter."

### Slide 7 — Ask + thanks (15 seconds)

One ask. Examples:

- "If you're a Base ecosystem grant officer in the room: 10 minutes after this session would unlock our pilot."
- "We need a Bandung-resident wet-market connection. If you can intro us, find me at the door."
- "Try the dApp at `bandung.bandungbuildmaterial.vercel.app`. Tell us where it's confusing."

End on "Thank you" + your project URL on screen. Stop talking. Sit down.

---

## Block B — The live demo (the make-or-break) (35 min)

90 seconds. Here is the explicit script template:

### Pre-flight (do this *before* you start your pitch)

- Open Chrome, single-tab, with your deployed app already loaded.
- Wallet pre-connected. Pre-funded with OP Sepolia ETH and STK tokens.
- Browser zoom at 125–150% so judges can read the UI from the back row.
- Network tab closed. Console closed. No Slack notifications.
- A second device (phone) with the same dApp loaded, screen-mirrored if possible.

### The 90-second demo, second-by-second

| Time   | What you do                                                         | What you say                                                                  |
| ------ | ------------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| 0:00–0:10 | Show the connected app. Highlight balance.                       | "I'm Bu Tati. I have 100 STK in my wallet."                                  |
| 0:10–0:30 | Click Stake → wallet popup → sign → wait                         | "I deposit 50 into the pool. Fee: $0.001. Confirms in 2 seconds."             |
| 0:30–0:45 | Show the updated balance + 0 earned rewards                      | "Now I'm staked. I start earning rewards immediately."                        |
| 0:45–1:00 | (Pre-staked account on screen) show earned rewards ticking up    | "30 minutes ago I staked from another account. Look — 1.2 RWD earned, live."  |
| 1:00–1:15 | Click Claim → wallet popup → sign → success                      | "I claim my rewards. Funds in my wallet."                                     |
| 1:15–1:30 | Open OP Sepolia Etherscan link to the contract, scroll to "Read Contract" tab | "Everything you just saw — verified, transparent, on OP Sepolia."          |

### Demo failure recovery

The judges *will* see your demo fail in some way. Prepare for it.

- **Wallet rejects:** retry confidently, say "There it goes" — don't apologize. They've seen it 50 times today.
- **Tx slow to confirm:** keep talking. Use the time to explain *what* is happening. "OP Sepolia averages 2-second blocks, sometimes 3 — there we go."
- **Page blanks:** have a recorded screen video as a backup. *"In the interest of time, here's the same flow I just walked through."* Switch to it. Resume.
- **WiFi dies:** seriously, have the video.

> "The team that *recovers gracefully* from a demo glitch wins the room over the team whose demo was flawless. Judges are humans; they remember composure."

---

## Block C — Rehearsal in pairs (45 min)

Two rounds.

### Round 1 — 60-second condensed version (20 min)

Each attendee delivers ONLY slides 1, 2, 3, 7 to one partner. 60 seconds. Then partner gives 60 seconds of feedback:

- Did the hook land?
- Was the problem specific?
- Was the solution understandable?
- Was the ask memorable?

Swap.

### Round 2 — Full 5-minute version (25 min)

Each attendee delivers the *full* 5-minute pitch, *with* the demo, to a different partner. Partner times it. After, 3 minutes of feedback.

Strict rules:

- No interruptions during the pitch.
- The listener writes feedback while listening — does not look up — to simulate distracted judges.

---

## Block D — Final critique + commit (20 min)

### Pick the strongest 3 pitches

Each attendee nominates 2 cohort members whose pitch they want to see in front of the room. Top 3 by votes present live. The rest of the room (and you) gives one piece of substantive feedback each.

### Take-home checklist

- [ ] 7-slide deck drafted in Keynote/Slides/Pitch.
- [ ] Live-demo script written word-for-word and rehearsed at least 5 times.
- [ ] A screen-recorded backup of the demo, exported to MP4, on your laptop and on iCloud/Drive.
- [ ] Project name, one-liner, and URL pinned to the cohort chat.
- [ ] You can recite slide 1 (the hook) word-for-word from memory.

### Common mistakes to drill out

- **The "we" prelude:** "Our team has been thinking about this for…" — cut.
- **Reading the slides:** the slide is a backdrop, not a script. Tell the story; the slide reinforces.
- **No demo:** if you don't demo, the judges assume you can't. Demo even if it's rough.
- **Vague ask:** "Connect with us!" is not an ask. Be specific.
- **Going over time:** judges cut the mic at 5:00 sharp. Practice with a timer, every time.

---

## Slide outline (drop into Keynote/Slides)

1. **Slide 1 — Hook**: bold sentence, no other content.
2. **Slide 2 — Problem**: persona name, persona quote, one number.
3. **Slide 3 — Solution**: one-line description, 3-actor diagram.
4. **Slide 4 — Demo**: full-screen browser, no slide chrome.
5. **Slide 5 — How it works**: architecture diagram, 3 bullets.
6. **Slide 6 — Tokenomics + GTM**: 2 bullets, 1 number each.
7. **Slide 7 — Ask**: one sentence, your URL, your name + handle.
