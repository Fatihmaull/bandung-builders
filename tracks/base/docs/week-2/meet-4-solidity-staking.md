# Meet 4 — Smart Contract Development (Solidity + Forge)

> **Track:** Technical
> **Duration:** 2.5 hours
> **Companion files:**
> - Reference: [`contracts/src/StakingProtocol.sol`](../../contracts/src/StakingProtocol.sol)
> - Exercise: [`contracts/src/StakingProtocol.exercise.sol`](../../contracts/src/StakingProtocol.exercise.sol)
> - Tests: [`contracts/test/StakingProtocol.t.sol`](../../contracts/test/StakingProtocol.t.sol)

## Learning objectives

By the end of this session, every attendee can:

1. Read and explain a Synthetix-style reward accumulator (`rewardPerTokenStored`, `userRewardPerTokenPaid`, the `updateReward` modifier).
2. Write the body of `stake`, `withdraw`, and `getReward` from scratch.
3. Use `SafeERC20`, `ReentrancyGuard`, and OpenZeppelin v5's `Ownable` correctly.
4. Write Foundry tests that use `vm.prank`, `vm.warp`, and `vm.expectRevert`.
5. Run `forge test -vvv` and read a failing trace.

## Agenda (150 minutes)

| Time      | Block                                                                |
| --------- | -------------------------------------------------------------------- |
| 00:00–00:10 | Frame the math (5 min) + ground rules (5 min)                      |
| 00:10–00:40 | Block A — read the reference contract together                     |
| 00:40–01:50 | Block B — live-code the exercise (with breaks)                     |
| 01:50–02:20 | Block C — write & run tests                                        |
| 02:20–02:30 | Wrap & take-home                                                   |

> "By the end of today, you will have authored — *from your fingertips, not from a copy-paste* — a real DeFi staking primitive. We're going to do it side-by-side, slowly, with the AI muted for the first hour. After that, you may turn the AI on as a tool, not as a crutch."

---

## 🚀 Solidity Fast-Track: Panduan Kilat 1 Malam

Selamat datang di modul akselerasi Solidity. Panduan ini dirancang khusus untuk memahami konsep inti pengembangan *smart contract* Ethereum secara instan, aman, dan siap praktik malam ini menggunakan **Remix IDE**.

---

### 1. Struktur Dasar Smart Contract

