# Script presentasi — Meet 1 + 2 gabungan (120 menit)

> **Facilitator only.** Baca sambil memandu ruangan.  
> **Slide peserta (projector):** [`meet-1-2-combined.html`](../../../presentations/optimism/meet-1-2-combined.html)  
> **Runbook:** [`meet-1-2-combined-facilitator.html`](../../../presentations/optimism/meet-1-2-combined-facilitator.html)  
> **Live URL:** https://presentations-pi-blue.vercel.app/optimism/meet-1-2-combined.html

**Legenda kolom**

| Kolom | Arti |
| ----- | ---- |
| **Waktu** | Menit ke-N dari awal sesi (0 = 0:00) |
| **Slide** | Anchor di `meet-1-2-combined.html` |
| **Ucapkan / lakukan** | Script verbal + aksi |
| **Catatan** | Tutor, timing, defer |

**North star akhir sesi:** EVM = state machine deterministik · ETH OP Sepolia · `forge test -vvv` hijau.

---

## Blok 0 · Opening (menit 0–4)

| Waktu | Slide | Ucapkan / lakukan | Catatan |
| ----- | ----- | ----------------- | ------- |
| **0** | `#hero` | “Selamat datang lagi, Bandung Builders. Minggu lalu kita sudah bahas gambaran besar Web3. Hari ini kita spesifik: **EVM**, **OP Sepolia**, dan **terminal Foundry**.” | Buka slide peserta di projector |
| **1** | `#hero` | “Di akhir 2 jam ini, target kamu tiga hal: bisa bilang *EVM = state machine deterministik*, wallet punya **ETH OP Sepolia**, dan **`forge test` hijau** di laptop sendiri.” | Tunjuk success criteria di slide |
| **2** | `#agenda` | Scroll ke agenda. Baca cepat 7 baris: opening → EVM → rules & faucet → Foundry → cast → hands-on → homework. | **Skip** round-robin intro |
| **3** | `#agenda` | “Repo kita: `tracks/optimism/` di GitHub `bandung-builders`. Slide ini ada di browser kamu — link sudah di group.” | Pastikan WiFi OK |
| **4** | `#opening` | “Tidak kita ulang Web3 101. Hari ini = **builder setup**. Terminal dan wallet harus terbuka sebelum menit ke-30.” | Transisi ke EVM |

---

## Blok 1a · EVM state machine (menit 5–11)

| Waktu | Slide | Ucapkan / lakukan | Catatan |
| ----- | ----- | ----------------- | ------- |
| **5** | `#opening` | “Minggu lalu = big picture. Hari ini kita jawab: **apa sebenarnya EVM** sebelum sentuh Solidity.” | |
| **6** | `#evm` | Gambar di whiteboard (atau tunjuk teks slide): `Transactions → EVM (deterministic) → new state` | |
| **7** | `#evm` | **Kalimat 1:** “EVM = **mesin state deterministik** — input sama, output sama di semua node di dunia.” | Minta repeat bareng |
| **8** | `#evm` | Klik demo interaktif: **Tx Alice → Bob 10 ETH**. “Lihat state before/after — murni fungsi dari tx.” | |
| **9** | `#evm` | Klik **Tx: Reverts**. “Revert = tidak ada perubahan state. Determinisme tetap.” Klik **Reset**. | |
| **10** | `#evm` | **Kalimat 2:** “**Gas = meteran compute** — storage mahal, calldata murah.” **Kalimat 3:** “**EOA** (private key) vs **Contract** (code + storage).” | |
| **11** | `#evm` | “Solidity compile jadi **opcode**; tiap baris = gas. Detail opcode & Merkle trie — **baca di rumah**, slide kamus.” | **Defer** opcode deep dive |

---

## Blok 1a · EVM visualizations (menit 12–14)

| Waktu | Slide | Ucapkan / lakukan | Catatan |
| ----- | ----- | ----------------- | ------- |
| **12** | `#evm-visuals` | “Tiga cara lihat EVM yang sama.” Tunjuk **diagram 1 — Global state machine**: Block N → tx → EVM → Block N+1. | |
| **13** | `#evm-visuals` | Tunjuk **diagram 2 — EOA vs Contract**: wallet vs bytecode. “Hanya EOA yang bisa **mulai** transaksi.” | |
| **14** | `#evm-visuals` | Tunjuk **diagram 3 — Gas ladder**: Storage $$$ > Memory $$ > Calldata $. “Ini yang bikin L2 masuk akal untuk dApp.” | Scroll ke flowchart Mermaid jika sempat |

---

## Blok 1b · OP Stack & OP Sepolia (menit 15–17)

