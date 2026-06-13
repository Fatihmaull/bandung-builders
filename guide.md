# Facilitator guide — Bandung OP Builders

> **Audience:** Facilitator & co-tutors only. Peserta pakai slide peserta + `tracks/optimism/docs/skills.md`, bukan file ini.
>
> **Repo:** https://github.com/Fatihmaull/bandung-builders  
> **Default track:** OP Sepolia · `tracks/optimism/` · chainId `11155420`

---

## 1. Clone di machine baru

```bash
git clone https://github.com/Fatihmaull/bandung-builders.git bandungbuildmaterial
cd bandungbuildmaterial
git pull origin main
```

Verifikasi branch & commit terbaru:

```bash
git log -1 --oneline
git status
```

Target: working tree clean sebelum sesi.

---

## 2. Setup AI agent di machine facilitator

Agent **wajib** paham repo sebelum kamu mulai sesi. Load **semua** layer berikut di Cursor (atau agent lain):

| Prioritas | File | Fungsi |
| --------- | ---- | ------ |
| 1 | [`.cursorrules`](.cursorrules) | Kontrak coding: network, stack pin, staking spec, aturan refuse |
| 2 | [`tracks/optimism/docs/system-prompt.md`](tracks/optimism/docs/system-prompt.md) | Mirror `.cursorrules` untuk non-Cursor agents |
| 3 | **`guide.md` (file ini)** | Konteks facilitator: pre-flight, URL, alur sesi |
| 4 | [`presentations/optimism/meet-1-2-combined-facilitator.html`](presentations/optimism/meet-1-2-combined-facilitator.html) | Runbook 2 jam (buka di browser, bukan untuk peserta) |
| 5 | [`tracks/optimism/docs/week-1/meet-1-2-combined-presenter-script.md`](tracks/optimism/docs/week-1/meet-1-2-combined-presenter-script.md) | **Script ucapan menit-per-menit** (120 menit) |
| 6 | [`tracks/optimism/docs/skills.md`](tracks/optimism/docs/skills.md) | Prerequisite peserta per sesi — referensi saat triage |

### Cursor (recommended)

1. Buka folder `bandungbuildmaterial/` sebagai project root.
2. Pastikan `.cursorrules` ter-load (*Settings → Rules*).
3. Di chat, sebelum sesi: `@guide.md` + `@tracks/optimism/docs/system-prompt.md`.

### Agent lain (Continue, Copilot, Claude project)

Paste ke system instructions:

1. Isi penuh `tracks/optimism/docs/system-prompt.md`
2. Section **"Facilitator context"** dari file ini (section 3–8)
3. Untuk sesi hari ini: buka runbook HTML facilitator di browser; jangan share ke peserta

### Verifikasi agent (wajib sebelum buka ruangan)

Tanyakan ke agent:

```
1. What track and network is this cohort on?
2. Where do contract addresses live in the frontend?
3. What is the precision factor in staking reward math?
4. What must every participant have green before we leave today's combined session?
5. What must we NEVER suggest to participants?
```

**Jawaban benar:**

| Pertanyaan | Jawaban |
| ---------- | ------- |
| Track / network | `tracks/optimism/`, OP Sepolia, chainId `11155420` |
| Contract addresses | `tracks/optimism/frontend/src/lib/contracts.ts` only |
| Precision | `1e18` |
| Combined session exit | OP Sepolia ETH in wallet + `forge test -vvv` green |
| Never | Mainnet, remove ReentrancyGuard, hardcode addresses in components, skip tests |

---

## 3. Peta repo (yang facilitator perlu hafal)

