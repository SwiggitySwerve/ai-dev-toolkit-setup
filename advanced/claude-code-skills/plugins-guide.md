# Claude Code Plugins Guide

> How to install, create, and distribute Claude Code plugins -- bundles of skills, hooks, subagents, MCP servers, and LSP servers packaged for sharing.

---

## Table of Contents

- [What Are Plugins?](#what-are-plugins)
- [Plugin Architecture](#plugin-architecture)
- [Installing Plugins](#installing-plugins)
- [Installation Scopes](#installation-scopes)
- [Official Marketplace Categories](#official-marketplace-categories)
- [Managing Installed Plugins](#managing-installed-plugins)
- [Creating Your Own Plugin](#creating-your-own-plugin)
- [Plugin Directory Structure](#plugin-directory-structure)
- [The plugin.json Manifest](#the-pluginjson-manifest)
- [Adding Skills to a Plugin](#adding-skills-to-a-plugin)
- [Adding Hooks to a Plugin](#adding-hooks-to-a-plugin)
- [Adding MCP Servers to a Plugin](#adding-mcp-servers-to-a-plugin)
- [Adding LSP Servers to a Plugin](#adding-lsp-servers-to-a-plugin)
- [Adding Subagents to a Plugin](#adding-subagents-to-a-plugin)
- [Local Development](#local-development)
- [Creating a Marketplace](#creating-a-marketplace)
- [Best Practices](#best-practices)

---

## What Are Plugins?

Plugins are the **distribution unit** for Claude Code extensions. A single plugin can bundle any combination of:

- **Skills** -- Reusable instructions and slash commands
- **Hooks** -- Deterministic lifecycle event handlers
- **Subagents** -- Scoped agent definitions for task decomposition
- **MCP Servers** -- Model Context Protocol tool servers
- **LSP Servers** -- Language Server Protocol integrations for code intelligence

### Why Plugins?

| Without Plugins | With Plugins |
|----------------|-------------|
| Copy-paste SKILL.md files between projects | `/plugin install my-skills` |
| Manually configure MCP servers in every project | Plugin auto-registers its MCP servers |
| Share hooks via wiki pages and README instructions | Hooks bundled and versioned with the plugin |
| No namespacing -- skill name conflicts | `/plugin-name:skill-name` avoids collisions |
| No versioning or update mechanism | `version` in plugin.json, marketplace updates |

### Namespacing

Plugin contents are automatically namespaced. If the plugin `acme-tools` contains a skill called `review`, it is accessible as:

```
/acme-tools:review
```

This prevents collisions with project-level skills or other plugins that might also define a `review` skill.

---

## Plugin Architecture

```
┌─────────────────────────────────────────────────┐
│                  Plugin Bundle                   │
│                                                  │
│  .claude-plugin/                                 │
│    plugin.json          (manifest & metadata)    │
│                                                  │
│  skills/                                         │
│    review/SKILL.md      (slash commands)          │
│    analyze/SKILL.md                               │
│                                                  │
│  hooks/                                          │
│    hooks.json           (lifecycle hooks)         │
│                                                  │
│  agents/                                         │
│    researcher/AGENT.md  (subagent definitions)    │
│                                                  │
│  .mcp.json              (MCP server configs)     │
│  .lsp.json              (LSP server configs)     │
│                                                  │
│  commands/              (legacy slash commands)    │
│    old-command.md                                 │
└─────────────────────────────────────────────────┘
```

---

## Installing Plugins

### Browse Available Plugins

```
/plugin
```

Opens an interactive browser showing installable plugins from configured marketplaces.

### Install from the Official Marketplace

```
/plugin install plugin-name@claude-plugins-official
```

The official marketplace is `claude-plugins-official` (hosted at [github.com/anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official)).

### Add a Community Marketplace

Before installing from a community source, register it:

```
/plugin marketplace add owner/repo
```

For example:

```
/plugin marketplace add acme-corp/claude-plugins
```

### Install from a Community Marketplace

```
/plugin install plugin-name@marketplace-name
```

For example:

```
/plugin install devops-toolkit@acme-corp/claude-plugins
```

### Install from a Local Directory (Development)

For developing and testing plugins locally:

```bash
claude --plugin-dir ./my-plugin
```

Or add to your settings:

```json
{
  "pluginDirs": ["./my-plugin", "/absolute/path/to/another-plugin"]
}
```

---

## Installation Scopes

Plugins can be installed at different scopes, controlling who and what they affect:

| Scope | Location | Affects | Use Case |
|-------|----------|---------|----------|
| **User** | `~/.claude/` | All your projects | Personal tools and workflows |
| **Project (shared)** | `.claude/settings.json` | Everyone on the project | Team standards (committed to git) |
| **Project (local)** | `.claude/settings.local.json` | Just you, on this project | Personal overrides (gitignored) |
| **Managed** | Admin-configured | Organization-wide | Company-mandated tools |

### Installing at a Specific Scope

```
/plugin install plugin-name@marketplace --scope user
/plugin install plugin-name@marketplace --scope project
/plugin install plugin-name@marketplace --scope local
```

Default scope is **user** unless otherwise specified.

---

## Official Marketplace Categories

The official marketplace ([claude-plugins-official](https://github.com/anthropics/claude-plugins-official)) is organized into categories:

### Code Intelligence (LSP)

Language Server Protocol plugins that give Claude deep understanding of your code:

| Plugin | Language | Features |
|--------|----------|----------|
| `typescript-lsp` | TypeScript / JavaScript | Type checking, auto-imports, refactoring |
| `python-lsp` | Python | Pyright-based type checking, diagnostics |
| `rust-lsp` | Rust | rust-analyzer integration |
| `go-lsp` | Go | gopls integration |
| `c-cpp-lsp` | C / C++ | clangd integration |
| `csharp-lsp` | C# | OmniSharp / Roslyn integration |
| `java-lsp` | Java | Eclipse JDT.LS integration |
| `kotlin-lsp` | Kotlin | Kotlin language server |
| `swift-lsp` | Swift | SourceKit-LSP integration |
| `php-lsp` | PHP | Intelephense / phpactor |
| `lua-lsp` | Lua | lua-language-server |

### External Integrations

Plugins that connect Claude Code to external services:

| Plugin | Service | Capabilities |
|--------|---------|-------------|
| `github` | GitHub | PRs, issues, actions, code search |
| `gitlab` | GitLab | MRs, issues, pipelines |
| `atlassian` | Jira + Confluence | Issue tracking, documentation |
| `asana` | Asana | Task and project management |
| `linear` | Linear | Issue tracking, project views |
| `notion` | Notion | Pages, databases, knowledge base |
| `figma` | Figma | Design tokens, component specs |
| `vercel` | Vercel | Deployment, environment, logs |
| `firebase` | Firebase | Database, auth, hosting |
| `supabase` | Supabase | Database, auth, storage |
| `slack` | Slack | Messaging, channel search |
| `sentry` | Sentry | Error tracking, performance monitoring |

### Development Workflows

Plugins that enhance coding workflows:

| Plugin | Description |
|--------|-------------|
| `commit-commands` | Conventional commit generation, changelog creation |
| `pr-review-toolkit` | PR review workflows, code quality checks |
| `agent-sdk-dev` | Agent SDK development helpers |
| `plugin-dev` | Plugin development and testing tools |

### Output Styles

Plugins that modify how Claude communicates:

| Plugin | Description |
|--------|-------------|
| `explanatory-output-style` | Detailed explanations with reasoning shown |
| `learning-output-style` | Educational style with concepts explained |

---

## Managing Installed Plugins

### List Installed Plugins

```
/plugin list
```

### Disable a Plugin (without uninstalling)

```
/plugin disable plugin-name
```

### Re-Enable a Plugin

```
/plugin enable plugin-name
```

### Uninstall a Plugin

```
/plugin uninstall plugin-name
```

### Update a Plugin

```
/plugin update plugin-name
```

Or update all:

```
/plugin update --all
```

---

## Creating Your Own Plugin

Let's walk through creating a plugin from scratch.

### Step 1: Create the Directory Structure

```bash
mkdir -p my-plugin/.claude-plugin
mkdir -p my-plugin/skills/greet
mkdir -p my-plugin/hooks
```

### Step 2: Write the Manifest

Create `my-plugin/.claude-plugin/plugin.json`:

```json
{
  "name": "my-plugin",
  "description": "A simple example plugin with a greeting skill and format-on-save hook",
  "version": "1.0.0",
  "author": "Your Name",
  "homepage": "https://github.com/yourname/my-plugin",
  "repository": {
    "type": "git",
    "url": "https://github.com/yourname/my-plugin.git"
  },
  "license": "MIT",
  "engines": {
    "claude-code": ">=1.0.0"
  },
  "keywords": ["greeting", "formatting", "example"]
}
```

### Step 3: Add a Skill

Create `my-plugin/skills/greet/SKILL.md`:

```markdown
---
name: greet
description: Greet the user and provide a project status overview
---

## Greeting Protocol

1. Greet the user warmly
2. Read the project's README.md (if it exists)
3. Check git status for any uncommitted changes
4. List recent commits (last 5)
5. Provide a brief status summary

Keep the response concise -- 3-5 bullet points maximum.
```

### Step 4: Add a Hook

Create `my-plugin/hooks/hooks.json`:

```json
{
  "PostToolUse": [
    {
      "matcher": "Edit|Write",
      "command": "echo '[my-plugin] File modified. Consider running tests.'"
    }
  ]
}
```

### Step 5: Test Locally

```bash
claude --plugin-dir ./my-plugin
```

In Claude Code, try:

```
/my-plugin:greet
```

### Step 6: Iterate and Refine

- Add more skills to `my-plugin/skills/`
- Add MCP server configurations to `my-plugin/.mcp.json`
- Test thoroughly before publishing

---

## Plugin Directory Structure

Here is the complete directory structure a plugin can contain:

```
my-plugin/
│
├── .claude-plugin/
│   └── plugin.json              # Required: Plugin manifest
│
├── skills/                      # Optional: Skill definitions
│   ├── skill-one/
│   │   ├── SKILL.md             # Skill instructions
│   │   └── templates/           # Supporting files
│   │       └── output.md
│   └── skill-two/
│       └── SKILL.md
│
├── hooks/                       # Optional: Lifecycle hooks
│   └── hooks.json               # Hook definitions
│
├── agents/                      # Optional: Subagent definitions
│   └── researcher/
│       └── AGENT.md             # Subagent instructions
│
├── commands/                    # Optional: Legacy slash commands
│   └── old-command.md           # (Migrated to skills internally)
│
├── .mcp.json                    # Optional: MCP server configurations
├── .lsp.json                    # Optional: LSP server configurations
│
├── scripts/                     # Optional: Hook scripts, utilities
│   ├── format.sh
│   └── validate.py
│
├── README.md                    # Recommended: Plugin documentation
├── CHANGELOG.md                 # Recommended: Version history
└── LICENSE                      # Recommended: License file
```

### Required vs Optional

| Component | Required? | Description |
|-----------|:---------:|-------------|
| `.claude-plugin/plugin.json` | **Yes** | Every plugin must have a manifest |
| `skills/` | No | Slash commands and injectable context |
| `hooks/hooks.json` | No | Lifecycle event handlers |
| `agents/` | No | Subagent definitions |
| `.mcp.json` | No | MCP server registrations |
| `.lsp.json` | No | LSP server registrations |
| `commands/` | No | Legacy format (still supported) |

---

## The plugin.json Manifest

The manifest file identifies and describes the plugin.

### Full Example

```json
{
  "name": "devops-toolkit",
  "description": "DevOps skills, hooks, and integrations for CI/CD workflows",
  "version": "2.1.0",
  "author": "DevOps Team <devops@example.com>",
  "homepage": "https://github.com/example/devops-toolkit",
  "repository": {
    "type": "git",
    "url": "https://github.com/example/devops-toolkit.git"
  },
  "license": "Apache-2.0",
  "engines": {
    "claude-code": ">=1.5.0"
  },
  "keywords": [
    "devops",
    "ci-cd",
    "docker",
    "kubernetes",
    "terraform"
  ],
  "dependencies": {
    "docker": ">=20.0.0",
    "kubectl": ">=1.25.0"
  }
}
```

### Manifest Fields Reference

| Field | Type | Required | Description |
|-------|------|:--------:|-------------|
| `name` | string | Yes | Plugin identifier (lowercase, hyphens, no spaces) |
| `description` | string | Yes | One-line plugin description |
| `version` | string | Yes | Semantic version (e.g., `"1.2.3"`) |
| `author` | string | No | Author name and optional email |
| `homepage` | string | No | URL to plugin documentation or website |
| `repository` | object | No | Source repository (`type` and `url`) |
| `license` | string | No | SPDX license identifier |
| `engines` | object | No | Minimum Claude Code version required |
| `keywords` | string[] | No | Search keywords for marketplace discovery |
| `dependencies` | object | No | External tool requirements (informational) |

---

## Adding Skills to a Plugin

Place skill directories under `skills/`:

```
my-plugin/
  skills/
    deploy/
      SKILL.md
    rollback/
      SKILL.md
    health-check/
      SKILL.md
```

Skills in plugins are automatically namespaced:

- `/my-plugin:deploy`
- `/my-plugin:rollback`
- `/my-plugin:health-check`

The SKILL.md format is identical to project-level skills. See the [Skills Guide](skills-guide.md) for full details.

---

## Adding Hooks to a Plugin

Create `hooks/hooks.json` with the same format as settings-level hooks:

```json
{
  "PostToolUse": [
    {
      "matcher": "Edit|Write",
      "command": "python3 ${PLUGIN_DIR}/scripts/validate.py"
    }
  ],
  "SessionStart": [
    {
      "command": "echo 'DevOps Toolkit loaded. Use /devops-toolkit:deploy to deploy.'"
    }
  ]
}
```

Note the `${PLUGIN_DIR}` variable, which resolves to the plugin's installation directory. Use this to reference scripts bundled with the plugin.

---

## Adding MCP Servers to a Plugin

Create `.mcp.json` at the plugin root:

```json
{
  "mcpServers": {
    "plugin-database": {
      "command": "node",
      "args": ["${PLUGIN_DIR}/mcp/database-server.js"],
      "env": {
        "DB_HOST": "localhost"
      }
    },
    "plugin-api": {
      "command": "npx",
      "args": ["-y", "@example/mcp-api-server"],
      "env": {
        "API_KEY": "${API_KEY}"
      }
    }
  }
}
```

MCP servers defined in a plugin are automatically registered when the plugin is enabled. They expose tools that Claude can call during the session.

---

## Adding LSP Servers to a Plugin

Create `.lsp.json` at the plugin root:

```json
{
  "lspServers": {
    "typescript": {
      "command": "typescript-language-server",
      "args": ["--stdio"],
      "languages": ["typescript", "javascript", "typescriptreact", "javascriptreact"],
      "rootPatterns": ["tsconfig.json", "package.json"]
    }
  }
}
```

LSP servers provide Claude with language-aware capabilities: type information, diagnostics, go-to-definition, and more.

---

## Adding Subagents to a Plugin

Create agent definitions under `agents/`:

```
my-plugin/
  agents/
    researcher/
      AGENT.md
    reviewer/
      AGENT.md
```

**`agents/researcher/AGENT.md`:**

```markdown
---
name: researcher
description: Research a topic across the codebase
allowed-tools:
  - Read
  - Grep
  - Glob
  - WebSearch
max-turns: 20
---

You are a research agent. Your job is to thoroughly investigate the given topic
across the codebase and return a structured summary.

## Output Format

1. **Summary**: 2-3 sentence overview
2. **Key Files**: List of relevant files with brief descriptions
3. **Findings**: Detailed findings organized by theme
4. **Recommendations**: Actionable next steps
```

Subagents defined in plugins can be invoked by the main Claude agent or by skills within the same plugin.

---

## Local Development

### Development Workflow

1. **Create the plugin directory** with the structure above
2. **Launch Claude Code with the plugin** loaded locally:
   ```bash
   claude --plugin-dir ./my-plugin
   ```
3. **Test skills** by typing their namespaced commands:
   ```
   /my-plugin:skill-name
   ```
4. **Test hooks** by triggering the relevant events (e.g., edit a file to trigger PostToolUse)
5. **Iterate**: Edit plugin files and restart Claude Code to pick up changes

### Debugging Tips

- Check Claude Code's output for hook execution errors
- Test MCP servers independently before adding them to a plugin
- Use `echo` commands in hooks to verify they are firing
- Start with a minimal plugin and add components incrementally

---

## Creating a Marketplace

A marketplace is a GitHub repository with a specific structure that allows others to discover and install your plugins.

### Requirements

- Public GitHub repository
- Contains a `marketplace.json` manifest listing available plugins
- Each plugin is either in a subdirectory or referenced by URL

### Basic Structure

```
my-marketplace/
  marketplace.json
  plugins/
    plugin-a/
      .claude-plugin/
        plugin.json
      skills/
      hooks/
    plugin-b/
      .claude-plugin/
        plugin.json
      skills/
```

### marketplace.json

```json
{
  "name": "My Plugin Marketplace",
  "description": "A collection of plugins for specific workflows",
  "plugins": [
    {
      "name": "plugin-a",
      "path": "plugins/plugin-a",
      "description": "Does A things"
    },
    {
      "name": "plugin-b",
      "path": "plugins/plugin-b",
      "description": "Does B things"
    }
  ]
}
```

### Registering Your Marketplace

Users add your marketplace with:

```
/plugin marketplace add your-github-username/your-marketplace-repo
```

For full marketplace creation documentation, see the [official Plugins docs](https://code.claude.com/docs/en/plugins).

---

## Best Practices

### 1. Start with a Skill, Evolve into a Plugin

Don't create a plugin until you have something worth distributing. Start with project-level skills, refine them, then package as a plugin when they're ready for sharing.

### 2. Keep Plugins Focused

A plugin should do one thing well. "devops-toolkit" is better than "everything-toolkit". Users can install multiple plugins.

### 3. Version Meaningfully

Follow semantic versioning:
- **Major** (2.0.0): Breaking changes (removed skills, changed hook behavior)
- **Minor** (1.1.0): New skills, hooks, or capabilities
- **Patch** (1.0.1): Bug fixes, documentation updates

### 4. Document Your Plugin

Include a README.md with:
- What the plugin does
- Prerequisites (external tools needed)
- List of included skills with descriptions
- Configuration instructions
- Examples of usage

### 5. Test Hooks Defensively

Plugin hooks run in environments you don't control. Always:
- Handle missing tools gracefully (`command -v tool || exit 0`)
- Use timeouts for external calls
- Never exit with code 2 unless truly necessary
- Use `|| true` to prevent cascading failures

### 6. Respect the Namespace

Don't name your plugin or skills with generic names that might conflict. Use a distinctive prefix or organization name.

### 7. Minimize Dependencies

External tool requirements (Docker, kubectl, etc.) should be clearly documented and gracefully handled when missing. Don't assume the user's environment matches yours.

### 8. Include a License

Always include a LICENSE file. MIT and Apache-2.0 are common choices for open-source plugins.

---

## Further Reading

- [Official Plugins Documentation](https://code.claude.com/docs/en/plugins)
- [Official Plugin Marketplace](https://github.com/anthropics/claude-plugins-official)
- [Skills Guide](skills-guide.md) -- Creating skills for your plugin
- [Hooks Guide](hooks-guide.md) -- Adding hooks to your plugin
- [Subagents Documentation](https://code.claude.com/docs/en/sub-agents)
- [MCP Specification](https://modelcontextprotocol.io)
- [Back to Overview](README.md)
