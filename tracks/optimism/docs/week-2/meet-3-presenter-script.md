# Script presentasi — Meet 3 (~160 menit)

> **Facilitator only.** Baca sambil memandu ruangan.  
> **Slide peserta (projector):** [`meet-3.html`](../../../presentations/optimism/meet-3.html)  
> **Speaker script lengkap:** [`meet-3-design-thinking.md`](./meet-3-design-thinking.md)  
> **Web3 sector map:** [`meet-3-web3-sectors.md`](./meet-3-web3-sectors.md)  
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
| **3** | `#agenda` | Scroll ke agenda. Baca 8 baris — perhatikan **selipan sector map** menit 10–22 sebelum EDIPT. | |
| **4** | `#agenda` | “Total ~**2 jam 40 menit**. Stretch break di menit ke-78. Blok ideation butuh otak segar.” | |
| **5** | `#why` | Baca callout **Why this session exists** di slide — atau parafrase: “Meet 4 kamu tulis Solidity. Tapi Solidity = alat. **Staking = primitive (kata kerja). Produk = kata benda.** Siapa stake? Kenapa? Dapat apa?” | **Kalimat kunci** — minta repeat |
| **6** | `#why` | “Contoh buruk: ‘Ini dApp staking DeFi.’ Contoh lebih baik: ‘Pedagang pasar butuh loyalty tier yang vendor tidak bisa ubah sendiri.’” | |
| **7** | `#why` | Quick poll: angkat tangan yang **`forge test` masih hijau** sejak Meet 1+2. Yang belum — tutor bantu **offline**, jangan potong sesi ideation. | Checkpoint toolchain |
| **8** | `#why` | “Siapa sudah baca **`meet-3-bandung-problems.md`**? Tidak masalah kalau belum — kita bahas live. Yang sudah baca: jangan spoil pilihan grup lain.” | |
| **9** | `#why` | Transisi: “Sebelum EDIPT — **peta sektor Web3**: DeFi, RWA, consumer, GameFi, SocialFi. Kamu perlu tahu **industri mana** wrapper produkmu.” | Scroll ke `#web3-sectors` |

---

## Blok 0b · Web3 sector map — selipan (menit 10–21)

| Waktu | Slide | Ucapkan / lakukan | Catatan |
| ----- | ----- | ----------------- | ------- |
| **10** | `#web3-sectors` | “Web3 **bukan satu industri** — ini **sektor** yang pakai rails sama: wallet, chain, smart contract. Produk kamu pilih **sektor**; engine cohort kita = **DeFi staking primitive**.” | **Kalimat kunci #3** |
| **11** | `#web3-sectors` | “Trend 2025–2026: dari spekulasi ke **utility** — DeFi matang, RWA tokenized treasuries tumbuh, consumer app gas murah di L2, GameFi/SocialFi fokus **retention** bukan airdrop.” | Jangan deep-dive data |
| **12** | `#web3-sectors` | Klik tab **DeFi**. “Lending, DEX, staking, stablecoin. **Engine kita di sini.** Brief treasury ITB & arisan driver.” | |
| **13** | `#web3-sectors` | Tab **RWA**. “Aset nyata on-chain — treasury, obligasi, kredit. Brief roastery = **escrow milestone**, bukan tokenize gedung.” | |
| **14** | `#web3-sectors` | Tab **Consumer**. “Bayar, tabung, loyalty — margin tipis butuh gas OP Sepolia sub-cent. Brief pasar & driver.” | |
| **15** | `#web3-sectors` | Tab **GameFi** + **SocialFi** — singkat: “Guild treasury / season pass vs patronage creator. Brief 5 = SocialFi klasik.” | 1 menit each |
| **16** | `#web3-sectors` | Tab **NFT/Membership** + **Infra** — “NFT = tiket/milestone accent. **Infra = bukan produk Demo Day** — kita build *on* OP Stack, bukan pitch L2 baru.” | Push back “we build L2” |
| **17** | `#web3-sectors` | Tab **AI × Web3** — “Emerging: agent + wallet. Stretch goal — AI propose off-chain, human approve on-chain.” | **Defer** implementasi |
| **18** | `#sector-map` | Tunjuk tabel **Bandung briefs → sectors**. “Setiap brief sudah map ke sektor — staking = **verb**, sektor = **noun**.” | |
| **19** | `#web3-sectors` | Baca callout hijau — minta repeat bareng: “**Sektor = noun. Staking = verb.**” | |
| **20** | `#web3-sectors` | Quick poll: “Sektor mana **instinct** kamu?” — angkat tangan DeFi / Consumer / SocialFi / lain. **Belum commit** masalah. | |
| **21** | `#web3-sectors` | Transisi EDIPT: “Sekarang framework **desain** produk di sektor yang kamu pilih.” | Scroll `#block-a` |

