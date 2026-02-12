# MCP Setup Guide: Configuring Servers with Claude Code, OpenCode, and Other Clients

This guide walks you through setting up MCP servers with your AI coding tools. It covers multiple configuration methods, provides ready-to-use starter configurations, and includes troubleshooting for common issues.

---

## Table of Contents

1. [Setting Up MCP with Claude Code](#setting-up-mcp-with-claude-code)
2. [Setting Up MCP with OpenCode](#setting-up-mcp-with-opencode)
3. [Recommended Starter Configurations](#recommended-starter-configurations)
4. [Environment Variables Reference](#environment-variables-reference)
5. [MCP Client Compatibility Matrix](#mcp-client-compatibility-matrix)
6. [Troubleshooting](#troubleshooting)
7. [Advanced Configuration](#advanced-configuration)

---

## Setting Up MCP with Claude Code

Claude Code has first-class MCP support with three configuration methods. Use whichever approach fits your workflow best.

### Method 1: CLI Commands (Fastest)

The `claude mcp add` command registers a server instantly. This is the quickest way to get started.

```bash
# Add the Filesystem server (restrict to your project directory)
claude mcp add filesystem -- npx -y @modelcontextprotocol/server-filesystem /path/to/project

# Add the GitHub server
claude mcp add github -- npx -y @github/mcp-server

# Add the Memory server for persistent context
claude mcp add memory -- npx -y @modelcontextprotocol/server-memory

# Add Context7 for live documentation
claude mcp add context7 -- npx -y @upstash/context7-mcp

# Add Sequential Thinking for complex reasoning
claude mcp add sequential-thinking -- npx -y @modelcontextprotocol/server-sequential-thinking

# Add Fetch for web content
claude mcp add fetch -- npx -y @modelcontextprotocol/server-fetch
```

**Managing servers via CLI:**

```bash
# List all configured MCP servers
claude mcp list

# Remove a server
claude mcp remove github

# Get details about a specific server
claude mcp get filesystem
```

### Method 2: Settings File (Recommended for Teams)

Edit the settings file directly for more control. This is the best approach when you want to share configurations across a team or set environment variables.

**Global configuration** (applies to all projects):
- Path: `~/.claude/settings.json`

**Project configuration** (applies to one project, commit to version control):
- Path: `.claude/settings.json` in your project root

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/project"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@github/mcp-server"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_xxxxxxxxxxxxxxxxxxxx"
      }
    },
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"]
    },
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp"]
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres", "postgres://user:password@localhost:5432/mydb"]
    },
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"]
    }
  }
}
```

**Important notes about settings files:**
- Project-level settings (`.claude/settings.json`) override global settings (`~/.claude/settings.json`) for the same server name.
- Do not commit files containing secrets (API keys, tokens) to version control. Use environment variables instead.
- Changes take effect the next time you start Claude Code. You do not need to restart an active session.

### Method 3: Via Plugins That Bundle MCP Servers

Some Claude Code plugins automatically register MCP servers when installed. This is the easiest approach when a plugin exists for your use case.

```bash
# Example: The Greptile plugin adds code review MCP tools
claude plugin add greptile

# Example: The episodic-memory plugin adds persistent memory
claude plugin add episodic-memory
```

Plugins that bundle MCP servers handle all configuration automatically. Check the plugin documentation to see which MCP tools become available after installation.

---

## Setting Up MCP with OpenCode

OpenCode supports MCP servers through its configuration file. The format is nearly identical to Claude Code.

### Project Configuration

Create or edit `opencode.json` in your project root:

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/project"]
    },
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@github/mcp-server"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_xxxxxxxxxxxxxxxxxxxx"
      }
    },
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"]
    },
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"]
    }
  }
}
```

### Global Configuration

For servers you want available in every project, add them to your global OpenCode configuration file. The location depends on your OS:

- **Linux/macOS:** `~/.config/opencode/config.json`
- **Windows:** `%APPDATA%\opencode\config.json`

The format is the same as the project-level `opencode.json`.

### OpenCode-Specific Tips

- OpenCode discovers `opencode.json` automatically when you open a project directory.
- You can use the TUI to verify which MCP servers are connected: check the status bar or server panel.
- OpenCode supports the same `command` + `args` + `env` format as Claude Code, so configs are often interchangeable.

---

## Recommended Starter Configurations

Copy-paste these complete configurations to get started quickly. Replace placeholder paths and credentials with your own values.

### Configuration 1: Minimal (3 Servers)

Best for: Solo developers, learning MCP, lightweight projects.

