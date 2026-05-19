# Workshop presentations

Interactive scroll-presentation pages for the 8 Bandung Base Builders sessions.

```
presentations/
├── index.html        Cohort home / nav
├── meet-1.html       Kick-Off & EVM
├── meet-2.html       Foundry & Setup
├── meet-3.html       Design Thinking + Bandung problems
├── meet-4.html       Solidity Staking
├── meet-5.html       DeFi Economics + Tokenomics
├── meet-6.html       Frontend Connection
├── meet-7.html       Pitching + GTM
├── meet-8.html       Demo Day + Deployment
└── assets/
    ├── styles.css    Shared base styles
    └── main.js       Shared widgets (scrollspy, checklists, copy-code, mobile nav)
```

## How to use them

### Locally (no build, no install)

Double-click `presentations/index.html`. That's it. Every link is relative; the
browser will resolve everything.

The pages use Tailwind via Play CDN, Prism.js for syntax highlighting, Mermaid.js
for diagrams, and Chart.js for the calculators. **First open requires internet.**
After that, the browser caches the CDN assets and pages run offline.

### Serving via a local HTTP server (recommended for `localStorage`)

Some browsers restrict `localStorage` on `file://` URLs. To get persistent checklist
progress and "Mark complete" indicators, serve over HTTP:

```bash
# from repo root
npx serve presentations
# or
python -m http.server 4000 --directory presentations
```

Then open `http://localhost:4000`.

### As live cohort projection

In facilitator mode:

- Use `Cmd/Ctrl + Shift + F` (or your browser's full-screen) for projection.
- The "Sections" sidebar acts as your speaker outline.
- Scrollspy highlights where you are; jump anywhere via the sidebar.
- Copy-code buttons appear on hover over any code block.
- `localStorage` keeps each attendee's checklist progress on their own laptop.

## Cross-references with `docs/`

These HTML pages are the **presentation surface** for the curriculum. The canonical
text lives at:

| Session | Source markdown |
|---|---|
| Meet 1 | [`docs/week-1/meet-1-kickoff-evm-narrative.md`](../docs/week-1/meet-1-kickoff-evm-narrative.md), [`meet-1-rules-of-the-game.md`](../docs/week-1/meet-1-rules-of-the-game.md), [`meet-1-skill-mapping.md`](../docs/week-1/meet-1-skill-mapping.md) |
| Meet 2 | [`docs/week-1/meet-2-foundry-setup.md`](../docs/week-1/meet-2-foundry-setup.md), [`meet-2-boilerplate-walkthrough.md`](../docs/week-1/meet-2-boilerplate-walkthrough.md) |
| Meet 3 | [`docs/week-2/meet-3-design-thinking.md`](../docs/week-2/meet-3-design-thinking.md), [`meet-3-bandung-problems.md`](../docs/week-2/meet-3-bandung-problems.md) |
| Meet 4 | [`docs/week-2/meet-4-solidity-staking.md`](../docs/week-2/meet-4-solidity-staking.md) |
| Meet 5 | [`docs/week-3/meet-5-defi-tokenomics.md`](../docs/week-3/meet-5-defi-tokenomics.md), [`meet-5-tokenomics-canvas.md`](../docs/week-3/meet-5-tokenomics-canvas.md) |
| Meet 6 | [`docs/week-3/meet-6-frontend-integration.md`](../docs/week-3/meet-6-frontend-integration.md) |
| Meet 7 | [`docs/week-4/meet-7-pitch-deck.md`](../docs/week-4/meet-7-pitch-deck.md), [`meet-7-gtm-base.md`](../docs/week-4/meet-7-gtm-base.md) |
| Meet 8 | [`docs/week-4/meet-8-deployment-checklist.md`](../docs/week-4/meet-8-deployment-checklist.md), [`meet-8-judging-rubric.md`](../docs/week-4/meet-8-judging-rubric.md) |

**Rule of thumb**: when you update a session's content for the next cohort, update the
markdown first, then mirror the change into the HTML page so they stay in sync.

## Interactive widgets per session

- **Meet 1** — Animated EVM state machine · L1-vs-Base cost calculator · Live block-number
  fetcher (real RPC call to `https://sepolia.base.org`) · Mermaid rollup diagram ·
  Rules-of-the-Game signature card.
- **Meet 2** — Typing terminal · Clickable annotated `foundry.toml` · Live `cast call` for
  WETH9.totalSupply() on Base Sepolia · File-tree explorer.
- **Meet 3** — EDIPT 5-phase carousel · 5 Bandung-problem flip cards · Trust-insight
  Mad-Libs statement builder with copy-out.
- **Meet 4** — Side-by-side code with Prism syntax highlighting · Live reward-accumulator
  simulator with 4 sliders · Mock `forge test -vvv` output · Reentrancy attack flow.
- **Meet 5** — APR calculator · Runway calculator · Chart.js `rewardPerToken(t)` plot ·
  Emissions-schedule comparator (flat vs decay vs halving) · Tokenomics Canvas form with
  localStorage save + JSON export.
- **Meet 6** — Clickable 3-layer stack diagram · Tx lifecycle animator (4 states with
  realistic delays) · Hook anatomy table · `useApproveStake` fill-in-the-blank exercise
  with reveal-solution toggle.
- **Meet 7** — 5-minute pitch countdown timer with section markers and a Web Audio chime
  at 30s · 90-second demo script with elapsed-time tracker · 12-question judge-question
  drill with shuffle.
- **Meet 8** — Pre-flight checklist · Pair smoke-test checklist (paired with peer) ·
  Disaster-recovery flowchart with click-to-expand · Judge's weighted scoring calculator
  (4 dimensions → total /10 with verdict).

## localStorage keys

The pages persist data per-browser. Keys are namespaced `bbb.v1.*`:

- `bbb.v1.chk.<group>` — checklist state for each session's take-home, smoke-test, etc.
- `bbb.v1.done.meet-N` — whether you clicked "Mark complete" on session N.
- `bbb.v1.tokenomics-canvas` — Meet 5 Tokenomics Canvas draft.

Clear via DevTools → Application → Local Storage if you want a fresh slate.

## Out of scope (intentionally)

- No backend, no API key handling. The live RPC calls hit Base Sepolia's free public endpoint.
- No build step (no Webpack, no Vite). Pure HTML/CSS/JS via CDNs.
- No translation. English only.
- No PDF export. Use the browser's "Print" → "Save as PDF" if you need a printable handout.
- No analytics. The pages don't phone home.

## Tested in

- Chrome / Edge / Brave 125+
- Firefox 128+
- Safari 17+
- iOS Safari + Android Chrome (mobile layout collapses sidebar to hamburger)
