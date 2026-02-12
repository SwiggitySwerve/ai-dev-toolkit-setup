# Contributing to AI Dev Toolkit

Thank you for your interest in contributing! This guide will help you get started.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How to Add a New Tool](#how-to-add-a-new-tool)
- [How to Add Aliases for a New Shell](#how-to-add-aliases-for-a-new-shell)
- [Style Guidelines](#style-guidelines)
- [Testing](#testing)
- [Pull Request Process](#pull-request-process)

## Code of Conduct

This project follows the [Contributor Covenant Code of Conduct](https://www.contributor-covenant.org/version/2/1/code_of_conduct/). By participating, you agree to uphold a welcoming, inclusive, and harassment-free environment for everyone.

## How to Add a New Tool

1. **Copy the template directory:**
   ```bash
   cp -r templates/new-tool-template/ docs/tools/your-tool-name/
   ```

2. **Fill in each template file:**
   - `README.md` - Tool overview, features, and why someone would use it
   - `install-macos.md` - macOS installation instructions
   - `install-linux.md` - Linux installation instructions (cover Ubuntu/Debian, Fedora, Arch at minimum)
   - `install-windows.md` - Windows instructions (PowerShell, CMD, and WSL)
   - `configuration.md` - Config file locations, authentication, key settings
   - `getting-started.md` - First run, basic usage, common workflows
   - `tips.md` - Keyboard shortcuts, advanced features, performance tips

3. **Replace all `[Tool Name]` placeholders** with the actual tool name.

4. **Update the setup scripts** if the tool should be offered during automated setup:
   - Add the tool to the selection menu in `scripts/setup.sh`
   - Add the tool to the selection menu in `scripts/setup.ps1`
   - Add default aliases for the tool in both scripts

5. **Add an entry** to the main `README.md` tools table.

6. **Verify all links** between documents work correctly.

## How to Add Aliases for a New Shell

Shell aliases live in the setup scripts. To add support for a new shell:

1. **In `scripts/setup.sh`:**
   - Add a detection case in the `detect_shell()` function
   - Add an alias block format in the `install_aliases()` function
   - Use the shell's native alias or abbreviation syntax
   - Ensure the correct config file path is set (e.g., `~/.config/nushell/config.nu`)

2. **Test the alias installation:**
   ```bash
   # Test with dry-run first
   bash scripts/setup.sh --dry-run --all

   # Verify idempotency by running twice
   bash scripts/setup.sh --all
   bash scripts/setup.sh --all
   # Check that aliases only appear once in the config file
   ```

3. **Document the shell** in the alias reference section of the docs.

## Style Guidelines

### Documentation

- Use **second person** ("you") when addressing the reader.
- Use **present tense** ("Run this command" not "You should run this command").
- Keep sentences short and direct.
- Always include a **verification step** after installation commands.
- Use fenced code blocks with language identifiers (```bash, ```powershell, etc.).
- Wrap lines at 80 characters in Markdown source where practical.
- Use ATX-style headings (`#`, `##`, `###`).

### Shell Scripts

- Use `set -euo pipefail` at the top of bash scripts.
- Quote all variable expansions: `"$var"` not `$var`.
- Use `readonly` for constants.
- Prefer long flags for readability in documentation (`--global` not `-g`).
- Add comments for non-obvious logic.
- Functions should be focused and named with verbs (`install_tool`, `detect_os`).

### PowerShell Scripts

- Use `Set-StrictMode -Version Latest`.
- Use approved PowerShell verbs for function names (`Install-`, `Test-`, `Get-`).
- Prefer full parameter names over positional arguments.
- Include comment-based help for public functions.

## Testing

### Testing Alias Files

To verify alias files work correctly without modifying your actual shell config:

```bash
# Create a temporary config file
tmpfile=$(mktemp)

# Source only the alias block
grep -A 100 'AI Dev Toolkit Aliases' ~/.bashrc > "$tmpfile"
bash --rcfile "$tmpfile" -i

# Verify aliases are available
type cc
type oc
```

For PowerShell:
```powershell
# Create a temporary profile
$tmpProfile = [System.IO.Path]::GetTempFileName() + ".ps1"
Select-String -Path $PROFILE -Pattern "AI Dev Toolkit" -Context 0,20 |
    ForEach-Object { $_.Context.PostContext } | Set-Content $tmpProfile

# Test in a new session
pwsh -NoProfile -Command ". $tmpProfile; Get-Alias cc"
```

### Testing Setup Scripts

```bash
# Dry-run mode tests all logic without side effects
bash scripts/setup.sh --dry-run --all
bash scripts/setup.sh --dry-run --claude-only
bash scripts/setup.sh --dry-run --opencode-only
```

```powershell
.\scripts\setup.ps1 -Tool All -DryRun
.\scripts\setup.ps1 -Tool Claude -DryRun
```

## Pull Request Process

1. **Fork the repository** and create a feature branch:
   ```bash
   git checkout -b feature/add-tool-name
   ```

2. **Make your changes** following the style guidelines above.

3. **Test your changes:**
   - Run the setup scripts with `--dry-run` to verify they work.
   - If adding documentation, verify all links resolve correctly.
   - Check Markdown renders properly (use a local preview tool).

4. **Commit with a clear message:**
   ```
   feat: add support for ToolName

   - Add installation docs for macOS, Linux, Windows
   - Add ToolName to setup script selection menu
   - Add default aliases (tn -> toolname)
   ```

5. **Open a Pull Request** against the `main` branch:
   - Fill out the PR template.
   - Reference any related issues.
   - Ensure the PR description explains *why*, not just *what*.

6. **Address review feedback** promptly. All PRs require at least one approval.

7. **Merging:** Maintainers will squash-merge after approval. Your commit message will be preserved in the squash commit.

## Questions?

Open an issue with the `question` label or start a discussion. We are happy to help!