Setiap file Solidity (`.sol`) wajib memiliki lisensi SPDX dan penentu versi kompiler agar dapat dieksekusi dengan benar oleh EVM.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BelajarKilat {
    // State Variable (Disimpan secara permanen di blockchain)
    string public teks;

    // Fungsi untuk mengubah data (Memerlukan Gas Fee)
    function setTeks(string memory _teksBaru) public {
        teks = _teksBaru;
    }

    // Fungsi untuk membaca data (Gratis / Tanpa Gas Fee jika dipanggil eksternal)
    function getTeks() public view returns (string memory) {
        return teks;
    }
}
```

### 2. Tipe Data Inti

| Tipe Data | Deskripsi | Contoh Penggunaan |
| --- | --- | --- |
| `uint256` | Angka bulat positif (unsigned integer 256-bit) | Menyimpan jumlah saldo, total suplai |
| `address` | Menyimpan alamat dompet (wallet) atau alamat contract lain | Menyimpan alamat owner atau deployer |
| `bool` | Nilai kebenaran logika (true atau false) | Status aktif/nonaktif fitur tertentu |
| `mapping` | Struktur data key-value (seperti hashmap/dictionary) | Memetakan alamat dompet ke saldo masing-masing |

```solidity
address public owner = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
mapping(address => uint256) public saldo;
```

### 3. Fungsi, Visibilitas, dan Modifiers

#### Visibilitas Fungsi
- **`public`**: Dapat dipanggil oleh siapa saja (dari luar maupun dari dalam contract itu sendiri).
- **`private`**: Hanya dapat dipanggil oleh fungsi lain yang berada di dalam contract yang sama.
- **`external`**: Hanya bisa dipanggil dari luar contract (lebih hemat gas untuk input data besar).
- **`internal`**: Hanya bisa dipanggil dari dalam contract atau contract turunannya (inheritance).

#### State Mutability
- **`view`**: Fungsi hanya membaca data dari blockchain tanpa mengubah state.
- **`pure`**: Fungsi tidak membaca maupun mengubah data blockchain (misal: kalkulasi matematika murni).

#### Constructor & Modifier
`constructor` adalah fungsi khusus yang dijalankan hanya satu kali saat contract pertama kali di-deploy. `modifier` digunakan untuk mengubah atau membatasi perilaku fungsi secara efisien.

```solidity
contract Kepemilikan {
    address public owner;

    constructor() {
        owner = msg.sender; // msg.sender adalah alamat yang men-deploy contract
    }

    modifier hanyaOwner() {
        require(msg.sender == owner, "Error: Bukan pemilik contract!");
        _; // Menjalankan sisa kode fungsi yang menggunakan modifier ini
    }

    // Fungsi ini dilindungi oleh modifier hanyaOwner
    function gantiOwner(address _ownerBaru) public hanyaOwner {
        owner = _ownerBaru;
    }
}
```

### 4. Lokasi Penyimpanan Data (Data Locations)
Solidity membagi penyimpanan data berdasarkan sifat permanen dan efisiensi biaya gas:
- **`storage`**: Data disimpan permanen di blockchain (seperti hard disk). Biaya gas sangat mahal. Variabel global otomatis bertipe storage.
- **`memory`**: Data disimpan sementara selama fungsi dieksekusi (seperti RAM). Biaya gas jauh lebih murah. Wajib digunakan untuk tipe data dinamis (seperti string, array, struct) di dalam fungsi.
- **`calldata`**: Tempat penyimpanan sementara khusus yang bersifat read-only (tidak bisa dimodifikasi). Sangat disarankan untuk argumen fungsi berjenis external karena paling hemat biaya gas.

### 5. Aliran Dana (Ether & Payable)
Agar smart contract dapat menerima dan mengirim aset Ether (ETH), keyword `payable` wajib disematkan pada fungsi atau tipe data alamat.

```solidity
contract Dompet {
    // Fungsi menerima Ether murni
    function isiSaldo() public payable {}

    // Mengecek saldo total yang dimiliki oleh contract ini
    function getSaldoContract() public view returns (uint256) {
        return address(this).balance;
    }

    // Mengirim seluruh Ether keluar dari contract ke alamat tujuan
    function tarikSemuaDana(address payable _keMana) public {
        uint256 jumlah = address(this).balance;
        (bool sukses, ) = _keMana.call{value: jumlah}("");
        require(sukses, "Transfer gagal");
    }
}
```

#### Fungsi Spesial: `fallback()` dan `receive()`
Dua fungsi ini tidak memiliki nama, tidak menerima argumen, dan tidak mengembalikan apa pun. Mereka otomatis dipanggil ketika ada interaksi tanpa data:
- **`receive() external payable`**: Dipanggil jika contract menerima Ether murni tanpa instruksi data apa pun.
- **`fallback() external payable`**: Dipanggil jika fungsi yang diakses oleh pengirim tidak ditemukan di dalam contract, atau jika contract menerima Ether tetapi fungsi `receive()` tidak didefinisikan.

### 6. Validasi, Error Handling, & Keamanan Dasar

#### Penanganan Error (Modern vs Klasik)
- **`require(kondisi, "pesan")`**: Memvalidasi input atau kondisi eksternal. Jika gagal, transaksi dibatalkan (revert) dan sisa gas dikembalikan ke user.
- **`assert(kondisi)`**: Digunakan untuk memeriksa invariant internal (kondisi yang seharusnya tidak pernah salah). Jika gagal, seluruh sisa gas akan hangus.
- **`revert CustomError()` (Rekomendasi Modern)**: Jauh lebih hemat biaya gas dibanding `require` dengan string teks.

```solidity
error SaldoKurang(uint256 tersedia, uint256 diminta);

contract ContohError {
    uint256 public totalSaldo = 100;

    function ambilDana(uint256 _jumlah) public view {
        if (_jumlah > totalSaldo) {
            revert SaldoKurang(totalSaldo, _jumlah);
        }
    }
}
```

#### Gas Optimization: Slot Packing
EVM menyimpan data dalam slot-slot berukuran 32 byte. Menyusun variabel berukuran kecil secara berurutan dapat menggabungkannya ke dalam satu slot yang sama, sehingga menghemat biaya transaksi secara signifikan.

```solidity
// BOROS GAS (Menggunakan 3 slot penyimpanan)
uint128 nilaiA;
uint256 nilaiB;
uint128 nilaiC;