---

## Blok 1 · EDIPT — Web3 dialect (menit 22–47)

| Waktu | Slide | Ucapkan / lakukan | Catatan |
| ----- | ----- | ----------------- | ------- |
| **22** | `#block-a` | Gambar di whiteboard (atau tunjuk tab): `Empathize → Define → Ideate → Prototype → Test` dengan **panah loop** kembali ke Empathize. “Ini **loop**, bukan garis lurus.” | |
| **23** | `#block-a` | Klik tab **1. Empathize**. Baca definisi standar: observasi user nyata — konteks, frustrasi, workaround. | |
| **24** | `#block-a` | **Web3 twist:** “User kamu punya friksi extra — wallet, seed phrase, gas, RPC error, beda mental model **approve** vs **transfer**.” | |
| **25** | `#block-a` | **Bandung specifics:** “Banyak kandidat user sudah punya MetaMask/Coinbase Wallet dari wave e-commerce — tapi **DeFi nol**. Optimalkan supaya **dApp pertama** mereka = milik kamu.” | |
| **26** | `#block-a` | Klik tab **2. Define**. Template: *“\<user\> needs \<need\> because \<insight\>.”* | |
| **27** | `#block-a` | **Trust clause (wajib):** *“…dan trust assumption yang bikin smart contract **materially better** dari solusi centralized adalah \<X\>.”* | **Kalimat kunci #2** |
| **28** | `#block-a` | “Kalau \<X\> kosong — itu bukan masalah Web3; itu SaaS biasa dengan langkah extra. **Ganti masalah.**” | Push back keras nanti |
| **29** | `#block-a` | Klik tab **3. Ideate**. “Divergen dulu, judge later.” Lalu **4 pertanyaan wajib** sebelum ide dianggap valid: | Baca satu per satu |
| **30** | `#block-a` | (1) **Siapa bayar gas?** (2) **Siapa custody value?** (3) **Apa on-chain vs off-chain?** (4) **Failure mode kalau frontend hilang?** | |
| **31** | `#block-a` | Klik tab **4. Prototype**. “Fidelity paling rendah untuk test asumsi paling riskan.” | |
| **32** | `#block-a` | **Web3 twist:** “Asumsi paling riskan hampir selalu **perilaku user**, bukan kontrak. Prototype di **kertas/Figma dulu** — Solidity belakangan.” | Counter-intuitive — jeda |
| **33** | `#block-a` | “Meet 4 kita kasih **staking primitive** siap pakai. Kerja berat hari ini: **sektor + siapa user + kenapa**.” | Link ke sector map |
| **34** | `#block-a` | Klik tab **5. Test**. “Taruh prototype di depan manusia nyata.” | |
| **35** | `#block-a` | **Web3 twist:** “Test di **testnet OP Sepolia**. 3–5 orang lewat flow dApp kamu sebelum Demo Day. Catat di mana mereka stuck. **Lebih valuable dari code review.**” | |
| **36–41** | `#block-a` | Q&A singkat EDIPT. Contoh: treasurer UKM ITB · sector DeFi · trust = tidak percaya satu nama di rekening BCA. | 6 menit buffer |
| **42–47** | `#block-a` | **Mini-quiz verbal** (opsional): “yield farming untuk semua” → trust clause kosong? “Kita build L2” → sector salah? | Flexible 6 menit |

---

