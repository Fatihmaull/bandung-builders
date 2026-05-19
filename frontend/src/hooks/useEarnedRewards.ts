"use client";

import { useAccount, useReadContract } from "wagmi";
import type { Address } from "viem";

import { STAKING_CONTRACT_ADDRESS, stakingAbi } from "@/lib/contracts";

/**
 * Read the connected user's unclaimed reward balance.
 *
 * Maps to `StakingProtocol.earned(address)`. Refetches every 5 seconds so the
 * UI feels live; bump the interval if you see RPC throttling.
 */
export function useEarnedRewards(account?: Address) {
  const { address } = useAccount();
  const target = account ?? address;

  return useReadContract({
    address: STAKING_CONTRACT_ADDRESS,
    abi: stakingAbi,
    functionName: "earned",
    args: target ? [target] : undefined,
    query: {
      enabled: Boolean(target),
      refetchInterval: 5_000,
    },
  });
}
