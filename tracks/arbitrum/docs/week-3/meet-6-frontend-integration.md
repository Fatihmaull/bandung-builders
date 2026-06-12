# Meet 6 — Frontend Connection (Viem, Wagmi, & RainbowKit)

> **Track:** Technical
> **Duration:** 2.5 hours
> **Companion files:**
> - Wagmi config: [`frontend/src/lib/wagmi.ts`](../../frontend/src/lib/wagmi.ts)
> - Providers: [`frontend/src/app/providers.tsx`](../../frontend/src/app/providers.tsx)
> - Hooks: [`frontend/src/hooks/`](../../frontend/src/hooks/)
> - Example page: [`frontend/src/app/page.tsx`](../../frontend/src/app/page.tsx)

## Learning objectives

By the end of this session, every attendee can:

1. Explain the relationship between Viem, Wagmi, and RainbowKit.
2. Configure a Next.js App Router app with the providers in the correct order.
3. Author a custom hook wrapping `useReadContract` and another wrapping `useWriteContract` + `useWaitForTransactionReceipt`.
4. Handle the full transaction lifecycle (signing → pending → confirmed → error) in the UI.
5. Implement the missing `useApproveStake` hook themselves.

## Agenda (150 minutes)

| Time      | Block                                                          |
| --------- | -------------------------------------------------------------- |
| 00:00–00:15 | Frame: Viem vs Wagmi vs RainbowKit, the three-layer stack    |
| 00:15–00:45 | Block A — Provider setup walkthrough                         |
| 00:45–01:25 | Block B — Read hooks deep-dive                               |
| 01:25–01:35 | Stretch break                                                 |
| 01:35–02:15 | Block C — Write hooks deep-dive + tx lifecycle               |
| 02:15–02:30 | Block D — Build the missing `useApproveStake` hook           |

---

## Frame (15 min)

Draw on the whiteboard:

```
┌─────────────────────────────────────────────────────────┐
│                    Your React app                        │
└────────────────────┬────────────────────────────────────┘
                     │ uses
                     ▼
┌─────────────────────────────────────────────────────────┐
│  RainbowKit  — wallet picker UI + ConnectButton          │
└────────────────────┬────────────────────────────────────┘
                     │ provides connectors to
                     ▼
┌─────────────────────────────────────────────────────────┐
│  Wagmi v2    — React hooks (useAccount, useReadContract) │
└────────────────────┬────────────────────────────────────┘
                     │ wraps
                     ▼
┌─────────────────────────────────────────────────────────┐
│  Viem v2     — TypeScript Ethereum client (RPC primitive)│
└─────────────────────────────────────────────────────────┘
```

Talking points:

- **Viem** is the bottom: a lightweight, TypeScript-first replacement for ethers.js. Pure functions: `createPublicClient`, `readContract`, `parseUnits`. No React. You *can* use Viem alone in a CLI / a backend.
- **Wagmi** wraps Viem in React hooks: `useAccount`, `useReadContract`, `useWriteContract`. It also handles caching (via TanStack Query) and reactivity (re-renders when the connected account changes).
- **RainbowKit** is just UI: the wallet-picker modal, the ConnectButton, themes. It sits on top of Wagmi and configures the connectors for you with `getDefaultConfig`.

> "When you debug, work down the stack. UI bug? RainbowKit. State bug? Wagmi. RPC bug? Viem (look at the network tab). The boundary between layers is clean."

---

## Block A — Provider setup walkthrough (30 min)

Open [`frontend/src/lib/wagmi.ts`](../../frontend/src/lib/wagmi.ts) on the projector.

### A.1. The Wagmi config

```ts
export const wagmiConfig = getDefaultConfig({
  appName: "Bandung Arbitrum Builders — Staking",
  projectId,
  chains: [arbitrumSepolia],
  transports: {
    [arbitrumSepolia.id]: http(customRpc ?? undefined),
  },
  ssr: true,
});
```

Talking points:

