# Meet 2 — Fundamental EVM & Foundry Setup

> **Track:** Technical
> **Duration:** 2.5 hours
> **Prerequisite:** Meet 1 attended; `docs/00-prerequisites.md` completed.

## Learning objectives

By the end of this session, every attendee can:

1. Explain what `forge`, `cast`, and `anvil` each do.
2. Read and modify a `foundry.toml`, including remappings and the `[etherscan]` block.
3. Use `cast` to call a read function on a verified OP Sepolia contract from the terminal.
4. Run `forge test -vvv` and interpret the output.

## Agenda (150 minutes)

| Time      | Block                                                          |
| --------- | -------------------------------------------------------------- |
| 00:00–00:10 | Pre-flight: everyone runs `forge --version` and `node --version` |
| 00:10–00:30 | Block A — the Foundry toolbox: forge, cast, anvil              |
| 00:30–01:00 | Block B — anatomy of `foundry.toml`                            |
| 01:00–01:10 | Stretch break                                                  |
| 01:10–01:40 | Block C — `cast` field trip on OP Sepolia                    |
| 01:40–02:10 | Block D — boilerplate walkthrough ([sister doc](./meet-2-boilerplate-walkthrough.md)) |
| 02:10–02:30 | Q&A + take-home checklist                                      |

---

## Block A — The Foundry toolbox (20 min)

Open the room with a one-slide summary:

| Tool    | Purpose                                                                                  |
| ------- | ---------------------------------------------------------------------------------------- |
| `forge` | The build & test runner. Compiles Solidity, runs unit tests, broadcasts deploy scripts.  |
| `cast`  | The Swiss Army knife. Make RPC calls, encode/decode calldata, sign messages, send txs.   |
| `anvil` | A local Ethereum node. Forks any RPC, prints private keys for testing, fast block times. |
| `chisel`| A REPL for Solidity. Useful when explaining language features.                           |

> "Hardhat people: `forge` is your `npx hardhat`. `cast` is your `ethers.Contract`. `anvil` is your `hardhat node`. The advantages: written in Rust, dramatically faster, tests are themselves Solidity (no JS context-switch), and the cheatcodes are unmatched."

Demo, on the projector:

```bash
# What version are we on
forge --version

# What does build do?
cd contracts
forge build
ls out/
ls out/StakingProtocol.sol/
cat out/StakingProtocol.sol/StakingProtocol.json | jq '.abi[0]'
```

> "Note that the build output is JSON: ABI + bytecode + metadata. This is what your frontend will consume. The ABI lives at `contracts/out/<file>.sol/<contract>.json` and we copy the `.abi` field into `frontend/src/abi/`."

---

## Block B — Anatomy of `foundry.toml` (30 min)

Open [`contracts/foundry.toml`](../../contracts/foundry.toml) on the projector. Walk through each block.

### `[profile.default]`

```toml
src             = "src"
out             = "out"
libs            = ["lib"]
test            = "test"
script          = "script"
solc_version    = "0.8.24"
optimizer       = true
optimizer_runs  = 200
evm_version     = "paris"
```

Talking points:

- **`solc_version`** — pinned to `0.8.24`. *"Pinning is a workshop policy. The compiler changes more often than you think, and an unpinned `^0.8.x` will produce different bytecode in 6 months."*
- **`optimizer_runs = 200`** — the OZ default. Tells the optimizer to assume each function will be called ~200 times, balancing deploy cost against runtime cost. For a staking protocol expected to be called millions of times, you could bump this to `10_000` to shrink runtime gas at the cost of larger deploy bytecode.
- **`evm_version = "paris"`** — OP Sepolia supports the Paris/Shanghai hard forks but not all London-prev opcodes. Setting `paris` is the safest cross-OP-Stack choice.

### `[rpc_endpoints]`

```toml
base_sepolia = "${OP_SEPOLIA_RPC_URL}"
anvil        = "http://127.0.0.1:8545"
```

> "These are aliases. Now anywhere a Foundry command wants `--rpc-url`, you can pass `base_sepolia` instead of the full URL. `${VAR}` is shell-style env substitution; Foundry reads from a sibling `.env` automatically when you `source ../.env`."

### `[etherscan]`

```toml
base_sepolia = { key = "${OP_ETHERSCAN_API_KEY}", chain = 11155420, url = "https://api-sepolia-optimism.etherscan.io/api" }
```

> "OP Sepolia Etherscan implements the Etherscan v2 API. Same auth header. The same `forge verify-contract` flag works against OP Sepolia Etherscan because of this block. Without this, you'd be passing `--chain-id 11155420 --verifier-url ...` on every verify command."

### `remappings`