```
bandungbuildmaterial/
├── guide.md                          ← kamu di sini (facilitator)
├── .cursorrules                      ← agent contract (semua track)
├── tracks/
│   └── optimism/                     ← DEFAULT cohort — kerjakan di sini
│       ├── contracts/                ← Foundry: src/, test/, script/
│       ├── frontend/                 ← Next.js 15 (Meet 6+)
│       ├── docs/                     ← Kurikulum markdown
│       │   ├── skills.md             ← Import agent untuk peserta
│       │   ├── 00-prerequisites.md
│       │   └── week-1/ … week-4/
│       ├── .env.example
│       └── README.md
├── presentations/
│   └── optimism/
│       ├── meet-1-2-combined.html           ← SLIDE PESERTA (projector + laptop peserta)
│       ├── meet-1-2-combined-facilitator.html ← RUNBOOK KAMU (privat)
│       ├── glossary.html
│       └── meet-1.html … meet-8.html
└── presentations/vercel.json         ← static deploy config
```

**Jangan campur track.** RPC, address, dan env dari `tracks/base/` atau `tracks/arbitrum/` tidak boleh muncul saat mengajar cohort Optimism.

---

## 4. URL live (bagikan ke peserta)

| Resource | URL |
| -------- | --- |
| Slide peserta (combined 2 jam) | https://presentations-pi-blue.vercel.app/optimism/meet-1-2-combined.html |
| Home OP Sepolia | https://presentations-pi-blue.vercel.app/optimism/ |
| Kamus workshop | https://presentations-pi-blue.vercel.app/optimism/glossary.html |
| Runbook facilitator (kamu saja) | https://presentations-pi-blue.vercel.app/optimism/meet-1-2-combined-facilitator.html |
| Repo GitHub | https://github.com/Fatihmaull/bandung-builders |
| Superchain Faucet | https://console.optimism.io/faucet |
| OP Sepolia explorer | https://sepolia-optimism.etherscan.io |

### Slide lokal (backup jika internet mati)

```bash
cd bandungbuildmaterial/presentations
npx serve .
# Buka http://localhost:3000/optimism/meet-1-2-combined.html
```

### Redeploy slide ke Vercel (setelah edit HTML)

```bash
cd bandungbuildmaterial/presentations
npx vercel deploy --prod
```

---

## 5. Konstanta network (hafal / tempel di whiteboard)

```
Network     : OP Sepolia
Chain ID    : 11155420
RPC         : https://sepolia.optimism.io
Explorer    : https://sepolia-optimism.etherscan.io
Faucet      : https://console.optimism.io/faucet  (GitHub login)
Work dir    : tracks/optimism/
Wagmi chain : optimismSepolia
```

---

## 6. Pre-flight facilitator — checklist

### H-7 (minggu sebelum sesi gabungan)

- [ ] Pull latest `main`; `git log -1` match dengan repo GitHub.
- [ ] Agent loaded & lulus verifikasi (section 2).
- [ ] Kirim ke group peserta: link slide + link repo + [`skills.md`](tracks/optimism/docs/skills.md) (section Combined Meet 1+2).
- [ ] Minta pre-install: Foundry, Node 20+, pnpm, Git, MetaMask, akun GitHub.
- [ ] Rekrut 1–2 tutor peer (yang sudah pernah `forge test` hijau).

### H-1 (sehari sebelum)

- [ ] Jalankan pre-flight machine facilitator (section 7) — semua hijau.
- [ ] Test projector: buka slide peserta + terminal font besar (zoom 150%+).
- [ ] Test faucet sendiri: claim OP Sepolia ETH ke wallet demo.
- [ ] Siapkan WiFi backup / hotspot.
- [ ] Print atau PDF: Rules of the Game (`tracks/optimism/docs/week-1/meet-1-rules-of-the-game.md`) — tanda tangan async OK.

### H-0 (30 menit sebelum sesi)

- [ ] Projector: `meet-1-2-combined.html` (peserta), bukan facilitator guide.
- [ ] Terminal facilitator: `cd tracks/optimism/contracts && forge test -vvv`.
- [ ] Tab browser: Superchain Faucet, slide live block + cast demo sections.
- [ ] Tutor standby untuk Windows/WSL + `forge install` issues.
- [ ] WhatsApp group pinned: link slide + repo clone command.

