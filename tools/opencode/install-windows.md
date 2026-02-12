# Installing OpenCode on Windows

This guide covers installing OpenCode on Windows. There are several approaches depending on your setup. If you use WSL (Windows Subsystem for Linux), you can also follow the [Linux installation guide](install-linux.md) inside your WSL environment.

## Prerequisites

You need a terminal application. Recommended options:

- **Windows Terminal** (recommended) -- Available from the Microsoft Store or pre-installed on Windows 11
- **PowerShell** -- Built into Windows
- **Command Prompt** -- Built into Windows (basic but functional)

---

## Method 1: Scoop (Recommended)

[Scoop](https://scoop.sh) is a command-line package manager for Windows that installs programs cleanly without requiring admin privileges.

### Step 1: Verify Scoop is installed

```powershell
scoop --version
```

If Scoop is not installed, install it first. Open PowerShell and run:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
```

For more details, see the [Package Managers prerequisite guide](../../prerequisites/package-managers.md).

### Step 2: Install OpenCode

```powershell
scoop install opencode
```

> **Note:** If OpenCode is not in the default Scoop bucket, you may need to add an extras bucket or install from a specific bucket:
> ```powershell
> scoop bucket add extras
> scoop install opencode
> ```

### Step 3: Verify the installation

```powershell
opencode --version
```

You should see a version number like `opencode v0.1.0`.

### Updating with Scoop

```powershell
scoop update opencode
```

---

## Method 2: PowerShell Install Script

OpenCode provides an install script that works on Windows via PowerShell.

### Step 1: Run the install script

Open PowerShell and run:

```powershell
irm https://opencode.ai/install.ps1 | iex
```

This script will:
1. Detect your Windows version and CPU architecture
2. Download the correct binary
3. Place it in a directory on your PATH

### Step 2: Restart your terminal

Close and reopen your terminal to pick up the PATH changes.

### Step 3: Verify the installation

```powershell
opencode --version
```

---

## Method 3: Go Install

If you have Go 1.23 or later installed, you can compile OpenCode from source.

### Step 1: Verify Go is installed

```powershell
go version
```

You need Go 1.23 or later. If Go is not installed, install it:

```powershell
# Via Scoop
scoop install go

# Or via winget
winget install GoLang.Go
```

Alternatively, download the installer from [go.dev/dl](https://go.dev/dl/).

### Step 2: Install OpenCode

```powershell
go install github.com/opencode-ai/opencode@latest
```

This compiles OpenCode and places the binary in your Go bin directory (typically `%USERPROFILE%\go\bin`).

### Step 3: Add Go's bin directory to your PATH (if needed)

If `opencode` is not found after installation, add Go's bin directory to your PATH:

1. Press **Win + R**, type `sysdm.cpl`, and press Enter
2. Go to the **Advanced** tab and click **Environment Variables**
3. Under **User variables**, find `Path` and click **Edit**
4. Click **New** and add: `%USERPROFILE%\go\bin`
5. Click **OK** on all dialogs

Or do it from PowerShell:

```powershell
$gobin = "$env:USERPROFILE\go\bin"
[Environment]::SetEnvironmentVariable("Path", "$([Environment]::GetEnvironmentVariable('Path', 'User'));$gobin", "User")
```

Then restart your terminal.

### Step 4: Verify the installation

```powershell
opencode --version
```

---

## Method 4: Download the Binary Manually

You can download a pre-built binary directly from GitHub.

### Step 1: Download the binary

Visit [https://github.com/opencode-ai/opencode/releases](https://github.com/opencode-ai/opencode/releases) and download the Windows binary (look for a file like `opencode_windows_amd64.exe`).

Or use PowerShell to download it:

```powershell
# For x86_64 (most Windows PCs)
Invoke-WebRequest -Uri "https://github.com/opencode-ai/opencode/releases/latest/download/opencode_windows_amd64.exe" -OutFile "opencode.exe"
```

### Step 2: Move the binary to a directory on your PATH

Create a directory for CLI tools if you do not already have one:

```powershell
mkdir "$env:USERPROFILE\bin" -ErrorAction SilentlyContinue
Move-Item opencode.exe "$env:USERPROFILE\bin\opencode.exe"
```

Add this directory to your PATH (if it is not already there):

```powershell
$bindir = "$env:USERPROFILE\bin"
[Environment]::SetEnvironmentVariable("Path", "$([Environment]::GetEnvironmentVariable('Path', 'User'));$bindir", "User")
```

### Step 3: Restart your terminal and verify

```powershell
opencode --version
```

---

## Method 5: WSL (Windows Subsystem for Linux)

If you prefer running OpenCode inside a Linux environment on Windows, WSL is an excellent option. The TUI tends to render more reliably in WSL terminals.

### Step 1: Install WSL (if not already set up)

```powershell
wsl --install
```

This installs WSL with Ubuntu by default. Restart your computer when prompted.

### Step 2: Open your WSL terminal

```powershell
wsl
```

### Step 3: Follow the Linux installation guide

Once inside WSL, follow the [Linux installation guide](install-linux.md). The recommended method:

```bash
curl -fsSL https://opencode.ai/install | bash
```

### Step 4: Verify

```bash
opencode --version
```

> **Tip:** WSL gives you a full Linux environment, so all Linux-specific instructions in this toolkit apply directly.

---

## Troubleshooting

### "opencode is not recognized as an internal or external command"

The binary is not in your PATH. Try these steps:

1. **Restart your terminal** -- Close and reopen Windows Terminal or PowerShell.
2. **Check if the binary exists:**
   ```powershell
   Test-Path "$env:USERPROFILE\go\bin\opencode.exe"
   Test-Path "$env:USERPROFILE\scoop\shims\opencode.exe"
   ```
3. **Verify your PATH:**
   ```powershell
   $env:Path -split ';'
   ```
   Look for the directory containing `opencode.exe` in the output.

### PowerShell execution policy errors

If you see errors about scripts being disabled:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Windows Defender SmartScreen warning

When running a downloaded binary, Windows may show a SmartScreen warning. Click **More info** and then **Run anyway**. This is normal for binaries that have not been digitally signed with an EV code signing certificate.

### TUI rendering issues

If the terminal interface does not look right:

1. **Use Windows Terminal** -- It has the best support for modern terminal features. The classic Command Prompt and older PowerShell windows may not render the TUI correctly.
2. **Enable virtual terminal processing** if you must use the legacy console:
   ```powershell
   [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
   ```
3. **Try a Nerd Font** -- Install a font like "FiraCode Nerd Font" or "JetBrainsMono Nerd Font" for proper icon rendering. You can install Nerd Fonts via Scoop:
   ```powershell
   scoop bucket add nerd-fonts
   scoop install JetBrainsMono-NF
   ```
   Then set it as your terminal font in Windows Terminal settings.

### Antivirus interference

Some antivirus software may flag or quarantine the OpenCode binary. If installation succeeds but the command is not found, check your antivirus quarantine. You may need to add an exception for the binary.

---

## Next Steps

Now that OpenCode is installed, head to the [Configuration guide](configuration.md) to set up your AI provider and API keys.
