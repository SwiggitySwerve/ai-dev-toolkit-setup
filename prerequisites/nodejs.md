# Node.js, npm, and npx Installation Guide

Node.js is a JavaScript runtime. When you install it, you also get two command-line tools that AI coding assistants depend on:

- **npm** -- the Node Package Manager, used to install packages globally or locally.
- **npx** -- a tool that comes with npm and lets you *run* a package without permanently installing it.

Many AI coding tools (Claude Code, for example) are installed with `npm install -g` or launched with `npx`. You need **Node.js version 18 or higher** for most modern AI tools.

---

## Table of Contents

- [Minimum Version Requirements](#minimum-version-requirements)
- [macOS Installation](#macos-installation)
- [Linux Installation](#linux-installation)
- [Windows Installation](#windows-installation)
- [Verifying Your Installation](#verifying-your-installation)
- [Troubleshooting](#troubleshooting)

---

## Minimum Version Requirements

| Tool    | Minimum Version | Recommended    |
|---------|----------------|----------------|
| Node.js | 18.0.0         | 20 LTS or newer |
| npm     | 9.0.0          | 10+ (comes with Node 20) |
| npx     | 9.0.0          | 10+ (comes with npm)     |

> **Tip:** LTS stands for "Long-Term Support." LTS versions receive security patches for years and are the safest choice for most users. As of 2025, Node.js 20 LTS and Node.js 22 LTS are both excellent choices.

---

## macOS Installation

You have three good options on macOS. Pick whichever feels most comfortable.

### Option A: Homebrew (Recommended)

If you already have Homebrew installed (see [package-managers.md](package-managers.md)), this is the fastest path:

```bash
# Install the current LTS version of Node.js
brew install node@20
```

Homebrew installs Node.js, npm, and npx all at once. If you want the absolute latest version instead of LTS:

```bash
brew install node
```

To update later:

```bash
brew upgrade node
```

### Option B: Official Installer

1. Go to [https://nodejs.org](https://nodejs.org).
2. Download the **LTS** installer for macOS (the `.pkg` file).
3. Double-click the downloaded file and follow the prompts.
4. The installer adds `node`, `npm`, and `npx` to your PATH automatically.

> **Tip:** The official installer is fine for getting started, but it installs Node.js system-wide and makes it harder to switch between versions later. If you anticipate needing multiple Node versions, use nvm instead.

### Option C: nvm (Node Version Manager)

nvm lets you install multiple Node.js versions side by side and switch between them instantly. This is the most flexible approach.

**Step 1 -- Install nvm:**

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
```

**Step 2 -- Restart your terminal** (or source your profile):

```bash
source ~/.zshrc    # if you use zsh (default on modern macOS)
source ~/.bashrc   # if you use bash
```

**Step 3 -- Install Node.js:**

```bash
# Install the latest LTS version
nvm install --lts

# Or install a specific version
nvm install 20
```

**Step 4 -- Set a default version:**

```bash
nvm alias default 20
```

**Switching versions later:**

```bash
nvm use 20
nvm use 22
nvm ls          # see all installed versions
```

---

## Linux Installation

### Option A: nvm (Recommended)

nvm works the same way on Linux as it does on macOS and is the recommended approach because distro repositories often ship outdated Node.js versions.

```bash
# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

# Restart your terminal, then:
nvm install --lts
nvm alias default lts/*
```

### Option B: NodeSource Repository (Debian/Ubuntu)

NodeSource maintains up-to-date Node.js packages for Debian-based distributions:

```bash
# Download and run the NodeSource setup script for Node.js 20
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -

# Install Node.js (npm and npx come with it)
sudo apt-get install -y nodejs
```

> **Note:** The `sudo` commands require your user password. `sudo` lets you run commands as the system administrator.

### Option C: Default apt (Debian/Ubuntu)

The default repositories often have an older version. Check the version first:

```bash
sudo apt update
apt show nodejs | grep Version
```

If the version shown is 18 or higher, you can install it directly:

```bash
sudo apt install -y nodejs npm
```

If the version is below 18, use nvm or NodeSource instead.

### Option D: dnf (Fedora/RHEL)

```bash
# Fedora usually has a reasonably recent Node.js
sudo dnf install -y nodejs npm
node --version   # verify it's 18+
```

If the version is too old, use nvm.

### Option E: pacman (Arch Linux)

```bash
sudo pacman -S nodejs npm
```

Arch Linux typically ships very recent versions, so this is usually fine.

---

## Windows Installation

### Option A: Official Installer (Simplest)

1. Go to [https://nodejs.org](https://nodejs.org).
2. Download the **LTS** installer for Windows (the `.msi` file).
3. Run the installer. Accept the defaults.
   - Make sure the checkbox **"Add to PATH"** is checked (it is by default).
   - The installer optionally installs "Tools for Native Modules" (Chocolatey-based). You can skip this unless you know you need to compile native add-ons.
4. **Open a new terminal window** (the old one will not have the updated PATH).

### Option B: winget (Windows 10/11)

winget is Microsoft's built-in package manager on Windows 10 (version 1809+) and Windows 11:

```powershell
winget install OpenJS.NodeJS.LTS
```

Close and reopen your terminal after installation.

### Option C: Scoop

If you use Scoop (see [package-managers.md](package-managers.md)):

```powershell
scoop install nodejs-lts
```

To update later:

```powershell
scoop update nodejs-lts
```

### Option D: nvm-windows

nvm-windows is a version manager for Node.js on Windows, similar to nvm on macOS/Linux but built as a separate project.

**Step 1 -- Download the installer:**

Go to [https://github.com/coreybutler/nvm-windows/releases](https://github.com/coreybutler/nvm-windows/releases) and download the latest `nvm-setup.exe`.

**Step 2 -- Run the installer** and follow the prompts.

**Step 3 -- Open a new terminal** and install Node.js:

```powershell
nvm install 20
nvm use 20
```

**Step 4 -- Set the default:**

```powershell
nvm alias default 20
```

> **Important:** nvm-windows requires you to run your terminal **as Administrator** when running `nvm use` or `nvm install`. Right-click your terminal app and choose "Run as administrator."

---

## Verifying Your Installation

After installing Node.js using any method above, open a **new terminal window** and run:

```bash
node --version
```

You should see something like `v20.11.0` (the exact number will vary). The major version (the first number) must be **18 or higher**.

```bash
npm --version
```

You should see something like `10.2.4`.

```bash
npx --version
```

This should print the same version as npm.

### Quick Smoke Test

You can verify everything works end-to-end by running a one-liner:

```bash
node -e "console.log('Node.js is working! Version:', process.version)"
```

You should see:

```
Node.js is working! Version: v20.11.0
```

---

## Troubleshooting

### "command not found: node"

This means Node.js is either not installed or not on your PATH.

- **Did you open a new terminal?** PATH changes only take effect in new terminal windows.
- **Are you using nvm?** Run `nvm use default` to activate your default version.
- **On Windows:** Search for "Environment Variables" in the Start menu and verify that the Node.js installation directory appears in your `Path` variable.
- See [shell-setup.md](shell-setup.md) for a deeper explanation of how PATH works.

### "npm WARN old lockfile" or similar warnings

These warnings are usually harmless. They appear when a project was created with a different npm version. You can safely ignore them in most cases.

### "permission denied" errors on macOS/Linux

Never use `sudo` with `npm install -g` if you installed Node.js via nvm. If you installed Node.js via a system package manager and get permission errors, there are two fixes:

**Fix 1 -- Switch to nvm** (recommended). Uninstall the system Node.js and install via nvm as shown above. nvm installs everything in your home directory, so permissions are never an issue.

**Fix 2 -- Change npm's default directory:**

```bash
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'
```

Then add this to your shell profile file (see [shell-setup.md](shell-setup.md)):

```bash
export PATH="$HOME/.npm-global/bin:$PATH"
```

### Node.js version is too old

If `node --version` shows a version below 18:

- **nvm users:** `nvm install --lts && nvm alias default lts/*`
- **Homebrew users:** `brew upgrade node`
- **apt users:** Remove the old version (`sudo apt remove nodejs`) and install via NodeSource or nvm.
- **Windows users:** Download the latest LTS installer from [nodejs.org](https://nodejs.org) and run it. It will upgrade your existing installation.

---

*Next: Make sure your [shell is configured properly](shell-setup.md) so that newly installed tools appear in your PATH.*
