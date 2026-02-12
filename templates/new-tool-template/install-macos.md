# Installing [Tool Name] on macOS

## Prerequisites

- macOS 12 (Monterey) or later
- [List any other prerequisites, e.g., Node.js v18+, Xcode Command Line Tools]

## Installation Methods

### Method 1: [Primary Method, e.g., Homebrew]

```bash
# Installation command here
brew install [tool-name]
```

### Method 2: [Alternative, e.g., npm]

```bash
# Alternative installation command
npm install -g [tool-package-name]
```

### Method 3: [Manual / Direct Download]

1. Download the latest release from [release page URL].
2. Extract the archive:
   ```bash
   tar -xzf [tool-name]-macos.tar.gz
   ```
3. Move the binary to your PATH:
   ```bash
   sudo mv [tool-name] /usr/local/bin/
   ```

## Verify Installation

```bash
[tool-name] --version
```

You should see output like:
```
[tool-name] v1.x.x
```

## Troubleshooting

### "command not found" after installation

Ensure your PATH includes the installation directory. Add the following to your shell config (`~/.zshrc` or `~/.bash_profile`):

```bash
export PATH="/usr/local/bin:$PATH"
```

Then reload your shell:
```bash
source ~/.zshrc
```

### Permission denied during installation

If you see permission errors with npm global installs, configure npm to use a user-writable directory:

```bash
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH="$HOME/.npm-global/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### [Additional Common Issue]

[Describe the issue and provide a solution.]
