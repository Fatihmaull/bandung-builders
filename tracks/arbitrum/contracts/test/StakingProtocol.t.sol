// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

import {StakingProtocol} from "../src/StakingProtocol.sol";
import {IStakingProtocol} from "../src/interfaces/IStakingProtocol.sol";
import {MockERC20} from "../src/MockERC20.sol";

/// @title  StakingProtocol — Foundry test suite
/// @notice Reference suite. Mirrors the security invariants stated in
///         `.cursorrules` and the math in `meet-4-solidity-staking.md`.
///
/// @dev Cheatcodes used:
///        - `vm.prank` / `vm.startPrank` — impersonate accounts for access control.
///        - `vm.warp` — advance block.timestamp to validate reward accrual.
///        - `vm.expectRevert` — assert custom errors and OZ errors by selector.
///
///      Run:
///        forge test -vvv
///        forge test --match-test test_Earned_AccruesOverTime -vvvv
contract StakingProtocolTest is Test {
    /*//////////////////////////////////////////////////////////////
                              TEST FIXTURE
    //////////////////////////////////////////////////////////////*/

    StakingProtocol internal staking;
    MockERC20 internal stk; // staking token
    MockERC20 internal rwd; // reward token

    address internal owner = makeAddr("owner");
    address internal alice = makeAddr("alice");
    address internal bob = makeAddr("bob");
    address internal eve = makeAddr("eve");

    uint256 internal constant INITIAL_BALANCE = 10_000 ether;
    uint256 internal constant REWARD_RATE = 1 ether; // 1 RWD per second globally
    uint256 internal constant REWARD_FUNDING = 1_000_000 ether;

    function setUp() public {
        vm.startPrank(owner);
        stk = new MockERC20("Stake Token", "STK", owner);
        rwd = new MockERC20("Reward Token", "RWD", owner);

        staking = new StakingProtocol(IERC20(address(stk)), IERC20(address(rwd)), owner);

        // Fund the staking contract with reward liquidity and seed users.
        rwd.mint(owner, REWARD_FUNDING);
        rwd.approve(address(staking), REWARD_FUNDING);
        staking.fundRewards(REWARD_FUNDING);

        stk.mint(alice, INITIAL_BALANCE);
        stk.mint(bob, INITIAL_BALANCE);
        vm.stopPrank();

        // Pre-approve allowances so individual tests stay focused on logic.
        vm.prank(alice);
        stk.approve(address(staking), type(uint256).max);
        vm.prank(bob);
        stk.approve(address(staking), type(uint256).max);
    }

    /*//////////////////////////////////////////////////////////////
                                  STAKE
    //////////////////////////////////////////////////////////////*/

    function test_Stake_HappyPath() public {
        vm.prank(alice);
        staking.stake(100 ether);

        assertEq(staking.balanceOf(alice), 100 ether, "balance");
        assertEq(staking.totalStaked(), 100 ether, "total");
        assertEq(stk.balanceOf(address(staking)), 100 ether, "escrow");
    }

    function test_Stake_RevertsOnZeroAmount() public {
        vm.prank(alice);
        vm.expectRevert(IStakingProtocol.ZeroAmount.selector);
        staking.stake(0);
    }

    function test_Stake_EmitsEvent() public {
        vm.prank(alice);
        vm.expectEmit(true, false, false, true, address(staking));
        emit IStakingProtocol.Staked(alice, 50 ether);
        staking.stake(50 ether);
    }

    /*//////////////////////////////////////////////////////////////
                                WITHDRAW
    //////////////////////////////////////////////////////////////*/

    function test_Withdraw_HappyPath() public {
        vm.prank(alice);
        staking.stake(100 ether);

        vm.prank(alice);
        staking.withdraw(40 ether);

        assertEq(staking.balanceOf(alice), 60 ether);
        assertEq(staking.totalStaked(), 60 ether);
        assertEq(stk.balanceOf(alice), INITIAL_BALANCE - 60 ether);
    }

    function test_Withdraw_RevertsOnZeroAmount() public {
        vm.prank(alice);
        vm.expectRevert(IStakingProtocol.ZeroAmount.selector);
        staking.withdraw(0);
    }

    function test_Withdraw_RevertsOnInsufficientBalance() public {
        vm.prank(alice);
        staking.stake(10 ether);

        vm.prank(alice);
        vm.expectRevert(IStakingProtocol.InsufficientBalance.selector);
        staking.withdraw(11 ether);
    }

    /*//////////////////////////////////////////////////////////////
                              REWARD MATH
    //////////////////////////////////////////////////////////////*/

    function test_Earned_ZeroBeforeAnyStake() public {
        vm.prank(owner);
        staking.setRewardRate(REWARD_RATE);
        vm.warp(block.timestamp + 1 days);
        assertEq(staking.earned(alice), 0);
    }

    function test_Earned_AccruesOverTime_SingleStaker() public {
        vm.prank(owner);
        staking.setRewardRate(REWARD_RATE);

        vm.prank(alice);
        staking.stake(100 ether);

        // After 60 seconds, alice is the sole staker so she gets the entire
        // emission window: REWARD_RATE * 60.
        vm.warp(block.timestamp + 60);
        uint256 expected = REWARD_RATE * 60;
        assertApproxEqAbs(staking.earned(alice), expected, 1, "1-staker accrual");
    }

    function test_Earned_SplitsProRata_TwoStakers() public {
        vm.prank(owner);
        staking.setRewardRate(REWARD_RATE);

        // alice stakes 100, bob stakes 300 -> alice owns 25%, bob 75%.
        vm.prank(alice);
        staking.stake(100 ether);
        vm.prank(bob);
        staking.stake(300 ether);

        vm.warp(block.timestamp + 100);
        uint256 totalEmitted = REWARD_RATE * 100;
        uint256 aliceExpected = totalEmitted / 4;
        uint256 bobExpected = (totalEmitted * 3) / 4;

        assertApproxEqAbs(staking.earned(alice), aliceExpected, 1, "alice 25%");
        assertApproxEqAbs(staking.earned(bob), bobExpected, 1, "bob 75%");
    }

    function test_RewardPerToken_ZeroWhenNoStake() public {
        vm.prank(owner);
        staking.setRewardRate(REWARD_RATE);
        vm.warp(block.timestamp + 1 days);
        assertEq(staking.rewardPerToken(), 0);
    }

    /*//////////////////////////////////////////////////////////////
                              CLAIM / EXIT
    //////////////////////////////////////////////////////////////*/

    function test_GetReward_TransfersAndZerosOut() public {
        vm.prank(owner);
        staking.setRewardRate(REWARD_RATE);

        vm.prank(alice);
        staking.stake(100 ether);

        vm.warp(block.timestamp + 60);
        uint256 expected = staking.earned(alice);

        vm.prank(alice);
        staking.getReward();

        assertEq(rwd.balanceOf(alice), expected, "reward paid");
        assertEq(staking.earned(alice), 0, "earned reset");
    }

    function test_Exit_WithdrawsAndClaimsInOneCall() public {
        vm.prank(owner);
        staking.setRewardRate(REWARD_RATE);

        vm.prank(alice);
        staking.stake(100 ether);

        vm.warp(block.timestamp + 60);
        uint256 expectedReward = staking.earned(alice);

        vm.prank(alice);
        staking.exit();

        assertEq(staking.balanceOf(alice), 0, "stake withdrawn");
        assertEq(stk.balanceOf(alice), INITIAL_BALANCE, "stake returned");
        assertEq(rwd.balanceOf(alice), expectedReward, "rewards paid");
    }

    function test_GetReward_NoOpWhenNothingEarned() public {
        vm.prank(alice);
        staking.getReward();
        assertEq(rwd.balanceOf(alice), 0);
    }

    /*//////////////////////////////////////////////////////////////
                            ACCESS CONTROL
    //////////////////////////////////////////////////////////////*/

    function test_SetRewardRate_RevertsForNonOwner() public {
        vm.prank(eve);
        vm.expectRevert(abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, eve));
        staking.setRewardRate(REWARD_RATE);
    }

    function test_SetRewardRate_OwnerCanUpdate() public {
        vm.prank(owner);
        staking.setRewardRate(REWARD_RATE);
        assertEq(staking.rewardRate(), REWARD_RATE);
    }

    function test_FundRewards_RevertsForNonOwner() public {
        vm.prank(eve);
        vm.expectRevert(abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, eve));
        staking.fundRewards(1 ether);
    }

    /*//////////////////////////////////////////////////////////////
                            RATE-CHANGE ACCRUAL
    //////////////////////////////////////////////////////////////*/

    /// @notice Changing the rate must NOT retroactively re-price past accrual.
    function test_SetRewardRate_FinalizesPastAccrualAtOldRate() public {
        vm.prank(owner);
        staking.setRewardRate(REWARD_RATE);

        vm.prank(alice);
        staking.stake(100 ether);

        // 30 seconds at REWARD_RATE
        vm.warp(block.timestamp + 30);
        uint256 expectedFirstWindow = REWARD_RATE * 30;

        // Owner doubles the rate
        vm.prank(owner);
        staking.setRewardRate(REWARD_RATE * 2);

        // 30 more seconds at 2x rate
        vm.warp(block.timestamp + 30);
        uint256 expectedSecondWindow = (REWARD_RATE * 2) * 30;

        assertApproxEqAbs(
            staking.earned(alice), expectedFirstWindow + expectedSecondWindow, 1, "split-rate accrual"
        );
    }

    /*//////////////////////////////////////////////////////////////
                              REENTRANCY
    //////////////////////////////////////////////////////////////*/

    /// @notice A malicious reward token that re-enters `getReward` on transfer
    ///         must be foiled by `nonReentrant`.
    function test_GetReward_RevertsOnReentry() public {
        // Deploy a fresh protocol whose REWARD token is a reentrant attacker.
        ReentrantToken evilRwd = new ReentrantToken("Evil RWD", "eRWD");
        vm.startPrank(owner);
        StakingProtocol evilStaking =
            new StakingProtocol(IERC20(address(stk)), IERC20(address(evilRwd)), owner);
        evilRwd.mint(address(evilStaking), 1_000 ether);
        evilStaking.setRewardRate(REWARD_RATE);
        vm.stopPrank();

        // Stake as alice, accrue, then point the attacker at evilStaking and trigger.
        vm.prank(alice);
        stk.approve(address(evilStaking), type(uint256).max);
        vm.prank(alice);
        evilStaking.stake(100 ether);
        vm.warp(block.timestamp + 10);

        evilRwd.setTarget(address(evilStaking));

        vm.prank(alice);
        vm.expectRevert(ReentrancyGuard.ReentrancyGuardReentrantCall.selector);
        evilStaking.getReward();
    }
}

/*//////////////////////////////////////////////////////////////////
                          REENTRANCY HELPER
//////////////////////////////////////////////////////////////////*/

/// @dev Minimal ERC20-ish reward token whose `transfer` re-enters the
///      staking protocol's `getReward`. Just enough surface area to satisfy
///      the SafeERC20 call inside StakingProtocol.
contract ReentrantToken {
    string public name;
    string public symbol;
    uint8 public constant decimals = 18;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    address public target;
    bool private _attacking;

    constructor(string memory n, string memory s) {
        name = n;
        symbol = s;
    }

    function setTarget(address t) external {
        target = t;
    }

    function mint(address to, uint256 amount) external {
        balanceOf[to] += amount;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        return true;
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;

        // The first time we are called from inside a getReward(), re-enter once.
        // We deliberately DO NOT catch the revert: it must bubble back out so
        // the outer getReward() reverts with ReentrancyGuardReentrantCall.
        if (target != address(0) && !_attacking) {
            _attacking = true;
            IStakingProtocol(target).getReward();
            _attacking = false;
        }
        return true;
    }
}