| Waktu | Slide | Ucapkan / lakukan | Catatan |
| ----- | ----- | ----------------- | ------- |
| **15** | `#op-stack` | “Ethereum L1 mahal karena **setiap node** eksekusi semuanya. Solusi: **rollup**.” Gambar: `User → Sequencer → L2 → state root → L1` | |
| **16** | `#op-stack` | “Cohort default: **OP Sepolia** — testnet **OP Stack**, parent dari Base, Mode, Zora. Base = branded OP Stack; kita belajar di **induk stack**.” | |
| **17** | `#op-stack` | Baca tabel L1 vs OP Sepolia (chain ID, fee, block time). “Faucet: **Superchain Faucet**, login GitHub — nanti kita praktik.” | **Defer** superchain deep dive & cost calculator |

---

## Blok 1c · Live block (menit 18–19)

| Waktu | Slide | Ucapkan / lakukan | Catatan |
| ----- | ----- | ----------------- | ------- |
| **18** | `#live-block` | “Chain ID **11155420**, RPC `https://sepolia.optimism.io`. Klik **Fetch block number** di slide.” | Atau terminal facilitator |
| **19** | `#live-block` | **Checkpoint:** “Angka ini **sama di seluruh dunia**. Itu **determinisme**.” Tunjuk perintah `cast block-number …` di slide. | Contingency −10': skip WETH cast nanti, bukan ini |

---

## Blok 2a · Rules of the Game (menit 20–24)

| Waktu | Slide | Ucapkan / lakukan | Catatan |
| ----- | ----- | ----------------- | ------- |
| **20** | `#rules` | “Sebelum sentuh kode: **Rules of the Game** — lima kebiasaan cohort.” | Speed run, jangan debat |
| **21** | `#rules` | **Rule 1:** Ship over polish (Week 1–3). **Rule 2:** Setiap PR direview peer. | |
| **22** | `#rules` | **Rule 3:** Setiap contract change = **`forge test`**. **Rule 4:** **OP Sepolia only** — no mainnet. | |
| **23** | `#rules` | **Rule 5:** **AI co-pilot, bukan pilot** — kamu harus jelaskan setiap baris yang di-commit. | |
| **24** | `#rules` | “Tanda tangan Rules: **foto/scan async** ke group — jangan habiskan 15 menit di ruangan.” | Contingency −20': 100% async |

---

## Blok 2b · Superchain Faucet (menit 25–29)

| Waktu | Slide | Ucapkan / lakukan | Catatan |
| ----- | ----- | ----------------- | ------- |
| **25** | `#faucet` | “Semua buka **console.optimism.io/faucet** + MetaMask. Login **GitHub**.” Demo di projector. | **Jangan potong** blok ini |
| **26** | `#faucet` | “Pilih **OP Sepolia**, paste address wallet.” Peserta ikut parallel. | Buddy system aktif |
| **27** | `#faucet` | “MetaMask harus network **OP Sepolia**, chainId **11155420**.” Baca tabel network di slide. | |
| **28** | `#faucet` | Keliling cepat — angkat tangan yang **sudah lihat ETH** masuk. Pair yang stuck dengan yang sudah. | Tutor ke wallet salah network |
| **29** | `#faucet` | “Belum dapat? Stay calm — tutor bantu. Yang sudah: jangan sentuh repo dulu, kita Foundry dulu.” | Checkpoint faucet partial OK |

---

## Blok 3 · Pre-flight & Foundry toolbox (menit 30–39)

| Waktu | Slide | Ucapkan / lakukan | Catatan |
| ----- | ----- | ----------------- | ------- |
| **30** | `#foundry` | “Terminal semua **buka**. Ketik bersama — angkat tangan kalau error.” | |
| **31** | `#foundry` | `forge --version` — tunggu ~80% OK. | Tutor: Foundry / WSL2 |
| **32** | `#foundry` | `node --version` — harus v20+. | |
| **33** | `#foundry` | `pnpm --version` — harus 9.x. | Ref: `docs/00-prerequisites.md` |
| **34** | `#foundry` | “Tiga tool: **`forge`** build/test/deploy · **`cast`** RPC dari terminal · **`anvil`** local node/fork.” | |
| **35** | `#foundry` | Demo projector: `cd tracks/optimism/contracts` | Path dari repo root |
| **36** | `#foundry` | `forge build` — “compile Solidity ke JSON ABI + bytecode.” | |
| **37** | `#foundry` | `forge test -vvv` — “**Hijau = repo sehat**. Kalau merah, kita fix bareng di hands-on nanti.” | |
| **38** | `#foundry` | “Hardhat refugees: forge = hardhat, cast = ethers CLI, anvil = hardhat node — tapi Rust, lebih cepat.” | Opsional singkat |
| **39** | `#foundry` | “Yang belum install Foundry — pair tutor sekarang, harus siap sebelum cast field trip.” | |

