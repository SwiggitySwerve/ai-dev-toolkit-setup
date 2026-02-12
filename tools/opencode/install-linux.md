# Installing OpenCode on Linux

This guide walks you through installing OpenCode on Linux. There are several methods available depending on your distribution and preference.

## Prerequisites

You need a terminal (you almost certainly already have one) and `curl` or `wget` installed for downloading. Most Linux distributions include these by default.

Check that `curl` is available:

```bash
curl --version
```

If `curl` is not installed, install it with your distribution's package manager:

```bash
# Debian/Ubuntu
sudo apt update && sudo apt install curl

# Fedora
sudo dnf install curl

# Arch Linux
sudo pacman -S curl
```

---

## Method 1: Shell Install Script (Recommended)

The install script is the fastest way to get OpenCode running on any Linux distribution. It automatically detects your architecture (x86_64 or ARM64) and installs the correct binary.

### Step 1: Run the install script

```bash
curl -fsSL https://opencode.ai/install | bash
```

This script will:
1. Detect your Linux distribution and CPU architecture
2. Download the appropriate binary
3. Install it to `/usr/local/bin` (or another location on your PATH)

### Step 2: Verify the installation

```bash
opencode --version
```

You should see a version number like `opencode v0.1.0`.

> **Note:** If the command is not found, restart your terminal or source your shell profile:
> ```bash
> source ~/.bashrc    # if you use bash
> source ~/.zshrc     # if you use zsh
> ```

### Updating

To update OpenCode, simply run the install script again:

```bash
curl -fsSL https://opencode.ai/install | bash
```

It will replace the existing binary with the latest version.

---

## Method 2: Go Install

If you have Go 1.23 or later installed, you can compile OpenCode from source.

### Step 1: Verify Go is installed

```bash
go version
```

You need Go 1.23 or later. If Go is not installed, you can install it:

```bash
# Debian/Ubuntu
sudo apt update && sudo apt install golang-go

# Fedora
sudo dnf install golang

# Arch Linux
sudo pacman -S go

# Or download directly from https://go.dev/dl/
```

> **Important:** Distribution package managers sometimes ship older versions of Go. If your distribution's Go is older than 1.23, download the latest version directly from [go.dev](https://go.dev/dl/).

### Step 2: Install OpenCode

```bash
go install github.com/opencode-ai/opencode@latest
```

This compiles OpenCode and places the binary in `$GOPATH/bin` (typically `~/go/bin`).

### Step 3: Add Go's bin directory to your PATH

If `opencode` is not found after installation, add Go's bin directory to your PATH. Add this line to your shell configuration file (`~/.bashrc`, `~/.zshrc`, or `~/.profile`):

```bash
export PATH="$HOME/go/bin:$PATH"
```

Then reload:

```bash
source ~/.bashrc
```

### Step 4: Verify the installation

```bash
opencode --version
```

---

## Method 3: Download the Binary Manually

You can download pre-built binaries directly from the GitHub releases page.

### Step 1: Go to the releases page

Visit [https://github.com/opencode-ai/opencode/releases](https://github.com/opencode-ai/opencode/releases) and find the latest release.

### Step 2: Download the correct binary for your architecture

```bash
# For x86_64 (most common)
curl -L -o opencode https://github.com/opencode-ai/opencode/releases/latest/download/opencode_linux_amd64

# For ARM64 (Raspberry Pi 4/5, AWS Graviton, etc.)
curl -L -o opencode https://github.com/opencode-ai/opencode/releases/latest/download/opencode_linux_arm64
```

Check your architecture if you are unsure:

```bash
uname -m
# x86_64 = use amd64 binary
# aarch64 = use arm64 binary
```

### Step 3: Make the binary executable

```bash
chmod +x opencode
```

### Step 4: Move it to a directory on your PATH

```bash
sudo mv opencode /usr/local/bin/
```

### Step 5: Verify the installation

```bash
opencode --version
```

---

## Method 4: Package Managers (Distribution-Specific)

Some Linux distributions may have OpenCode available in their package repositories or community repositories.

### Arch Linux (AUR)

If an AUR package is available:

```bash
# Using yay
yay -S opencode

# Using paru
paru -S opencode
```

### Nix

If you use the Nix package manager:

```bash
nix-shell -p opencode
```

Or add it to your system configuration.

> **Note:** Package manager availability varies and packages may lag behind the latest release. Check the [GitHub releases page](https://github.com/opencode-ai/opencode/releases) for the most recent version.

---

## Troubleshooting

### "command not found: opencode"

The binary is not in your PATH. Try these steps:

1. **Restart your terminal** -- Close and reopen your terminal emulator.
2. **Source your shell profile:**
   ```bash
   source ~/.bashrc    # bash users
   source ~/.zshrc     # zsh users
   ```
3. **Check if the binary exists:**
   ```bash
   ls -la /usr/local/bin/opencode
   ls -la ~/go/bin/opencode
   ```
4. **Verify your PATH includes the right directories:**
   ```bash
   echo $PATH
   ```

### Permission denied during installation

If the install script fails with permission errors:

```bash
curl -fsSL https://opencode.ai/install | sudo bash
```

Or if you downloaded the binary manually:

```bash
sudo chmod +x /usr/local/bin/opencode
```

### GLIBC version errors

If you see errors about GLIBC version requirements, your Linux distribution may be too old. Options:

1. **Update your distribution** to a newer release
2. **Use the Go install method** to compile from source (this avoids pre-built binary compatibility issues)
3. **Use a container** to run OpenCode in a newer environment

### Terminal rendering issues

If the TUI does not render correctly:

1. Make sure your terminal emulator supports **256 colors** or **true color**. Most modern terminals do.
2. Try setting the TERM environment variable:
   ```bash
   export TERM=xterm-256color
   ```
3. Consider using a modern terminal like Kitty, Alacritty, WezTerm, or Ghostty.

---

## Next Steps

Now that OpenCode is installed, head to the [Configuration guide](configuration.md) to set up your AI provider and API keys.