---

## 7. Pre-flight machine facilitator (jalankan di laptop kamu)

```bash
cd bandungbuildmaterial

# Toolchain
forge --version
node --version
pnpm --version
git --version

# Repo health (default track)
cd tracks/optimism
cp -n .env.example .env 2>/dev/null || copy .env.example .env
cp -n frontend/.env.local.example frontend/.env.local 2>/dev/null || copy frontend\.env.local.example frontend\.env.local

cd contracts
forge install
forge build
forge test -vvv

# RPC live
cast chain-id --rpc-url https://sepolia.optimism.io
# expect: 11155420

cast block-number --rpc-url https://sepolia.optimism.io
```

Semua harus hijau. Kalau `forge test` merah, fix **sebelum** peserta datang — sesi macet di Blok 5.

---

## 8. Menjalankan sesi gabungan Meet 1 + 2 (2 jam)

**North star:** setiap peserta bisa bilang *"EVM = state machine deterministik"*, punya ETH OP Sepolia, dan `forge test -vvv` hijau.

| Waktu | Blok | Mode | Referensi |
| ----- | ---- | ---- | --------- |
| 0:00–0:05 | Opening | Talk | Runbook facilitator #blok-0 |
| 0:05–0:20 | EVM + OP Stack + live block | Talk + demo | Slide `#evm`, `#evm-visuals`, `#op-stack`, `#live-block` |
| 0:20–0:30 | Rules + Faucet | Talk + hands-on | Slide `#rules`, `#faucet` |
| 0:30–0:45 | Foundry + foundry.toml | Demo | Slide `#foundry`, `#foundry-toml` |
| 0:45–1:10 | cast field trip | Everyone types | Slide `#cast` |
| 1:10–1:50 | forge install + test | Everyone types | Slide `#hands-on` |
| 1:50–2:00 | Recap + homework | Talk | Slide `#takehome` |

**Buka runbook lengkap:** [`meet-1-2-combined-facilitator.html`](presentations/optimism/meet-1-2-combined-facilitator.html) (timing, triage, contingency).

**Script ucapan menit-per-menit:** [`meet-1-2-combined-presenter-script.md`](tracks/optimism/docs/week-1/meet-1-2-combined-presenter-script.md) — baca di laptop kedua atau print.

**Jangan potong:** Superchain Faucet + `forge test` pass.

**Defer ke rumah:** skill mapping in-room, superchain deep dive, boilerplate file-per-file, tanda tangan Rules panjang di ruangan.

### Checkpoint keras (Blok 5 akhir)

Angkat tangan siapa `forge test -vvv` hijau. Yang belum → tutor lanjut offline.

### Perintah peserta (urutan wajib Blok 5)

```bash
cd bandungbuildmaterial/tracks/optimism
cp .env.example .env
cp frontend/.env.local.example frontend/.env.local
cd contracts
forge install
forge build
forge test -vvv
```

### Triage cepat

| Gejala | Fix |
| ------ | --- |
| `forge: command not found` | Pair tutor; Foundry install / WSL2 |
| `forge install` gagal | `forge install OpenZeppelin/openzeppelin-contracts@v5.0.2 --no-commit` |
| Test fail | Biasanya belum `forge install` |
| Faucet 0 balance | MetaMask salah network — harus OP Sepolia 11155420 |

---

## 9. Sesi lanjutan (Meet 3–8)

| Meet | Slide peserta | Docs facilitator |
| ---- | ------------- | ---------------- |
| 3 | `meet-3.html` | `docs/week-2/meet-3-design-thinking.md` |
| 4 | `meet-4.html` | `docs/week-2/meet-4-solidity-staking.md` |
| 5 | `meet-5.html` | `docs/week-3/meet-5-defi-tokenomics.md` |
| 6 | `meet-6.html` | `docs/week-3/meet-6-frontend-integration.md` |
| 7 | `meet-7.html` | `docs/week-4/meet-7-pitch-deck.md` |
| 8 | `meet-8.html` | `docs/week-4/meet-8-deployment-checklist.md` |

