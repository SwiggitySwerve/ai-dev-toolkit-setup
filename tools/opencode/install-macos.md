# Installing OpenCode on macOS

This guide walks you through installing OpenCode on macOS. There are three installation methods -- pick whichever one suits your setup best. Homebrew is the recommended approach for most users.

## Prerequisites

Before you begin, make sure you have a terminal application open. You can use the built-in **Terminal.app** (found in Applications > Utilities) or a third-party terminal like iTerm2, Warp, or Kitty.

## Method 1: Homebrew (Recommended)

[Homebrew](https://brew.sh) is the most popular package manager for macOS. If you already have it installed, this is the fastest path.

### Step 1: Verify Homebrew is installed

```bash
brew --version
```

If this command fails, install Homebrew first by following the [Package Managers prerequisite guide](../../prerequisites/package-managers.md), or run:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Step 2: Add the OpenCode tap

A "tap" is a third-party repository of Homebrew packages. You need to add the OpenCode tap before installing:

```bash
brew tap opencode-ai/tap
```

### Step 3: Install OpenCode

```bash
brew install opencode-ai/tap/opencode
```

This downloads, compiles (if needed), and installs the `opencode` binary into your PATH.

### Step 4: Verify the installation

```bash
opencode --version
```

You should see a version number printed, for example `opencode v0.1.0`. If you see this, you are all set.

### Updating with Homebrew

To update OpenCode in the future:

```bash
brew update && brew upgrade opencode
```

---

## Method 2: Shell Install Script

OpenCode provides a one-line install script that detects your operating system and architecture automatically.

### Step 1: Run the install script

```bash
curl -fsSL https://opencode.ai/install | bash
```

This script will:
1. Detect your macOS version and CPU architecture (Intel or Apple Silicon)
2. Download the correct binary
3. Install it to a location on your PATH (typically `/usr/local/bin`)

### Step 2: Verify the installation

```bash
opencode --version
```

> **Note:** If the command is not found after installation, you may need to restart your terminal or source your shell profile:
> ```bash
> source ~/.zshrc
> ```

---

## Method 3: Go Install

If you have Go 1.23 or later installed, you can build OpenCode from source.

### Step 1: Verify Go is installed

```bash
go version
```

You need Go 1.23 or later. If Go is not installed, you can install it with Homebrew:

```bash
brew install go
```

### Step 2: Install OpenCode via Go

```bash
go install github.com/opencode-ai/opencode@latest
```

This compiles OpenCode from source and places the binary in your `$GOPATH/bin` directory (typically `~/go/bin`).

### Step 3: Ensure Go's bin directory is in your PATH

If `opencode` is not found after installation, add Go's bin directory to your PATH. Add this line to your `~/.zshrc` file:

```bash
export PATH="$HOME/go/bin:$PATH"
```

Then reload your shell configuration:

```bash
source ~/.zshrc
```

### Step 4: Verify the installation

```bash
opencode --version
```

---

## Troubleshooting

### "command not found: opencode"

This means the `opencode` binary is not in your PATH. Try these steps:

1. **Restart your terminal** -- Close and reopen your terminal application.
2. **Source your shell profile** -- Run `source ~/.zshrc` (or `source ~/.bashrc` if you use bash).
3. **Check where it was installed** -- Run `which opencode` or `where opencode` to see if the system can find it.
4. **Manually check common locations:**
   ```bash
   ls /usr/local/bin/opencode
   ls ~/go/bin/opencode
   ls /opt/homebrew/bin/opencode
   ```

### Permission denied

If you get a permission error during installation:

```bash
sudo curl -fsSL https://opencode.ai/install | sudo bash
```

Or for the Homebrew method, fix permissions on your Homebrew directory:

```bash
sudo chown -R $(whoami) /opt/homebrew
```

### Apple Silicon (M1/M2/M3/M4) specific issues

OpenCode provides native Apple Silicon binaries. If you experience issues, make sure you are not accidentally running the Intel version through Rosetta. Check your architecture:

```bash
uname -m
```

This should return `arm64` on Apple Silicon Macs.

---

## Next Steps

Now that OpenCode is installed, head to the [Configuration guide](configuration.md) to set up your AI provider and API keys.
