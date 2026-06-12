// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title  IStakingProtocol
/// @notice External interface for the Bandung Base Builders staking protocol.
/// @dev    Implementations use a Synthetix-style reward-per-token accumulator.
interface IStakingProtocol {
    /*//////////////////////////////////////////////////////////////
                                EVENTS
    //////////////////////////////////////////////////////////////*/

    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event RewardPaid(address indexed user, uint256 reward);
    event RewardRateUpdated(uint256 newRate);
    event RewardsFunded(address indexed funder, uint256 amount);

    /*//////////////////////////////////////////////////////////////
                                ERRORS
    //////////////////////////////////////////////////////////////*/

    error ZeroAmount();
    error InsufficientBalance();
    error InsufficientRewardLiquidity();

    /*//////////////////////////////////////////////////////////////
                              USER ACTIONS
    //////////////////////////////////////////////////////////////*/

    /// @notice Deposit `amount` of the staking token. Requires prior `approve`.
    function stake(uint256 amount) external;

    /// @notice Withdraw `amount` of previously staked tokens.
    function withdraw(uint256 amount) external;

    /// @notice Claim all currently earned reward tokens.
    function getReward() external;

    /// @notice Withdraw the full staked balance and claim rewards in one call.
    function exit() external;

    /*//////////////////////////////////////////////////////////////
                                VIEWS
    //////////////////////////////////////////////////////////////*/

    /// @notice Current global accumulator value (scaled by 1e18).
    function rewardPerToken() external view returns (uint256);

    /// @notice Total rewards earned by `account` but not yet claimed.
    function earned(address account) external view returns (uint256);

    /*//////////////////////////////////////////////////////////////
                                OWNER
    //////////////////////////////////////////////////////////////*/

    /// @notice Set the global reward rate (tokens per second).
    function setRewardRate(uint256 newRate) external;
}
