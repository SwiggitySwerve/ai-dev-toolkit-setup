# Installing Claude Code on macOS

## Prerequisites

Claude Code requires **Node.js version 18 or later**. Check your current version:

```bash
node --version
```

If you do not have Node.js installed or need to upgrade, choose one of these methods:

### Option A: Install Node.js via Homebrew (Recommended)

```bash
brew install node
```

### Option B: Install Node.js via nvm (Node Version Manager)

```bash
# Install nvm if you don't have it
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

# Restart your terminal, then install Node.js
nvm install 20
nvm use 20
```

### Option C: Download from nodejs.org

Download the macOS installer from [https://nodejs.org](https://nodejs.org) and follow the installation wizard.

## Install Claude Code

Once Node.js 18+ is available, install Claude Code globally via npm:

```bash
npm install -g @anthropic-ai/claude-code
```

This installs the `claude` command globally so it is available from any directory.

## Verify Installation

```bash
claude --version
```

You should see output showing the installed version number. If the command is recognized and prints a version, the installation was successful.

## First Run

To start Claude Code for the first time:

```bash
claude
```

This will initiate the authentication flow. See [Configuration and Authentication](configuration.md) for details.

## Troubleshooting

### "command not found: claude"

This means the npm global bin directory is not in your PATH. Fix it by finding where npm installs global packages and adding that to your PATH:

```bash
# Find the npm global bin directory
npm config get prefix
```

This typically returns `/usr/local` (system Node.js) or something like `/Users/yourname/.nvm/versions/node/v20.x.x` (nvm). The `bin` subdirectory of that prefix needs to be in your PATH.

```bash
# Add to your shell profile (~/.zshrc for macOS Catalina and later)
echo 'export PATH="$(npm config get prefix)/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

> **Note**: macOS Catalina (10.15) and later use zsh as the default shell. If you use bash, edit `~/.bash_profile` instead.

### Permission Errors (EACCES)

If you see errors like `EACCES: permission denied` during installation, **do not use `sudo npm install -g`** as a first resort. Instead, fix npm's permissions:

**Method 1: Use nvm (Best Solution)**

nvm installs Node.js into your home directory, avoiding system-level permission issues entirely. See the nvm installation instructions above.

**Method 2: Change npm's default directory**

```bash
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH="~/.npm-global/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# Now install again
npm install -g @anthropic-ai/claude-code
```

**Method 3: Use sudo (Last Resort)**

```bash
sudo npm install -g @anthropic-ai/claude-code
```

> **Warning**: Using `sudo` with npm can cause ownership issues with your global packages directory. Methods 1 and 2 are preferred.

### Node.js Version Too Old

If you get errors about unsupported Node.js versions:

```bash
# Check your version
node --version

# If using nvm, switch to a newer version
nvm install 20
nvm use 20
nvm alias default 20

# Then reinstall
npm install -g @anthropic-ai/claude-code
```

### Apple Silicon (M1/M2/M3/M4) Notes

Claude Code works natively on Apple Silicon Macs. No special steps are required. Ensure you are using an ARM-native build of Node.js for best performance:

```bash
# Verify architecture
node -p "process.arch"
# Should output: arm64
```

If it outputs `x64`, you are running Node.js under Rosetta 2. Consider reinstalling Node.js natively via Homebrew or nvm for better performance.

## Updating Claude Code

To update to the latest version:

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