- **`getDefaultConfig`** comes from RainbowKit, not Wagmi. It's a "batteries included" helper that builds a Wagmi `Config` with a curated set of connectors (Coinbase Wallet, MetaMask, WalletConnect, injected). You *can* hand-build a Wagmi config from scratch — but for a workshop dApp, this is two lines.
- **`chains: [arbitrumSepolia]`** is the entire chain whitelist. Note the array — multi-chain support would be `[arbitrumSepolia, base, mainnet]`. Workshop policy: stays one element.
- **`transports`** lets you override the public RPC. We optionally read `NEXT_PUBLIC_ARBITRUM_SEPOLIA_RPC_URL`. Public Arbitrum Sepolia is throttled; a private RPC (Alchemy/Infura/QuickNode) is recommended for any UI that polls.
- **`ssr: true`** is critical for Next.js App Router. It tells Wagmi to hydrate cleanly across the server/client boundary; without it, you get hydration mismatches.

### A.2. The `projectId` runtime check

> "Notice we `throw` if the projectId is missing. Why? Because WalletConnect silently degrades — the modal still renders, but WalletConnect doesn't work. Failing loud at boot is *better* than failing silent in production."

### A.3. The provider tree

Open [`frontend/src/app/providers.tsx`](../../frontend/src/app/providers.tsx).

```tsx
<WagmiProvider config={wagmiConfig}>
  <QueryClientProvider client={queryClient}>
    <RainbowKitProvider theme={...}>
      {children}
```

Three providers, ordered outermost-to-innermost. Why this order?

1. **WagmiProvider** must wrap everything else because it owns the chain/connector state.
2. **QueryClientProvider** wraps Rainbow because Rainbow uses TanStack Query internally for chain state.
3. **RainbowKitProvider** is innermost because it consumes both of the above.

> "Reverse the order and you'll get a runtime error like 'useAccount must be used within WagmiProvider.' If you ever see that, suspect the provider tree first."

### A.4. The `useState(() => new QueryClient())` pattern

```tsx
const [queryClient] = useState(() => new QueryClient({ ... }));
```

> "Why not just `new QueryClient()` at module scope? Because of React Server Components — module scope runs on the *server too*, and a server-instantiated QueryClient is shared across requests (data leakage). Per-component-mount instantiation, gated by `useState`, ensures one client per browser tab."

### A.5. The `"use client"` boundary

Point out the `"use client"` at the top of `providers.tsx`. The entire React Context tree (Wagmi/Query/Rainbow) is client-side; only the server-rendered shell of `layout.tsx` is RSC.

> "App Router lets you mix server and client components, but anything using React hooks must be `\"use client\"`. Components inside `<Providers>` can be server components too, as long as *they themselves* don't use Wagmi hooks. In practice, this app is mostly client-side."

### A.6. The root layout

Open [`frontend/src/app/layout.tsx`](../../frontend/src/app/layout.tsx).

Walk through:

