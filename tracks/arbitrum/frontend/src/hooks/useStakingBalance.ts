"use client";

import { useAccount, useReadContract } from "wagmi";
import type { Address } from "viem";

import { STAKING_CONTRACT_ADDRESS, stakingAbi } from "@/lib/contracts";

/**
 * Read the connected user's staked balance.
 *
 * Maps directly to `StakingProtocol.balanceOf(address)`.
 *
 * Returns Wagmi's standard `{ data, isLoading, isError, refetch, ... }`
 * with `data` typed as `bigint | undefined`.
 *
 * Usage:
 *   const { data: staked } = useStakingBalance();
 *   const formatted = staked ? formatUnits(staked, 18) : "0";
 */
export function useStakingBalance(account?: Address) {
  const { address } = useAccount();
  const target = account ?? address;

  return useReadContract({
    address: STAKING_CONTRACT_ADDRESS,
    abi: stakingAbi,
    functionName: "balanceOf",
    args: target ? [target] : undefined,
    query: {
      enabled: Boolean(target),
    },
  });
}
