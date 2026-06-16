# Script presentasi — Meet 3 (150 menit)

> **Facilitator only.** Baca sambil memandu ruangan.  
> **Slide peserta (projector):** [`meet-3.html`](../../../presentations/optimism/meet-3.html)  
> **Speaker script lengkap:** [`meet-3-design-thinking.md`](./meet-3-design-thinking.md)  
> **Problem briefs:** [`meet-3-bandung-problems.md`](./meet-3-bandung-problems.md)  
> **Live URL:** https://presentations-pi-blue.vercel.app/optimism/meet-3.html

**Legenda kolom**

| Kolom | Arti |
| ----- | ---- |
| **Waktu** | Menit ke-N dari awal sesi (0 = 0:00) |
| **Slide** | Anchor di `meet-3.html` |
| **Ucapkan / lakukan** | Script verbal + aksi |
| **Catatan** | Tutor, timing, defer |

**North star akhir sesi:** Setiap peserta punya **satu problem statement** tertulis — user, need, trust insight — siap dipakai di Meet 4.

**Prasyarat keras:** `forge test -vvv` hijau · wallet OP Sepolia funded · Rules of the Game acknowledged.

---

## Blok 0 · Opening & recap (menit 0–9)

| Waktu | Slide | Ucapkan / lakukan | Catatan |
| ----- | ----- | ----------------- | ------- |
| **0** | `#hero` | “Selamat datang, Bandung Builders. Meet 3 — **Ideasi Proyek & Design Thinking**. Hari ini **non-technical**: tidak ada terminal wajib, tidak ada Solidity baru.” | Buka slide peserta di projector |
| **1** | `#hero` | “Pertanyaan satu-satunya hari ini: **dApp kamu sebenarnya mau ngapain?** Kalau jawabannya cuma ‘staking protocol’ — belum ada produk.” | Tunjuk learning objectives |
| **2** | `#hero` | “Target akhir 2,5 jam: kamu bisa jelaskan **EDIPT versi Web3**, pilih **satu masalah Bandung**, dan tulis **problem statement** satu paragraf untuk Meet 4.” | |
| **3** | `#agenda` | Scroll ke agenda. Baca 7 baris: recap → EDIPT → empathize → break → define/ideate → prototype → commit. | |
| **4** | `#agenda` | “Stretch break di menit ke-70 — **10 menit**, jangan skip. Blok ideation butuh otak segar.” | |
| **5** | `#why` | Baca callout **Why this session exists** di slide — atau parafrase: “Meet 4 kamu tulis Solidity. Tapi Solidity = alat. **Staking = primitive (kata kerja). Produk = kata benda.** Siapa stake? Kenapa? Dapat apa?” | **Kalimat kunci** — minta repeat |
| **6** | `#why` | “Contoh buruk: ‘Ini dApp staking DeFi.’ Contoh lebih baik: ‘Pedagang pasar butuh loyalty tier yang vendor tidak bisa ubah sendiri.’” | |
| **7** | `#why` | Quick poll: angkat tangan yang **`forge test` masih hijau** sejak Meet 1+2. Yang belum — tutor bantu **offline**, jangan potong sesi ideation. | Checkpoint toolchain |
| **8** | `#why` | “Siapa sudah baca **`meet-3-bandung-problems.md`**? Tidak masalah kalau belum — kita bahas live. Yang sudah baca: jangan spoil pilihan grup lain.” | |
| **9** | `#why` | Transisi: “Framework kita: **EDIPT** — design thinking dengan twist Web3.” | Scroll ke Block A |

---

## Blok 1 · EDIPT — Web3 dialect (menit 10–39)

