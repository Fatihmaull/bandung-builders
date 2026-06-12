import type { Metadata } from "next";
import { Providers } from "./providers";
import "./globals.css";

export const metadata: Metadata = {
  title: "Bandung Arbitrum Builders — Staking",
  description:
    "Workshop dApp built on Arbitrum Sepolia by the Bandung Arbitrum Builders cohort.",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body className="min-h-screen bg-neutral-950 text-neutral-50 antialiased">
        <Providers>{children}</Providers>
      </body>
    </html>
  );
}