## Blok 2 · Empathize — user Bandung nyata (menit 48–77)

| Waktu | Slide | Ucapkan / lakukan | Catatan |
| ----- | ----- | ----------------- | ------- |
| **48** | `#block-b` | “Blok B — **Empathize**. Bentuk **grup 3 orang**. Facilitator tentukan grup sekarang — jangan cluster teman dekat saja.” | Assign groups |
| **49** | `#block-b` | Tunjuk 5 kartu archetype di slide. “Ini **seed**, bukan jawaban. Brainstorm archetype **spesifik Bandung** — ingat **sektor** dari tadi.” | |
| **50** | `#block-b` | Baca cepat: seller Tokopedia/QRIS · driver Gojek/Grab · organizer kampus ITB · freelancer USDC · owner boba shop + stamp kertas. | |
| **51–60** | `#block-b` | **10 menit timer** — grup brainstorm archetype + pilih **satu**. Tulis **day-in-the-life** satu paragraf: minggu finansial + frustrasi yang *mungkin* Web3-shaped. | Facilitator set timer |
| **61–75** | `#block-b` | **15 menit timer** — lanjut polish paragraf. Push back kalau terdengar: “mau passive income crypto” — tanya: **“Selasa sore jam 3, orang ini ngapain?”** | Keliling push-back |
| **76** | `#block-b` | **5 menit read-around** — tiap grup 1 menit keras, satu orang baca paragraf. | Hard cap 60 detik/grup |
| **77** | `#block-b` | “Paragraf empathize **tidak harus** sama dengan problem yang akan kamu commit nanti. Ini latihan observasi.” | Transisi ke break |

---

## Blok 2b · Stretch break (menit 78–87)

| Waktu | Slide | Ucapkan / lakukan | Catatan |
| ----- | ----- | ----------------- | ------- |
| **78** | — | “**Break 10 menit.** Stretch, air, snack. Kembali menit ke-88 — siapkan kertas + pena untuk Block C.” | **Jangan potong** |
| **79–87** | — | Facilitator + tutor prep: link `meet-3-bandung-problems.md` di chat · sticky notes · projector di `#block-c`. | |

---

## Blok 3a · Define + Ideate — 5 problem briefs (menit 88–107)

| Waktu | Slide | Ucapkan / lakukan | Catatan |
| ----- | ----- | ----------------- | ------- |
| **88** | `#block-c` | “Blok C — **Define + Ideate**. Grup **sama** tadi. Buka **5 Bandung problems** — klik kartu untuk flip. **Cocokkan sektor** dari tabel `#sector-map`.” | |
| **89** | `#block-c` | “Front = user + workaround. Back = framing **naive** vs **ambitious** + **trust insight**.” | Demo flip 1 kartu |
| **90–99** | `#problems` | **10 menit silent read** — kelima brief. Facilitator idle — jangan interupsi. | Timer silent |
| **100** | `#problems` | Brief 1 — **Pasar Vendor Loyalty** · sector **Consumer+DeFi**. | Flip kartu live |
| **101** | `#problems` | Brief 2 — **ITB Treasury** · sector **DeFi**. | |
| **102** | `#problems` | Brief 3 — **Roastery Co-op** · sector **RWA-adjacent**. | |
| **103** | `#problems` | Brief 4 — **Arisan Driver** · sector **DeFi+Consumer**. | |
| **104** | `#problems` | Brief 5 — **Creator Patronage** · sector **SocialFi**. | |
| **105–107** | `#block-c` | “Grup pilih **satu brief** — tulis problem statement + **3 sketsa solusi**. Sebut **sektor wrapper** di sketsa #1.” | Timer 15 menit mulai 108 |

---

## Blok 3b · Problem statement + trust builder (menit 108–117)

| Waktu | Slide | Ucapkan / lakukan | Catatan |
| ----- | ----- | ----------------- | ------- |
| **108–117** | `#block-c` | **15 menit** grup lanjut tulis. Facilitator keliling — 4 pertanyaan ideation + “**sektor mana?**” | |
| **113** | `#trust-builder` | Demo **Trust-insight builder** — Copy statement ke chat. | Projector demo |
| **116–117** | `#block-c` | **5 menit read-around** — tiap grup baca **1 sketsa terbaik** + sebut sektornya. | 60 detik/grup |