// HEMAT GAS (Menggunakan 2 slot karena nilaiA dan nilaiC dikemas bersama)
uint128 nilaiA;
uint128 nilaiC;
uint256 nilaiB;
```

#### Keamanan: Reentrancy Attack
Kerentanan fatal di mana contract luar memanggil kembali fungsi penarikan sebelum status saldo internal diperbarui.

**Solusi Pola Checks-Effects-Interactions:** Selalu lakukan pengecekan (validasi), perbarui status (ubah saldo internal), baru kemudian lakukan interaksi (kirim Ether eksternal).

**Integer Overflow/Underflow:** Angka melewati batas maksimum atau minimum. Sejak Solidity versi 0.8.0, hal ini sudah otomatis ditangani (akan langsung revert jika terjadi overflow).

### 7. Standar Token Industri (EIP / ERC)
Pengembangan aplikasi web3 memanfaatkan standar token modular yang diawasi oleh OpenZeppelin:
- **`ERC-20`**: Standar untuk Fungible Token (Token yang dapat dipertukarkan dengan nilai setara, contoh: USDT, koin kripto biasa).
- **`ERC-721`**: Standar untuk Non-Fungible Token (NFT, setiap token bersifat unik dan tidak dapat dipertukarkan satu sama lain).
- **`ERC-1155`**: Standar Multi-Token (Dapat mengelola ERC-20 dan ERC-721 sekaligus dalam satu contract tunggal demi efisiensi tinggi).

### 8. Proyek Praktik Malam Ini: Pembuatan Token Sederhana
Salin kode final di bawah ini ke Remix IDE, kompilasi, dan lakukan simulasi deployment di Remix VM untuk mematangkan pemahaman Anda malam ini.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract KoinSimpel {
    string public nama = "Koin Malam";
    string public simbol = "KLM";
    uint256 public totalSuplai;
    address public pembuat;

    mapping(address => uint256) public saldo;

    // Event untuk melacak aktivitas transaksi di blockchain log
    event Transfer(address indexed dari, address indexed ke, uint256 jumlah);

    constructor(uint256 _suplaiAwal) {
        pembuat = msg.sender;
        totalSuplai = _suplaiAwal;
        saldo[msg.sender] = _suplaiAwal; // Alokasi awal diberikan penuh kepada pembuat contract
    }

    function kirimKoin(address _penerima, uint256 _jumlah) public {
        require(saldo[msg.sender] >= _jumlah, "Error: Saldo Anda tidak mencukupi");
        
        saldo[msg.sender] -= _jumlah;
        saldo[_penerima] += _jumlah;
        
        emit Transfer(msg.sender, _penerima, _jumlah);
    }
}
```

