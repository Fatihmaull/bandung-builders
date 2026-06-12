import type { NextConfig } from "next";

const config: NextConfig = {
  reactStrictMode: true,
  // WalletConnect / RainbowKit pulls a few node-targeted packages; mark them
  // as externals only on the server build, where they are not used.
  webpack: (cfg) => {
    cfg.externals.push("pino-pretty", "lokijs", "encoding");
    return cfg;
  },
};

export default config;
