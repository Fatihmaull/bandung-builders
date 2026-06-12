// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

import {IStakingProtocol} from "./interfaces/IStakingProtocol.sol";

/// @title  StakingProtocol
/// @author Bandung Base Builders
/// @notice Synthetix-style single-asset staking protocol. Users deposit
///         `stakingToken`, earn `rewardToken` continuously at `rewardRate`
///         tokens per second, distributed pro-rata across the global stake.
/// @dev    Math (precision factor PRECISION = 1e18):
///
///         rewardPerToken() =
///             rewardPerTokenStored
///           + (block.timestamp - lastUpdateTime) * rewardRate * PRECISION
///             / totalStaked                                     (if totalStaked > 0)
///             else rewardPerTokenStored
///
///         earned(account) =
///             balanceOf[account]
///           * (rewardPerToken() - userRewardPerTokenPaid[account])
///           / PRECISION
///           + rewards[account]
contract StakingProtocol is IStakingProtocol, ReentrancyGuard, Ownable {
    using SafeERC20 for IERC20;

    /*//////////////////////////////////////////////////////////////
                                CONSTANTS
    //////////////////////////////////////////////////////////////*/

    uint256 private constant PRECISION = 1e18;

    /*//////////////////////////////////////////////////////////////
                                IMMUTABLES
    //////////////////////////////////////////////////////////////*/

    IERC20 public immutable stakingToken;
    IERC20 public immutable rewardToken;

    /*//////////////////////////////////////////////////////////////
                                STATE
    //////////////////////////////////////////////////////////////*/

    /// @notice Reward tokens emitted globally per second.
    uint256 public rewardRate;

    /// @notice Timestamp of the last `_updateReward` call.
    uint256 public lastUpdateTime;

    /// @notice Global accumulator: total reward-per-staked-token, scaled by PRECISION.
    uint256 public rewardPerTokenStored;

    /// @notice Snapshot of `rewardPerTokenStored` at each user's last interaction.
    mapping(address account => uint256 rewardPerTokenPaid) public userRewardPerTokenPaid;

    /// @notice Pending, not-yet-claimed rewards for each account.
    mapping(address account => uint256 reward) public rewards;

    /// @notice Total amount of `stakingToken` currently staked across all users.
    uint256 public totalStaked;

    /// @notice Per-user staked balance.
    mapping(address account => uint256 balance) public balanceOf;

    /*//////////////////////////////////////////////////////////////
                              CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    /// @param _stakingToken Address of the ERC20 users will deposit.
    /// @param _rewardToken  Address of the ERC20 paid out as rewards.
    /// @param initialOwner  Account granted `onlyOwner` privileges.
    constructor(IERC20 _stakingToken, IERC20 _rewardToken, address initialOwner) Ownable(initialOwner) {
        stakingToken = _stakingToken;
        rewardToken = _rewardToken;
        lastUpdateTime = block.timestamp;
    }

    /*//////////////////////////////////////////////////////////////
                                MODIFIERS
    //////////////////////////////////////////////////////////////*/

    /// @dev Settle global and per-user reward bookkeeping before any state change.
    ///      Pass `address(0)` to settle only globals (used on `setRewardRate`).
    modifier updateReward(address account) {
        rewardPerTokenStored = rewardPerToken();
        lastUpdateTime = block.timestamp;

        if (account != address(0)) {
            rewards[account] = earned(account);
            userRewardPerTokenPaid[account] = rewardPerTokenStored;
        }
        _;
    }

    /*//////////////////////////////////////////////////////////////
                                VIEWS
    //////////////////////////////////////////////////////////////*/

    /// @inheritdoc IStakingProtocol
    function rewardPerToken() public view returns (uint256) {
        if (totalStaked == 0) {
            return rewardPerTokenStored;
        }
        uint256 elapsed = block.timestamp - lastUpdateTime;
        return rewardPerTokenStored + (elapsed * rewardRate * PRECISION) / totalStaked;
    }

    /// @inheritdoc IStakingProtocol
    function earned(address account) public view returns (uint256) {
        uint256 delta = rewardPerToken() - userRewardPerTokenPaid[account];
        return (balanceOf[account] * delta) / PRECISION + rewards[account];
    }

    /*//////////////////////////////////////////////////////////////
                              USER ACTIONS
    //////////////////////////////////////////////////////////////*/

    /// @inheritdoc IStakingProtocol
    function stake(uint256 amount) external nonReentrant updateReward(msg.sender) {
        if (amount == 0) revert ZeroAmount();

        totalStaked += amount;
        balanceOf[msg.sender] += amount;

        stakingToken.safeTransferFrom(msg.sender, address(this), amount);
        emit Staked(msg.sender, amount);
    }

    /// @inheritdoc IStakingProtocol
    function withdraw(uint256 amount) public nonReentrant updateReward(msg.sender) {
        if (amount == 0) revert ZeroAmount();
        if (balanceOf[msg.sender] < amount) revert InsufficientBalance();

        totalStaked -= amount;
        balanceOf[msg.sender] -= amount;

        stakingToken.safeTransfer(msg.sender, amount);
        emit Withdrawn(msg.sender, amount);
    }

    /// @inheritdoc IStakingProtocol
    function getReward() public nonReentrant updateReward(msg.sender) {
        uint256 reward = rewards[msg.sender];
        if (reward == 0) return;

        // Reward liquidity invariant: the protocol must hold enough reward
        // tokens to honor this payout. Because rewardToken and stakingToken
        // may be distinct, this protects against an under-funded protocol.
        if (rewardToken.balanceOf(address(this)) < reward) {
            revert InsufficientRewardLiquidity();
        }

        rewards[msg.sender] = 0;
        rewardToken.safeTransfer(msg.sender, reward);
        emit RewardPaid(msg.sender, reward);
    }

    /// @inheritdoc IStakingProtocol
    function exit() external {
        uint256 staked = balanceOf[msg.sender];
        if (staked > 0) {
            withdraw(staked);
        }
        getReward();
    }

    /*//////////////////////////////////////////////////////////////
                                OWNER
    //////////////////////////////////////////////////////////////*/

    /// @inheritdoc IStakingProtocol
    /// @dev Settles global accrual *before* changing the rate so historical
    ///      emissions are computed at the old rate. Pass `address(0)` because
    ///      no specific user is interacting.
    function setRewardRate(uint256 newRate) external onlyOwner updateReward(address(0)) {
        rewardRate = newRate;
        emit RewardRateUpdated(newRate);
    }

    /// @notice Convenience helper for the owner to top up the contract's
    ///         reward-token liquidity. Caller must approve first.
    /// @dev    Does NOT change `rewardRate`; emissions continue at the current
    ///         rate until the owner explicitly updates it. Pull-style transfer
    ///         keeps the funding flow auditable on-chain.
    function fundRewards(uint256 amount) external onlyOwner {
        if (amount == 0) revert ZeroAmount();
        rewardToken.safeTransferFrom(msg.sender, address(this), amount);
        emit RewardsFunded(msg.sender, amount);
    }
}