---

## Blok 3 · foundry.toml (menit 40–44)

| Waktu | Slide | Ucapkan / lakukan | Catatan |
| ----- | ----- | ----------------- | ------- |
| **40** | `#foundry-toml` | “Buka tab **profile.default**: `solc_version = 0.8.24` — **pin**, jangan upgrade sembarangan.” | |
| **41** | `#foundry-toml` | “`optimizer_runs = 200` — standar workshop. Ini kebijakan cohort, bukan saran random.” | |
| **42** | `#foundry-toml` | Tab **rpc_endpoints**: `op_sepolia = "${OP_SEPOLIA_RPC_URL}"` — alias dari `.env`. | |
| **43** | `#foundry-toml` | Tab **etherscan**: `chain = 11155420` — untuk verify Meet 8. | Contingency −15': kirim link docs saja |
| **44** | `#foundry-toml` | “OpenZeppelin ada di `lib/` via **remapping** — detail baris-per-baris **homework**. `[fmt]` skip hari ini.” | **Defer** remappings quiz |

---

## Blok 4 · cast field trip — chain & block (menit 45–52)

| Waktu | Slide | Ucapkan / lakukan | Catatan |
| ----- | ----- | ----------------- | ------- |
| **45** | `#cast` | “**Ikuti di terminal.** Saya tunggu 80% sebelum lanjut per command.” | Everyone types |
| **46** | `#cast` | `#1` — `cast chain-id --rpc-url https://sepolia.optimism.io` → expect **11155420**. | |
| **47** | `#cast` | Tunggu. “Siapa dapat 11155420? Good — kamu di OP Sepolia.” | |
| **48** | `#cast` | `#2` — `cast block-number --rpc-url https://sepolia.optimism.io` | |
| **49** | `#cast` | “Angka block kamu harus **mendekati** angka di slide Fetch block tadi — determinisme lagi.” | |
| **50** | `#cast` | Opsional: `cast gas-price --rpc-url https://sepolia.optimism.io` — “wei; bagi 1e9 untuk gwei.” | Skip jika meleset |
| **51** | `#cast` | “Tanpa Solidity, tanpa frontend — kamu sudah **bicara ke jaringan**.” | |
| **52** | `#cast` | Breath. Yang error RPC — cek internet / VPN. | Tutor keliling |

---

## Blok 4 · cast — WETH & balance (menit 53–69)

| Waktu | Slide | Ucapkan / lakukan | Catatan |
| ----- | ----- | ----------------- | ------- |
| **53** | `#cast` | `#3` — WETH predeploy OP Stack `0x4200…0006` — `cast call … "totalSupply()(uint256)"` | Baca command dari slide |
| **54** | `#cast` | “Itu **kontrak orang lain** di L2 nyata — kamu baca storage/view function dari CLI.” | |
| **55** | `#cast` | Klik **Call totalSupply()** di slide (live demo browser) — “sama persis dengan `cast call`.” | Contingency −10': skip WETH |
| **56** | `#cast` | `#4` — `cast balance ALAMAT_WALLET_KAMU --rpc-url https://sepolia.optimism.io` | Paste address sendiri |
| **57** | `#cast` | “Harus > 0 kalau faucet tadi sukses. Nol? → network MetaMask salah.” | |
| **58** | `#cast` | Tunggu 80% selesai. **Checkpoint verbal:** “Tanpa tulis Solidity — kamu sudah bicara ke kontrak di L2 nyata.” | |
| **59–69** | `#cast` | **Buffer / Q&A singkat / ulang command** untuk yang stuck. Jangan mulai Blok 5 sampai mayoritas selesai 4 command. | Flexible 11 menit |

---

## Blok 5 · Hands-on checkpoint (menit 70–109)

