// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console2} from "forge-std/Script.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {StakingProtocol} from "../src/StakingProtocol.sol";
import {MockERC20} from "../src/MockERC20.sol";

/// @title  Deploy
/// @notice Deploy two MockERC20 tokens (STK + RWD), the StakingProtocol, fund
///         it with reward liquidity, and set the initial reward rate.
///
///         Usage (from `contracts/`):
///
///           source ../.env
///           forge script script/Deploy.s.sol:Deploy \
///               --rpc-url $OP_SEPOLIA_RPC_URL \
///               --broadcast \
///               --verify \
///               --etherscan-api-key $OP_ETHERSCAN_API_KEY \
///               -vvvv
///
/// @dev   Reads `PRIVATE_KEY` from env via `vm.envUint`. The deployer becomes
///        owner of both tokens and the staking contract.
contract Deploy is Script {
    /// @dev Tunables — edit before broadcasting if you need different numbers.
    uint256 internal constant INITIAL_REWARD_FUNDING = 100_000 ether;
    uint256 internal constant INITIAL_REWARD_RATE = 0.01 ether; // 0.01 RWD per second
    uint256 internal constant INITIAL_USER_AIRDROP = 0; // 0 = no auto-airdrop

    function run()
        external
        returns (MockERC20 stakingToken, MockERC20 rewardToken, StakingProtocol staking)
    {
        uint256 deployerPk = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPk);

        console2.log("Deployer:", deployer);
        console2.log("Chain ID:", block.chainid);

        vm.startBroadcast(deployerPk);

        // 1. Tokens
        stakingToken = new MockERC20("Bandung Stake Token", "STK", deployer);
        rewardToken = new MockERC20("Bandung Reward Token", "RWD", deployer);

        // 2. Staking protocol
        staking = new StakingProtocol(
            IERC20(address(stakingToken)),
            IERC20(address(rewardToken)),
            deployer
        );

        // 3. Mint and fund reward liquidity
        rewardToken.mint(deployer, INITIAL_REWARD_FUNDING);
        rewardToken.approve(address(staking), INITIAL_REWARD_FUNDING);
        staking.fundRewards(INITIAL_REWARD_FUNDING);

        // 4. Set initial reward rate
        staking.setRewardRate(INITIAL_REWARD_RATE);

        // 5. Optional: airdrop staking tokens to the deployer for quick testing.
        if (INITIAL_USER_AIRDROP > 0) {
            stakingToken.mint(deployer, INITIAL_USER_AIRDROP);
        }

        vm.stopBroadcast();

        console2.log("------------------------------------------");
        console2.log("StakingProtocol:", address(staking));
        console2.log("Staking Token  :", address(stakingToken));
        console2.log("Reward Token   :", address(rewardToken));
        console2.log("Reward Rate    :", INITIAL_REWARD_RATE);
        console2.log("Reward Funded  :", INITIAL_REWARD_FUNDING);
        console2.log("------------------------------------------");
        console2.log("Next steps:");
        console2.log("  1. Copy these addresses into frontend/.env.local");
        console2.log("  2. Verify on OP Sepolia Etherscan if --verify did not auto-run");
        console2.log("  3. Call STK.faucet() from your wallet to get test tokens");
    }
}
