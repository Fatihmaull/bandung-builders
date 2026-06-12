# Curriculum — Bandung Base Builders

A 4-week, 8-session intensive workshop teaching tech-savvy developers in Bandung to ship a hackathon-ready DeFi Staking Protocol MVP on Base Sepolia.

## Cadence

- **Duration:** 4 weeks
- **Sessions:** 8 total, 2 per week (one non-technical, one technical)
- **Session length:** 2.5 hours
- **Cohort size:** 10–15 developers
- **Final deliverable:** a deployed, verified contract on Base Sepolia + a connected Next.js dApp + a 5-minute pitch

## Files

### Onboarding

- [`00-prerequisites.md`](./00-prerequisites.md) — Foundry + Node + pnpm install, OS-agnostic.
- [`system-prompt.md`](./system-prompt.md) — AI agent operating contract (mirror of `/.cursorrules`).

### Week 1 — Alignment & Core Architecture

| File                                                                                 | Type            | Purpose                                                |
| ------------------------------------------------------------------------------------ | --------------- | ------------------------------------------------------ |
| [`week-1/meet-1-kickoff-evm-narrative.md`](./week-1/meet-1-kickoff-evm-narrative.md) | Speaker script  | EVM internals, Base L2 rollup mechanics, Bandung vision |
| [`week-1/meet-1-rules-of-the-game.md`](./week-1/meet-1-rules-of-the-game.md)         | Framework       | Workshop norms, accountability, AI usage policy        |
| [`week-1/meet-1-skill-mapping.md`](./week-1/meet-1-skill-mapping.md)                 | Questionnaire   | Pre-cohort skill survey for pair-up                    |
| [`week-1/meet-2-foundry-setup.md`](./week-1/meet-2-foundry-setup.md)                 | Hands-on doc    | OS-agnostic install, `foundry.toml` walkthrough        |
| [`week-1/meet-2-boilerplate-walkthrough.md`](./week-1/meet-2-boilerplate-walkthrough.md) | Hands-on doc | Tour of the monorepo & AI-rules file                   |

### Week 2 — Logic Development & Smart Contracts

| File                                                                                 | Type            | Purpose                                                  |
| ------------------------------------------------------------------------------------ | --------------- | -------------------------------------------------------- |
| [`week-2/meet-3-design-thinking.md`](./week-2/meet-3-design-thinking.md)             | Speaker script  | Web3 EDIPT framework (Empathize → Test)                  |
| [`week-2/meet-3-bandung-problems.md`](./week-2/meet-3-bandung-problems.md)           | Ideation prompt | 5 specific Bandung problems solvable on Base L2          |
| [`week-2/meet-4-solidity-staking.md`](./week-2/meet-4-solidity-staking.md)           | Live-coding doc | Walkthrough of `StakingProtocol.sol` + exercise + tests  |

### Week 3 — Advanced Ecosystem & Client Integration

| File                                                                                       | Type            | Purpose                                                    |
| ------------------------------------------------------------------------------------------ | --------------- | ---------------------------------------------------------- |
| [`week-3/meet-5-defi-tokenomics.md`](./week-3/meet-5-defi-tokenomics.md)                   | Speaker script  | The math of automated staking, derivation of `earned()`    |
| [`week-3/meet-5-tokenomics-canvas.md`](./week-3/meet-5-tokenomics-canvas.md)               | Template        | Supply / Vesting / Utility / Yield-Rate canvas             |
| [`week-3/meet-6-frontend-integration.md`](./week-3/meet-6-frontend-integration.md)         | Live-coding doc | Providers + custom hooks + UI assembly                     |

### Week 4 — Business Strategy & Launch

| File                                                                                 | Type            | Purpose                                                  |
| ------------------------------------------------------------------------------------ | --------------- | -------------------------------------------------------- |
| [`week-4/meet-7-pitch-deck.md`](./week-4/meet-7-pitch-deck.md)                       | Framework       | 5-minute, 7-slide hackathon pitch outline                |
| [`week-4/meet-7-gtm-base.md`](./week-4/meet-7-gtm-base.md)                           | Framework       | Go-to-market for low-gas consumer dApps on Base          |
| [`week-4/meet-8-judging-rubric.md`](./week-4/meet-8-judging-rubric.md)               | Scoring rubric  | Weighted criteria for Demo Day                           |
| [`week-4/meet-8-deployment-checklist.md`](./week-4/meet-8-deployment-checklist.md)   | Checklist       | Basescan verify + Vercel deploy walkthrough              |

## How to Use These Docs

Each Meet doc follows the same structure:

1. **Learning objectives** — what attendees should know/do by the end.
2. **Timeboxed agenda** — minute-by-minute for the 2.5-hour session.
3. **Speaker narrative** — what the facilitator says, sectioned.
4. **Slide outline** — bullet points ready to drop into Keynote / Google Slides.
5. **Hands-on / Exercise** — what the attendees do during/after.
6. **Take-home checklist** — what should be on `main` by next session.

The docs are intentionally written for the **facilitator**; attendees consume the docs as homework and reference, not as a presentation.
