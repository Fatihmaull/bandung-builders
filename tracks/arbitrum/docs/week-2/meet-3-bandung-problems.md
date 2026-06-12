# Five Bandung Problem Briefs — DeFi on Arbitrum Sepolia

> Companion to [`meet-3-design-thinking.md`](./meet-3-design-thinking.md). Five concrete, locally-grounded problems where a staking-style protocol on Arbitrum Sepolia could be the engine.
>
> **Read this as a menu, not a prescription.** Each brief intentionally leaves design room. The "naive" framing makes the problem fit a vanilla staking contract. The "ambitious" framing pushes you to wrap the primitive in something users actually want.

---

## Brief 1 — Pasar (Wet-market) Vendor Loyalty Pool

### User
A wet-market vendor in Pasar Baru / Pasar Kosambi who already accepts QRIS payments and has a Coinbase Wallet because their nephew set it up.

### Today's workaround
Paper loyalty cards. Hand-stamped. Lost in the rain. No way to do tiered rewards or seasonal multipliers.

### Why this is plausibly Web3-shaped
- The vendor doesn't trust a Big Loyalty Platform with their margin.
- Customers don't trust the vendor's hand-stamped totals.
- A *shared* settlement layer with public state removes both trust gaps.

### Naive staking framing
Customers "stake" loyalty points (a vendor-issued ERC20). The longer they hold, the higher the discount tier when they redeem.

### Ambitious framing
A *multi-vendor* staking pool — stamps from any participating vendor in Pasar Baru flow into one pool; the pool funds shared marketing (a Saturday block party, an Instagram campaign). Vendors pay zero platform fees and own their data.

### Trust insight (the clause you must write)
*"Vendors will not adopt a centralized loyalty SaaS because they have been burned by Tokopedia/Shopee fees and policy changes; a Base-deployed protocol with an open, verifiable accumulator is materially better because no central party can change the terms unilaterally."*

---

## Brief 2 — ITB Student Organization Treasury

### User
A treasurer of a 200-member student organization at ITB (e.g., Himpunan, BEM, a UKM). Manages dues collection, event budgets, and yearly handover.

### Today's workaround
A shared GoPay/OVO/BCA account, screenshotted balances, Excel spreadsheets, paranoia at handover time, and a lot of disputed receipts.

### Why this is plausibly Web3-shaped
- Treasurer turnover is annual. Continuity of records is fragile.
- Membership is open and audit-able by definition. The state should be too.
- The bank account exists in *one person's name* and is a single point of failure.

### Naive staking framing
Members "stake" annual dues (USDC) into a contract. Dues *earn* the org's governance token. Officers can spend from the pool only with multi-sig approval.

### Ambitious framing
The contract becomes the org's *whole ledger*: dues, event budget allocations, vendor payments, sponsorship inflows — all on-chain, all viewable by any member, with proposals & approvals on-chain. Handover is now zero-work — the new treasurer is just a new signer.

### Trust insight
*"The current 'one student holds the account' arrangement repeatedly breaks at graduation; a Base-deployed multi-sig with transparent state removes the single point of failure without requiring members to trust any one individual."*

---

## Brief 3 — Coffee Shop "Roastery Co-op"

### User
The owner of a small-batch coffee roastery near Dago who buys green beans cooperatively with 4 other roasters to get bulk pricing.

### Today's workaround
WhatsApp group, screenshotted bank transfers, one trusted "treasurer roaster" who books the import.

### Why this is plausibly Web3-shaped
- The co-op is non-permanent — roasters come and go.
- Disputes about who paid what for which container are common.
- The treasury exists in one personal bank account, creating tax and trust issues.

### Naive staking framing
Roasters "stake" rupiah-pegged tokens (or USDC) into a pool for each import batch. The contract releases funds to a known supplier address on a milestone schedule.

### Ambitious framing
A reusable "small-business escrow + staking" module — every import becomes a new instance, the treasury isn't anyone's personal bank, and historical batch-level cost data accrues into a useful public record (negotiation leverage with suppliers).

### Trust insight
*"The 'treasurer roaster' arrangement creates personal tax exposure for one member and inevitable disputes over historical contributions; an on-chain co-op with USDC settlement removes both, and the audit trail is a feature, not a side effect."*

---

## Brief 4 — Gig-Worker Rainy-Day Pool

### User
A Bandung-area Gojek/Grab/Maxim driver who earns variable daily income and worries about lean weeks (Ramadan slowdowns, motorbike repairs).

### Today's workaround
"Arisan" (rotating savings & credit association) with neighbors — informal, paper-tracked, sometimes the rotating-pot holder absconds, sometimes friends fall out.

### Why this is plausibly Web3-shaped
- Arisan is *literally* a peer-to-peer staking-and-payout schedule.
- It already exists as social technology; the missing piece is settlement reliability.
- The user is risk-averse, low-margin, and gas costs matter — Base's sub-cent fees become a feature.

### Naive staking framing
N drivers each stake equal USDC monthly. The contract distributes the pooled monthly amount to one driver per month on rotation (configurable order).

### Ambitious framing
A more flexible variant: *priority claim* unlocks for emergency expenses (motorbike repair = stake a claim, vote-based approval by 2 others in the pool). The default rotation continues otherwise.

### Trust insight
*"Arisan participants are constantly worrying whether the pot-holder will run with the money; a Base contract removes the human pot-holder without removing the social bond, which is the actual value of arisan."*

---

## Brief 5 — Local Creator Patronage with Vesting

### User
A Bandung-based independent musician / illustrator / podcaster who has 500–2,000 super-fans and currently earns through Trakteer / Saweria / Patreon-equivalents.

### Today's workaround
Centralized patronage platforms that take 5–20% fees, can deplatform creators, and don't offer time-locked or milestone-based pledges.

### Why this is plausibly Web3-shaped
- Creator/audience relationship is direct; the platform is rent extraction.
- Pledges often want to be conditional: "I'll fund your album if you actually release it."
- Crypto-native fans exist (anime/music communities skew tech-adjacent).

### Naive staking framing
Fans "stake" USDC into a creator's pool. The creator earns a continuous stream (e.g., 0.001 USDC/sec). Fans can withdraw their stake (unsubscribe) anytime; rewards already streamed are non-refundable.

### Ambitious framing
*Milestone* stakes — fans pre-commit funds, the creator unlocks them only by minting a milestone NFT (e.g., "Album dropped"). If the milestone isn't met by a deadline, funds auto-return to fans.

### Trust insight
*"Patreon's existence is built on the premise that fans cannot directly pay creators; that premise is false on Arbitrum Sepolia because gas is sub-cent. The platform fee is rent that no longer needs to exist, and milestone-conditional pledges are a feature only smart contracts can offer."*

---

## How to use these for your team's selection

For each brief above, the cohort attendee should be able to answer in 60 seconds:

1. "What's the on-chain primitive?" (almost always: staking with a reward accumulator)
2. "What's the off-chain wrapper?" (the *product*: loyalty card, treasury, escrow, arisan, patronage)
3. "Who pays gas?" (the user, the protocol treasury, sponsored?)
4. "What's the failure mode if the frontend disappears?" (can users still withdraw?)

If you can answer all four, you have a defensible pitch. If you can't, return to the design-thinking session.

## Ground rules for picking

- You may pick from this list OR propose your own. Either is fine.
- You may *not* pick "vanilla staking pool with no consumer wrapper." That is not a product.
- You must commit to *one* problem before Meet 4 starts. Indecision now costs you 5 hours of build time you don't have.