#### 🛠️ Langkah Eksperimen di Remix IDE
1. Buka browser Anda dan akses [Remix Project](https://remix.ethereum.org).
2. Buat file baru di dalam folder contracts, beri nama `BelajarSolidity.sol`.
3. Salin dan tempel kode `KoinSimpel` di atas ke dalam file tersebut.
4. Buka tab **Solidity Compiler** di sisi kiri, pilih versi kompiler yang sesuai (0.8.20), lalu klik tombol **Compile**.
5. Pindah ke tab **Deploy & Run Transactions**, pastikan Environment diatur ke **Remix VM**, masukkan angka suplai awal pada kolom input di samping tombol Deploy, lalu klik **Deploy**.
6. Ekspand menu contract di bagian bawah untuk menguji fungsi interaktif yang telah berhasil Anda buat!
```

\n## Frame (10 min)

### The math, in one paragraph

A staking protocol pays *X reward tokens per second*, split across whoever is staking *right now*. If you are alone with 100 STK staked, you earn X per second. If someone else joins with 100 STK, you each earn X/2 per second. If they leave, you go back to X.

Implementing this naively requires updating *every staker's balance* every time anyone joins or leaves — O(n) per call. That doesn't scale.

The Synthetix trick: maintain **one global accumulator**, `rewardPerTokenStored`, that represents "total reward earned per 1 staked token since genesis." Each user has their own checkpoint of this accumulator at their last interaction (`userRewardPerTokenPaid`). Their unclaimed rewards are simply:

```
earned(user) =
    balanceOf[user] * (rewardPerToken_now - userRewardPerTokenPaid[user])
  / PRECISION
  + rewards[user]
```

The genius: we only update one global value (`rewardPerTokenStored`) per state-change, regardless of staker count. O(1).

The `PRECISION = 1e18` factor is essential because Solidity has no decimals. Without it, `rewardRate * elapsed / totalStaked` would round to zero for any small case.

### Ground rules for the next 90 minutes

1. **AI off for Block A and the first 30 minutes of Block B.** You write with your fingers; you ask the human next to you when stuck.
2. **No peeking at `StakingProtocol.sol`** until you've made a real attempt at each TODO in the exercise file.
3. **Save and run `forge build` constantly.** Compile errors are friends.

---

## Block A — Read the reference (30 min)

Open [`contracts/src/StakingProtocol.sol`](../../contracts/src/StakingProtocol.sol) on the projector. Walk through *with the room*, top to bottom. For each section, ask one attendee to read it aloud, then you explain.

### A.1. SPDX + pragma

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
```

> "MIT licence keeps it permissive. `^0.8.24` matches the workshop pin. The `^` means '0.8.24 or any later 0.8.x'; combined with `solc_version = 0.8.24` in `foundry.toml`, the compiler is bit-for-bit deterministic."

### A.2. Imports

```solidity
import {IERC20}        from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20}     from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {Ownable}       from "@openzeppelin/contracts/access/Ownable.sol";
```

> "Named imports — Solidity 0.8.x style, way better than `import \"…\";` because the symbol is explicit. Trace each one to OZ v5; the API changed from v4 (especially `Ownable`'s constructor)."

### A.3. State

Walk through every variable. Emphasize:

- `IERC20 public immutable stakingToken;` — `immutable` saves a `SLOAD` per access; compiler embeds the value into runtime bytecode.
- `mapping(address account => uint256 reward) public rewards;` — Solidity 0.8.18+ named-mapping syntax. Pure documentation; doesn't affect bytecode.
- Custom errors live on the *interface*. They are part of the contract's public surface area.

### A.4. The `updateReward` modifier

```solidity
modifier updateReward(address account) {
    rewardPerTokenStored = rewardPerToken();
    lastUpdateTime = block.timestamp;

    if (account != address(0)) {
        rewards[account] = earned(account);
        userRewardPerTokenPaid[account] = rewardPerTokenStored;
    }
    _;
}
```

This is the heart of the contract. Explain *the order*:

1. First, settle global state — `rewardPerTokenStored` is brought current.
2. Then, *if* a specific user is interacting, settle their personal state too.
3. Then, run the function body.

Why pass `address(0)` for `setRewardRate`? Because no user is interacting — only the rate is changing. We still want global state settled (so the rate change applies *forward only*), but we don't need to touch any user's row.

> "Quiz the room: what would happen if the function body ran first, then the modifier? *(Answer: catastrophic — the user's balance change would be priced at the new accumulator, retroactively earning them rewards on time before their stake existed.)*"

### A.5. Views

`rewardPerToken()` and `earned()` are `view` and `public`. The implementation must match the math you stated in the frame. Walk through it slowly:

```solidity
function rewardPerToken() public view returns (uint256) {
    if (totalStaked == 0) {
        return rewardPerTokenStored;          // edge case: avoid div by 0
    }
    uint256 elapsed = block.timestamp - lastUpdateTime;
    return rewardPerTokenStored + (elapsed * rewardRate * PRECISION) / totalStaked;
}
```

> "Notice the `if (totalStaked == 0)` branch. Without it, the contract bricks the first time anyone calls a view function before the first stake."

### A.6. `stake` walkthrough

```solidity
function stake(uint256 amount) external nonReentrant updateReward(msg.sender) {
    if (amount == 0) revert ZeroAmount();

    totalStaked += amount;
    balanceOf[msg.sender] += amount;

    stakingToken.safeTransferFrom(msg.sender, address(this), amount);
    emit Staked(msg.sender, amount);
}
```

Three rules to teach here:

1. **Checks-Effects-Interactions.** Check inputs (the `if`), mutate state (the two increments), call external contract (the transfer), emit event. In that order, every time.
2. **Modifier ordering.** `nonReentrant` is outermost; `updateReward` runs inside it. Both fire before `amount == 0` check, which is fine because the check is cheap.
3. **safeTransferFrom.** Pulling tokens FROM the user requires they `approve` first. The `SafeERC20` wrapper checks return values; some tokens return `bool`, some `revert`, some return nothing — `SafeERC20` normalizes.

### A.7. `getReward` and the liquidity check

```solidity
function getReward() public nonReentrant updateReward(msg.sender) {
    uint256 reward = rewards[msg.sender];
    if (reward == 0) return;
    if (rewardToken.balanceOf(address(this)) < reward) {
        revert InsufficientRewardLiquidity();
    }
    rewards[msg.sender] = 0;
    rewardToken.safeTransfer(msg.sender, reward);
    emit RewardPaid(msg.sender, reward);
}
```

> "Notice the liquidity guard. If the protocol has been emitting rewards for a long time but the owner never funded the reward token, the math says 'you've earned 1000 RWD' but the contract has 0 RWD. We revert *loudly* with a specific error instead of silently zeroing the user's earned balance."

---

## Block B — Live-code the exercise (70 min)

Switch the projector to [`contracts/src/StakingProtocol.exercise.sol`](../../contracts/src/StakingProtocol.exercise.sol). The file contains seven `// TODO:` blocks. Walk the room through each, paced as below.

| Block | Target time | What's implemented                                                       |
| ----- | ----------- | ------------------------------------------------------------------------ |
| 1     | 10 min      | `updateReward` modifier                                                  |
| 2     | 10 min      | `rewardPerToken()`                                                       |
| 3     | 10 min      | `earned(address)`                                                        |
| —     | 5 min       | **Stretch + `forge build` checkpoint**                                   |
| 4     | 15 min      | `stake(amount)`                                                          |
| 5     | 15 min      | `withdraw(amount)` and `getReward()`                                     |
| 6     | 5 min       | `exit()`                                                                 |
| 7     | 10 min      | `setRewardRate(newRate)`                                                 |

### How to pace this

- Read the TODO comment aloud.
- Give 60 seconds of silent thinking.
- Ask the room: "What's the first line?"
- One attendee answers. You type it on the projector. Discuss alternatives.
- Repeat until the function is complete.
- Run `forge build`. If it doesn't compile, the room debugs together.
- Move to the next TODO.

### Common gotchas to flag

- **Forgetting `nonReentrant`.** The compiler does not complain. The test suite will (eventually) — but the test for reentrancy is one of the trickier ones, so they may not catch it themselves.
- **Wrong order of modifier + state mutation.** Putting `balanceOf[msg.sender] += amount` *before* the `updateReward` modifier would mean settling rewards using the *new* balance. Catastrophic, subtle.
- **Forgetting the `1e18` precision factor** in `rewardPerToken`. The TODO comment warns about this, but someone always does it anyway.
- **Calling `IERC20.transfer` directly** instead of via `SafeERC20`. Visually compiles; fails for tokens that don't return bool.

### When to allow AI help

After 60 minutes of live-coding, attendees plateau. At that point — and not before — say:

> "OK. Turn your AI back on. But before you ask it anything, write a one-sentence description of what you're stuck on. Then ask the AI specifically. 'Fix my contract' is not allowed; 'Why does my updateReward modifier need address(0) handling?' is allowed."

---

## Block C — Write & run tests (30 min)

Open [`contracts/test/StakingProtocol.t.sol`](../../contracts/test/StakingProtocol.t.sol) on the projector.

### C.1. The fixture

```solidity
function setUp() public {
    vm.startPrank(owner);
    stk = new MockERC20("Stake Token", "STK", owner);
    rwd = new MockERC20("Reward Token", "RWD", owner);
    staking = new StakingProtocol(IERC20(address(stk)), IERC20(address(rwd)), owner);
    rwd.mint(owner, REWARD_FUNDING);
    rwd.approve(address(staking), REWARD_FUNDING);
    staking.fundRewards(REWARD_FUNDING);
    stk.mint(alice, INITIAL_BALANCE);
    stk.mint(bob, INITIAL_BALANCE);
    vm.stopPrank();
    // ...allowances...
}
```

Talking points:

- `makeAddr("alice")` creates a deterministic test address with the label "alice" — shows up in traces, much better debuggability than `address(0x123)`.
- `vm.startPrank` / `vm.stopPrank` — every call between them is sent as if from `owner`.

### C.2. The simplest test

```solidity
function test_Stake_HappyPath() public {
    vm.prank(alice);
    staking.stake(100 ether);

    assertEq(staking.balanceOf(alice), 100 ether, "balance");
    assertEq(staking.totalStaked(), 100 ether, "total");
    assertEq(stk.balanceOf(address(staking)), 100 ether, "escrow");
}
```

> "`vm.prank` (singular) applies to *only the next call*. Compare to `startPrank`/`stopPrank`. Use the singular when you can — less state to keep track of."

### C.3. The time-travel test

```solidity
function test_Earned_AccruesOverTime_SingleStaker() public {
    vm.prank(owner);
    staking.setRewardRate(REWARD_RATE);

    vm.prank(alice);
    staking.stake(100 ether);

    vm.warp(block.timestamp + 60);
    uint256 expected = REWARD_RATE * 60;
    assertApproxEqAbs(staking.earned(alice), expected, 1, "1-staker accrual");
}
```

> "`vm.warp` sets `block.timestamp`. We advance 60 seconds. Alice is the sole staker, so she earns the entire emission window: `rate * time`. We use `assertApproxEqAbs(..., 1, ...)` because of the `1e18 / totalStaked` integer division — there can be a 1-wei rounding error. That's why we accept ±1 in the assertion."

### C.4. The access-control test

```solidity
function test_SetRewardRate_RevertsForNonOwner() public {
    vm.prank(eve);
    vm.expectRevert(abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, eve));
    staking.setRewardRate(REWARD_RATE);
}
```

> "OpenZeppelin v5's `Ownable` reverts with a *parameterized* error: `OwnableUnauthorizedAccount(address account)`. `abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, eve)` constructs the full expected revert payload. If you only check the selector, you miss the parameter; this form is stricter and better."

### C.5. The split-rate test

This one is the litmus test for whether attendees understood the `updateReward(address(0))` trick:

```solidity
function test_SetRewardRate_FinalizesPastAccrualAtOldRate() public {
    vm.prank(owner);
    staking.setRewardRate(REWARD_RATE);
    vm.prank(alice);
    staking.stake(100 ether);
    vm.warp(block.timestamp + 30);
    uint256 expectedFirstWindow = REWARD_RATE * 30;
    vm.prank(owner);
    staking.setRewardRate(REWARD_RATE * 2);
    vm.warp(block.timestamp + 30);
    uint256 expectedSecondWindow = (REWARD_RATE * 2) * 30;
    assertApproxEqAbs(
        staking.earned(alice),
        expectedFirstWindow + expectedSecondWindow,
        1,
        "split-rate accrual"
    );
}
```

> "Walk through what this proves: changing the rate mid-stream must *not* retroactively re-price the past 30 seconds. If you got the `updateReward(address(0))` placement wrong in your `setRewardRate`, this test fails."

### C.6. Run them all

```bash
forge test -vvv
```

Expect output similar to:

```
[PASS] test_Stake_HappyPath() (gas: ...)
[PASS] test_Earned_AccruesOverTime_SingleStaker() (gas: ...)
...
Test result: ok. 14 passed; 0 failed; 0 skipped
```

Walk through what each verbosity level shows:

- `-v` PASS/FAIL only
- `-vv` adds logs
- `-vvv` adds traces for failing tests
- `-vvvv` adds traces for all tests (use sparingly, very chatty)

> "When a test fails, the first thing you do is bump to `-vvvv` on just that test: `forge test --match-test test_Foo -vvvv`. The trace shows every external call, every `vm.*` cheatcode, and the exact revert. It's the best debugger you'll ever use."

---

## Closing (10 min) — Take-home

### Checklist

- [ ] Your exercise file compiles (`forge build` clean).
- [ ] Your exercise passes the existing test suite when you point the tests at `StakingProtocolExercise` instead of `StakingProtocol`. *(Optional bonus: write a second test file.)*
- [ ] You can answer, without notes:
  - "Why does `updateReward` accept `address(0)`?"
  - "What does `1e18` mean and why is it there?"
  - "What's the difference between `vm.prank` and `vm.startPrank`?"
- [ ] You've pushed your branch to GitHub and tagged a peer reviewer.

### Looking ahead

> "Meet 5 zooms out to the *economics* of staking. Meet 6 connects the contract to a UI. Meet 7 is pitching. Meet 8 is shipping. We just crossed the technical mountain — the rest of the course is downhill, but you must do every step."
