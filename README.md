# AI Dev Toolkit Setup

> Progressive guides for AI coding tools - from first install to building your own plugins. Cross-platform support for Claude Code, OpenCode, and the MCP ecosystem.

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

The setup script detects your OS, installs prerequisites, and configures shell aliases automatically.

---

## Learning Path

```
  INTRO                INTERMEDIATE            ADVANCED               EXPERT
  (Start Here)         (Daily Driver)          (Power User)           (Builder)

  Prerequisites        Configuration           Skills & Slash         Plugin Development
       |                    |                   Commands               & Marketplaces
       v                    v                      |                      |
  Install a Tool       Getting Started             v                      v
       |                    |                   Hooks &                Custom Subagents
       v                    v                   Automation             & MCP Servers
  First Commands       Shell Aliases               |                      |
                            |                      v                      v
                            v                   MCP Ecosystem          Contributing
                       Power Flags              & Plugins              New Tools
```

Pick your level or work through them in order:

| Level | You'll Learn | Time |
|-------|-------------|------|
| [Intro](#intro) | Install tools, run first commands | ~15 min |
| [Intermediate](#intermediate) | Configure tools, install aliases, smooth your workflow | ~30 min |
| [Advanced](#advanced) | Custom skills, hooks, MCP servers, plugin ecosystem | ~1 hour |
| [Expert](#expert) | Build plugins, create marketplaces, develop MCP servers | ~2 hours |

---

## Supported Tools

| Tool | Description | Status |
|------|-------------|--------|
| [Claude Code](tools/claude-code/) | Anthropic's official CLI for agentic AI coding | Documented |
| [OpenCode](tools/opencode/) | Open-source multi-provider AI coding TUI | Documented |

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

# Intro

> *New to AI coding tools? Start here. You'll go from zero to running your first AI-assisted coding session.*

### Step 1: Prerequisites

Make sure your system is ready:

- [Prerequisites Overview](prerequisites/README.md) - What you need before installing
- [Node.js & npm](prerequisites/nodejs.md) - Required for Claude Code (Node.js 18+)
- [Package Managers](prerequisites/package-managers.md) - Homebrew, Scoop, Chocolatey, winget
- [Shell & Terminal Setup](prerequisites/shell-setup.md) - Where profile files live, how PATH works

### Step 2: Install Your First Tool

**Claude Code** - Best for Anthropic Claude users:

- [What is Claude Code?](tools/claude-code/README.md)
- [Install on macOS](tools/claude-code/install-macos.md)
- [Install on Linux](tools/claude-code/install-linux.md)
- [Install on Windows](tools/claude-code/install-windows.md)

**OpenCode** - Best for multi-provider flexibility (OpenAI, Anthropic, Google, local models):

- [What is OpenCode?](tools/opencode/README.md)
- [Install on macOS](tools/opencode/install-macos.md)
- [Install on Linux](tools/opencode/install-linux.md)
- [Install on Windows](tools/opencode/install-windows.md)

### Step 3: Verify It Works

```bash
# Claude Code
claude --version
claude "Hello! What can you help me with?"

# OpenCode
opencode --version
```

---

# Intermediate

> *You have a tool installed. Now configure it properly, learn the workflow, and add aliases to move faster.*

### Configuration

Set up auth, API keys, and project-level settings:

- [Claude Code Configuration](tools/claude-code/configuration.md) - OAuth, API keys, Max subscription, CLAUDE.md, model selection
- [OpenCode Configuration](tools/opencode/configuration.md) - Multi-provider API keys, model selection, Ollama for local models

### Getting Started Workflows

Learn the daily workflow - prompting, reviewing changes, using slash commands:

- [Claude Code Getting Started](tools/claude-code/getting-started.md) - Slash commands, permission system, git integration, example workflows
- [OpenCode Getting Started](tools/opencode/getting-started.md) - TUI navigation, sessions, file editing workflow

### Shell Aliases

Install aliases to speed up your workflow. Type `cc` instead of `claude`, `gac "msg"` instead of `git add -A && git commit -m "msg"`:

- [Alias Overview & Conventions](aliases/README.md) - Philosophy, naming, how to install
- [Bash / Zsh](aliases/bash/) - `.sh` sourceable files
- [PowerShell](aliases/powershell/) - `.ps1` profile scripts
- [CMD](aliases/cmd/) - `.cmd` DOSKEY macro files
- [Fish](aliases/fish/) - `.fish` config files

<details>
<summary><strong>Quick Alias Reference</strong></summary>

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

#### Shell Functions

| Function | Description |
|----------|-------------|
| `ccask "question"` | Quick one-shot question to Claude |
| `ccfix` | Pipe last command's error into Claude |
| `ccpr` | Start a PR review with Claude |
| `ccinit` | Create a CLAUDE.md in current project |

</details>

### Recommended Command Options

Flags that make the experience smoother:

```bash
# Claude Code Power Flags
claude --print "How do I center a div?"           # One-shot answer, no session
claude --continue                                  # Pick up where you left off
claude --resume                                    # Resume a specific session
claude --model claude-sonnet-4-5-20250929          # Use a specific model
claude --output-format json --print "list files"   # JSON output for scripting
claude --directory /path/to/project                # Run in a different directory
claude --allowedTools "Read,Grep,Glob" --print "analyze this"  # Restrict permissions
```

```bash
# OpenCode TUI Bindings
# Ctrl+N  New session          Ctrl+S  Switch session
# Ctrl+L  Clear screen         Tab     Switch panels
# ?       Help
```

### Tips & Tricks

- [Claude Code Tips](tools/claude-code/tips.md) - Slash commands, piping, CLAUDE.md, CI mode, cost management
- [OpenCode Tips](tools/opencode/tips.md) - LSP, provider switching, custom prompts, git workflows

---

# Advanced

> *You're comfortable with your tools. Now extend them with skills, hooks, plugins, and MCP servers.*

### Claude Code Extension System

Claude Code has four extension types that can be bundled into plugins:

- [Extension System Overview](advanced/claude-code-skills/README.md) - Decision matrix for skills vs hooks vs plugins vs subagents

**Skills** - Custom slash commands and injectable context:
- [Skills Guide](advanced/claude-code-skills/skills-guide.md) - SKILL.md format, YAML frontmatter, dynamic context injection, community skill directories (300+ available), creating your own

**Hooks** - Deterministic automation at lifecycle events:
- [Hooks Guide](advanced/claude-code-skills/hooks-guide.md) - 14 lifecycle events, auto-format on save, block protected files, desktop notifications, context re-injection

**Plugins** - Bundled skills + hooks + MCP + LSP for distribution:
- [Plugins Guide](advanced/claude-code-skills/plugins-guide.md) - Official marketplace, `/plugin install`, installation scopes, plugin.json manifest

### OpenCode Plugin Ecosystem

60+ community plugins across auth, memory, orchestration, safety, and more:

- [Plugin Ecosystem Overview](advanced/opencode-plugins/README.md) - Architecture, comparison with Claude Code skills
- [Plugins Directory](advanced/opencode-plugins/plugins-guide.md) - Complete categorized catalog with install guides
- [Oh My OpenCode](advanced/opencode-plugins/oh-my-opencode.md) - Batteries-included orchestration layer with Sisyphus/Prometheus/Metis agents, 25+ hooks, built-in MCPs

### MCP Ecosystem

Model Context Protocol servers work with both Claude Code AND OpenCode:

- [MCP Overview](advanced/mcp-ecosystem/README.md) - What MCP is, why it matters, client compatibility
- [Popular Servers](advanced/mcp-ecosystem/popular-servers.md) - Top servers ranked by tier and category (87k-star MarkItDown down to reference servers)
- [Setup Guide](advanced/mcp-ecosystem/setup-guide.md) - Configure MCP for both tools, 3 starter configs (minimal/full-stack/devops), troubleshooting

**Essential MCP Servers to Start With:**

| Server | What It Does | Install |
|--------|--------------|---------|
| Context7 | Live documentation fetching | `npx -y @upstash/context7-mcp` |
| GitHub | PRs, issues, code search | `npx -y @github/mcp-server` |
| Memory | Persistent knowledge across sessions | `npx -y @modelcontextprotocol/server-memory` |
| Filesystem | Secure file access beyond working dir | `npx -y @modelcontextprotocol/server-filesystem /path` |

---

# Expert

> *You want to build your own extensions, create plugin marketplaces, or contribute new tools to this repo.*

### Building Claude Code Plugins

Create distributable packages of skills, hooks, MCP servers, and LSP servers:

- [Plugins Guide - "Creating Your Own"](advanced/claude-code-skills/plugins-guide.md) - plugin.json manifest, directory structure, testing with `--plugin-dir`, marketplace publishing
- [Creating a Marketplace](advanced/claude-code-skills/plugins-guide.md) - Host your own plugin registry as a Git repo

**Official marketplace categories you can contribute to:**
- Code Intelligence (LSP): TypeScript, Python, Rust, Go, C/C++, Java, Kotlin, Swift, PHP, Lua, C#
- External Integrations: GitHub, GitLab, Atlassian, Asana, Linear, Notion, Figma, Vercel, Firebase, Supabase, Slack, Sentry
- Development Workflows: commit-commands, pr-review-toolkit
- Output Styles: explanatory, learning

### Building OpenCode Plugins

- [Plugin Template](https://github.com/zenobi-us/opencode-plugin-template) - Starter with CICD, generator, Release Please, and npm publishing
- [OpenCode Plugin Docs](https://opencode.ai/docs/plugins/) - Official development documentation
- [Plugins Guide - "Building Your Own"](advanced/opencode-plugins/plugins-guide.md) - Directory structure, TypeScript examples, development workflow

### Building MCP Servers

- [MCP Specification](https://modelcontextprotocol.io) - The protocol standard
- [MCP TypeScript SDK](https://github.com/modelcontextprotocol/typescript-sdk) - Build servers in TypeScript
- [MCP Python SDK](https://github.com/modelcontextprotocol/python-sdk) - Build servers in Python
- [Setup Guide - Advanced Configuration](advanced/mcp-ecosystem/setup-guide.md) - Docker-based servers, remote servers, conditional loading

### Contributing New Tools to This Repo

Add support for additional AI coding tools (Aider, Cursor, Cline, etc.):

1. Read the [Contributing Guide](CONTRIBUTING.md)
2. Copy the [new tool template](templates/new-tool-template/)
3. Follow the existing structure (install per OS, config, getting started, tips)
4. Add aliases in each shell format
5. Submit a PR

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

### Extending with Skills and Plugins

**Claude Code Skills** (custom slash commands):
- Create `.claude/skills/<name>/SKILL.md` files with YAML frontmatter
- Skills follow the cross-platform [Agent Skills Standard](https://agentskills.io/specification)
- Browse/install plugins: run `/plugin` inside Claude Code
- Install from marketplace: `/plugin install plugin-name@claude-plugins-official`
- Official plugins repo: https://github.com/anthropics/claude-plugins-official
- Full guide: [advanced/claude-code-skills/](advanced/claude-code-skills/)

**OpenCode Plugins** (npm-based extensions):
- 60+ community plugins for auth, memory, orchestration, safety, and more
- Install Oh My OpenCode for batteries-included setup: `bunx oh-my-opencode install`
- Browse: https://github.com/awesome-opencode/awesome-opencode
- Full guide: [advanced/opencode-plugins/](advanced/opencode-plugins/)

**MCP Servers** (works with both tools):
- Add to Claude Code: `claude mcp add <name> -- npx -y @server/package`
- Add to OpenCode: configure in `opencode.json` under `mcpServers`
- Essential servers: Context7, GitHub, Playwright, Memory, Sequential Thinking
- Full guide with configs: [advanced/mcp-ecosystem/](advanced/mcp-ecosystem/)

<!-- END LLM INSTRUCTIONS -->

</details>

---

## Resources by Level

### Intro Resources

| Resource | Description |
|----------|-------------|
| [Claude Code Official Docs](https://docs.anthropic.com/en/docs/claude-code) | Anthropic's official documentation |
| [OpenCode Docs](https://opencode.ai) | Official documentation |
| [OpenCode GitHub](https://github.com/opencode-ai/opencode) | Source code and issue tracker |
| [Ollama](https://ollama.ai) | Run local models with OpenCode |

### Intermediate Resources

| Resource | Description |
|----------|-------------|
| [CLAUDE.md Guide](https://docs.anthropic.com/en/docs/claude-code/memory) | Best practices for project-level instructions |
| [Claude Code GitHub Action](https://github.com/anthropics/claude-code-action) | CI/CD integration for automated code review |
| [opencode.nvim](https://github.com/nickjvandyke/opencode.nvim) | Neovim integration for OpenCode |

### Advanced Resources

| Resource | Description |
|----------|-------------|
| [Skills Documentation](https://code.claude.com/docs/en/skills) | Official skills/slash commands guide |
| [Hooks Guide](https://code.claude.com/docs/en/hooks-guide) | Lifecycle hooks for automation |
| [Plugin Marketplace](https://github.com/anthropics/claude-plugins-official) | Official Claude Code plugin repository |
| [Oh My OpenCode](https://github.com/code-yeongyu/oh-my-opencode) | Batteries-included orchestration layer |
| [Oh My OpenCode (Slim)](https://github.com/alvinunreal/oh-my-opencode-slim) | Lightweight version with reduced tokens |
| [awesome-opencode](https://github.com/awesome-opencode/awesome-opencode) | Curated plugins, themes, agents, resources |
| [awesome-mcp-servers](https://github.com/punkpeye/awesome-mcp-servers) | 75k+ stars - largest curated MCP server list |
| [Context7](https://github.com/upstash/context7) | ~45k stars - live documentation fetching |
| [GitHub MCP Server](https://github.com/github/github-mcp-server) | ~27k stars - official GitHub integration |
| [Playwright MCP](https://github.com/microsoft/playwright-mcp) | ~27k stars - Microsoft browser automation |

### Expert Resources

| Resource | Description |
|----------|-------------|
| [Agent Skills Standard](https://agentskills.io/specification) | Cross-platform skill format (Claude Code, Codex, Copilot, Cursor) |
| [Building Skills PDF](https://resources.anthropic.com/hubfs/The-Complete-Guide-to-Building-Skill-for-Claude.pdf) | Complete guide to building skills |
| [OpenCode Plugin Docs](https://opencode.ai/docs/plugins/) | Official plugin development docs |
| [Plugin Template](https://github.com/zenobi-us/opencode-plugin-template) | Starter template with CICD |
| [MCP Specification](https://modelcontextprotocol.io) | The protocol standard |
| [Official MCP Registry](https://registry.modelcontextprotocol.io) | Centralized server registry |
| [awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code) | Community curated skills, hooks, and plugins |
| [Claude Task Master](https://github.com/eyaltoledano/claude-task-master) | ~25k stars - AI task management |
| [Serena](https://github.com/oraios/serena) | ~20k stars - LSP-based coding agent toolkit |
| [Smithery.ai](https://smithery.ai) | One-click MCP server installation hub |
| [MCP Market](https://mcpmarket.com) | Top 100 MCP servers leaderboard |
| [awesome-cli-agents](https://github.com/phamquiluan/awesome-cli-agents) | CLI AI tools for Vim, Neovim, Terminal |

---

## Contributing

We welcome contributions at any level:

1. Read the [Contributing Guide](CONTRIBUTING.md)
2. Use the [new tool template](templates/new-tool-template/) for adding tools
3. Submit a PR

---

## License

[MIT](LICENSE) - Use freely, attribution appreciated.
