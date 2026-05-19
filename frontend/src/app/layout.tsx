import type { Metadata } from "next";
import { Providers } from "./providers";
import "./globals.css";

export const metadata: Metadata = {
  title: "Bandung Base Builders — Staking",
  description:
    "Workshop dApp built on Base Sepolia by the Bandung Base Builders cohort.",
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