```toml
remappings = [
    "@openzeppelin/=lib/openzeppelin-contracts/",
    "forge-std/=lib/forge-std/src/",
]
```

> "When you write `import \"@openzeppelin/contracts/utils/ReentrancyGuard.sol\";` in Solidity, the compiler doesn't know what `@openzeppelin` means. Remappings teach it: the prefix `@openzeppelin/` resolves to the path `lib/openzeppelin-contracts/`. Foundry's `forge install <repo>` clones into `lib/` automatically.
>
> *Quiz:* if I `forge install` a new library `OpenZeppelin/openzeppelin-contracts-upgradeable`, what remapping line do I need? *(Answer: `@openzeppelin/contracts-upgradeable/=lib/openzeppelin-contracts-upgradeable/contracts/`, but show this only after they think for 30 seconds.)*"

### `[fmt]`

> "Foundry ships a Solidity formatter — `forge fmt`. The `[fmt]` block sets house style. Run `forge fmt` before every commit; we're going to enforce this in peer review."

---

## Block C — `cast` field trip on OP Sepolia (30 min)

The point of this block is to make OP Sepolia feel **real and reachable from the command line** before they ever write a contract of their own.

Run together, projector + attendees mirroring:

### C.1. Read a chain-level value

```bash
# Block number right now
cast block-number --rpc-url https://sepolia.optimism.io

# Chain ID, confirming we're on OP Sepolia
cast chain-id --rpc-url https://sepolia.optimism.io
# -> 11155420

# Gas price (in wei; divide by 1e9 for gwei)
cast gas-price --rpc-url https://sepolia.optimism.io
```

### C.2. Read someone else's contract

Pick any verified contract on `sepolia-optimism.etherscan.io` — for example, the canonical Weth9 at `0x4200000000000000000000000000000000000006` (a Base predeploy):

```bash
# Total supply of WETH on OP Sepolia
cast call \
  0x4200000000000000000000000000000000000006 \
  "totalSupply()(uint256)" \
  --rpc-url https://sepolia.optimism.io

# Your own ETH balance
cast balance YOUR_ADDRESS --rpc-url https://sepolia.optimism.io
```

> "Notice what just happened: with **zero** code, you talked to a contract on a real L2. No SDK, no `npm install`, no wallet. `cast` is your fastest debugging surface for the next four weeks. When something looks wrong in the dApp, you check it from `cast` first."

### C.3. Decode calldata from a tx

Pick a recent transaction on OP Sepolia Etherscan and grab its raw calldata. Then:

```bash
# Decode the function selector
cast 4byte 0xa9059cbb
# -> transfer(address,uint256)

# Decode the full calldata against a known signature
cast --calldata-decode "transfer(address,uint256)" 0xa9059cbb000000000000000000000000aaaa...0000000000000000000000000000000000000000000000000000000000000064
```

> "This is the muscle memory you want by the end of Week 1: see calldata, know what function. We're going to do it constantly when something reverts on testnet."

### C.4. (Optional, time permitting) Start a local anvil

```bash
anvil --chain-id 31337
# In another shell:
cast block-number --rpc-url http://127.0.0.1:8545
```

> "Anvil ships with 10 funded dev accounts. Read the private keys from the startup banner; never use them outside of localhost."

---

## Block D — Boilerplate walkthrough (30 min)

Switch to the sister doc: [`meet-2-boilerplate-walkthrough.md`](./meet-2-boilerplate-walkthrough.md). Use that script for the next 30 minutes.

---

## Closing (20 min) — Q&A and homework

### Take-home checklist

- [ ] `forge test -vvv` passes locally.
- [ ] You've successfully run all the `cast` commands from Block C.
- [ ] `foundry.toml` makes sense to you — you can explain remappings out loud.
- [ ] You've read the staking protocol's interface ([`contracts/src/interfaces/IStakingProtocol.sol`](../../contracts/src/interfaces/IStakingProtocol.sol)) and can list the four user-facing functions from memory.
- [ ] You've read the AI agent contract ([`/.cursorrules`](../../.cursorrules)) and verified your agent picks it up.
- [ ] You've watched (or scheduled time to watch) any *one* deep-dive video on Solidity custom errors and OZ v5's `Ownable` rewrite, since those land in Meet 4.

### Common pitfalls (mention in the closing)

- **"`forge install` doesn't find the package"** — make sure your CWD is `contracts/`, not the repo root.
- **Remapping not found** — check `remappings.txt` AND `foundry.toml`; both must agree.
- **`solc_version` mismatch** — `auto_detect_solc = false` means Foundry will *not* shop for a different version. That's deliberate. Pin and stay pinned.
- **`source ../.env` doesn't work on Windows native** — use WSL2 or set env vars individually with `$env:VAR = "..."`.