**What you get:** File access, persistent memory, and web fetching.

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/your/project"]
    },
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"]
    },
    "fetch": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-fetch"]
    }
  }
}
```

**Why these three:**
- **Filesystem** lets the AI read and write files in your project with controlled access boundaries.
- **Memory** gives the AI persistent recall across sessions so it remembers your project's architecture, decisions, and preferences.
- **Fetch** allows the AI to read documentation, API references, and web pages when it needs up-to-date information.

---

### Configuration 2: Full Stack Developer (6 Servers)

Best for: Web application developers working with GitHub, databases, and modern frameworks.

**What you get:** Everything in Minimal, plus GitHub integration, live docs, database access, and structured reasoning.

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/your/project"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@github/mcp-server"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_xxxxxxxxxxxxxxxxxxxx"
      }
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres", "postgres://user:password@localhost:5432/devdb"]
    },
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp"]
    },
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"]
    },
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"]
    }
  }
}
```

**Why these six:**
- **GitHub** lets the AI create PRs, review code, search issues, and manage your repository directly.
- **PostgreSQL** gives the AI access to your database schema and data for writing accurate queries and migrations.
- **Context7** ensures the AI uses correct, current API syntax for React, Next.js, Prisma, or whatever framework you are using.
- **Sequential Thinking** helps the AI plan complex features before writing code, reducing back-and-forth iterations.

---

### Configuration 3: DevOps Engineer (7 Servers)

Best for: Infrastructure engineers, SREs, and platform teams.