- `<Providers>` wraps `{children}`.
- `suppressHydrationWarning` on `<html>` is recommended by Next when the body theme changes client-side (RainbowKit's dark theme).
- Tailwind classes on `<body>` set the global background.

---

## Block B — Read hooks deep-dive (40 min)

Open [`frontend/src/hooks/useStakingBalance.ts`](../../frontend/src/hooks/useStakingBalance.ts).

### B.1. The simplest read hook

```ts
export function useStakingBalance(account?: Address) {
  const { address } = useAccount();
  const target = account ?? address;

  return useReadContract({
    address: STAKING_CONTRACT_ADDRESS,
    abi: stakingAbi,
    functionName: "balanceOf",
    args: target ? [target] : undefined,
    query: { enabled: Boolean(target) },
  });
}
```

Five things to call out:

1. **Composition with `useAccount`.** The hook reads the connected address as the default `account`. The optional parameter lets a caller pass any address (useful for an admin panel).
2. **`args: target ? [target] : undefined`.** When `target` is undefined, args are undefined — combined with `query.enabled: false`, the hook doesn't fire an RPC call.
3. **Return shape is Wagmi's standard query result.** `{ data, isLoading, isError, refetch, ... }`. We deliberately don't unwrap it — letting consumers use the full power of TanStack Query.
4. **No manual polling.** The default refresh interval from `<QueryClientProvider>` (15 seconds) applies.
5. **Strict typing via the const ABI.** With `stakingAbi` typed properly, Wagmi infers that `data` is `bigint | undefined`. Try `data.toString()` to see TS allow `bigint.toString`.

### B.2. The polling variant

Open [`frontend/src/hooks/useEarnedRewards.ts`](../../frontend/src/hooks/useEarnedRewards.ts). Same shape, but:

```ts
query: { enabled: Boolean(target), refetchInterval: 5_000 },
```

> "Why poll earned rewards every 5 seconds? Because they accrue continuously on-chain (a function of `block.timestamp`). The user expects to see the number tick up. 5 seconds is the sweet spot between 'feels alive' and 'wastes RPC calls.'"

> "Why *not* poll `balanceOf`? Because it only changes when the user explicitly stakes or withdraws. We refetch on tx confirmation instead."

### B.3. Using a read hook in a page

Switch to [`frontend/src/app/page.tsx`](../../frontend/src/app/page.tsx). Show the read example:

```tsx
const { data: stakedBalance } = useStakingBalance();
// ...
<div>{stakedBalance !== undefined ? formatUnits(stakedBalance, 18) : "—"} STK</div>
```

> "`formatUnits` from Viem. Takes a `bigint`, returns a string. The `18` is decimals; our `MockERC20` is 18, USDC would be 6. Hardcoding 18 is a smell — better to read decimals from the token contract. That's an exercise for after this session."

### B.4. (Live) Add a third read hook

To check comprehension, live-code a new hook together: `useTotalStaked`. Should be ~10 lines, mirror `useStakingBalance` but no account.

```ts
export function useTotalStaked() {
  return useReadContract({
    address: STAKING_CONTRACT_ADDRESS,
    abi: stakingAbi,
    functionName: "totalStaked",
  });
}
```

Save, hot-reload, render the value in the UI. Three minutes of green-bar dopamine.

---

## Block C — Write hooks deep-dive + tx lifecycle (40 min)

Open [`frontend/src/hooks/useStakeTokens.ts`](../../frontend/src/hooks/useStakeTokens.ts).

### C.1. The pattern

```ts
const { writeContract, data: hash, isPending, error, reset } = useWriteContract();
const { isLoading: isConfirming, isSuccess: isConfirmed } =
  useWaitForTransactionReceipt({ hash });

const stake = useCallback((amount: bigint) => {
  writeContract({
    address: STAKING_CONTRACT_ADDRESS,
    abi: stakingAbi,
    functionName: "stake",
    args: [amount],
  });
}, [writeContract]);
```

Talking points:

- **`useWriteContract`** sends the transaction. Returns the hash. `isPending = true` while the wallet popup is open.
- **`useWaitForTransactionReceipt`** polls for the receipt. `isLoading = true` while the tx is in mempool. `isSuccess = true` once mined.
- The combined lifecycle has *four* states: idle → pending (signing) → confirming → confirmed/error. The UI must show all four; users get anxious when nothing visibly happens.

### C.2. The lifecycle, visualized

| State          | `isPending` | `isConfirming` | `isConfirmed` | UI                                  |
| -------------- | ----------- | -------------- | ------------- | ----------------------------------- |
| Idle           | false       | false          | false         | "Stake" button enabled              |
| Signing        | true        | false          | false         | "Sign in wallet…" disabled          |
| Confirming     | false       | true           | false         | "Confirming…" disabled              |
| Confirmed      | false       | false          | true          | Success state, refetch balances     |
| Error          | (depends)   | (depends)      | false         | Error message, re-enable button     |

Walk through how the example page implements this:

```tsx
<button onClick={handleStake} disabled={!isConnected || isPending || isConfirming}>
  {isPending ? "Sign in wallet…" : isConfirming ? "Confirming…" : "Stake"}
</button>

{isConfirmed && <p className="text-emerald-400">Stake confirmed.</p>}
{error && <p className="text-rose-400">{error.message}</p>}
```

### C.3. The approval problem (the missing piece)

> "Look at our `useStakeTokens` hook. What does it *assume*?"

Wait. Someone will say: "That the user has approved already."

> "Exactly. The staking contract calls `safeTransferFrom(user, this, amount)` which requires a prior `approve(staking, amount)` from the user. We need a `useApproveStake` hook. **You're going to write it in Block D.**"

### C.4. Error handling realities

Common errors users will see:

- **User rejects wallet popup:** `writeError` will be a Viem error with code 4001.
- **Tx reverts:** `receiptError` will contain the revert reason if the contract emitted a custom error.
- **Insufficient ETH for gas:** RPC error; surface as "You don't have enough Arbitrum Sepolia ETH. Faucet: …".
- **Tx never confirms:** mempool issues; `useWaitForTransactionReceipt` will just sit there. Add a timeout client-side if you want to surface it.

> "In production you'd map these to friendly UX strings. For Demo Day, surfacing `error.message` is acceptable; the judges will not penalize 'execution reverted: InsufficientBalance()' on a testnet build."

### C.5. Triggering a refetch after success

Critical missing piece in our example: when `isConfirmed` flips true, we should refetch `useStakingBalance` so the UI updates. Two ways:

1. Manually call `refetch()` from the read hook inside a `useEffect`.
2. Use Wagmi's `useWatchContractEvent` to listen for the `Staked` event and refetch.

Live-code option 1:

```tsx
const { data: stakedBalance, refetch: refetchBalance } = useStakingBalance();
const { stake, isConfirmed } = useStakeTokens();

useEffect(() => {
  if (isConfirmed) refetchBalance();
}, [isConfirmed, refetchBalance]);
```

---

## Block D — Build the missing `useApproveStake` (15 min)

Live exercise. Cohort writes it together. Target file: `frontend/src/hooks/useApproveStake.ts`.

Requirements:

1. Wraps `useWriteContract` + `useWaitForTransactionReceipt`, exactly like `useStakeTokens`.
2. Calls `STAKING_TOKEN_ADDRESS.approve(STAKING_CONTRACT_ADDRESS, amount)`.
3. Uses the minimal `erc20Abi` exported from `@/lib/contracts`.

Reference solution to project after attendees attempt:

```ts
"use client";

import { useCallback } from "react";
import {
  useWriteContract,
  useWaitForTransactionReceipt,
} from "wagmi";

import {
  STAKING_CONTRACT_ADDRESS,
  STAKING_TOKEN_ADDRESS,
  erc20Abi,
} from "@/lib/contracts";

/**
 * Approve the staking contract to spend `amount` of the user's stake token.
 * Call this before `useStakeTokens.stake(...)`.
 */
export function useApproveStake() {
  const { writeContract, data: hash, isPending, error: writeError, reset } =
    useWriteContract();
  const { isLoading: isConfirming, isSuccess: isConfirmed, error: receiptError } =
    useWaitForTransactionReceipt({ hash });

  const approve = useCallback(
    (amount: bigint) => {
      writeContract({
        address: STAKING_TOKEN_ADDRESS,
        abi: erc20Abi,
        functionName: "approve",
        args: [STAKING_CONTRACT_ADDRESS, amount],
      });
    },
    [writeContract]
  );

  return {
    approve,
    hash,
    isPending,
    isConfirming,
    isConfirmed,
    error: writeError ?? receiptError,
    reset,
  };
}
```

> "Notice the symmetry with `useStakeTokens`. Every write hook in this app should look the same shape. That's the value of conventions: a reviewer can spot a deviation in 5 seconds."

---

## Closing — Take-home

### Checklist

- [ ] `useApproveStake` hook written and merged.
- [ ] Page renders staked balance, earned rewards, total staked.
- [ ] Page has working approve → stake flow (two-step).
- [ ] Page has working withdraw and claim buttons (you wire them up).
- [ ] Tx lifecycle UI shows pending / confirming / success states.
- [ ] Errors are surfaced (even just `error.message` is fine for now).

### Next session preview

> "Meet 7 is non-technical. We pitch. You're going to pretend you're standing in front of ETHGlobal judges and explain *why* this matters. Bring your project name and one-liner — we'll workshop them."
