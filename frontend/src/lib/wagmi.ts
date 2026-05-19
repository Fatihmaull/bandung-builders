import { getDefaultConfig } from "@rainbow-me/rainbowkit";
import { baseSepolia } from "wagmi/chains";
import { http } from "wagmi";

const projectId = process.env.NEXT_PUBLIC_WC_PROJECT_ID;

if (!projectId) {
  // Fail loudly during build/dev. RainbowKit silently breaks without it.
  throw new Error(
    "NEXT_PUBLIC_WC_PROJECT_ID is not set. Get one at https://cloud.walletconnect.com and add it to frontend/.env.local."
  );
}

const customRpc = process.env.NEXT_PUBLIC_BASE_SEPOLIA_RPC_URL;

/**
 * Single Wagmi v2 config for the entire app. Pinned to Base Sepolia only —
 * do not add other chains without first updating the workshop policy.
 *
 * `getDefaultConfig` is RainbowKit's batteries-included helper: it builds a
 * Wagmi `Config` with sensible connector defaults (Coinbase Wallet, MetaMask,
 * WalletConnect, injected) and a public transport per chain. We override
 * `transports` so the dApp can use a custom RPC if the operator provides one.
 */
export const wagmiConfig = getDefaultConfig({
  appName: "Bandung Base Builders — Staking",
  projectId,
  chains: [baseSepolia],
  transports: {
    [baseSepolia.id]: http(customRpc ?? undefined),
  },
  ssr: true,
});