---

## Blok 4 · Prototype + Test (menit 118–147)

| Waktu | Slide | Ucapkan / lakukan | Catatan |
| ----- | ----- | ----------------- | ------- |
| **118** | `#block-d` | “Blok D — **Prototype + Test**. Prinsip: prototype **murah, cepat, memalukan** > polish prematur.” | |
| **119** | `#block-d` | **D.1 Paper prototype — 15 menit, individual.** Gambar **3 layar**: landing · aksi utama · success. Label **sektor** di corner (e.g. SocialFi). | Bagikan kertas |
| **120** | `#block-d` | Annotate: Connect Wallet · gas · error states. | |
| **121–132** | `#block-d` | Timer 15 menit — gambar. Facilitator keliling. | |
| **133** | `#block-d` | **Test cepat:** tetangga tebak dApp + **sektor** dalam 10 detik tanpa penjelasan. | Pair test |
| **134** | `#block-d` | **D.2 Wallet walk-through — 15 menit, grup 3.** | |
| **135–145** | `#block-d` | Walk-through + debrief per grup. | |
| **146** | `#block-d` | Callout hijau — usability test nol kode; 5 user nyata Week 4. | |
| **147** | `#block-d` | “Staking Meet 4 = **mesin**. Sector + problem statement = **mobil**.” | Transisi commit |

---

## Blok 5 · Commit + close (menit 148–161)

| Waktu | Slide | Ucapkan / lakukan | Catatan |
| ----- | ----- | ----------------- | ------- |
| **148** | `#commit` | “**Commitment time.** Problem statement + **sektor wrapper** (1 kata: DeFi / Consumer / SocialFi / …).” | |
| **149** | `#commit` | Format: `USER:` · `NEED:` · `INSIGHT:` · `SECTOR:` | |
| **150** | `#commit` | Ground rules — tidak boleh vanilla staking tanpa wrapper. | |
| **151–155** | `#commit` | **5 menit silent write** — trust builder + paste chat. | **Checkpoint keras** |
| **156** | `#commit` | Target **100%** submission. | |
| **157** | `#takehome` | Homework: problem statement · baca bandung-problems · skim StakingProtocol · OZ docs · **`forge test` hijau** | |
| **158** | `#takehome` | Opsional rumah: baca [`meet-3-web3-sectors.md`](./meet-3-web3-sectors.md) untuk pitch Meet 7. | |
| **159–160** | `#session-glossary` | Recap: EDIPT · trust clause · **8 sektor** · sector=noun staking=verb. Preview Meet 4 Solidity. | |
| **161** | `#session-glossary` | “Terima kasih — minggu depan **tulis kontrak**.” | **Selesai ~2:41** |

---

## Ringkasan blok (referensi cepat)

| Menit | Blok | Mode |
| ----- | ---- | ---- |
| 0–9 | Opening + why | Talk |
| 10–21 | **Web3 sector map (selipan)** | Talk + tabs |
| 22–47 | EDIPT Web3 dialect | Talk + quiz |
| 48–77 | Empathize (grup 3) | Workshop |
| 78–87 | Stretch break | Break |
| 88–117 | 5 problems + trust builder | Workshop |
| 118–147 | Paper prototype + wallet walk | Workshop |
| 148–161 | Commit + homework | Talk + submit |

---

## Contingency (potong dari atas jika meleset)

| Kekurangan | Potong |
| ---------- | ------ |
| −10 menit | Sector map → **4 tab saja** (DeFi, Consumer, SocialFi, Infra warning) + skip AI/GameFi |
| −15 menit | Mini-quiz EDIPT + wallet walk-through → 1 volunteer demo |
| −20 menit | Paper prototype → 1 layar; empathize read-around → 2 grup |

**Jangan potong:** Trust clause · sector=noun/staking=verb framing · **problem statement commit**.

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

*Bandung OP Builders · Presenter script · Meet 3 · ~160 menit*
