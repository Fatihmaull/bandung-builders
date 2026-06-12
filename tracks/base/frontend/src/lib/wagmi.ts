import { getDefaultConfig } from "@rainbow-me/rainbowkit";
import { baseSepolia } from "wagmi/chains";
import { http } from "wagmi";

const projectId = process.env.NEXT_PUBLIC_WC_PROJECT_ID;

if (!projectId) {
  throw new Error(
    "NEXT_PUBLIC_WC_PROJECT_ID is not set. Get one at https://cloud.walletconnect.com and add it to frontend/.env.local."
  );
}

const customRpc = process.env.NEXT_PUBLIC_BASE_SEPOLIA_RPC_URL;

/** Wagmi v2 config pinned to Base Sepolia (track: base). */
export const wagmiConfig = getDefaultConfig({
  appName: "Bandung Base Builders — Staking",
  projectId,
  chains: [baseSepolia],
  transports: {
    [baseSepolia.id]: http(customRpc ?? undefined),
  },
  ssr: true,
});
