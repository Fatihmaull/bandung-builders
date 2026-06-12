// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

import {IStakingProtocol} from "./interfaces/IStakingProtocol.sol";

/// @title  StakingProtocol — Exercise (Meet 4)
/// @notice Skeleton for the Meet 4 live-coding session. Each `// TODO:` block
///         is a contiguous chunk attendees implement themselves; do NOT peek
///         at `StakingProtocol.sol` until you have made an honest attempt.
///
/// @dev    Implementation rubric:
///         - All token transfers use `SafeERC20`.
///         - `nonReentrant` on every external balance-mutating function.
///         - `updateReward(msg.sender)` modifier runs BEFORE state mutation.
///         - The reward-per-token formula uses a `PRECISION = 1e18` factor.
///         - Custom errors over `require` strings.
///
/// @custom:exercise-time 75 minutes (target)
contract StakingProtocolExercise is IStakingProtocol, ReentrancyGuard, Ownable {
    using SafeERC20 for IERC20;

    uint256 private constant PRECISION = 1e18;

    IERC20 public immutable stakingToken;
    IERC20 public immutable rewardToken;

    uint256 public rewardRate;
    uint256 public lastUpdateTime;
    uint256 public rewardPerTokenStored;

    mapping(address => uint256) public userRewardPerTokenPaid;
    mapping(address => uint256) public rewards;

    uint256 public totalStaked;
    mapping(address => uint256) public balanceOf;

    constructor(IERC20 _stakingToken, IERC20 _rewardToken, address initialOwner) Ownable(initialOwner) {
        stakingToken = _stakingToken;
        rewardToken = _rewardToken;
        lastUpdateTime = block.timestamp;
    }

    // -------------------------------------------------------------------
    // TODO #1 (10 min) — `updateReward` modifier
    // -------------------------------------------------------------------
    // Implement a modifier `updateReward(address account)` that:
    //   1. Sets `rewardPerTokenStored = rewardPerToken();`
    //   2. Sets `lastUpdateTime = block.timestamp;`
    //   3. If `account != address(0)`:
    //      - sets `rewards[account] = earned(account);`
    //      - sets `userRewardPerTokenPaid[account] = rewardPerTokenStored;`
    //   4. Continues to the function body with `_;`
    //
    // HINT: `address(0)` is used by `setRewardRate` to settle globals without
    //       a specific user.
    // -------------------------------------------------------------------
    modifier updateReward(address account) {
        // TODO: implement
        _;
    }

    // -------------------------------------------------------------------
    // TODO #2 (10 min) — `rewardPerToken()`
    // -------------------------------------------------------------------
    // Return:
    //   - If totalStaked == 0:  rewardPerTokenStored
    //   - Else:                  rewardPerTokenStored
    //                          + (elapsed * rewardRate * PRECISION) / totalStaked
    //
    // where elapsed = block.timestamp - lastUpdateTime.
    //
    // WHY THE PRECISION FACTOR? Solidity has no decimals. Without 1e18 the
    // division would round to zero for small stakes/short elapsed times.
    // -------------------------------------------------------------------
    function rewardPerToken() public view returns (uint256) {
        // TODO: implement
    }

    // -------------------------------------------------------------------
    // TODO #3 (10 min) — `earned(address)`
    // -------------------------------------------------------------------
    // Return:
    //     balanceOf[account]
    //   * (rewardPerToken() - userRewardPerTokenPaid[account])
    //   / PRECISION
    //   + rewards[account]
    //
    // Think about overflow: PRECISION cancels the scaling factor so result
    // fits in a normal uint256 reward amount.
    // -------------------------------------------------------------------
    function earned(address account) public view returns (uint256) {
        // TODO: implement
    }

    // -------------------------------------------------------------------
    // TODO #4 (15 min) — `stake(amount)`
    // -------------------------------------------------------------------
    // Requirements:
    //   - external, nonReentrant, updateReward(msg.sender)
    //   - revert ZeroAmount() if amount == 0
    //   - increase totalStaked and balanceOf[msg.sender]
    //   - pull tokens with stakingToken.safeTransferFrom(msg.sender, this, amount)
    //   - emit Staked(msg.sender, amount)
    //
    // ORDER MATTERS: settle reward bookkeeping first (modifier), then mutate
    // balances, then move tokens. Checks-Effects-Interactions.
    // -------------------------------------------------------------------
    function stake(uint256 amount) external {
        // TODO: implement
    }

    // -------------------------------------------------------------------
    // TODO #5 (15 min) — `withdraw(amount)` and `getReward()`
    // -------------------------------------------------------------------
    // withdraw:
    //   - public, nonReentrant, updateReward(msg.sender)
    //   - revert ZeroAmount() if amount == 0
    //   - revert InsufficientBalance() if balanceOf[msg.sender] < amount
    //   - decrement totalStaked and balanceOf[msg.sender]
    //   - push with stakingToken.safeTransfer
    //   - emit Withdrawn
    //
    // getReward:
    //   - public, nonReentrant, updateReward(msg.sender)
    //   - if rewards[msg.sender] == 0, return early (no revert, no event)
    //   - revert InsufficientRewardLiquidity() if reward token balance is too low
    //   - zero out rewards[msg.sender] BEFORE the transfer
    //   - push reward, emit RewardPaid
    // -------------------------------------------------------------------
    function withdraw(uint256 amount) public {
        // TODO: implement
    }

    function getReward() public {
        // TODO: implement
    }

    // -------------------------------------------------------------------
    // TODO #6 (5 min) — `exit()`
    // -------------------------------------------------------------------
    // Withdraw the full balance (if any) and then claim rewards in one call.
    // No modifiers needed here — they fire on the inner calls.
    // -------------------------------------------------------------------
    function exit() external {
        // TODO: implement
    }

    // -------------------------------------------------------------------
    // TODO #7 (10 min) — `setRewardRate(newRate)`
    // -------------------------------------------------------------------
    // - onlyOwner
    // - updateReward(address(0))  <-- settle globals BEFORE rate change
    // - assign rewardRate = newRate
    // - emit RewardRateUpdated(newRate)
    //
    // FACILITATOR Q: Why settle globals before the rate change?
    // ANSWER (don't peek): so historical accrual is finalized at the OLD
    // rate. If we changed rate first, past stakers would retroactively
    // receive the new rate for time already elapsed.
    // -------------------------------------------------------------------
    function setRewardRate(uint256 newRate) external {
        // TODO: implement
    }
}
