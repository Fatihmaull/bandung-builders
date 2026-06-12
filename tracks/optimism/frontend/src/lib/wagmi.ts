import { getDefaultConfig } from "@rainbow-me/rainbowkit";
import { optimismSepolia } from "wagmi/chains";
import { http } from "wagmi";

const projectId = process.env.NEXT_PUBLIC_WC_PROJECT_ID;

if (!projectId) {
  throw new Error(
    "NEXT_PUBLIC_WC_PROJECT_ID is not set. Get one at https://cloud.walletconnect.com and add it to frontend/.env.local."
  );
}

const customRpc = process.env.NEXT_PUBLIC_OP_SEPOLIA_RPC_URL;

/** Wagmi v2 config pinned to OP Sepolia (track: optimism). */
export const wagmiConfig = getDefaultConfig({
  appName: "Bandung OP Builders — Staking",
  projectId,
  chains: [optimismSepolia],
  transports: {
    [optimismSepolia.id]: http(customRpc ?? undefined),
  },
  ssr: true,
});
