# `contracts/` — Foundry Workspace

Solidity sources, tests, and deployment scripts for the Bandung Base Builders staking protocol.

## Install dependencies

This workspace expects two Foundry libraries inside `lib/` (gitignored). Run from this directory:

```bash
# OpenZeppelin Contracts v5.x (pin to a tag for reproducibility)
forge install OpenZeppelin/openzeppelin-contracts@v5.0.2 --no-commit

# forge-std (pin a known-good tag)
forge install foundry-rs/forge-std@v1.9.4 --no-commit
```

If you cloned the monorepo fresh, the shorter alias is:

```bash
forge install
```

…which reads `.gitmodules` if present, otherwise re-run the explicit commands above.

## Build & test

```bash
forge build
forge test -vvv
forge test -vvv --match-test test_Earned   # filter
forge coverage                              # optional, slow
forge snapshot                              # gas snapshot for /reports
```

## Local node (anvil)

```bash
anvil --chain-id 31337
# in another shell:
forge script script/Deploy.s.sol:Deploy --rpc-url anvil --broadcast --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
```

## Deploy to Base Sepolia

Ensure the track-level `.env` is filled (`BASE_SEPOLIA_RPC_URL`, `PRIVATE_KEY`, `BASESCAN_API_KEY`).

Fund the deployer from a free faucet (no mainnet activity required):
- https://ethfaucet.com/
- https://www.ethereum-ecosystem.com/faucets/base-sepolia

```bash
# from contracts/
source ../.env

forge script script/Deploy.s.sol:Deploy \
    --rpc-url $BASE_SEPOLIA_RPC_URL \
    --broadcast \
    --verify \
    --etherscan-api-key $BASESCAN_API_KEY \
    -vvvv
```

The `--verify` flag uses the `[etherscan]` block in `foundry.toml` so the contract is verified on Basescan in the same run.

## Layout

```
contracts/
├── foundry.toml
├── remappings.txt
├── src/
│   ├── StakingProtocol.sol             reference implementation
│   ├── StakingProtocol.exercise.sol    blank version, used in Meet 4
│   ├── MockERC20.sol                   test/dev tokens
│   └── interfaces/IStakingProtocol.sol
├── test/
│   └── StakingProtocol.t.sol
└── script/
    └── Deploy.s.sol
```
