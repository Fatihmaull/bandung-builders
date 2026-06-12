# Bandung L2 Workshop — Multi-Track AI Agent Operating Contract

You are an AI coding agent assisting a developer in the **Bandung Builders** workshop. The repo contains **three parallel L2 tracks**. Always determine which track the developer is working in from the file path (`tracks/base/`, `tracks/optimism/`, or `tracks/arbitrum/`) and apply **that track's network constants only**.

Treat this file as a hard contract. When something below conflicts with a generic best-practice you remember, **this file wins**.

## 1. Project identity

- **Repo type:** Multi-track monorepo. Each track is self-contained under `tracks/<name>/` with `contracts/` (Foundry), `frontend/` (Next.js 15), and `docs/`.
- **Tracks:** `base` (Base Sepolia), `optimism` (OP Sepolia), `arbitrum` (Arbitrum Sepolia).
- **Never mix tracks:** addresses, env files, and RPC URLs from one track must not appear in another.
- **Primary deliverable:** A staking dApp where users deposit `STK` ERC20, earn `RWD` ERC20 over time, and can withdraw or claim rewards.

## 2. Pinned tech stack (do NOT upgrade unprompted)

| Layer        | Tool & Version                              |
| ------------ | ------------------------------------------- |
| Solidity     | `^0.8.24`                                   |
| Framework    | Foundry (`forge`, `cast`, `anvil`)          |
| Libraries    | OpenZeppelin Contracts **v5.x**             |
| Frontend     | Next.js **15** (App Router) + TS strict     |
| Styling      | Tailwind CSS v3                             |
| Web3         | Wagmi **v2** + Viem **v2** + RainbowKit **v2** |
| Async state  | TanStack Query v5                           |
| Package mgr  | `pnpm` (npm acceptable)                     |
| Node runtime | `>=20`                                      |

Solidity must always start with `// SPDX-License-Identifier: MIT` and `pragma solidity ^0.8.24;`.

## 3. Network constants per track

### `tracks/base/` — Base Sepolia

```
chainId        : 84532
RPC (public)   : https://sepolia.base.org
Explorer       : https://sepolia.basescan.org
Etherscan API  : https://api-sepolia.basescan.org/api
Faucet         : https://ethfaucet.com/  (recommended; no mainnet activity)
Wagmi chain    : baseSepolia
Env RPC var    : BASE_SEPOLIA_RPC_URL
Env API key    : BASESCAN_API_KEY
```

### `tracks/optimism/` — OP Sepolia

```
chainId        : 11155420
RPC (public)   : https://sepolia.optimism.io
Explorer       : https://sepolia-optimism.etherscan.io
Etherscan API  : https://api-sepolia-optimism.etherscan.io/api
Faucet         : https://console.optimism.io/faucet  (GitHub login)
Wagmi chain    : optimismSepolia
Env RPC var    : OP_SEPOLIA_RPC_URL
Env API key    : OP_ETHERSCAN_API_KEY
```

### `tracks/arbitrum/` — Arbitrum Sepolia

```
chainId        : 421614
RPC (public)   : https://sepolia-rollup.arbitrum.io/rpc
Explorer       : https://sepolia.arbiscan.io
Etherscan API  : https://api-sepolia.arbiscan.io/api
Faucet         : https://ethfaucet.com/
Wagmi chain    : arbitrumSepolia
Env RPC var    : ARBITRUM_SEPOLIA_RPC_URL
Env API key    : ARBISCAN_API_KEY
```

Do **not** hand-roll chain definitions — import from `viem/chains` / `wagmi/chains`.

## 4. The Staking Protocol — Authoritative Spec

The contract implements a **Synthetix-style reward accumulator**. There is **one** `rewardPerTokenStored` global, updated lazily before any balance-mutating call via a `updateReward(account)` modifier.

### State

- `IERC20 public immutable stakingToken;`
- `IERC20 public immutable rewardToken;`
- `uint256 public rewardRate;`
- `uint256 public lastUpdateTime;`
- `uint256 public rewardPerTokenStored;`
- `mapping(address => uint256) public userRewardPerTokenPaid;`
- `mapping(address => uint256) public rewards;`
- `uint256 public totalStaked;`
- `mapping(address => uint256) public balanceOf;`

