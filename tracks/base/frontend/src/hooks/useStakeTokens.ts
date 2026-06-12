"use client";

import { useCallback } from "react";
import {
  useWriteContract,
  useWaitForTransactionReceipt,
} from "wagmi";

import {
  STAKING_CONTRACT_ADDRESS,
  stakingAbi,
} from "@/lib/contracts";

/**
 * Write hook: `StakingProtocol.stake(amount)`.
 *
 * Returns:
 *   - `stake(amount)`     — call to submit the tx.
 *   - `hash`              — tx hash once broadcast.
 *   - `isPending`         — wallet popup open / signing.
 *   - `isConfirming`      — tx in mempool, waiting on receipt.
 *   - `isConfirmed`       — receipt mined and OK.
 *   - `error`             — any wallet, RPC, or revert error.
 *
 * CALLER RESPONSIBILITY: ensure the user has already approved the staking
 * contract to spend `amount` of the staking token. See `useApproveStake`
 * (left as an exercise for Meet 6).
 */
export function useStakeTokens() {
  const {
    writeContract,
    data: hash,
    isPending,
    error: writeError,
    reset,
  } = useWriteContract();

  const {
    isLoading: isConfirming,
    isSuccess: isConfirmed,
    error: receiptError,
  } = useWaitForTransactionReceipt({ hash });

  const stake = useCallback(
    (amount: bigint) => {
      writeContract({
        address: STAKING_CONTRACT_ADDRESS,
        abi: stakingAbi,
        functionName: "stake",
        args: [amount],
      });
    },
    [writeContract]
  );

  return {
    stake,
    hash,
    isPending,
    isConfirming,
    isConfirmed,
    error: writeError ?? receiptError,
    reset,
  };
}
