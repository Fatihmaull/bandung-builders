import { getDefaultConfig } from "@rainbow-me/rainbowkit";
import { arbitrumSepolia } from "wagmi/chains";
import { http } from "wagmi";

const projectId = process.env.NEXT_PUBLIC_WC_PROJECT_ID;

if (!projectId) {
  throw new Error(
    "NEXT_PUBLIC_WC_PROJECT_ID is not set. Get one at https://cloud.walletconnect.com and add it to frontend/.env.local."
  );
}

const customRpc = process.env.NEXT_PUBLIC_ARBITRUM_SEPOLIA_RPC_URL;

/** Wagmi v2 config pinned to Arbitrum Sepolia (track: arbitrum). */
export const wagmiConfig = getDefaultConfig({
  appName: "Bandung Arbitrum Builders — Staking",
  projectId,
  chains: [arbitrumSepolia],
  transports: {
    [arbitrumSepolia.id]: http(customRpc ?? undefined),
  },
  ssr: true,
});