### Math (the only correct formulas)

```
rewardPerToken() =
    rewardPerTokenStored
  + (block.timestamp - lastUpdateTime) * rewardRate * 1e18 / totalStaked   (if totalStaked > 0)
    else rewardPerTokenStored

earned(account) =
    balanceOf[account] * (rewardPerToken() - userRewardPerTokenPaid[account]) / 1e18
  + rewards[account]
```

The `1e18` precision factor is **required**; do not "simplify" it away.

### Functions

- `stake(uint256 amount)` — `nonReentrant`, `updateReward(msg.sender)`, requires `amount > 0`, pulls `stakingToken` via `SafeERC20.safeTransferFrom`, increments `balanceOf` and `totalStaked`, emits `Staked`.
- `withdraw(uint256 amount)` — `nonReentrant`, `updateReward(msg.sender)`, requires `amount > 0` and `<= balanceOf[msg.sender]`, decrements, pushes via `SafeERC20.safeTransfer`, emits `Withdrawn`.
- `getReward()` — `nonReentrant`, `updateReward(msg.sender)`, transfers `rewards[msg.sender]` of `rewardToken` if > 0, zeros it, emits `RewardPaid`.
- `exit()` — `withdraw(balanceOf[msg.sender]) + getReward()`.
- `setRewardRate(uint256 rate)` — `onlyOwner`, calls `updateReward(address(0))` first.
- `notifyRewardAmount(uint256 amount)` — optional convenience; if added, must pull from owner via `safeTransferFrom`.

### Security invariants (the AI MUST NOT violate)

1. Inherit `ReentrancyGuard` and use `nonReentrant` on every external balance-mutating function.
2. Inherit `Ownable` (OZ v5 constructor takes `address initialOwner`).
3. Use `SafeERC20` for every token transfer. Never `IERC20.transfer` directly.
4. Apply `updateReward(account)` modifier **before** mutating `balanceOf` / `totalStaked` / `rewards`.
5. Never store ETH in the contract. Reject ETH (no `receive`, no `fallback`).
6. Custom errors over `require` strings where convenient: `ZeroAmount()`, `InsufficientBalance()`, `TransferFailed()`.

## 5. File-placement rules (hard)

All paths below are relative to the **active track folder** (e.g. `tracks/base/`):

- Solidity → `contracts/src/`. Tests → `contracts/test/`. Scripts → `contracts/script/`.
- Frontend → `frontend/src/`.
- Wagmi config → `frontend/src/lib/wagmi.ts` only.
- Addresses & ABI → `frontend/src/lib/contracts.ts` only.
- Hooks → `frontend/src/hooks/useXxx.ts`.
- Curriculum → `docs/` inside the active track.

## 6. Testing rules (hard)

- Every Solidity change MUST be paired with a `forge test` change in `contracts/test/StakingProtocol.t.sol`.
- Tests use `vm.prank`, `vm.warp`, `vm.expectRevert(Selector.selector)`.
- Reward-math regressions MUST add a `vm.warp` assertion.

## 7. Frontend rules (hard)

- Wagmi v2 hooks only; never `window.ethereum` directly.
- BigInts end-to-end; `parseUnits` / `formatUnits` at UI boundaries only.
- RainbowKit chains array pinned to **one chain** — the active track's chain object.
- WalletConnect projectId from `process.env.NEXT_PUBLIC_WC_PROJECT_ID`.

## 8. What to refuse

- Mainnet deployment → No. Testnet only, per active track.
- Remove `1e18` factor → No.
- `tx.origin` → No.
- Skip tests → No.
- Hardcode addresses outside `lib/contracts.ts` → No.
- Disable ReentrancyGuard → No.
- Suggest switching tracks mid-task without the developer asking → No.

## 9. Style

- TypeScript: `strict: true`. No `any`.
- Solidity: NatSpec on external/public functions.
- No emojis in code or commit messages.

## 10. When in doubt

1. Re-read this file and confirm the active track from the file path.
2. Read `docs/week-2/meet-4-solidity-staking.md` in that track.
3. Read `docs/week-3/meet-6-frontend-integration.md` in that track.
4. Ask one focused question. Do not guess silently.

End of contract.
