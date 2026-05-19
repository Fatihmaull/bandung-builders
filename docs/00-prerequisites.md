# Prerequisites — Local Environment

Complete this before Meet 1. Budget 45–90 minutes depending on your OS and prior setup.

## Hardware

- 8 GB RAM minimum (16 GB recommended).
- 10 GB free disk.
- Stable internet — Base Sepolia RPCs can be flaky from low-bandwidth links.

## Software (target versions)

| Tool         | Minimum version          | Check                |
| ------------ | ------------------------ | -------------------- |
| Git          | 2.40+                    | `git --version`      |
| Node.js      | 20.x or 22.x LTS         | `node --version`     |
| pnpm         | 9.x                      | `pnpm --version`     |
| Foundry      | 0.2.0+ (any recent build) | `forge --version`   |
| A code editor | Cursor / VS Code / Zed   | —                    |
| A wallet     | Coinbase Wallet, MetaMask, or Rabby | —         |

You will also need accounts at:

- [Basescan](https://basescan.org/myapikey) — free API key for contract verification.
- [WalletConnect Cloud](https://cloud.walletconnect.com) — free `projectId` for RainbowKit.
- [Coinbase Faucet](https://www.coinbase.com/faucets/base-ethereum-sepolia-faucet) — for Base Sepolia ETH.

---

## 1. Install Foundry (Solidity toolchain)

Foundry is `forge`, `cast`, `anvil`, and `chisel` — the modern Solidity workflow. Install via the official one-liner.

### macOS / Linux / WSL2

```bash
curl -L https://foundry.paradigm.xyz | bash
# Reload your shell so `foundryup` is on PATH:
exec $SHELL
foundryup
```

`foundryup` installs the latest stable binaries to `~/.foundry/bin`. To verify:

```bash
forge --version
cast --version
anvil --version
```

To later update or pin a version:

```bash
foundryup            # latest stable
foundryup --version stable  # pin to current stable
```

### Windows (native PowerShell — slower path, prefer WSL2)

WSL2 is the supported path. If you cannot use WSL2:

1. Install Rust from <https://rustup.rs>.
2. Build Foundry from source:

   ```powershell
   cargo install --git https://github.com/foundry-rs/foundry --profile release --locked foundry-cli anvil chisel cast forge
   ```

3. Add `%USERPROFILE%\.cargo\bin` to PATH.

If you hit `cl.exe not found`, install **Visual Studio Build Tools** with the "Desktop development with C++" workload.

### Windows (recommended path — WSL2 Ubuntu)

1. PowerShell as Administrator: `wsl --install`.
2. Reboot, set up Ubuntu username/password.
3. Inside Ubuntu, follow the **macOS / Linux / WSL2** instructions above.

---

## 2. Install Node.js + pnpm

### macOS / Linux / WSL2 — via Node Version Manager (recommended)

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
exec $SHELL
nvm install 22
nvm use 22
node --version    # v22.x
```

Then enable Corepack (ships with Node 16+) to get `pnpm`:

```bash
corepack enable
corepack prepare pnpm@9 --activate
pnpm --version
```

### Windows (native)

1. Download Node 22 LTS from <https://nodejs.org/en/download>.
2. Run the installer with defaults; check "Automatically install necessary tools".
3. Open a fresh PowerShell:

   ```powershell
   corepack enable
   corepack prepare pnpm@9 --activate
   ```

---

## 3. Clone the workshop monorepo

```bash
git clone <your-fork-url> bandungbuildmaterial
cd bandungbuildmaterial

# Configure env files
cp .env.example .env
cp frontend/.env.local.example frontend/.env.local

# Install contract deps
cd contracts
forge install OpenZeppelin/openzeppelin-contracts@v5.0.2 --no-commit
forge install foundry-rs/forge-std@v1.9.4 --no-commit
forge build
forge test -vvv

# Install frontend deps
cd ../frontend
pnpm install
```

If `forge test` passes, your toolchain is healthy.

---

## 4. Get a Base Sepolia wallet + funds

1. Install Coinbase Wallet, MetaMask, or Rabby.
2. Create a **fresh** account for the workshop. **Do not reuse a mainnet key.**
3. Export the private key and put it in `.env` as `PRIVATE_KEY`. The repo `.gitignore` keeps this out of version control — but treat it like a password anyway.
4. Visit <https://www.coinbase.com/faucets/base-ethereum-sepolia-faucet>, sign in with a Coinbase account, request 0.05 Base Sepolia ETH. You'll need to repeat this every ~24 hours throughout the workshop.

---

## 5. Verify your AI agent

The repo ships with [`/.cursorrules`](../.cursorrules). If you use:

- **Cursor:** opening the project loads the file automatically. Confirm via the "Rules for AI" panel.
- **GitHub Copilot / Continue / Cline / Aider:** open [`docs/system-prompt.md`](./system-prompt.md), copy the whole file, paste it into your agent's system-prompt slot. (Continue: `~/.continue/config.json` `customCommands` or `systemMessage`.)

Verify by asking the agent: *"What network are we targeting and what is the precision factor in the reward math?"* — it should answer "Base Sepolia (chainId 84532)" and "`1e18`".

---

## 6. Pre-cohort checklist

Before Meet 1, you should be able to tick every box:

- [ ] `forge --version` works.
- [ ] `node --version` reports v20+ or v22+.
- [ ] `pnpm --version` works.
- [ ] Cloned the repo, both `forge test` and `pnpm install` succeed.
- [ ] Have a Base Sepolia address with > 0 ETH.
- [ ] Basescan API key obtained.
- [ ] WalletConnect projectId obtained, pasted into `frontend/.env.local`.
- [ ] AI agent is loaded with `.cursorrules` / `system-prompt.md`.

If any box is unchecked at Meet 1, raise it in the first 10 minutes. We unblock together.