**What you get:** Cloud infrastructure management, container orchestration, error tracking, and CI/CD integration.

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/infra/repo"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@github/mcp-server"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_xxxxxxxxxxxxxxxxxxxx"
      }
    },
    "kubernetes": {
      "command": "npx",
      "args": ["-y", "mcp-server-kubernetes"]
    },
    "docker": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "-v", "/var/run/docker.sock:/var/run/docker.sock", "mcp-server-docker"]
    },
    "sentry": {
      "command": "npx",
      "args": ["@sentry/mcp-server@latest"],
      "env": {
        "SENTRY_ACCESS_TOKEN": "sntrys_xxxxxxxxxxxxxxxxxxxx"
      }
    },
    "fetch": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-fetch"]
    },
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"]
    }
  }
}
```

**Why these seven:**
- **Kubernetes** lets the AI inspect pod status, read logs, describe deployments, and help troubleshoot cluster issues.
- **Docker** provides container management so the AI can help build, run, and debug containerized applications.
- **Sentry** connects error tracking so the AI can correlate production errors with code changes and suggest fixes.
- **Fetch** lets the AI read runbooks, internal documentation, and cloud provider status pages.

---

## Environment Variables Reference

Many MCP servers require API keys or tokens. Here is a complete reference of commonly needed environment variables.

| Variable | Used By | How to Obtain | Free Tier |
|----------|---------|---------------|-----------|
| `GITHUB_PERSONAL_ACCESS_TOKEN` | GitHub MCP | [github.com/settings/tokens](https://github.com/settings/tokens) - Generate a fine-grained token with repo access | Yes (public repos unlimited) |
| `BRAVE_API_KEY` | Brave Search | [brave.com/search/api](https://brave.com/search/api) | Yes (2,000 queries/month) |
| `SLACK_BOT_TOKEN` | Slack MCP | [api.slack.com/apps](https://api.slack.com/apps) - Create app, add bot scopes, install to workspace | Yes (with workspace admin approval) |
| `NOTION_API_KEY` | Notion MCP | [notion.so/my-integrations](https://www.notion.so/my-integrations) - Create an internal integration | Yes |
| `SENTRY_ACCESS_TOKEN` | Sentry MCP | Sentry dashboard > Settings > Auth Tokens | Yes (free developer plan) |
| `EXA_API_KEY` | Exa Search | [exa.ai](https://exa.ai) | Limited free tier |
| `TAVILY_API_KEY` | Tavily Search | [tavily.com](https://tavily.com) | Yes (1,000 queries/month) |
| `FIRECRAWL_API_KEY` | Firecrawl | [firecrawl.dev](https://firecrawl.dev) | Yes (500 pages/month) |
| `ATLASSIAN_API_TOKEN` | Jira MCP | [id.atlassian.com](https://id.atlassian.com/manage-profile/security/api-tokens) | Yes (with Jira account) |
| `ATLASSIAN_EMAIL` | Jira MCP | Your Atlassian account email | N/A |
| `SUPABASE_ACCESS_TOKEN` | Supabase MCP | Supabase dashboard > Account > Access Tokens | Yes (free tier project) |

### Security Best Practices for Environment Variables

**Never hardcode secrets in config files that are committed to version control.** Instead, use one of these approaches:

**Option 1: System environment variables (recommended)**

Set variables in your shell profile (`~/.bashrc`, `~/.zshrc`, or Windows environment variables):

```bash
# Add to ~/.bashrc or ~/.zshrc
export GITHUB_PERSONAL_ACCESS_TOKEN="ghp_xxxxxxxxxxxxxxxxxxxx"
export BRAVE_API_KEY="BSA_xxxxxxxxxxxxxxxxxxxx"
```

Then reference them in your MCP config without the `env` block. The server process will inherit them automatically.

**Option 2: `.env` file with `.gitignore` (for project-specific secrets)**

Create a `.env` file in your project root and add it to `.gitignore`:

```bash
# .env (DO NOT COMMIT THIS FILE)
GITHUB_PERSONAL_ACCESS_TOKEN=ghp_xxxxxxxxxxxxxxxxxxxx
BRAVE_API_KEY=BSA_xxxxxxxxxxxxxxxxxxxx
```

**Option 3: Env block in global config only**

Use the `env` block in `~/.claude/settings.json` (which is not committed to any repo) but not in `.claude/settings.json` (which may be committed).

---

## MCP Client Compatibility Matrix

MCP is an open standard supported by many AI coding tools. Here is how each client handles MCP configuration.

| Client | MCP Support | Config Format | Config Location |
|--------|-------------|---------------|-----------------|
| **Claude Code** | Native, first-class | `settings.json` or CLI (`claude mcp add`) | `~/.claude/settings.json` (global) or `.claude/settings.json` (project) |
| **Claude Desktop** | Native | `claude_desktop_config.json` | `~/.config/claude/` (Linux), `~/Library/Application Support/Claude/` (macOS), `%APPDATA%\Claude\` (Windows) |
| **OpenCode** | Native | `opencode.json` | Project root (project) or `~/.config/opencode/config.json` (global) |
| **Cursor** | Built-in | Settings UI or `.cursor/mcp.json` | Via Cursor settings panel or project-level JSON |
| **VS Code + Cline** | Via extension | Cline extension settings | VS Code settings JSON or Cline config panel |
| **Zed** | Native | `settings.json` | Zed settings directory |
| **Continue** | Native | `config.json` | `~/.continue/config.json` |
| **Windsurf** | Native | Settings UI | Windsurf settings panel |

### Cross-Client Configuration Tips

- The `command` + `args` + `env` format is consistent across Claude Code, Claude Desktop, OpenCode, and most other clients. You can often copy a server config from one tool to another with minimal changes.
- Some clients (Cursor, Windsurf) provide a GUI for adding MCP servers. Use their settings panel if you prefer a visual approach.
- If you use multiple AI tools, maintain a single "source of truth" config file and copy the `mcpServers` block where needed.

---

## Troubleshooting

### Server Not Starting

**Symptoms:** The AI says it cannot find MCP tools, or `claude mcp list` shows a server with an error status.

**Check 1: Is Node.js installed and up to date?**
```bash
node --version    # Should be v18.0.0 or later
npx --version     # Should be available
```

Most MCP servers distributed via npm require Node.js 18+. If you are on an older version, upgrade Node.js first.

**Check 2: Can the server run manually?**

Try running the server command directly in your terminal:
```bash
npx -y @modelcontextprotocol/server-filesystem /path/to/project
```

If this fails, you will see the actual error message (missing dependency, network issue, etc.).

**Check 3: Is the `command` path correct?**

On Windows, you may need to use `npx.cmd` instead of `npx`:
```json
{
  "command": "npx.cmd",
  "args": ["-y", "@modelcontextprotocol/server-filesystem", "C:\\Users\\you\\project"]
}
```

On systems using `nvm` or `fnm`, ensure the Node.js path is available to non-interactive shells.

### Permission Errors

**Symptoms:** Server starts but reports permission denied errors.

- **Filesystem server:** Ensure the path you provide in the args is a directory that exists and that your user has read (and optionally write) access to it.
- **Docker server:** The Docker socket (`/var/run/docker.sock`) requires your user to be in the `docker` group, or run with appropriate permissions.
- **Kubernetes server:** Ensure your kubeconfig is readable and the current context has the necessary RBAC permissions.

### Environment Variables Not Loading

**Symptoms:** Server starts but API calls fail with authentication errors.

**Check 1: Are variables set in the correct scope?**

Variables in the `env` block of your MCP config are set only for that server process. System-level environment variables must be set in your shell profile and may require restarting your terminal.

**Check 2: Are variable names correct?**

Copy the exact variable name from the server's documentation. Common mistakes:
- `GITHUB_TOKEN` vs `GITHUB_PERSONAL_ACCESS_TOKEN` (GitHub MCP uses the latter)
- `SLACK_TOKEN` vs `SLACK_BOT_TOKEN` (Slack MCP uses the latter)

**Check 3: Are quotes handled correctly?**

In JSON config files, values must be strings. Do not include shell-style quotes inside the JSON string:
```json
// Correct
"GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_abc123"