Sebelum setiap sesi: update agent dengan section Meet yang sesuai di [`skills.md`](tracks/optimism/docs/skills.md).

---

## 10. Menjalankan frontend (Meet 6+)

```bash
cd bandungbuildmaterial
pnpm install          # sekali, dari root monorepo
pnpm dev:optimism     # alias ke tracks/optimism/frontend
```

Env wajib Meet 6: `NEXT_PUBLIC_WC_PROJECT_ID` di `tracks/optimism/frontend/.env.local`.

---

## 11. Pesan template ke group peserta (H-3)

```
Halo builders — sesi gabungan Meet 1+2 (2 jam):

Slide (buka di laptop): https://presentations-pi-blue.vercel.app/optimism/meet-1-2-combined.html

Clone repo:
git clone https://github.com/Fatihmaull/bandung-builders.git
cd bandung-buildmaterial/tracks/optimism

Pre-install (wajib): Foundry, Node 20+, pnpm, Git, MetaMask, akun GitHub
Cek: forge --version && node --version && pnpm --version

Faucet: https://console.optimism.io/faucet (OP Sepolia, chainId 11155420)

Target akhir sesi: forge test -vvv hijau + ETH di wallet OP Sepolia.
```

---

## 12. Homework setelah sesi gabungan

| Task | Referensi |
| ---- | --------- |
| Baca Superchain deep dive | Slide `meet-1.html#superchain` |
| Skill mapping | `docs/week-1/meet-1-skill-mapping.md` |
| Tanda tangan Rules | `docs/week-1/meet-1-rules-of-the-game.md` |
| Walkthrough repo | `docs/week-1/meet-2-boilerplate-walkthrough.md` |
| WalletConnect projectId | `frontend/.env.local.example` |
| Screenshot | `forge test` hijau + saldo OP Sepolia → group |

Preview Meet 3: bawa 1 masalah Bandung untuk diselesaikan on-chain.

---

## 13. Tips projector & ruangan

- Terminal: dark mode, font ≥ 18pt, zoom 150%+.
- Hands-on > slide: target 50+ menit keyboard aktif (cast + forge).
- Buddy system: Web2 kuat + Web3 baru = 1 pasang.
- Defer dengan jelas — sebut apa yang sengaja ditunda ke rumah.

---

## 14. Agent facilitator — prompt siap pakai

Tempel ini ke agent saat sesi berlangsung (untuk triage peserta):

```
You are assisting the FACILITATOR of Bandung OP Builders cohort on OP Sepolia.
Track: tracks/optimism/ only. Testnet only. Never mainnet.

Today's session: Combined Meet 1+2 (2 hours).
Success criteria: every participant has forge test -vvv green and OP Sepolia ETH.

When helping triage:
- Prefer forge install fixes before deep test debugging
- Windows users → WSL2 for Foundry
- Faucet issues → check MetaMask network chainId 11155420
- Do not rewrite staking contract (that's Meet 4)
- Do not setup frontend (that's Meet 6)

Reference: guide.md and meet-1-2-combined-facilitator.html in repo.
```

---

## 15. Quick links (bookmark)

- **Repo:** https://github.com/Fatihmaull/bandung-builders
- **Slide peserta:** https://presentations-pi-blue.vercel.app/optimism/meet-1-2-combined.html
- **Runbook kamu:** https://presentations-pi-blue.vercel.app/optimism/meet-1-2-combined-facilitator.html
- **Kamus:** https://presentations-pi-blue.vercel.app/optimism/glossary.html
- **Kurikulum index:** [`tracks/optimism/docs/README.md`](tracks/optimism/docs/README.md)
- **Vercel dashboard:** https://vercel.com/fatihmaulls-projects/presentations

---

*Bandung OP Builders · Facilitator guide · Update when session format or URLs change.*
