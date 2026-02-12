# Installing Claude Code on Linux

## Prerequisites

Claude Code requires **Node.js version 18 or later**. Check your current version:

```bash
node --version
```

If Node.js is not installed or is below version 18, follow the instructions for your distribution below.

---

## Installing Node.js

### Option A: Using nvm (Recommended -- All Distributions)

nvm (Node Version Manager) is the most reliable way to install and manage Node.js on Linux. It installs into your home directory, avoiding permission issues entirely.

```bash
# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

# Restart your terminal or source your profile
source ~/.bashrc   # or ~/.zshrc if using zsh

# Install Node.js 20 (LTS)
nvm install 20
nvm use 20
nvm alias default 20

# Verify
node --version
```

### Option B: Ubuntu / Debian

```bash
# Update package index
sudo apt update

# Install Node.js from NodeSource (recommended for up-to-date versions)
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# Verify
node --version
npm --version
```

Alternatively, the default Ubuntu/Debian repos may have Node.js, but it is often outdated:

```bash
# NOT recommended -- may install Node.js 12 or 16
sudo apt install nodejs npm
```

> **Warning**: The default `nodejs` package in many Ubuntu/Debian releases ships a version older than 18. Always verify with `node --version` after installation. Use NodeSource or nvm if the system version is too old.

### Option C: Fedora

```bash
# Fedora typically ships a recent Node.js
sudo dnf install nodejs npm

# Verify version is 18+
node --version
```

If the version is too old, use nvm (Option A) or install from NodeSource:

```bash
curl -fsSL https://rpm.nodesource.com/setup_20.x | sudo bash -
sudo dnf install -y nodejs
```

### Option D: Arch Linux

```bash
sudo pacman -S nodejs npm

# Verify
node --version
```

Arch Linux typically ships a recent version of Node.js, so this is usually sufficient.

---

## Install Claude Code

Once Node.js 18+ is available:

```bash
npm install -g @anthropic-ai/claude-code
```

## Verify Installation

```bash
claude --version
```

You should see the installed version number printed to the terminal.

## First Run

```bash
claude
```

This will start the authentication flow. See [Configuration and Authentication](configuration.md) for details.

---

## Troubleshooting

### "command not found: claude"

The npm global bin directory is not in your PATH. Find and add it:

```bash
# Find where npm installs global binaries
npm config get prefix
# Typically: /usr/local or ~/.nvm/versions/node/v20.x.x

# Add the bin subdirectory to your PATH
# For bash:
echo 'export PATH="$(npm config get prefix)/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# For zsh:
echo 'export PATH="$(npm config get prefix)/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### Permission Errors (EACCES)

If you get `EACCES: permission denied` errors during installation:

**Best fix: Use nvm**

nvm installs everything in your home directory, so no `sudo` is needed. See Option A above.

**Alternative: Change npm's default directory**

```bash
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'

# Add to your shell profile
echo 'export PATH="$HOME/.npm-global/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Reinstall
npm install -g @anthropic-ai/claude-code
```

**Last resort: sudo**

```bash
sudo npm install -g @anthropic-ai/claude-code
```

> **Warning**: Using `sudo` with npm can create root-owned files in your home directory and cause ongoing permission problems. nvm or changing the npm prefix is strongly preferred.

### Missing Build Tools

Some npm packages require native compilation. If you see errors about `node-gyp`, `make`, or `gcc`:

**Ubuntu / Debian:**

```bash
sudo apt install build-essential
```

**Fedora:**

```bash
sudo dnf groupinstall "Development Tools"
```

**Arch:**

```bash
sudo pacman -S base-devel
```

### Node.js Version Too Old

```bash
# Check version
node --version

# If using nvm:
nvm install 20
nvm use 20
nvm alias default 20

# Reinstall Claude Code
npm install -g @anthropic-ai/claude-code
```

### Headless Servers / SSH Sessions

Claude Code works in SSH sessions and headless environments. For the authentication flow, you may need to copy a URL from the terminal and open it in a browser on another machine. Alternatively, set the `ANTHROPIC_API_KEY` environment variable to skip the browser-based OAuth flow:

```bash
export ANTHROPIC_API_KEY="sk-ant-..."
claude
```

See [Configuration](configuration.md) for more details on API key authentication.

---

## Updating Claude Code

```bash
npm update -g @anthropic-ai/claude-code
```

## Uninstalling

```bash
npm uninstall -g @anthropic-ai/claude-code
```

## Next Steps

- [Configuration and Authentication](configuration.md)
- [Getting Started](getting-started.md)
