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

## Frame (10 min)

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