| Waktu | Slide | Ucapkan / lakukan | Catatan |
| ----- | ----- | ----------------- | ------- |
| **10** | `#block-a` | Gambar di whiteboard (atau tunjuk tab): `Empathize → Define → Ideate → Prototype → Test` dengan **panah loop** kembali ke Empathize. “Ini **loop**, bukan garis lurus.” | |
| **11** | `#block-a` | Klik tab **1. Empathize**. Baca definisi standar: observasi user nyata — konteks, frustrasi, workaround. | |
| **12** | `#block-a` | **Web3 twist:** “User kamu punya friksi extra — wallet, seed phrase, gas, RPC error, beda mental model **approve** vs **transfer**.” | |
| **13** | `#block-a` | **Bandung specifics:** “Banyak kandidat user sudah punya MetaMask/Coinbase Wallet dari wave e-commerce — tapi **DeFi nol**. Optimalkan supaya **dApp pertama** mereka = milik kamu.” | |
| **14** | `#block-a` | Klik tab **2. Define**. Template: *“\<user\> needs \<need\> because \<insight\>.”* | |
| **15** | `#block-a` | **Trust clause (wajib):** *“…dan trust assumption yang bikin smart contract **materially better** dari solusi centralized adalah \<X\>.”* | **Kalimat kunci #2** |
| **16** | `#block-a` | “Kalau \<X\> kosong — itu bukan masalah Web3; itu SaaS biasa dengan langkah extra. **Ganti masalah.**” | Push back keras nanti |
| **17** | `#block-a` | Klik tab **3. Ideate**. “Divergen dulu, judge later.” Lalu **4 pertanyaan wajib** sebelum ide dianggap valid: | Baca satu per satu |
| **18** | `#block-a` | (1) **Siapa bayar gas?** (2) **Siapa custody value?** (3) **Apa on-chain vs off-chain?** (4) **Failure mode kalau frontend hilang?** | |
| **19** | `#block-a` | Klik tab **4. Prototype**. “Fidelity paling rendah untuk test asumsi paling riskan.” | |
| **20** | `#block-a` | **Web3 twist:** “Asumsi paling riskan hampir selalu **perilaku user**, bukan kontrak. Prototype di **kertas/Figma dulu** — Solidity belakangan.” | Counter-intuitive — jeda |
| **21** | `#block-a` | “Meet 4 kita kasih **staking primitive** siap pakai. Kerja berat hari ini: **siapa mau pakai** dan **kenapa**.” | Preview Meet 4 |
| **22** | `#block-a` | Klik tab **5. Test**. “Taruh prototype di depan manusia nyata.” | |
| **23** | `#block-a` | **Web3 twist:** “Test di **testnet OP Sepolia**. 3–5 orang lewat flow dApp kamu sebelum Demo Day. Catat di mana mereka stuck. **Lebih valuable dari code review.**” | |
| **24–29** | `#block-a` | Q&A singkat EDIPT. Contoh cepat facilitator: user = treasurer UKM ITB · need = transparansi kas · trust = tidak percaya satu nama di rekening BCA. | 6 menit buffer |
| **30–39** | `#block-a` | **Mini-quiz verbal** (opsional): facilitator sebut ide buruk — “yield farming untuk semua orang” — peserta jawab **trust clause**-nya kosong atau tidak. | Flexible 10 menit |

---

## Blok 2 · Empathize — user Bandung nyata (menit 40–69)

| Waktu | Slide | Ucapkan / lakukan | Catatan |
| ----- | ----- | ----------------- | ------- |
| **40** | `#block-b` | “Blok B — **Empathize**. Bentuk **grup 3 orang**. Facilitator tentukan grup sekarang — jangan cluster teman dekat saja.” | Assign groups |
| **41** | `#block-b` | Tunjuk 5 kartu archetype di slide. “Ini **seed**, bukan jawaban. Brainstorm archetype **spesifik Bandung**.” | |
| **42** | `#block-b` | Baca cepat: seller Tokopedia/QRIS · driver Gojek/Grab · organizer kampus ITB · freelancer USDC · owner boba shop + stamp kertas. | |
| **43–52** | `#block-b` | **10 menit timer** — grup brainstorm archetype + pilih **satu**. Tulis **day-in-the-life** satu paragraf: minggu finansial + frustrasi yang *mungkin* Web3-shaped. | Facilitator set timer |
| **53–67** | `#block-b` | **15 menit timer** — lanjut polish paragraf. Push back kalau terdengar: “mau passive income crypto” — tanya: **“Selasa sore jam 3, orang ini ngapain?”** | Keliling push-back |
| **68** | `#block-b` | **5 menit read-around** — tiap grup 1 menit keras, satu orang baca paragraf. | Hard cap 60 detik/grup |
| **69** | `#block-b` | “Paragraf empathize **tidak harus** sama dengan problem yang akan kamu commit nanti. Ini latihan observasi.” | Transisi ke break |

---

## Blok 2b · Stretch break (menit 70–79)

