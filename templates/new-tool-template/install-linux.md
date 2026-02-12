# Installing [Tool Name] on Linux

## Prerequisites

- A supported Linux distribution (Ubuntu 20.04+, Debian 11+, Fedora 36+, Arch Linux)
- [List any other prerequisites, e.g., Node.js v18+, build-essential]

## Installation Methods

### Method 1: [Primary Method, e.g., npm]

```bash
# Installation command here
npm install -g [tool-package-name]
```

### Method 2: [Distribution Package Manager]

**Ubuntu / Debian:**
```bash
sudo apt update
sudo apt install [tool-name]
```

**Fedora:**
```bash
sudo dnf install [tool-name]
```

**Arch Linux:**
```bash
sudo pacman -S [tool-name]
```

### Method 3: [Manual / Direct Download]

1. Download the latest release:
   ```bash
   curl -fsSL https://[release-url]/[tool-name]-linux-x64.tar.gz -o [tool-name].tar.gz
   ```
2. Extract and install:
   ```bash
   tar -xzf [tool-name].tar.gz
   sudo mv [tool-name] /usr/local/bin/
   chmod +x /usr/local/bin/[tool-name]
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

Ensure `/usr/local/bin` is in your PATH. Add this to your `~/.bashrc` or `~/.zshrc`:

```bash
export PATH="/usr/local/bin:$PATH"
```

Then reload:
```bash
source ~/.bashrc
```

### Permission denied with npm global install

Option A -- Use sudo (quick fix):
```bash
sudo npm install -g [tool-package-name]
```

Option B -- Configure npm prefix (recommended):
```bash
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH="$HOME/.npm-global/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### GLIBC version errors

If you see errors about GLIBC version requirements, your distribution may be too old. Either upgrade your OS or use a containerized version:

```bash
docker run --rm -it [tool-docker-image] --version
```

### [Additional Common Issue]

[Describe the issue and provide a solution.]
