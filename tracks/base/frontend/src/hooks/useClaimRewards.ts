"use client";

import { useCallback } from "react";
import {
  useWriteContract,
  useWaitForTransactionReceipt,
} from "wagmi";

import { STAKING_CONTRACT_ADDRESS, stakingAbi } from "@/lib/contracts";

/**
 * Write hook: `StakingProtocol.getReward()`.
 *
 * Pulls any unclaimed reward token balance to the caller. No-ops on-chain
 * (no revert, no event) if `earned(caller) == 0`, so the UI should hide
 * the claim button until `useEarnedRewards` returns a positive value.
 */
export function useClaimRewards() {
  const { writeContract, data: hash, isPending, error: writeError, reset } =
    useWriteContract();
  const { isLoading: isConfirming, isSuccess: isConfirmed, error: receiptError } =
    useWaitForTransactionReceipt({ hash });

  const claim = useCallback(() => {
    writeContract({
      address: STAKING_CONTRACT_ADDRESS,
      abi: stakingAbi,
      functionName: "getReward",
    });
  }, [writeContract]);

  return {
    claim,
    hash,
    isPending,
    isConfirming,
    isConfirmed,
    error: writeError ?? receiptError,
    reset,
  };
}