| Waktu | Slide | Ucapkan / lakukan | Catatan |
| ----- | ----- | ----------------- | ------- |
| **70** | — | “**Break 10 menit.** Stretch, air, snack. Kembali menit ke-80 — siapkan kertas + pena untuk Block C.” | **Jangan potong** |
| **71–79** | — | Facilitator + tutor prep: pastikan link `meet-3-bandung-problems.md` di chat · siapkan sticky notes · projector di `#block-c`. | |

---

## Blok 3a · Define + Ideate — 5 problem briefs (menit 80–99)

| Waktu | Slide | Ucapkan / lakukan | Catatan |
| ----- | ----- | ----------------- | ------- |
| **80** | `#block-c` | “Blok C — **Define + Ideate**. Grup **sama** tadi. Buka slide **5 Bandung problems** — klik kartu untuk flip front/back.” | |
| **81** | `#block-c` | “Front = user + workaround. Back = framing **naive** (cocok staking vanilla) vs **ambitious** + **trust insight**.” | Demo flip 1 kartu |
| **82–91** | `#problems` | **10 menit silent read** — baca kelima brief: (1) Pasar loyalty (2) ITB treasury (3) Roastery co-op (4) Arisan driver (5) Creator patronage. | Timer silent |
| **92** | `#problems` | Brief 1 — **Pasar Vendor Loyalty**: vendor Pasar Baru/Kosambi, stamp kertas hilang hujan. Naive = stake loyalty points; ambitious = multi-vendor pool. | Flip kartu live |
| **93** | `#problems` | Brief 2 — **ITB Student Org Treasury**: rekening atas nama satu mahasiswa, handover tahunan chaos. | |
| **94** | `#problems` | Brief 3 — **Coffee Roastery Co-op**: WhatsApp + screenshot transfer, satu “treasurer roaster”. | |
| **95** | `#problems` | Brief 4 — **Gig-Worker Rainy-Day Pool**: arisan tetangga — pot-holder kadang kabur. Arisan = **social tech**; settlement = yang hilang. | |
| **96** | `#problems` | Brief 5 — **Creator Patronage**: Trakteer/Saweria ambil 5–20%, bisa deplatform. Milestone pledge = fitur kontrak. | |
| **97–99** | `#block-c` | “Grup pilih **satu brief** — boleh beda dari empathize tadi. Tulis problem statement format trust clause + **3 sketsa solusi** (1 kalimat each). Buruk OK — divergen.” | Timer 15 menit mulai menit 100 |

---

## Blok 3b · Problem statement + trust builder (menit 100–109)

| Waktu | Slide | Ucapkan / lakukan | Catatan |
| ----- | ----- | ----------------- | ------- |
| **100–114** | `#block-c` | **15 menit** grup lanjut tulis. Facilitator keliling — tanya 4 pertanyaan ideation: gas? custody? on/off-chain? frontend hilang? | |
| **105** | `#trust-builder` | Demo **Trust-insight builder** interaktif di slide: isi User · Need · Insight · Trust clause → statement auto-generate → **Copy statement**. | Projector demo |
| **106** | `#trust-builder` | “Format final: **\<user\> needs \<need\> because \<insight\>. Trust assumption: \<X\>.” Grup polish versi final. | |
| **107–109** | `#block-c` | **5 menit read-around** — tiap grup baca **1 sketsa solusi terbaik** (bukan full statement dulu). | 60 detik/grup |

---

## Blok 4 · Prototype + Test (menit 110–139)

| Waktu | Slide | Ucapkan / lakukan | Catatan |
| ----- | ----- | ----------------- | ------- |
| **110** | `#block-d` | “Blok D — **Prototype + Test**. Prinsip: prototype **murah, cepat, memalukan** > polish prematur.” | |
| **111** | `#block-d` | **D.1 Paper prototype — 15 menit, individual.** Gambar **3 layar**: landing · aksi utama (stake/claim/dll) · success state. | Bagikan kertas |
| **112** | `#block-d` | Annotate: di mana **Connect Wallet**? Di mana **gas** muncul di UX? Error state apa yang kamu design? | |
| **113–124** | `#block-d` | Timer 15 menit — gambar. Facilitator keliling. | |
| **125** | `#block-d` | **Test cepat:** tunjuk ke tetangga **tanpa jelaskan** — bisa tebak dApp kamu dalam **10 detik**? Kalau tidak = prototype gagal test #1. | Pair test |
| **126** | `#block-d` | **D.2 Wallet walk-through — 15 menit, grup 3.** Satu orang jadi “user”, jalanin flow **bayangan** pakai wallet asli (MetaMask). Dua lain **diam**, observe. | |
| **127–137** | `#block-d` | Walk-through + **5 menit debrief** per grup: di mana “user” bingung? | |
| **138** | `#block-d` | Baca callout hijau: “Usability test **nol baris kode**. Value-to-effort ratio tinggi. Week 4: **5 user nyata** di OP Sepolia sebelum Demo Day.” | |
| **139** | `#block-d` | “Kontrak staking Meet 4 = **mesin**. Problem statement hari ini = **mobil** yang mesin itu tenagai.” | Transisi commit |

