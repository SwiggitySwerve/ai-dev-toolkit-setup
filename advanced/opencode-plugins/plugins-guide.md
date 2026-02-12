# OpenCode Plugins: Comprehensive Guide

A thorough reference for finding, installing, configuring, and building OpenCode plugins. This guide catalogs 60+ plugins across 13 categories with descriptions and links.

---

## Table of Contents

1. [What Are OpenCode Plugins](#what-are-opencode-plugins)
2. [Official Documentation](#official-documentation)
3. [Plugin Categories and Top Picks](#plugin-categories-and-top-picks)
4. [How to Install Plugins](#how-to-install-plugins)
5. [Plugin Configuration](#plugin-configuration)
6. [Building Your Own Plugin](#building-your-own-plugin)
7. [Curated Resources](#curated-resources)

---

## What Are OpenCode Plugins

OpenCode plugins are extensions that hook into OpenCode's event system and customize its behavior at every stage of the agent lifecycle. They go well beyond prompt injection -- plugins have programmatic access to OpenCode internals and can fundamentally alter how the agent operates.

**What plugins can do:**

- **Add tools** the agent can invoke (browser automation, code search, notifications, file management)
- **Modify agents** by overriding models, temperatures, system prompts, and permission settings
- **Register hooks** that fire on events such as session start, tool call, message completion, or error
- **Integrate external services** like MCP servers, vector databases, issue trackers, and CI/CD systems
- **Orchestrate sub-agents** for complex multi-step workflows with planning, delegation, and review
- **Manage background tasks** with concurrency control and context persistence

**Technical details:**

- Plugins are standard npm packages following OpenCode's plugin interface
- They are installed via the OpenCode plugin system and activated at startup
- Each plugin declares its capabilities (tools, hooks, agents, MCPs) in a manifest
- Plugins run in the same process as OpenCode, giving them access to the full API surface
- Configuration is handled through JSON/JSONC files at the project or user level

---

## Official Documentation

- **Plugin Docs:** <https://opencode.ai/docs/plugins/>
- **Plugin API Reference:** Included in the official docs under the Plugins section
- **Plugin Template:** <https://github.com/zenobi-us/opencode-plugin-template>

---

## Plugin Categories and Top Picks

### Authentication Plugins

Plugins that enable OpenCode to authenticate with various AI providers using existing subscriptions.

| Plugin | Description | URL |
|--------|-------------|-----|
| opencode-gemini-auth | Google account authentication for Gemini plans | [github.com/jenslys/opencode-gemini-auth](https://github.com/jenslys/opencode-gemini-auth) |
| opencode-antigravity-auth | Access Gemini/Anthropic via Google Antigravity | [github.com/NoeFabris/opencode-antigravity-auth](https://github.com/NoeFabris/opencode-antigravity-auth) |
| opencode-antigravity-multi-auth | Multiple Google accounts with automatic rotation | [github.com/theblazehen/opencode-antigravity-multi-auth](https://github.com/theblazehen/opencode-antigravity-multi-auth) |
| opencode-openai-codex-auth | ChatGPT Plus/Pro OAuth for OpenAI models | [github.com/numman-ali/opencode-openai-codex-auth](https://github.com/numman-ali/opencode-openai-codex-auth) |
| OpenHax Codex | Another ChatGPT authentication option | [github.com/open-hax/codex](https://github.com/open-hax/codex) |

### Memory and Context Plugins

Plugins that give the agent persistent memory and optimize context window usage.

| Plugin | Description | URL |
|--------|-------------|-----|
| opencode-agent-memory | Letta-inspired persistent, self-editable memory blocks | [github.com/joshuadavidthomas/opencode-agent-memory](https://github.com/joshuadavidthomas/opencode-agent-memory) |
| opencode-mem | Vector database persistent memory across sessions | [github.com/tickernelz/opencode-mem](https://github.com/tickernelz/opencode-mem) |
| opencode-plugin-simple-memory | Git-based memory suitable for team review | [github.com/cnicolov/opencode-plugin-simple-memory](https://github.com/cnicolov/opencode-plugin-simple-memory) |
| opencode-dynamic-context-pruning | Optimizes tokens by removing obsolete tool outputs | [github.com/Tarquinen/opencode-dynamic-context-pruning](https://github.com/Tarquinen/opencode-dynamic-context-pruning) |
| opencode-context-analysis | Token usage analysis for AI sessions | [github.com/IgorWarzocha/Opencode-Context-Analysis-Plugin](https://github.com/IgorWarzocha/Opencode-Context-Analysis-Plugin) |

### Orchestration and Multi-Agent Plugins

Plugins that coordinate multiple agents for complex, multi-step workflows.

| Plugin | Description | URL |
|--------|-------------|-----|
| oh-my-opencode | Full orchestration layer with agents, hooks, and MCPs | [github.com/code-yeongyu/oh-my-opencode](https://github.com/code-yeongyu/oh-my-opencode) |
| oh-my-opencode-slim | Lightweight version with reduced token usage | [github.com/alvinunreal/oh-my-opencode-slim](https://github.com/alvinunreal/oh-my-opencode-slim) |
| micode | Brainstorm-Plan-Implement workflow with subagents | [github.com/vtemian/micode](https://github.com/vtemian/micode) |
| opencode-workspace | Bundled multi-agent orchestration (16 components) | [github.com/kdcokenny/opencode-workspace](https://github.com/kdcokenny/opencode-workspace) |
| pocket-universe | Resilient async agents with closed-loop coordination | [github.com/spoons-and-mirrors/pocket-universe](https://github.com/spoons-and-mirrors/pocket-universe) |
| opencode-swarm-plugin | Swarm-based agent coordination | [github.com/joelhooks/opencode-swarm-plugin](https://github.com/joelhooks/opencode-swarm-plugin) |
| subtask2 | Orchestration extending /commands with flow control | [github.com/spoons-and-mirrors/subtask2](https://github.com/spoons-and-mirrors/subtask2) |

> **See also:** [oh-my-opencode.md](./oh-my-opencode.md) for an in-depth guide to Oh My OpenCode.

### Developer Experience Plugins

Plugins that improve day-to-day development workflows.

| Plugin | Description | URL |
|--------|-------------|-----|
| opencode-background | Background process management | [github.com/zenobi-us/opencode-background](https://github.com/zenobi-us/opencode-background) |
| opencode-background-agents | Claude Code-style async agents with context persistence | [github.com/kdcokenny/opencode-background-agents](https://github.com/kdcokenny/opencode-background-agents) |
| opencode-worktree | Zero-friction git worktrees with auto-cleanup | [github.com/kdcokenny/opencode-worktree](https://github.com/kdcokenny/opencode-worktree) |
| opencode-sessions | Session management with multi-agent collaboration | [github.com/malhashemi/opencode-sessions](https://github.com/malhashemi/opencode-sessions) |
| opencode-smart-title | Auto-generates meaningful session titles using AI | [github.com/Tarquinen/opencode-smart-title](https://github.com/Tarquinen/opencode-smart-title) |
| opencode-snippets | Instant inline text expansion with shell-enabled snippets | [github.com/JosXa/opencode-snippets](https://github.com/JosXa/opencode-snippets) |
| opencode-canvas | Interactive terminal canvases in tmux splits | [github.com/mailshieldai/opencode-canvas](https://github.com/mailshieldai/opencode-canvas) |

### Safety and Quality Plugins

Plugins that prevent destructive actions and enforce safety guardrails.

| Plugin | Description | URL |
|--------|-------------|-----|
| claude-code-safety-net | Catches destructive git and filesystem commands | [github.com/kenryu42/claude-code-safety-net](https://github.com/kenryu42/claude-code-safety-net) |
| envsitter-guard | Prevents agents from reading sensitive .env files | [github.com/boxpositron/envsitter-guard](https://github.com/boxpositron/envsitter-guard) |
| opencode-shell-strategy | Teaches LLMs to avoid interactive command hangs | [github.com/JRedeker/opencode-shell-strategy](https://github.com/JRedeker/opencode-shell-strategy) |
| opencode-ignore | Ignore directories/files based on pattern matching | [github.com/lgladysz/opencode-ignore](https://github.com/lgladysz/opencode-ignore) |

### Utility Plugins

General-purpose plugins for notifications, quota tracking, configuration, and model management.

| Plugin | Description | URL |
|--------|-------------|-----|
| opencode-notify | Native OS notifications for task completion | [github.com/kdcokenny/opencode-notify](https://github.com/kdcokenny/opencode-notify) |
| opencode-smart-voice-notify | Voice notifications with multiple TTS engines | [github.com/MasuRii/opencode-smart-voice-notify](https://github.com/MasuRii/opencode-smart-voice-notify) |
| opencode-quota | Track quota and token usage via toasts | [github.com/slkiser/opencode-quota](https://github.com/slkiser/opencode-quota) |
| opencode-mystatus | Check AI subscription quotas across providers | [github.com/vbgate/opencode-mystatus](https://github.com/vbgate/opencode-mystatus) |
| opencode-synced | Sync configurations across machines | [github.com/iHildy/opencode-synced](https://github.com/iHildy/opencode-synced) |
| opencode-model-announcer | Injects current model name into context | [github.com/ramarivera/opencode-model-announcer](https://github.com/ramarivera/opencode-model-announcer) |
| opencode-optimal-model-temps | Sets preferred sampling temperatures per model | [github.com/Lyapsus/opencode-optimal-model-temps](https://github.com/Lyapsus/opencode-optimal-model-temps) |

### Search and Browsing Plugins

Plugins that add web browsing, search, and content fetching capabilities.

| Plugin | Description | URL |
|--------|-------------|-----|
| opencode-browser | Automate Chrome with your real profile | [github.com/different-ai/opencode-browser](https://github.com/different-ai/opencode-browser) |
| Opencode-Google-AI-Search | Native Google AI Mode search tool | [github.com/IgorWarzocha/Opencode-Google-AI-Search-Plugin](https://github.com/IgorWarzocha/Opencode-Google-AI-Search-Plugin) |
| opencode-froggy | Hooks, agents, and tools including gitingest | [github.com/smartfrog/opencode-froggy](https://github.com/smartfrog/opencode-froggy) |

### Performance Plugins

Plugins that accelerate code editing and generation.

| Plugin | Description | URL |
|--------|-------------|-----|
| opencode-morph-fast-apply | 10,500+ tokens/sec code editing via Fast Apply API | [github.com/JRedeker/opencode-morph-fast-apply](https://github.com/JRedeker/opencode-morph-fast-apply) |

### Planning and Project Management Plugins

Plugins for strategic planning, issue tracking, and project coordination.

| Plugin | Description | URL |
|--------|-------------|-----|
| opencode-roadmap | Strategic planning and multi-agent coordination | [github.com/IgorWarzocha/Opencode-Roadmap](https://github.com/IgorWarzocha/Opencode-Roadmap) |
| opencode-pilot | Automation daemon polling GitHub issues and Linear tickets | [github.com/athal7/opencode-pilot](https://github.com/athal7/opencode-pilot) |
| opencode-beads | Integration for Steve Yegge's issue tracker | [github.com/joshuadavidthomas/opencode-beads](https://github.com/joshuadavidthomas/opencode-beads) |
| opencode-plugin-openspec | Architecture planning and specification agent | [github.com/Octane0411/opencode-plugin-openspec](https://github.com/Octane0411/opencode-plugin-openspec) |

### Skills Plugins

Plugins that manage and load dynamic skills (prompt-based commands).

| Plugin | Description | URL |
|--------|-------------|-----|
| opencode-agent-skills | Dynamic skills loading from project/user/plugin dirs | [github.com/joshuadavidthomas/opencode-agent-skills](https://github.com/joshuadavidthomas/opencode-agent-skills) |
| openskills | Alternative skills management system | [github.com/numman-ali/openskills](https://github.com/numman-ali/openskills) |
| opencode-skills | Manage and organize skills | [github.com/malhashemi/opencode-skills](https://github.com/malhashemi/opencode-skills) |

### Integration Plugins

Plugins that connect OpenCode with editors, containers, and environment tools.

| Plugin | Description | URL |
|--------|-------------|-----|
| opencode.nvim | Neovim integration | [github.com/nickjvandyke/opencode.nvim](https://github.com/nickjvandyke/opencode.nvim) |
| opencode-devcontainers | Multi-branch devcontainers with auto-assigned ports | [github.com/athal7/opencode-devcontainers](https://github.com/athal7/opencode-devcontainers) |
| opencode-direnv | Auto-loads direnv environment variables | [github.com/simonwjackson/opencode-direnv](https://github.com/simonwjackson/opencode-direnv) |

---

## How to Install Plugins

### Basic Installation

```bash
# Install a plugin by name (fetches from npm)
opencode plugin install <plugin-name>

# Example: Install the notification plugin
opencode plugin install opencode-notify

# Example: Install Oh My OpenCode
opencode plugin install oh-my-opencode
```

### Install from GitHub

```bash
# Install directly from a GitHub repository
opencode plugin install github:kdcokenny/opencode-worktree

# Install a specific version/tag
opencode plugin install opencode-notify@1.2.0
```

### List Installed Plugins

```bash
# View all installed plugins and their status
opencode plugin list
```

### Remove a Plugin

```bash
# Uninstall a plugin
opencode plugin remove <plugin-name>
```

### Update Plugins

```bash
# Update a specific plugin
opencode plugin update <plugin-name>

# Update all plugins
opencode plugin update --all
```

### Verify Installation

After installing a plugin, restart OpenCode (or start a new session). The plugin will be loaded automatically. You can verify by checking the startup logs or running:

```bash
opencode plugin list
```

Active plugins will show a status indicator confirming they are loaded and running.

---

## Plugin Configuration

Plugins are configured through JSON or JSONC files at two levels:

### Project-Level Configuration

Located at `.opencode/plugins.json` in your project root. Settings here apply only to the current project.

```jsonc
{
  // Project-specific plugin configuration
  "opencode-notify": {
    "enabled": true,
    "sound": true,
    "on_complete": true,
    "on_error": true
  },
  "opencode-ignore": {
    "patterns": [
      "node_modules/**",
      "dist/**",
      ".env*"
    ]
  }
}
```

### User-Level Configuration

Located at `~/.config/opencode/plugins.json`. Settings here apply globally across all projects.

```jsonc
{
  // Global plugin settings
  "opencode-quota": {
    "show_on_startup": true,
    "warning_threshold": 80  // Warn at 80% usage
  },
  "opencode-synced": {
    "sync_target": "github",
    "auto_sync": true
  }
}
```

### Configuration Precedence

Project-level settings override user-level settings. This lets you maintain sensible global defaults while customizing behavior per project.

---

## Building Your Own Plugin

### Getting Started

The fastest way to start is with the official plugin template:

```bash
# Clone the template
git clone https://github.com/zenobi-us/opencode-plugin-template my-plugin
cd my-plugin

# Install dependencies
npm install

# Start development
npm run dev
```

**Template repository:** <https://github.com/zenobi-us/opencode-plugin-template>

### Basic Plugin Structure

```
my-opencode-plugin/
  src/
    index.ts          # Main entry point - exports the plugin definition
    tools/            # Custom tools the agent can invoke
      my-tool.ts
    hooks/            # Event hooks (session start, tool call, etc.)
      on-session.ts
    agents/           # Custom agent definitions
      my-agent.ts
  package.json        # npm package with opencode plugin metadata
  tsconfig.json
  README.md
```

### Minimal Plugin Example

```typescript
// src/index.ts
import { definePlugin } from "@opencode/plugin-sdk";

export default definePlugin({
  name: "my-plugin",
  version: "1.0.0",
  description: "A minimal OpenCode plugin example",

  // Register tools the agent can call
  tools: [
    {
      name: "greet",
      description: "Returns a greeting message",
      parameters: {
        name: { type: "string", description: "Name to greet" },
      },
      execute: async ({ name }) => {
        return `Hello, ${name}! This response comes from my-plugin.`;
      },
    },
  ],

  // Register hooks for lifecycle events
  hooks: {
    onSessionStart: async (session) => {
      console.log(`[my-plugin] Session started: ${session.id}`);
    },
    onToolCall: async (tool, args) => {
      console.log(`[my-plugin] Tool called: ${tool.name}`);
    },
  },
});
```

### Development Workflow

```bash
# Build the plugin
npm run build

# Link locally for testing (makes it available to OpenCode)
npm link

# Install the linked plugin in OpenCode
opencode plugin install my-plugin --link

# Start OpenCode and test your plugin
opencode

# Watch mode for development (rebuild on changes)
npm run dev
```

### CI/CD Setup

The plugin template includes configurations for automated publishing:

1. **Generator:** Scaffolds new plugins with consistent structure
2. **Release Please:** Automates versioning and changelogs based on conventional commits
3. **npm Publishing:** GitHub Actions workflow that publishes to npm on release

```yaml
# .github/workflows/release.yml (included in template)
name: Release
on:
  push:
    branches: [main]

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: google-github-actions/release-please-action@v4
        id: release
      - uses: actions/checkout@v4
        if: ${{ steps.release.outputs.release_created }}
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          registry-url: https://registry.npmjs.org
      - run: npm ci && npm run build && npm publish
        if: ${{ steps.release.outputs.release_created }}
        env:
          NODE_AUTH_TOKEN: ${{ secrets.NPM_TOKEN }}
```

### Publishing Checklist

1. Ensure your `package.json` includes the `opencode-plugin` keyword
2. Add a clear README with installation and configuration instructions
3. Test the plugin locally with `opencode plugin install --link`
4. Push to GitHub and let Release Please manage versioning
5. After the first npm publish, submit to [awesome-opencode](https://github.com/awesome-opencode/awesome-opencode) for visibility

---

## Curated Resources

These community-maintained directories track the OpenCode plugin ecosystem:

- **awesome-opencode (GitHub):** <https://github.com/awesome-opencode/awesome-opencode>
  Community-curated list of plugins, tools, and resources organized by category.

- **awesome-opencode.com:** <https://awesome-opencode.com/>
  Searchable web interface for discovering plugins with ratings and reviews.

- **awesomeopencode.com (Extension Schema Registry):** <https://awesomeopencode.com/>
  Registry focused on plugin schemas and compatibility information.

- **OpenCode Official Plugin Docs:** <https://opencode.ai/docs/plugins/>
  Canonical reference for the plugin API, lifecycle hooks, and best practices.

- **Plugin Template:** <https://github.com/zenobi-us/opencode-plugin-template>
  Official starter template with CI/CD, testing, and publishing already configured.
