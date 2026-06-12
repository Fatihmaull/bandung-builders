import type { Abi, Address } from "viem";
import stakingAbiJson from "@/abi/StakingProtocol.json";

/**
 * Single source of truth for the dApp's on-chain endpoints.
 *
 * - Addresses come from environment variables (filled after `forge script`).
 * - The ABI is committed alongside the frontend so the types stay stable; we
 *   re-export it `as const` so Wagmi/Viem can infer argument/return types.
 *
 * RULE: no other file in `frontend/src` may import an ABI or hardcode an
 * address. If you find yourself wanting to, add it here instead.
 */

function requireAddress(value: string | undefined, name: string): Address {
  if (!value) {
    throw new Error(`${name} is not set. Add it to frontend/.env.local.`);
  }
  if (!/^0x[a-fA-F0-9]{40}$/.test(value)) {
    throw new Error(`${name}="${value}" is not a 20-byte hex address.`);
  }
  return value as Address;
}

export const STAKING_CONTRACT_ADDRESS = requireAddress(
  process.env.NEXT_PUBLIC_STAKING_CONTRACT_ADDRESS,
  "NEXT_PUBLIC_STAKING_CONTRACT_ADDRESS"
);

export const STAKING_TOKEN_ADDRESS = requireAddress(
  process.env.NEXT_PUBLIC_STAKING_TOKEN_ADDRESS,
  "NEXT_PUBLIC_STAKING_TOKEN_ADDRESS"
);

export const REWARD_TOKEN_ADDRESS = requireAddress(
  process.env.NEXT_PUBLIC_REWARD_TOKEN_ADDRESS,
  "NEXT_PUBLIC_REWARD_TOKEN_ADDRESS"
);

export const stakingAbi = stakingAbiJson as unknown as Abi;

/** Minimal ERC20 ABI for approve / balanceOf and MockERC20's faucet. */
export const erc20Abi = [
  {
    type: "function",
    name: "balanceOf",
    inputs: [{ name: "account", type: "address" }],
    outputs: [{ name: "", type: "uint256" }],
    stateMutability: "view",
  },
  {
    type: "function",
    name: "allowance",
    inputs: [
      { name: "owner", type: "address" },
      { name: "spender", type: "address" },
    ],
    outputs: [{ name: "", type: "uint256" }],
    stateMutability: "view",
  },
  {
    type: "function",
    name: "approve",
    inputs: [
      { name: "spender", type: "address" },
      { name: "amount", type: "uint256" },
    ],
    outputs: [{ name: "", type: "bool" }],
    stateMutability: "nonpayable",
  },
  {
    type: "function",
    name: "faucet",
    inputs: [],
    outputs: [],
    stateMutability: "nonpayable",
  },
] as const satisfies Abi;
