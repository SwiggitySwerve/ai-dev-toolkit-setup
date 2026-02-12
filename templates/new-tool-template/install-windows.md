# Installing [Tool Name] on Windows

## Prerequisites

- Windows 10 version 1903 or later (Windows 11 recommended)
- [List any other prerequisites, e.g., Node.js v18+]

## Installation Methods

### Method 1: [Primary Method, e.g., npm] (PowerShell)

Open PowerShell as Administrator and run:

```powershell
npm install -g [tool-package-name]
```

### Method 2: winget

```powershell
winget install [publisher].[tool-name]
```

### Method 3: Scoop

```powershell
scoop install [tool-name]
```

### Method 4: Manual Download

1. Download the latest release from the [releases page](https://[release-url]).
2. Extract the ZIP to a directory of your choice (e.g., `C:\Tools\[tool-name]`).
3. Add that directory to your system PATH:
   ```powershell
   # Add to user PATH permanently
   $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
   [Environment]::SetEnvironmentVariable("Path", "$currentPath;C:\Tools\[tool-name]", "User")
   ```
4. Restart your terminal.

## Verify Installation

**PowerShell:**
```powershell
[tool-name] --version
```

**Command Prompt (CMD):**
```cmd
[tool-name] --version
```

You should see output like:
```
[tool-name] v1.x.x
```

## Using with WSL (Windows Subsystem for Linux)

If you prefer a Linux environment on Windows, install inside WSL:

1. Open your WSL terminal (Ubuntu, Debian, etc.).
2. Follow the [Linux installation guide](install-linux.md).

To access [Tool Name] from both Windows and WSL, install it in both environments separately. They maintain independent configurations.

## Troubleshooting

### "'[tool-name]' is not recognized" after installation

The PATH may not have been updated in your current session. Try:

```powershell
# Refresh PATH in the current session
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
            [System.Environment]::GetEnvironmentVariable("Path", "User")
```

Or simply open a new terminal window.

### Execution policy prevents running scripts

If PowerShell blocks script execution:

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

### Permission errors during npm install

Run PowerShell as Administrator, or configure npm to use a user-writable directory:

```powershell
npm config set prefix "$env:APPDATA\npm"
```

Ensure `%APPDATA%\npm` is in your PATH.

### Windows Defender / antivirus blocks the tool

Some antivirus software may flag newly installed CLI tools. Add an exclusion for the tool's installation directory:

1. Open Windows Security.
2. Go to Virus & threat protection > Manage settings.
3. Scroll to Exclusions > Add or remove exclusions.
4. Add the tool's installation folder.

### [Additional Common Issue]

[Describe the issue and provide a solution.]