// Wrong (extra quotes inside the string)
"GITHUB_PERSONAL_ACCESS_TOKEN": "'ghp_abc123'"
```

### Checking Which MCP Servers Are Active

**Claude Code:**
```bash
# List all configured servers and their status
claude mcp list
```

Inside an active Claude Code session, you can also ask: "What MCP tools do you have access to?" and the AI will list all available tools from connected servers.

**OpenCode:**

Check the status bar or server panel in the OpenCode TUI. Connected servers show a green indicator.

### Restarting MCP Servers

**Claude Code:**
```bash
# Remove and re-add a server to force restart
claude mcp remove filesystem
claude mcp add filesystem -- npx -y @modelcontextprotocol/server-filesystem /path/to/project
```

Alternatively, exit and restart Claude Code. All MCP servers are restarted when a new session begins.

**OpenCode:**

Restart OpenCode to reconnect all MCP servers. OpenCode re-initializes server connections on startup.

### Server Crashes or Becomes Unresponsive

If an MCP server crashes mid-session:

1. The AI client will typically report that tools from that server are unavailable.
2. Check for error output in the server's stderr (visible in the terminal if you started the server manually).
3. Common causes: memory exhaustion (especially with large file operations), network timeouts, or bugs in the server.
4. Restart the server using the methods described above.

### Windows-Specific Issues

- **Path separators:** Use forward slashes (`/`) or escaped backslashes (`\\`) in JSON config files. Single backslashes (`\`) are escape characters in JSON and will cause parse errors.
- **npx.cmd:** On Windows, the `npx` binary is sometimes registered as `npx.cmd`. If `npx` is not found, try `npx.cmd` as the command.
- **Long paths:** Windows has a 260-character path limit by default. If you encounter path errors, enable long path support or use shorter directory names.

---

## Advanced Configuration

### Running Multiple Instances of the Same Server

You can run multiple instances of the same server with different configurations by using different names:

```json
{
  "mcpServers": {
    "project-files": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/project"]
    },
    "docs-files": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/documentation"]
    },
    "dev-db": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres", "postgres://user:pass@localhost:5432/devdb"]
    },
    "staging-db": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres", "postgres://user:pass@staging-host:5432/stagingdb"]
    }
  }
}
```

### Using Docker-Based MCP Servers

Some MCP servers are distributed as Docker images instead of npm packages:

```json
{
  "mcpServers": {
    "docker-server": {
      "command": "docker",
      "args": [
        "run", "-i", "--rm",
        "-v", "/var/run/docker.sock:/var/run/docker.sock",
        "mcp-server-docker"
      ]
    }
  }
}
```

Key flags:
- `-i` (interactive) is required for stdio transport.
- `--rm` cleans up the container when the server stops.
- Mount volumes (`-v`) as needed for the server to access host resources.

### Using Python-Based MCP Servers

Some servers are distributed as Python packages:

```json
{
  "mcpServers": {
    "serena": {
      "command": "python",
      "args": ["-m", "serena"]
    },
    "markitdown": {
      "command": "python",
      "args": ["-m", "markitdown.mcp"]
    }
  }
}
```

Ensure the Python package is installed in an environment accessible to the command. Using `pipx` or a virtual environment is recommended to avoid dependency conflicts.

### Remote MCP Servers (SSE and Streamable HTTP)

Some MCP servers run as remote services instead of local processes. These use HTTP-based transports:

```json
{
  "mcpServers": {
    "linear": {
      "command": "npx",
      "args": ["-y", "mcp-remote", "https://mcp.linear.app/mcp"]
    }
  }
}
```

The `mcp-remote` package bridges between the stdio transport that clients expect and the HTTP transport that remote servers use. It handles authentication (typically OAuth) via your browser.

### Conditional Server Loading

For large teams with varied needs, consider maintaining separate config files per role:

```
.claude/
  settings.json          # Base config (filesystem, memory)
  settings.frontend.json # Frontend-specific servers
  settings.backend.json  # Backend-specific servers
  settings.devops.json   # Infrastructure servers
```

Developers copy or symlink the relevant config for their role. This keeps individual configurations lean and avoids loading unnecessary servers.

---

## Next Steps

- Browse the [Popular Servers](popular-servers.md) guide to find servers for your specific tech stack.
- Return to the [MCP Ecosystem Overview](README.md) for additional context and official resources.
- Start with the Minimal configuration, verify it works, and add servers incrementally as needed.
