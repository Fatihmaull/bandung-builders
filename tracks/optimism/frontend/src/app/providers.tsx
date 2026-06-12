"use client";

import { ReactNode, useState } from "react";
import { WagmiProvider } from "wagmi";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { RainbowKitProvider, darkTheme } from "@rainbow-me/rainbowkit";
import "@rainbow-me/rainbowkit/styles.css";

import { wagmiConfig } from "@/lib/wagmi";

/**
 * Top-level client provider tree. Order matters:
 *
 *   <WagmiProvider>          // chain + connectors
 *     <QueryClientProvider>  // async cache for read hooks
 *       <RainbowKitProvider> // wallet picker UI
 *         {children}
 *
 * Mounted in `app/layout.tsx`. Everything below is a server component until
 * a leaf marks itself "use client".
 */
export function Providers({ children }: { children: ReactNode }) {
  // useState instantiates the QueryClient exactly once per browser session,
  // surviving HMR while staying out of the module-level singleton trap.
  const [queryClient] = useState(
    () =>
      new QueryClient({
        defaultOptions: {
          queries: {
            staleTime: 15_000,
            refetchInterval: 15_000,
            refetchOnWindowFocus: false,
          },
        },
      })
  );

  return (
    <WagmiProvider config={wagmiConfig}>
      <QueryClientProvider client={queryClient}>
        <RainbowKitProvider
          theme={darkTheme({
            accentColor: "#0052FF",
            borderRadius: "medium",
          })}
          modalSize="compact"
        >
          {children}
        </RainbowKitProvider>
      </QueryClientProvider>
    </WagmiProvider>
  );
}
