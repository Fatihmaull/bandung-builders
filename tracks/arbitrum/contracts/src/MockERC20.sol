// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @title  MockERC20
/// @notice Minimal mintable ERC20 used as the staking and reward token in tests
///         and on Base Sepolia. NOT FOR MAINNET. Anyone can request mints via
///         the public `faucet` helper to make workshop UX easy.
/// @dev    Inherits OZ v5 `ERC20` + `Ownable`. Decimals default to 18.
contract MockERC20 is ERC20, Ownable {
    uint256 public constant FAUCET_AMOUNT = 1_000 ether;

    constructor(string memory name_, string memory symbol_, address initialOwner)
        ERC20(name_, symbol_)
        Ownable(initialOwner)
    {}

    /// @notice Owner-only mint for funding the staking contract or seeding accounts.
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    /// @notice Public, capped faucet for workshop attendees on Base Sepolia.
    /// @dev    Mints `FAUCET_AMOUNT` to the caller. There is no per-address
    ///         cooldown because this token has no real value; spammers waste
    ///         only their own gas.
    function faucet() external {
        _mint(msg.sender, FAUCET_AMOUNT);
    }
}
