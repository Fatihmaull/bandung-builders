# Rules of the Game — Bandung Arbitrum Builders Cohort

> A signed contract between every attendee and the cohort.
> Read it. Sign at the bottom. Hand to the facilitator at Meet 1.

## Why this exists

Builder cohorts succeed or fail based on **habits**, not talent. We have 60 hours of synchronous time over four weeks to take you from "I can read Solidity" to "I can ship a Base dApp." That is enough — but only if we are disciplined.

These five rules are non-negotiable.

---

## Rule 1 — Ship over polish (until Week 4)

For Weeks 1–3, *imperfect & merged* beats *perfect & local*. If your contract works but isn't gas-optimal, ship it. If your UI is ugly but reads on-chain state correctly, ship it. We polish in Week 4.

**Operational:** every Thursday session ends with a `git push`. If your local code is broken, push a WIP branch — but push.

## Rule 2 — Every PR is reviewed by one peer

No solo merges to `main`. Open a PR, tag at least one cohort member, get one approval, then merge. The reviewer:

- Reads the diff.
- Pulls and runs `forge test` (contracts) or `pnpm dev` (frontend).
- Leaves at least one substantive comment.

If review is missing 6 hours before next session, the facilitator approves. You forfeit the peer-review pass for that week — track it; it counts in the cohort scoring.

## Rule 3 — Every contract change ships with a test

A `forge test` change must accompany every Solidity diff that touches behavior. If you add a function, add a happy-path test. If you fix a bug, add the regression test that would have caught it.

**Why this is the most important rule:** the staking protocol is mathematical. Visual review will miss off-by-one errors in `rewardPerToken()`. Tests catch them. A contract without tests is a hypothesis, not a deliverable.

## Rule 4 — No mainnet anything

Arbitrum Sepolia only. No mainnet RPC URLs in `.env`. No mainnet private keys. If you accidentally fund a mainnet address with workshop ETH, treat that ETH as gone — do not "just deploy a quick fix to mainnet to recover it." That is how exploits ship.

The repo's `.cursorrules` is configured to refuse mainnet suggestions. Do not override.

## Rule 5 — AI is a co-pilot, not the pilot

You will use Cursor / Copilot / Cline / Aider — encouraged. Your `.cursorrules` is dialed in for this project; the AI is your fastest pair-programmer.

But: **you must be able to explain every line you commit.** In peer review, the reviewer can ask "what does this line do?" and "why this approach over the alternative?" — and the answer "the AI wrote it" is not an answer.

Practically:
- Read every diff the AI produces before accepting.
- If you don't understand a piece, ask the AI to explain it; then ask the AI to challenge its own explanation.
- For the pitch in Week 4, you must be the source of all technical claims.

---

## Attendance & rescheduling

- 8 sessions, 2.5 hr each. Showing up to all 8 is the *floor*, not the ceiling.
- One excused absence is allowed, planned ≥48 hr in advance, with a written catch-up plan agreed with the facilitator.
- Two absences without a catch-up plan = you're out of the cohort and not eligible for the Demo Day pitch slot.

## AI usage policy summary

- ✅ Asking AI to generate scaffolding, tests, boilerplate.
- ✅ Asking AI to explain a concept or a diff.
- ✅ Asking AI to suggest a refactor or test case.
- ❌ Asking AI to do your peer review for you.
- ❌ Copy-pasting AI output you cannot defend in a code review.
- ❌ Using AI to generate the pitch deck's technical claims without verification.

## Communication channel hierarchy

1. **In-session, in-room.** Highest bandwidth. Save the hard questions for here.
2. **Cohort chat (Telegram/Discord).** Async, default. Post here unless it's urgent.
3. **Direct DM to facilitator.** Reserved for personal/blocking issues — losing a laptop, hospital, family emergency. Not for "I can't get `forge install` working".
4. **GitHub Issues.** For repo-level bugs and questions tied to a specific file or commit.

## Demo Day eligibility

You are eligible to pitch on Demo Day if and only if:
- [ ] You attended ≥7 of 8 sessions (or 6/8 with a documented catch-up).
- [ ] Your contract is deployed *and verified* on Arbitrum Sepolia.
- [ ] Your frontend is deployed (Vercel or equivalent) with the contract wired in.
- [ ] You have a repository with `main` building green.

---

## Signature

I, ___________________________________________, agree to the five rules above for the duration of the Bandung Arbitrum Builders cohort.

Signature: _____________________________
Date:      _____________________________
GitHub handle: __________________________
