# AI Dev Toolkit Setup

> Beginner-friendly guides and automation for getting started with AI coding tools. Cross-platform installation, shell aliases, and workflow automation.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

---

## Quick Start

**Unix (macOS / Linux):**

```bash
git clone https://github.com/SwiggitySwerve/ai-dev-toolkit-setup.git
cd ai-dev-toolkit-setup
bash scripts/setup.sh
```

**Windows (PowerShell):**

```powershell
git clone https://github.com/SwiggitySwerve/ai-dev-toolkit-setup.git
cd ai-dev-toolkit-setup
.\scripts\setup.ps1
```

The setup script will detect your OS, install prerequisites, and configure shell aliases automatically.

---

## Supported Tools

| Tool | Description | Status |
|------|-------------|--------|
| [Claude Code](tools/claude-code/) | Anthropic's official CLI for agentic AI coding | Documented |
| [OpenCode](tools/opencode/) | Open-source multi-provider AI coding TUI | Documented |

> Want to add a tool? See [Contributing](CONTRIBUTING.md) and the [new tool template](templates/new-tool-template/).

---

## Supported Platforms

| Platform | Claude Code | OpenCode | Aliases |
|----------|:-----------:|:--------:|:-------:|
| macOS | Yes | Yes | bash, zsh, fish |
| Linux (Ubuntu/Debian) | Yes | Yes | bash, zsh, fish |
| Linux (Fedora/Arch) | Yes | Yes | bash, zsh, fish |
| Windows (PowerShell) | Yes | Yes | PowerShell |
| Windows (CMD) | Yes | Yes | CMD/DOSKEY |
| Windows (Git Bash) | Yes | Yes | bash |
| Windows (WSL) | Yes | Yes | bash, zsh, fish |

---

## Table of Contents

### Prerequisites

Before installing any AI coding tool, make sure you have the basics covered:

- [Prerequisites Overview](prerequisites/README.md)
- [Node.js & npm](prerequisites/nodejs.md) - Required for Claude Code
- [Package Managers](prerequisites/package-managers.md) - Homebrew, Scoop, Chocolatey, winget
- [Shell & Terminal Setup](prerequisites/shell-setup.md) - Profile files, PATH, sourcing

### Tool Guides

#### Claude Code

- [Overview](tools/claude-code/README.md) - What is Claude Code and why use it
- [Install on macOS](tools/claude-code/install-macos.md)
- [Install on Linux](tools/claude-code/install-linux.md)
- [Install on Windows](tools/claude-code/install-windows.md)
- [Configuration](tools/claude-code/configuration.md) - Auth, API keys, settings
- [Getting Started](tools/claude-code/getting-started.md) - First steps and workflows
- [Tips & Tricks](tools/claude-code/tips.md) - Power user features

#### OpenCode

- [Overview](tools/opencode/README.md) - What is OpenCode and why use it
- [Install on macOS](tools/opencode/install-macos.md)
- [Install on Linux](tools/opencode/install-linux.md)
- [Install on Windows](tools/opencode/install-windows.md)
- [Configuration](tools/opencode/configuration.md) - Provider setup, models
- [Getting Started](tools/opencode/getting-started.md) - First steps and workflows
- [Tips & Tricks](tools/opencode/tips.md) - Advanced features

### Shell Aliases

Pre-built aliases and functions to speed up your AI coding workflow:

- [Alias Overview & Conventions](aliases/README.md)
- [Bash / Zsh](aliases/bash/) - `.sh` sourceable files
- [PowerShell](aliases/powershell/) - `.ps1` profile scripts
- [CMD](aliases/cmd/) - `.cmd` DOSKEY macro files
- [Fish](aliases/fish/) - `.fish` config files

### Quick Alias Reference

#### Claude Code

| Alias | Command | Description |
|-------|---------|-------------|
| `cc` | `claude` | Launch Claude Code |
| `ccc` | `claude --continue` | Continue last conversation |
| `ccr` | `claude --resume` | Resume a specific session |
| `ccp` | `claude --print` | One-shot print mode |
| `ccd` | `claude doctor` | Run diagnostics |
| `ccv` | `claude --version` | Check version |
| `ccup` | *(OS-specific)* | Update Claude Code |
| `ccmod` | `claude --model` | Quick model switch |
| `cchelp` | `claude --help` | Show help |

