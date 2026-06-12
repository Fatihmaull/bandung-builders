"use client";

import { useState } from "react";
import { ConnectButton } from "@rainbow-me/rainbowkit";
import { useAccount } from "wagmi";
import { formatUnits, parseUnits } from "viem";

import { useStakingBalance } from "@/hooks/useStakingBalance";
import { useEarnedRewards } from "@/hooks/useEarnedRewards";
import { useStakeTokens } from "@/hooks/useStakeTokens";

/**
 * Example page. INTENTIONALLY MINIMAL.
 *
 * This file demonstrates *one* read hook (`useStakingBalance`) and *one*
 * write hook (`useStakeTokens`). Meet 6 is where attendees build out the
 * full UI (withdraw, claim, approve, balances, error toasts, etc.) using
 * the other hooks already in `src/hooks/`.
 *
 * Do NOT pre-build the full staking UI here — that is the attendee's job.
 */
export default function Home() {
  const { address, isConnected } = useAccount();
  const { data: stakedBalance } = useStakingBalance();
  const { data: earned } = useEarnedRewards();
  const { stake, isPending, isConfirming, isConfirmed, error } = useStakeTokens();

  const [amount, setAmount] = useState<string>("10");

  function handleStake() {
    try {
      const parsed = parseUnits(amount || "0", 18);
      if (parsed <= 0n) return;
      stake(parsed);
    } catch {
      /* parse error: user typed nonsense; ignore */
    }
  }

  return (
    <main className="mx-auto flex min-h-screen max-w-3xl flex-col gap-8 px-6 py-12">
      <header className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-semibold">Bandung Arbitrum Builders</h1>
          <p className="text-sm text-neutral-400">
            Staking dApp boilerplate — Arbitrum Sepolia
          </p>
        </div>
        <ConnectButton showBalance={false} chainStatus="icon" />
      </header>

      <section className="panel">
        <h2 className="mb-4 text-lg font-medium">Connection</h2>
        {isConnected ? (
          <p className="text-sm text-neutral-300">
            Connected as <span className="font-mono">{address}</span>
          </p>
        ) : (
          <p className="text-sm text-neutral-400">
            Connect a wallet (Coinbase Wallet, MetaMask, WalletConnect) to continue.
          </p>
        )}
      </section>

      <section className="panel">
        <h2 className="mb-4 text-lg font-medium">Read example — your stake</h2>
        <div className="grid grid-cols-2 gap-4 text-sm">
          <div>
            <div className="text-neutral-400">Staked balance</div>
            <div className="font-mono text-base">
              {stakedBalance !== undefined ? formatUnits(stakedBalance, 18) : "—"} STK
            </div>
          </div>
          <div>
            <div className="text-neutral-400">Unclaimed rewards</div>
            <div className="font-mono text-base">
              {earned !== undefined ? formatUnits(earned, 18) : "—"} RWD
            </div>
          </div>
        </div>
        <p className="mt-4 text-xs text-neutral-500">
          Hooks: <code>useStakingBalance</code> + <code>useEarnedRewards</code>.
        </p>
      </section>

      <section className="panel">
        <h2 className="mb-4 text-lg font-medium">Write example — stake STK</h2>
        <div className="flex items-end gap-3">
          <div className="flex-1">
            <label
              htmlFor="amount"
              className="mb-1 block text-xs uppercase tracking-wide text-neutral-400"
            >
              Amount (STK)
            </label>
            <input
              id="amount"
              type="number"
              min="0"
              step="0.0001"
              value={amount}
              onChange={(e) => setAmount(e.target.value)}
              className="w-full rounded-lg border border-white/10 bg-black/30 px-3 py-2 font-mono text-base focus:border-base focus:outline-none"
            />
          </div>
          <button
            type="button"
            className="btn"
            onClick={handleStake}
            disabled={!isConnected || isPending || isConfirming}
          >
            {isPending
              ? "Sign in wallet…"
              : isConfirming
              ? "Confirming…"
              : "Stake"}
          </button>
        </div>

        {isConfirmed && (
          <p className="mt-3 text-sm text-emerald-400">Stake confirmed.</p>
        )}
        {error && (
          <p className="mt-3 break-all text-sm text-rose-400">
            {error.message}
          </p>
        )}
        <p className="mt-4 text-xs text-neutral-500">
          Hook: <code>useStakeTokens</code>. Remember: you must first approve
          the staking contract to spend your STK. That hook is your Meet 6
          exercise.
        </p>
      </section>

      <footer className="mt-auto pt-6 text-xs text-neutral-600">
        Curriculum:{" "}
        <a className="underline" href="https://github.com">
          /docs
        </a>{" "}
        · Chain: Base Sepolia (84532)
      </footer>
    </main>
  );
}