---

## Blok 5 · Commit + close (menit 140–149)

| Waktu | Slide | Ucapkan / lakukan | Catatan |
| ----- | ----- | ----------------- | ------- |
| **140** | `#commit` | “**Commitment time.** Tiap peserta **wajib** tulis problem statement — sticky note atau paste di group chat.” | |
| **141** | `#commit` | Format wajib: `USER:` · `NEED:` · `INSIGHT:` (trust clause masuk insight). | |
| **142** | `#commit` | Baca **ground rules**: boleh pilih dari 5 brief **atau** masalah sendiri · **tidak boleh** “vanilla staking tanpa wrapper konsumen” · **harus satu** masalah sebelum Meet 4. | |
| **143** | `#commit` | **5 menit silent write** — pakai trust builder di laptop masing-masing, paste ke chat. Facilitator monitor chat. | **Checkpoint keras** |
| **144** | `#commit` | Hitung submission — target **100%** punya statement. Yang belum: tulis di sticky, foto ke chat **sebelum pulang**. | |
| **145** | `#takehome` | Homework 1: problem statement final (boleh refine, tidak boleh hilang). | |
| **146** | `#takehome` | Homework 2: baca **`meet-3-bandung-problems.md`** cover-to-cover kalau belum. | |
| **147** | `#takehome` | Homework 3: **skim** `contracts/src/StakingProtocol.sol` sekali — **jangan** pahami dulu. | |
| **148** | `#takehome` | Homework 4: baca OpenZeppelin **`ReentrancyGuard`** + **`Ownable` v5** — 15 menit. **`forge test` tetap hijau.** | |
| **149** | `#session-glossary` | “Istilah hari ini di **Kamus sesi** + `glossary.html`. **Preview Meet 4:** Solidity staking — reward accumulator, `updateReward`, `forge test` setiap edit. Bawa problem statement — itu **cerita produk** kamu. Terima kasih.” | **Selesai 2:30** |

---

## Ringkasan blok (referensi cepat)

| Menit | Blok | Mode |
| ----- | ---- | ---- |
| 0–9 | Opening + why | Talk |
| 10–39 | EDIPT Web3 dialect | Talk + quiz |
| 40–69 | Empathize (grup 3) | Workshop |
| 70–79 | Stretch break | Break |
| 80–109 | 5 problems + trust builder | Workshop |
| 110–139 | Paper prototype + wallet walk | Workshop |
| 140–149 | Commit + homework | Talk + submit |

---

## Contingency (potong dari atas jika meleset)

| Kekurangan | Potong |
| ---------- | ------ |
| −10 menit | Mini-quiz EDIPT + perpanjang silent read briefs jadi skim facilitator-led |
| −15 menit | Wallet walk-through → demo facilitator saja, 1 volunteer |
| −20 menit | Paper prototype → 1 layar saja; empathize read-around jadi 2 grup saja |

**Jangan potong:** Trust clause explanation · silent read 5 briefs (min. facilitator summary) · **problem statement commit** di akhir.

---

## Defer ke rumah (sebutkan keras agar peserta tenang)

- Implementasi Solidity / edit `StakingProtocol.sol` (Meet 4)  
- Tokenomics canvas (Meet 5)  
- Frontend hooks & RainbowKit (Meet 6)  
- Pitch deck polish (Meet 7)  
- Deploy & verify mainnet (**tidak pernah** — OP Sepolia only)

---

## Cheat sheet facilitator — 4 pertanyaan ideation

Sebelum grup commit, pastikan bisa jawab dalam 60 detik:

1. **On-chain primitive?** (hampir selalu: staking + reward accumulator)  
2. **Off-chain wrapper?** (produk: loyalty, treasury, escrow, arisan, patronage)  
3. **Siapa bayar gas?**  
4. **Frontend hilang — user masih bisa withdraw?**

---

*Bandung OP Builders · Presenter script · Meet 3 · 150 menit*