| Waktu | Slide | Ucapkan / lakukan | Catatan |
| ----- | ----- | ----------------- | ------- |
| **70** | `#hands-on` | “**Blok paling penting.** Target: semua lihat **`Suite result: ok`**.” Facilitator + tutor keliling. | **Jangan potong** |
| **71** | `#hands-on` | `cd bandungbuildmaterial/tracks/optimism` — sesuaikan path clone masing-masing. | |
| **72** | `#hands-on` | `cp .env.example .env` dan `cp frontend/.env.local.example frontend/.env.local` | |
| **73** | `#hands-on` | `cd contracts` | |
| **74** | `#hands-on` | `forge install` — “first time pulls OpenZeppelin + forge-std.” | Fix: `--no-commit` OZ v5.0.2 |
| **75–78** | `#hands-on` | **Pause** — tutor fix `forge install` / Git / SSH issues. Facilitator monitor projector idle. | 4 menit triage |
| **79** | `#hands-on` | `forge build` — tunggu compile selesai. | |
| **80–83** | `#hands-on` | **Pause** — compile errors rare if deps OK. | |
| **84** | `#hands-on` | `forge test -vvv` — “ini safety net kamu 4 minggu ke depan.” | |
| **85–95** | `#hands-on` | **Pause** — mayoritas run tests. Fail? → biasanya belum `forge install`. Jangan deep debug dulu. | Tutor pair |
| **96** | `#hands-on` | “Angkat tangan yang **`forge test` hijau**!” Hitung — target >80%. | Checkpoint keras |
| **97–100** | `#hands-on` | Yang belum hijau: tutor lanjut **offline** setelah sesi. Yang sudah: bantu peer. | Pair programming |
| **101** | `#hands-on` | “Frontend detail **Meet 6**. Hari ini cukup tahu repo di `tracks/optimism/`.” | **Defer** boilerplate tour |
| **102–109** | `#hands-on` | Buffer: extra triage, screenshot `forge test` + balance untuk homework, stretch 30 detik. | Flexible 8 menit |

---

## Blok 6 · Close + homework (menit 110–119)

| Waktu | Slide | Ucapkan / lakukan | Catatan |
| ----- | ----- | ----------------- | ------- |
| **110** | `#takehome` | **Recap 4 bullet:** (1) EVM = deterministic state machine + gas (2) OP Sepolia + Superchain Faucet (3) `forge test` = safety net (4) `cast` = debug tercepat | |
| **111** | `#takehome` | “Yang **belum** hijau — stay 10 menit dengan tutor atau fix malam ini; **Meet 4 macet** tanpa ini.” | |
| **112** | `#takehome` | Homework 1: baca **Meet 1 `#superchain`** + cost calculator sendiri di slide `meet-1.html`. | |
| **113** | `#takehome` | Homework 2: isi **Skill mapping** — `docs/week-1/meet-1-skill-mapping.md`. | **Defer** in-room |
| **114** | `#takehome` | Homework 3: tanda tangan **Rules of the Game** — kirim foto ke group. | |
| **115** | `#takehome` | Homework 4: **Boilerplate walkthrough** — `meet-2-boilerplate-walkthrough.md`. | |
| **116** | `#takehome` | Homework 5: isi **WalletConnect projectId** di `.env.local` (Meet 6). | |
| **117** | `#takehome` | Homework 6: **screenshot** `forge test` hijau + saldo OP Sepolia → group. | |
| **118** | `#takehome` | **Preview Meet 3:** design thinking — bawa **1 masalah Bandung** mau diselesaikan on-chain. | |
| **119** | `#session-glossary` | “Istilah hari ini ada di **Kamus sesi** bawah slide + **`glossary.html`** lengkap. Terima kasih — minggu depan kita ide produk.” | **Selesai 2:00** |

---

## Ringkasan blok (referensi cepat)

| Menit | Blok | Mode |
| ----- | ---- | ---- |
| 0–4 | Opening | Talk |
| 5–19 | EVM + OP + live block | Talk + demo |
| 20–29 | Rules + Faucet | Talk + hands-on |
| 30–44 | Foundry + foundry.toml | Demo |
| 45–69 | cast field trip | Everyone types |
| 70–109 | forge install + test | Everyone types |
| 110–119 | Close + homework | Talk |

---

## Contingency (potong dari atas jika meleset)

| Kekurangan | Potong |
| ---------- | ------ |
| −10 menit | Live block + WETH `cast call` (cukup chain-id + balance) |
| −15 menit | `foundry.toml` detail → link docs |
| −20 menit | Rules verbal saja; tanda tangan 100% async |

**Jangan potong:** Superchain Faucet + `forge test` pass.

---

## Defer ke rumah (sebutkan keras agar peserta tenang)

- Skill mapping questionnaire di ruangan  
- Superchain deep dive + cost calculator interaktif  
- Block C Bandung vision panjang  
- Anatomy `foundry.toml` baris-per-baris + remappings quiz  
- Boilerplate walkthrough file-per-file  
- Whiteboard opcode detail, Merkle trie  

---

*Bandung OP Builders · Presenter script · Meet 1+2 combined · 120 menit*
