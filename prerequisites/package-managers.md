# Package Manager Installation Guide

A **package manager** is a program that installs, updates, and removes other programs. Think of it like an app store for your terminal. Instead of visiting a website, downloading an installer, and clicking through a wizard, you type one command and the package manager handles everything -- downloading, extracting, putting files in the right place, and adding them to your PATH.

---

## Table of Contents

- [Why Package Managers Matter for AI Tool Installation](#why-package-managers-matter-for-ai-tool-installation)
- [macOS: Homebrew](#macos-homebrew)
- [Windows: Scoop, Chocolatey, and winget](#windows-scoop-chocolatey-and-winget)
- [Linux: apt, dnf, pacman](#linux-apt-dnf-pacman)
- [Summary Table](#summary-table)

---

## Why Package Managers Matter for AI Tool Installation

AI coding tools like Claude Code, GitHub Copilot CLI, Aider, and Continue often depend on other software -- Node.js, Python, Git, and more. Package managers solve several problems at once:

1. **One-command installs.** Instead of hunting for download links, you run something like `brew install node` and you are done.
2. **Automatic PATH management.** Package managers put binaries in directories that are already on your PATH, so new tools are immediately available in your terminal.
3. **Easy updates.** A single command (`brew upgrade`, `scoop update *`, `sudo apt upgrade`) brings everything up to date.
4. **Dependency resolution.** If tool A needs library B, the package manager installs both automatically.
5. **Clean uninstalls.** Removing a package removes all of its files, unlike manually installed software that leaves fragments behind.

The installation guides for many AI tools assume you have a package manager available. Setting one up now means those instructions will "just work."

---

## macOS: Homebrew

### What Is Homebrew?

[Homebrew](https://brew.sh) is the de facto standard package manager for macOS. Nearly every developer tool installation guide for macOS starts with "install it with Homebrew." If you use a Mac for development, you should install Homebrew.

### Installing Homebrew

**Step 1 -- Open Terminal.**

Press `Cmd + Space`, type "Terminal", and press Enter. Or find Terminal in `Applications > Utilities`.

**Step 2 -- Run the install command:**

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

The script will explain what it plans to do and ask for your password. Your password is the one you use to log in to your Mac.

**Step 3 -- Follow the post-install instructions.**

On Apple Silicon Macs (M1, M2, M3, M4), Homebrew installs to `/opt/homebrew` and prints instructions to add it to your PATH. The output will look something like this:

```
==> Next steps:
- Run these commands in your terminal to add Homebrew to your PATH:
    echo >> ~/.zprofile
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
```

**Copy and paste those exact commands.** They add Homebrew to your shell profile so it is available every time you open a terminal. (See [shell-setup.md](shell-setup.md) for more on what this means.)

On Intel Macs, Homebrew installs to `/usr/local` and usually does not require PATH changes.

**Step 4 -- Verify:**

```bash
brew --version
```

You should see something like `Homebrew 4.x.x`.

### Common Homebrew Commands

```bash
brew install <package>     # Install a package
brew uninstall <package>   # Remove a package
brew upgrade               # Update all installed packages
brew update                # Update Homebrew itself
brew list                  # Show all installed packages
brew search <name>         # Search for a package
brew info <package>        # Show info about a package
```

### Example: Installing Node.js with Homebrew

```bash
brew install node@20
```

That single command installs Node.js, npm, and npx.

---

## Windows: Scoop, Chocolatey, and winget

Windows has three major package managers. Here is when to use each one.

### Quick Comparison

| Feature           | winget                     | Scoop                      | Chocolatey                     |
|-------------------|----------------------------|----------------------------|--------------------------------|
| Built in?         | Yes (Win 10/11)            | No (easy install)          | No (easy install)              |
| Admin required?   | Sometimes                  | No                         | Yes (usually)                  |
| Install location  | Program Files (system)     | User's home directory      | Program Files (system)         |
| Best for          | Mainstream apps            | Dev tools, portable apps   | Enterprise, system-wide tools  |
| Package count     | Large and growing          | Moderate                   | Very large                     |

**Our recommendation:** Use **winget** for mainstream applications. Use **Scoop** for developer tools and anything you want installed without admin privileges. Use **Chocolatey** if your workplace already uses it or if a package is only available there.

---

### winget (Windows Package Manager)

#### What Is winget?

winget is Microsoft's official package manager. It ships pre-installed on Windows 11 and on Windows 10 (version 1809 and later, via the App Installer package from the Microsoft Store).

#### Checking If winget Is Available

Open PowerShell or Windows Terminal and run:

```powershell
winget --version
```

If you see a version number, you are good to go. If not, install "App Installer" from the Microsoft Store.

#### Using winget

```powershell
winget install OpenJS.NodeJS.LTS      # Install Node.js LTS
winget install Git.Git                 # Install Git
winget upgrade --all                   # Update all packages
winget search <name>                   # Search for a package
winget list                            # List installed packages
winget uninstall <package>             # Remove a package
```

> **Tip:** After installing something with winget, you usually need to **close and reopen your terminal** for the new command to be recognized.

---

### Scoop

#### What Is Scoop?

[Scoop](https://scoop.sh) installs programs into your user directory (`~\scoop`), meaning you never need admin privileges. It is particularly popular for developer tools because it manages PATH entries cleanly and keeps everything self-contained.

#### Installing Scoop

Open PowerShell (does not need to be admin) and run:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex
```

The first command allows PowerShell to run the install script. The second downloads and runs the Scoop installer.

#### Verify:

```powershell
scoop --version
```

#### Adding Buckets

Scoop organizes packages into "buckets." The default `main` bucket has many tools, but you may want `extras` for additional software:

```powershell
scoop bucket add extras
```

#### Common Scoop Commands

```powershell
scoop install <package>     # Install a package
scoop uninstall <package>   # Remove a package
scoop update *              # Update all packages
scoop update                # Update Scoop itself
scoop search <name>         # Search for a package
scoop list                  # List installed packages
```

#### Example: Installing Node.js with Scoop

```powershell
scoop install nodejs-lts
```

---

### Chocolatey

#### What Is Chocolatey?

[Chocolatey](https://chocolatey.org) is the oldest and largest Windows package manager. It installs software system-wide (usually into `C:\ProgramData\chocolatey`) and typically requires an **Administrator** terminal.

#### Installing Chocolatey

**Step 1 -- Open PowerShell as Administrator.**

Right-click the Start menu, choose "Windows Terminal (Admin)" or "PowerShell (Admin)".

**Step 2 -- Run the install command:**

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

**Step 3 -- Verify:**

```powershell
choco --version
```

#### Common Chocolatey Commands

All of these need an Administrator terminal:

```powershell
choco install <package> -y    # Install a package (-y auto-confirms)
choco uninstall <package>     # Remove a package
choco upgrade all -y          # Update all packages
choco search <name>           # Search for a package
choco list                    # List installed packages
```

#### Example: Installing Node.js with Chocolatey

```powershell
choco install nodejs-lts -y
```

---

## Linux: apt, dnf, pacman

On Linux, your package manager is determined by your distribution and is usually pre-installed. You rarely need to install the package manager itself.

### apt (Debian, Ubuntu, Linux Mint, Pop!_OS)

apt (Advanced Package Tool) is the default on Debian-based distributions.

```bash
sudo apt update                  # Refresh the package index
sudo apt install <package>       # Install a package
sudo apt remove <package>        # Remove a package
sudo apt upgrade                 # Upgrade all installed packages
apt search <name>                # Search for a package
apt list --installed             # List installed packages
```

> **What does `sudo` mean?** `sudo` stands for "superuser do." It runs a command with administrator privileges. Your system will prompt you for your user password.

#### Adding Third-Party Repositories

Some tools are not in the default Ubuntu/Debian repositories, or the version there is outdated. You can add third-party repositories. For example, to add the NodeSource repository for Node.js:

```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
```

---

### dnf (Fedora, RHEL 8+, CentOS Stream, Rocky Linux, AlmaLinux)

dnf (Dandified YUM) is the default on Fedora and modern Red Hat-based distributions.

```bash
sudo dnf install <package>       # Install a package
sudo dnf remove <package>        # Remove a package
sudo dnf upgrade                 # Upgrade all installed packages
dnf search <name>                # Search for a package
dnf list installed               # List installed packages
```

---

### pacman (Arch Linux, Manjaro, EndeavourOS)

pacman is the default on Arch-based distributions. Arch tends to have the most up-to-date packages of any distribution.

```bash
sudo pacman -Syu                 # Update package database and upgrade all packages
sudo pacman -S <package>         # Install a package
sudo pacman -R <package>         # Remove a package
pacman -Ss <name>                # Search for a package
pacman -Q                        # List installed packages
```

> **Tip:** Arch users also have access to the **AUR** (Arch User Repository) via helpers like `yay` or `paru`. The AUR contains packages contributed by the community and covers almost every piece of software imaginable.

---

## Summary Table

| Operating System      | Package Manager | Install Command for Node.js LTS |
|-----------------------|-----------------|--------------------------------|
| macOS                 | Homebrew        | `brew install node@20`         |
| Windows               | winget          | `winget install OpenJS.NodeJS.LTS` |
| Windows               | Scoop           | `scoop install nodejs-lts`     |
| Windows               | Chocolatey      | `choco install nodejs-lts -y`  |
| Ubuntu/Debian         | apt + NodeSource| `sudo apt install nodejs`      |
| Fedora/RHEL           | dnf             | `sudo dnf install nodejs`      |
| Arch Linux            | pacman          | `sudo pacman -S nodejs npm`    |

---

*Next: Now that you have a package manager, proceed to [installing Node.js](nodejs.md) if you have not already, then set up your [shell and PATH](shell-setup.md).*
