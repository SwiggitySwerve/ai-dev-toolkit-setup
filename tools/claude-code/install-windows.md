# Installing Claude Code on Windows

Claude Code runs on Windows through multiple methods. This guide covers all of them, from the simplest native approach to the recommended WSL setup for the best experience.

---

## Method 1: Native Windows (PowerShell / CMD)

This is the simplest method -- install and run directly on Windows.

### Step 1: Install Node.js 18+

Download the Windows installer from [https://nodejs.org](https://nodejs.org) (LTS version recommended) and run it. The installer adds `node` and `npm` to your PATH automatically.

Alternatively, use a package manager:

**Using winget:**

```powershell
winget install OpenJS.NodeJS.LTS
```

**Using Chocolatey:**

```powershell
choco install nodejs-lts
```

**Using Scoop:**

```powershell
scoop install nodejs-lts
```

After installation, restart your terminal and verify:

```powershell
node --version
npm --version
```

### Step 2: Install Claude Code

```powershell
npm install -g @anthropic-ai/claude-code
```

### Step 3: Verify

```powershell
claude --version
```

### Troubleshooting: Execution Policy

If PowerShell blocks script execution with an error like `running scripts is disabled on this system`:

```powershell
# Check current policy
Get-ExecutionPolicy

# Set it to allow local scripts (requires admin PowerShell)
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

> **Note**: `RemoteSigned` allows locally-created scripts to run but requires downloaded scripts to be signed. This is a safe default for development machines.

### Troubleshooting: "claude is not recognized"

If `claude` is not found after installation, the npm global bin directory may not be in your PATH.

```powershell
# Find the npm global prefix
npm config get prefix

# The output will be something like:
# C:\Users\YourName\AppData\Roaming\npm
```

Add that directory to your PATH:

1. Press `Win + R`, type `sysdm.cpl`, press Enter.
2. Go to **Advanced** > **Environment Variables**.
3. Under **User variables**, select `Path` and click **Edit**.
4. Click **New** and paste the npm prefix directory (e.g., `C:\Users\YourName\AppData\Roaming\npm`).
5. Click **OK** on all dialogs and restart your terminal.

Alternatively, via PowerShell:

```powershell
# Add to user PATH for the current session
$env:Path += ";$(npm config get prefix)"

# To make it permanent, add to your PowerShell profile
Add-Content $PROFILE "`n`$env:Path += `";$(npm config get prefix)`""
```

---

## Method 2: Git Bash

If you have [Git for Windows](https://gitforwindows.org/) installed, you already have Git Bash, which provides a Unix-like terminal experience.

### Step 1: Install Node.js

Install Node.js using any method from Method 1 above. Git Bash inherits the Windows PATH, so `node` and `npm` will be available.

### Step 2: Install Claude Code

Open Git Bash and run:

```bash
npm install -g @anthropic-ai/claude-code
```

### Step 3: Verify

```bash
claude --version
```

Git Bash works well with Claude Code and provides familiar Unix commands (`ls`, `grep`, `cat`, etc.) alongside Windows paths.

---

## Method 3: WSL (Windows Subsystem for Linux) -- Recommended

WSL provides the best Claude Code experience on Windows. It runs a full Linux environment, which means all Unix tools work natively, file permissions behave correctly, and you avoid Windows-specific path and shell issues.

### Step 1: Install WSL

Open PowerShell as Administrator:

```powershell
wsl --install
```

This installs WSL 2 with Ubuntu by default. Restart your computer when prompted.

After restart, Ubuntu will open automatically to complete setup. Create a username and password when prompted.

> **Tip**: If you already have WSL installed, you can check your distributions with `wsl --list --verbose`.

### Step 2: Install Node.js Inside WSL

Open your WSL terminal (search for "Ubuntu" in the Start menu or type `wsl` in a terminal):

```bash
# Install nvm (recommended)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
source ~/.bashrc

# Install Node.js
nvm install 20
nvm use 20
nvm alias default 20

# Verify
node --version
```

### Step 3: Install Claude Code

```bash
npm install -g @anthropic-ai/claude-code
```

### Step 4: Verify

```bash
claude --version
```

### Accessing Windows Files from WSL

Your Windows drives are mounted under `/mnt/`:

```bash
# Access your Windows projects
cd /mnt/c/Users/YourName/Projects

# Run Claude Code there
claude
```

### Accessing WSL Files from Windows

From Windows Explorer, type `\\wsl$` in the address bar to browse your WSL filesystem. Or from PowerShell:

```powershell
explorer.exe \\wsl$\Ubuntu\home\yourusername
```

> **Tip**: For best performance, keep your project files inside the WSL filesystem (e.g., `~/projects/`) rather than on the mounted Windows drives (`/mnt/c/`). File operations on mounted Windows drives are significantly slower due to the filesystem translation layer.

---

## Common Windows Issues

### Long Path Support

Some npm packages create deeply nested `node_modules` directories that exceed the Windows 260-character path limit. Enable long paths:

1. Open **Group Policy Editor** (`gpedit.msc`).
2. Navigate to: **Computer Configuration** > **Administrative Templates** > **System** > **Filesystem**.
3. Enable **Enable Win32 long paths**.

Or via Registry:

```powershell
# Run as Administrator
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "LongPathsEnabled" -Value 1 -PropertyType DWORD -Force
```

### Line Ending Issues (CRLF vs LF)

Windows uses CRLF (`\r\n`) line endings while Unix uses LF (`\n`). This can cause issues with git and scripts. Configure git to handle this:

```bash
git config --global core.autocrlf input
```

### Antivirus / Defender Slowdowns

Windows Defender can slow down npm installations significantly because it scans every file. Add exclusions for Node.js and npm directories:

1. Open **Windows Security** > **Virus & threat protection** > **Manage settings**.
2. Scroll to **Exclusions** > **Add or remove exclusions**.
3. Add your Node.js install directory (e.g., `C:\Program Files\nodejs\`).
4. Add your npm global directory (e.g., `C:\Users\YourName\AppData\Roaming\npm\`).
5. Add your project directories.

### Terminal Recommendations

For the best experience on Windows, consider using **Windows Terminal** (available from the Microsoft Store). It supports tabs, split panes, and handles both PowerShell and WSL terminals in one window.

---

## Updating Claude Code

**Native Windows / Git Bash:**

```powershell
npm update -g @anthropic-ai/claude-code
```

**WSL:**

```bash
npm update -g @anthropic-ai/claude-code
```

## Uninstalling

```powershell
npm uninstall -g @anthropic-ai/claude-code
```

## Next Steps

- [Configuration and Authentication](configuration.md)
- [Getting Started](getting-started.md)
