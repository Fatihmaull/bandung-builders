"use client";

import { useCallback } from "react";
import {
  useWriteContract,
  useWaitForTransactionReceipt,
} from "wagmi";

import { STAKING_CONTRACT_ADDRESS, stakingAbi } from "@/lib/contracts";

/**
 * Write hook: `StakingProtocol.withdraw(amount)`.
 *
 * No allowance needed — the protocol is pushing tokens BACK to the user.
 * See `useStakeTokens` for the lifecycle field shape.
 */
export function useWithdraw() {
  const { writeContract, data: hash, isPending, error: writeError, reset } =
    useWriteContract();
  const { isLoading: isConfirming, isSuccess: isConfirmed, error: receiptError } =
    useWaitForTransactionReceipt({ hash });

  const withdraw = useCallback(
    (amount: bigint) => {
      writeContract({
        address: STAKING_CONTRACT_ADDRESS,
        abi: stakingAbi,
        functionName: "withdraw",
        args: [amount],
      });
    },
    [writeContract]
  );

  return {
    withdraw,
    hash,
    isPending,
    isConfirming,
    isConfirmed,
    error: writeError ?? receiptError,
    reset,
  };
}
