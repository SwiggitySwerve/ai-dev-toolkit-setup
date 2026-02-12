# Shell Setup, Profile Files, and PATH

When you install a new command-line tool, your terminal needs to know *where* to find it. This guide explains the foundational concepts -- shells, profile files, sourcing, and PATH -- that make everything click into place. Understanding these ideas once will save you from confusion every time you install a new tool going forward.

---

## Table of Contents

- [What Is a Shell?](#what-is-a-shell)
- [Which Shell Am I Using?](#which-shell-am-i-using)
- [Profile and Configuration Files](#profile-and-configuration-files)
- [How to Edit Profile Files](#how-to-edit-profile-files)
- [What Is PATH?](#what-is-path)
- [What Does "Sourcing" Mean?](#what-does-sourcing-mean)
- [Putting It All Together: Adding a Tool to Your PATH](#putting-it-all-together-adding-a-tool-to-your-path)
- [Common Pitfalls](#common-pitfalls)

---

## What Is a Shell?

A **shell** is the program that reads what you type in a terminal and executes it. When you open a terminal window, a shell starts running inside it. The shell displays a prompt (like `$` or `>`), waits for you to type a command, runs that command, and shows you the output.

Different shells exist, and they have slightly different syntax and configuration files. Here are the most common ones:

### macOS

| Shell | Notes |
|-------|-------|
| **zsh** | The default shell on macOS since Catalina (2019). If you have a relatively recent Mac, this is almost certainly what you are using. |
| **bash** | The default shell on older macOS versions (pre-Catalina). Still available on modern macOS. |
| **fish** | A third-party shell popular for its user-friendly defaults. Must be installed separately. |

### Linux

| Shell | Notes |
|-------|-------|
| **bash** | The default shell on most Linux distributions (Ubuntu, Fedora, Debian, etc.). |
| **zsh** | Popular alternative, especially with the Oh My Zsh framework. Must be installed separately on most distros. |
| **fish** | User-friendly shell with syntax highlighting out of the box. Must be installed separately. |

### Windows

| Shell | Notes |
|-------|-------|
| **PowerShell** | The modern default on Windows 10/11. Windows Terminal runs this by default. |
| **CMD (Command Prompt)** | The legacy Windows command line. Still works but has limited features compared to PowerShell. |
| **Git Bash** | A bash emulation layer that comes with Git for Windows. Lets you use bash commands on Windows. |
| **WSL (Windows Subsystem for Linux)** | Runs a real Linux shell (usually bash) inside Windows. If you use WSL, follow the Linux instructions for everything inside the WSL environment. |

---

## Which Shell Am I Using?

### macOS and Linux

Open your terminal and run:

```bash
echo $SHELL
```

This prints the path to your default shell, for example:

- `/bin/zsh` -- you are using zsh
- `/bin/bash` -- you are using bash
- `/usr/bin/fish` -- you are using fish

### Windows

- If your prompt looks like `PS C:\Users\yourname>`, you are in **PowerShell**.
- If your prompt looks like `C:\Users\yourname>`, you are in **CMD**.
- If your prompt looks like `user@hostname MINGW64 ~`, you are in **Git Bash**.

You can also check in PowerShell:

```powershell
$PSVersionTable.PSEdition
```

---

## Profile and Configuration Files

Every shell has a **profile file** (also called a config file or rc file). This is a text file that the shell reads and executes every time it starts. Anything you put in this file -- environment variables, PATH additions, aliases -- will be available in every new terminal window you open.

### Where Profile Files Live

#### zsh (macOS default)

| File | When It Runs | Typical Use |
|------|-------------|-------------|
| `~/.zshrc` | Every time you open a new terminal window (interactive shell) | **This is the main one.** Put your PATH changes, aliases, and tool configuration here. |
| `~/.zprofile` | Once at login | Homebrew on Apple Silicon adds its setup here. Similar to `.bash_profile`. |
| `~/.zshenv` | Every time zsh starts (interactive and non-interactive) | Rarely edited by hand. |

> **Tip:** `~` means your home directory. On macOS, that is `/Users/yourname`. On Linux, that is `/home/yourname`.

#### bash (Linux default, older macOS)

| File | When It Runs | Typical Use |
|------|-------------|-------------|
| `~/.bashrc` | Every interactive non-login shell | **This is the main one on Linux.** |
| `~/.bash_profile` | Login shells (e.g., when you first log in to a remote server) | On macOS with bash, Terminal.app opens login shells, so this file runs instead of `.bashrc`. Many people add `source ~/.bashrc` inside `.bash_profile` to unify behavior. |
| `~/.profile` | Login shells (if `.bash_profile` does not exist) | Fallback used by some systems. |

#### fish

| File | When It Runs |
|------|-------------|
| `~/.config/fish/config.fish` | Every time fish starts |

#### PowerShell (Windows)

| File | When It Runs |
|------|-------------|
| `$PROFILE` | Every time PowerShell starts |

To find the exact path of your PowerShell profile:

```powershell
echo $PROFILE
```

This typically prints something like:

```
C:\Users\yourname\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
```

> **Note:** This file may not exist yet. That is normal -- you create it when you need it.

#### CMD (Windows)

CMD does not have a profile file in the same sense. Environment variables are set through the Windows System Settings GUI (search for "Environment Variables" in the Start menu) or via the `setx` command.

---

## How to Edit Profile Files

### Using a Terminal Text Editor

**nano** is the most beginner-friendly terminal editor. It is available on macOS and most Linux distributions.

```bash
nano ~/.zshrc       # Edit zsh config
nano ~/.bashrc      # Edit bash config
```

Inside nano:

- Type or paste your changes.
- Press `Ctrl + O` (the letter O) to save, then `Enter` to confirm.
- Press `Ctrl + X` to exit.

**vim** and **vi** are more powerful but have a steeper learning curve. If you accidentally open vim, press `Esc`, type `:q!`, and press `Enter` to exit without saving.

### Using a GUI Text Editor

You can also open profile files in any text editor:

```bash
# macOS -- open in TextEdit
open -a TextEdit ~/.zshrc

# macOS -- open in VS Code (if installed)
code ~/.zshrc

# Linux -- open in VS Code
code ~/.bashrc

# Linux -- open in gedit (GNOME default editor)
gedit ~/.bashrc
```

### Windows (PowerShell)

```powershell
# Open your PowerShell profile in Notepad
notepad $PROFILE

# If the file doesn't exist yet, create it first:
if (!(Test-Path -Path $PROFILE)) { New-Item -ItemType File -Path $PROFILE -Force }
notepad $PROFILE
```

---

## What Is PATH?

**PATH** is an environment variable that contains a list of directories. When you type a command like `node`, your shell searches through each directory in PATH (in order) looking for an executable file named `node`. If it finds one, it runs it. If it does not find one in any PATH directory, you get the error "command not found."

### Viewing Your PATH

**macOS/Linux:**

```bash
echo $PATH
```

This prints something like:

```
/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
```

The directories are separated by colons (`:`). Your shell searches them left to right.

**Windows (PowerShell):**

```powershell
$env:Path -split ';'
```

On Windows, directories are separated by semicolons (`;`).

### How Tools Get on Your PATH

When you install something with a package manager (Homebrew, Scoop, apt, etc.), the package manager places the executable in a directory that is already on your PATH. That is why the command works immediately.

When you install something manually or use a tool like nvm, you sometimes need to **add a new directory to your PATH** yourself. This is done by editing your profile file.

### Adding a Directory to PATH

**zsh or bash (macOS/Linux):**

Add this line to your profile file (`~/.zshrc` or `~/.bashrc`):

```bash
export PATH="/path/to/new/directory:$PATH"
```

Breaking this down:

- `export` makes the variable available to child processes (programs you launch from the shell).
- `PATH=` sets the PATH variable.
- `"/path/to/new/directory:$PATH"` prepends the new directory to the existing PATH. The `$PATH` at the end preserves everything that was already there.

> **Tip:** Putting the new directory at the **beginning** (before `$PATH`) means it will be searched first. This is how you can override a system-installed version with your own version.

**PowerShell (Windows):**

Add this to your PowerShell profile (`$PROFILE`):

```powershell
$env:Path = "C:\path\to\new\directory;" + $env:Path
```

**Permanently via Windows GUI:**

1. Press `Win + R`, type `sysdm.cpl`, press Enter.
2. Click the "Advanced" tab.
3. Click "Environment Variables."
4. Under "User variables," find `Path` and click "Edit."
5. Click "New" and add the directory path.
6. Click OK on all dialogs.
7. Open a new terminal window.

---

## What Does "Sourcing" Mean?

When you edit a profile file, the changes do not take effect in your current terminal session. The profile file is only read when a *new* shell starts. You have two options:

### Option 1: Open a new terminal window

This is the simplest approach. Close your current terminal and open a fresh one. The new shell will read the updated profile file.

### Option 2: Source the file

"Sourcing" means telling your current shell to read and execute a file right now, without restarting. The command is `source` (or its shorthand `.`):

```bash
source ~/.zshrc      # Re-read zsh config in the current session
source ~/.bashrc     # Re-read bash config in the current session

# Shorthand (does the same thing):
. ~/.zshrc
```

**In PowerShell:**

```powershell
. $PROFILE
```

After sourcing, any new PATH entries, aliases, or environment variables defined in the file are immediately available.

> **When will you see "source" in installation instructions?** Many tools tell you to "add this line to your profile and then run `source ~/.zshrc`." Now you know why: the first part makes the change permanent (for future terminals), and the `source` command makes it work right now (in your current terminal).

---

## Putting It All Together: Adding a Tool to Your PATH

Here is a complete real-world example. Suppose you install a tool that places its executable in `~/.local/bin`, but running the tool's command gives "command not found."

**Step 1 -- Figure out which shell you use:**

```bash
echo $SHELL
```

Result: `/bin/zsh`

**Step 2 -- Edit the profile file:**

```bash
nano ~/.zshrc
```

**Step 3 -- Add the PATH line at the end of the file:**

```bash
export PATH="$HOME/.local/bin:$PATH"
```

> **Tip:** Use `$HOME` instead of `~` inside export statements. They mean the same thing, but `$HOME` is more reliable in all contexts.

**Step 4 -- Save and exit nano** (`Ctrl + O`, `Enter`, `Ctrl + X`).

**Step 5 -- Source the file or open a new terminal:**

```bash
source ~/.zshrc
```

**Step 6 -- Verify the tool works:**

```bash
which my-tool    # Should print ~/.local/bin/my-tool
my-tool --version
```

---

## Common Pitfalls

### "I added it to my profile but the command still isn't found"

- Did you edit the right profile file for your shell? Check with `echo $SHELL`.
- Did you source the file or open a new terminal?
- Is the path correct? Run `ls /path/to/directory` to make sure the directory exists and contains the executable.

### "It works in one terminal but not another"

- You may have sourced the file in one terminal but not others. Only new terminals (opened after you edited the profile) will pick up changes automatically.
- On macOS, if you use both `.bash_profile` and `.bashrc`, only one may be loaded depending on how the terminal was opened.

### "I have multiple versions of the same tool"

Use `which` (macOS/Linux) or `where` (Windows) to see which version is being found:

```bash
which node        # macOS/Linux
where node        # Windows (CMD)
Get-Command node  # Windows (PowerShell)
```

If the wrong version is being found, it means the wrong directory appears first in your PATH. Reorder the directories in your profile file so the correct one comes first.

### "Permission denied when editing profile files"

Profile files in your home directory are owned by you. You should never need `sudo` to edit them. If you get permission denied:

```bash
ls -la ~/.zshrc   # Check ownership and permissions
```

The file should be owned by your user. If it is owned by root, fix it:

```bash
sudo chown $(whoami) ~/.zshrc
```

### Windows: "Running scripts is disabled on this system"

PowerShell's execution policy may block profile scripts. Fix it by running (in an Administrator PowerShell):

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

This allows locally-created scripts (like your profile) to run while still blocking unsigned scripts downloaded from the internet.

---

*You now have the foundational knowledge to install and configure any command-line tool. Return to the [prerequisites overview](README.md) to make sure you have completed all the steps, then continue with the main AI Dev Toolkit setup.*