#### OpenCode

| Alias | Command | Description |
|-------|---------|-------------|
| `oc` | `opencode` | Launch OpenCode |
| `ocv` | `opencode --version` | Check version |
| `ocup` | *(OS-specific)* | Update OpenCode |
| `ochelp` | `opencode --help` | Show help |

#### Shared Workflow

| Alias | Description |
|-------|-------------|
| `aidir` | Jump to projects directory |
| `gac "msg"` | Git add all + commit |
| `gp` | Git push |
| `gacp "msg"` | Git add + commit + push |
| `newai name` | Scaffold a new AI project |

#### Shell Functions (Bash/Zsh/Fish/PowerShell)

| Function | Description |
|----------|-------------|
| `ccask "question"` | Quick one-shot question to Claude |
| `ccfix` | Pipe last command's error into Claude |
| `ccpr` | Start a PR review with Claude |
| `ccinit` | Create a CLAUDE.md in current project |

---

## How It Works

```
┌─────────────────────────────────────────────┐
│              setup.sh / setup.ps1           │
│  Detects OS → Installs prereqs → Installs   │
│  tools → Configures shell aliases            │
└──────────────────┬──────────────────────────┘
                   │
       ┌───────────┼───────────┐
       ▼           ▼           ▼
   ┌────────┐ ┌────────┐ ┌────────┐
   │ Claude │ │  Open  │ │ Shared │
   │  Code  │ │  Code  │ │ Tools  │
   │Aliases │ │Aliases │ │Aliases │
   └────────┘ └────────┘ └────────┘
```

1. **Run the setup script** - It detects your OS and shell
2. **Choose your tools** - Install Claude Code, OpenCode, or both
3. **Aliases are configured** - Sourced into your shell profile
4. **Start coding** - Use `cc` to launch Claude Code or `oc` for OpenCode

---

## For AI Agents & LLMs

<details>
<summary><strong>Click to expand: LLM/Agent-readable installation instructions</strong></summary>

<!-- BEGIN LLM INSTRUCTIONS -->

If you are an AI coding agent (Claude Code, OpenCode, Cursor, Copilot, Aider, etc.) and a user asks you to help them install or set up AI coding tools, use the following instructions.

### Installing Claude Code

Claude Code is Anthropic's official agentic CLI tool. It requires Node.js 18+.

**Install on any OS:**
```bash
npm install -g @anthropic-ai/claude-code
```

**First-time setup:**
1. Run `claude` in a terminal
2. Complete the OAuth authentication flow in your browser
3. Or set `ANTHROPIC_API_KEY` environment variable for API key auth

**Subscription options:**
- **Claude Pro** ($20/mo): Includes limited Claude Code usage
- **Claude Max** ($100/mo or $200/mo): Includes heavy Claude Code usage
- **API**: Pay-per-use with your own API key

**Key commands:**
- `claude` - Start interactive session in current directory
- `claude --continue` - Continue the last conversation
- `claude --resume` - Resume a specific past session
- `claude --print "question"` - One-shot query (non-interactive)
- `claude doctor` - Run diagnostics
- `claude --model claude-sonnet-4-5-20250929` - Use a specific model

**Configuration:**
- Settings: `~/.claude/` directory
- Project instructions: Create `CLAUDE.md` in project root
- MCP servers: Configure in `~/.claude/settings.json`

**Official documentation:** https://docs.anthropic.com/en/docs/claude-code

### Installing OpenCode

OpenCode is an open-source AI coding assistant with TUI and multi-provider support.

**Install methods:**
```bash
# macOS (Homebrew)
brew install opencode-ai/tap/opencode

# Any OS (Go)
go install github.com/opencode-ai/opencode@latest

# Any OS (shell script)
curl -fsSL https://opencode.ai/install | bash

# Windows (Scoop)
scoop install opencode
```

**Configuration:**
- Create `opencode.json` in your project root, or
- Global config at `~/.config/opencode/config.toml`

