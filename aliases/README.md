# AI Dev Toolkit - Shell Aliases

## Philosophy

These aliases follow a few core principles:

1. **Brevity without obscurity** -- Short aliases like `cc` for `claude` save keystrokes, but every alias should be guessable from context. The two-letter prefix identifies the tool (`cc` = Claude Code, `oc` = OpenCode), and the suffix hints at the action (`v` = version, `up` = update, `r` = resume).

2. **Shell-native, not wrapper scripts** -- Aliases are defined as plain shell constructs (`alias` and small functions) that you source into your session. They add no abstraction layer and have zero startup cost.

3. **Portable defaults, local overrides** -- Every alias file works out of the box. Environment variables like `AI_PROJECTS_DIR` let you customize behavior without editing the files.

4. **Organized by shell, then by tool** -- Each supported shell (bash/zsh, fish) has its own directory. Within that directory, files are split by tool so you can source only what you use.

## Naming Conventions

| Prefix | Tool | Example |
|--------|------|---------|
| `cc`   | Claude Code | `cc`, `ccc`, `ccr`, `ccask` |
| `oc`   | OpenCode    | `oc`, `ocv`, `ocup` |
| *(none)* | Shared / git helpers | `gac`, `gacp`, `gp`, `aidir`, `newai` |

Suffixes used across tools:

| Suffix | Meaning |
|--------|---------|
| `v`    | `--version` |
| `up`   | Update / upgrade the tool |
| `help` | `--help` |
| `r`    | Resume last session |
| `c`    | Continue last conversation |
| `p`    | Print mode (non-interactive) |
| `d`    | Doctor / diagnostics |
| `mod`  | Switch model |

## Directory Structure

```
aliases/
  README.md          # This file
  bash/
    claude-code.sh   # Claude Code aliases (bash/zsh)
    opencode.sh      # OpenCode aliases (bash/zsh)
    shared.sh        # Shared AI workflow helpers (bash/zsh)
    install.sh       # Auto-installer for bash/zsh
  fish/
    claude-code.fish # Claude Code aliases (fish)
    opencode.fish    # OpenCode aliases (fish)
    shared.fish      # Shared AI workflow helpers (fish)
    install.fish     # Auto-installer for fish
```

## Installation

### Option 1 -- Run the installer script

**Bash / Zsh:**

```bash
bash aliases/bash/install.sh
source ~/.bashrc   # or source ~/.zshrc
```

The installer appends `source` lines to your shell RC file. It is idempotent -- running it twice will not create duplicate entries.

**Fish:**

```fish
fish aliases/fish/install.fish
```

The fish installer copies alias files into `~/.config/fish/conf.d/` so they are loaded automatically on every new shell.

### Option 2 -- Source manually

Add the following to your `~/.bashrc` or `~/.zshrc`:

```bash
source /path/to/aliases/bash/claude-code.sh
source /path/to/aliases/bash/opencode.sh
source /path/to/aliases/bash/shared.sh
```

Or for fish, add to `~/.config/fish/config.fish`:

```fish
source /path/to/aliases/fish/claude-code.fish
source /path/to/aliases/fish/opencode.fish
source /path/to/aliases/fish/shared.fish
```

### Option 3 -- Cherry-pick

Source only the files you need. Each file is self-contained and has no dependencies on the others.

## Full Alias Reference

### Claude Code (`cc*`)

| Alias / Function | Shell | Description |
|---|---|---|
| `cc` | bash, fish | Launch Claude Code |
| `ccc` | bash, fish | Continue last conversation |
| `ccr` | bash, fish | Resume a previous session |
| `ccp` | bash, fish | Print mode (pipe-friendly, non-interactive) |
| `ccd` | bash, fish | Run `claude doctor` diagnostics |
| `ccv` | bash, fish | Print version |
| `ccmod` | bash, fish | Select model |
| `cchelp` | bash, fish | Show help |
| `ccup` | bash, fish | Update Claude Code via npm |
| `ccask "question"` | bash, fish | One-shot question in print mode |
| `ccfix` | bash, fish | Re-run last command and pipe errors to Claude for help |
| `ccpr` | bash | Pipe `git diff` into Claude for a quick PR review |
| `ccinit` | bash, fish | Scaffold a `CLAUDE.md` file in the current directory |

### OpenCode (`oc*`)

| Alias / Function | Shell | Description |
|---|---|---|
| `oc` | bash, fish | Launch OpenCode |
| `ocv` | bash, fish | Print version |
| `ochelp` | bash, fish | Show help |
| `ocup` | bash, fish | Update OpenCode (auto-detects brew/go/curl) |

### Shared Workflow Helpers

| Alias / Function | Shell | Description |
|---|---|---|
| `aidir` | bash, fish | `cd` to your projects directory (`$AI_PROJECTS_DIR`) |
| `gp` | bash, fish | `git push` |
| `gac "msg"` | bash, fish | `git add -A && git commit -m "msg"` |
| `gacp "msg"` | bash, fish | `git add -A && git commit -m "msg" && git push` |
| `newai name` | bash, fish | Create a new project directory with git init and README |

## Customization

Set `AI_PROJECTS_DIR` in your shell profile to change the default projects directory:

```bash
export AI_PROJECTS_DIR="$HOME/dev"
```

```fish
set -gx AI_PROJECTS_DIR "$HOME/dev"
```