**Provider setup (set one or more):**
```bash
export OPENAI_API_KEY="sk-..."
export ANTHROPIC_API_KEY="sk-ant-..."
export GOOGLE_API_KEY="..."
```

**Official repository:** https://github.com/opencode-ai/opencode

### Alias Installation

To install productivity aliases for these tools:
```bash
# Unix
git clone https://github.com/SwiggitySwerve/ai-dev-toolkit-setup.git
cd ai-dev-toolkit-setup && bash aliases/bash/install.sh

# PowerShell
git clone https://github.com/SwiggitySwerve/ai-dev-toolkit-setup.git
cd ai-dev-toolkit-setup; .\aliases\powershell\install.ps1
```

<!-- END LLM INSTRUCTIONS -->

</details>

---

## Popular Extensions & Resources

### Claude Code Ecosystem

| Resource | Description |
|----------|-------------|
| [Claude Code Official Docs](https://docs.anthropic.com/en/docs/claude-code) | Anthropic's official documentation |
| [MCP Servers](https://github.com/modelcontextprotocol/servers) | Model Context Protocol servers for extended capabilities |
| [Claude Code GitHub Action](https://github.com/anthropics/claude-code-action) | CI/CD integration for automated code review |
| [CLAUDE.md Guide](https://docs.anthropic.com/en/docs/claude-code/memory) | Best practices for project-level instructions |

### OpenCode Ecosystem

| Resource | Description |
|----------|-------------|
| [OpenCode GitHub](https://github.com/opencode-ai/opencode) | Source code and issue tracker |
| [OpenCode Docs](https://opencode.ai) | Official documentation |
| [Ollama](https://ollama.ai) | Run local models with OpenCode |

### General AI Coding Resources

| Resource | Description |
|----------|-------------|
| [Model Context Protocol](https://modelcontextprotocol.io) | Open standard for AI tool integration |
| [Awesome AI Coding](https://github.com/stoerr/awesome-ai-coding) | Curated list of AI coding tools |

---

## Recommended Command Options

These flags and options make the AI coding experience smoother:

### Claude Code Power Flags

```bash
# Skip the interactive session, get a direct answer
claude --print "How do I center a div?"

# Continue right where you left off
claude --continue

# Pick up a specific past conversation
claude --resume

# Use a specific model
claude --model claude-sonnet-4-5-20250929

# Set output format for scripting
claude --output-format json --print "list files"

# Run in a specific directory without cd-ing
claude --directory /path/to/project

# Limit permissions for automated/CI usage
claude --allowedTools "Read,Grep,Glob" --print "analyze this code"
```

### OpenCode Power Features

```bash
# Start with a specific provider/model configured in opencode.json
opencode

# Key TUI bindings (once inside OpenCode):
# Ctrl+N - New session
# Ctrl+S - Switch session
# Ctrl+L - Clear screen
# Tab    - Switch between chat and file panels
# ?      - Help
```

---

## Successful OpenCode Plugins & MCP Integrations

OpenCode supports MCP (Model Context Protocol) servers for extended functionality. Here are proven integrations:

### File System & Search

- **filesystem** - Read, write, and manage files beyond the working directory
- **ripgrep** - Fast code search across large codebases

### Development Tools

- **github** - PR reviews, issue management, repo operations from within OpenCode
- **gitlab** - Same for GitLab-hosted repos
- **docker** - Container management and debugging

### Database & APIs

- **sqlite** - Query and manage SQLite databases
- **postgres** - PostgreSQL database interaction
- **fetch** - Make HTTP requests and inspect APIs

### Knowledge & Context

- **memory** - Persistent memory across sessions
- **brave-search** - Web search integration for up-to-date information

### Configuration Example

Add to your `opencode.json` or global config:

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/allowed/dir"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "your-token-here"
      }
    },
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"]
    }
  }
}
```

---

## Contributing

We welcome contributions! Whether it's adding a new tool, improving documentation, or fixing a typo:

1. Read the [Contributing Guide](CONTRIBUTING.md)
2. Use the [new tool template](templates/new-tool-template/) for adding tools
3. Submit a PR

---

## License

[MIT](LICENSE) - Use freely, attribution appreciated.
