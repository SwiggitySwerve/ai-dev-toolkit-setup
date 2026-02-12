# Claude Code Extensibility: Skills, Hooks, Plugins & Subagents

> Comprehensive guides for extending Claude Code beyond out-of-the-box capabilities. Covers the full extensibility surface: skills, hooks, plugins, subagents, and MCP servers.

---

## Why Extend Claude Code?

Claude Code ships with powerful defaults, but real-world workflows demand customization. You might need to:

- Enforce team coding standards automatically on every edit
- Bundle reusable workflows as slash commands your whole team shares
- Integrate external services (Jira, Figma, Sentry) directly into the agent loop
- Run deterministic validations that Claude must never skip
- Decompose complex tasks across specialized subagents

Claude Code provides five distinct extension mechanisms to handle these cases. Choosing the right one matters.

---

## Extension Types at a Glance

| Extension | What It Is | Deterministic? | Shareable? | Typical Use Case |
|-----------|-----------|:--------------:|:----------:|------------------|
| **Skills** | Markdown instruction files (SKILL.md) invoked as slash commands or injected as context | No (advisory) | Yes (plugin, git) | Workflows, domain knowledge, code review checklists |
| **Hooks** | Shell commands triggered at lifecycle events | Yes (guaranteed) | Yes (plugin, settings) | Auto-format, lint-on-save, block protected files, notifications |
| **Plugins** | Bundles of skills + hooks + MCP/LSP servers + subagents | N/A (container) | Yes (marketplace) | Distributing a complete integration (e.g., GitHub plugin, TypeScript LSP) |
| **Subagents** | Scoped Claude instances with limited tools and focused instructions | No (advisory) | Yes (plugin, project) | Parallel research, specialized analysis, task decomposition |
| **MCP Servers** | External tool servers exposing functions over the Model Context Protocol | Yes (tool calls) | Yes (plugin, config) | Database access, API integrations, file system extensions |

---

## Decision Matrix: Which Extension Should I Use?

Use this table to find the right mechanism for your goal:

| I want to... | Use | Why |
|--------------|-----|-----|
| Give Claude reusable instructions or a workflow | **Skill** | Advisory markdown that Claude follows when invoked |
| Guarantee a shell command runs on every file edit | **Hook** | Deterministic, cannot be skipped by the model |
| Block edits to certain files or directories | **Hook** (exit 2) | PreToolUse hook with exit code 2 blocks the action |
| Add a slash command for my team | **Skill** | User-invocable skills appear as `/skill-name` |
| Integrate an external API (Jira, Slack, etc.) | **MCP Server** | Exposes tools Claude can call; structured I/O |
| Add language intelligence (autocomplete, diagnostics) | **LSP Server** (via plugin) | Language Server Protocol integration |
| Break a big task into parallel subtasks | **Subagent** | Scoped agent with own context and tool permissions |
| Share a collection of extensions with my team | **Plugin** | Namespaced bundle installable from a marketplace |
| Run a linter/formatter after every code change | **Hook** (PostToolUse) | Deterministic post-edit command execution |
| Inject dynamic context (git diff, PR info) into a prompt | **Skill** with `!`command`` | Dynamic context injection runs shell commands at invocation |

---

## Guides in This Section

### [Skills Guide](skills-guide.md)

Everything about Claude Code skills: the SKILL.md format, frontmatter fields, dynamic context injection, invocation control, community skill sources, and best practices for authoring your own.

### [Hooks Guide](hooks-guide.md)

Complete reference for Claude Code hooks: lifecycle events, hook types (command, prompt, agent), exit code semantics, configuration locations, and practical examples for auto-formatting, file protection, notifications, and more.

### [Plugins Guide](plugins-guide.md)

How to install, create, and distribute Claude Code plugins: directory structure, the plugin.json manifest, installation scopes, the official marketplace, community marketplaces, and a step-by-step plugin creation walkthrough.

---

## Official Documentation

| Topic | URL |
|-------|-----|
| Skills | [code.claude.com/docs/en/skills](https://code.claude.com/docs/en/skills) |
| Plugins | [code.claude.com/docs/en/plugins](https://code.claude.com/docs/en/plugins) |
| Hooks | [code.claude.com/docs/en/hooks-guide](https://code.claude.com/docs/en/hooks-guide) |
| Subagents | [code.claude.com/docs/en/sub-agents](https://code.claude.com/docs/en/sub-agents) |
| Agent Skills Standard | [agentskills.io/specification](https://agentskills.io/specification) |
| Model Context Protocol | [modelcontextprotocol.io](https://modelcontextprotocol.io) |
| Claude Code Docs (general) | [docs.anthropic.com/en/docs/claude-code](https://docs.anthropic.com/en/docs/claude-code) |

---

## How They Fit Together

```
┌─────────────────────────────────────────────────────────────────┐
│                        PLUGIN BUNDLE                            │
│                                                                 │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌───────────────┐  │
│  │  Skills   │  │  Hooks   │  │Subagents │  │  MCP / LSP    │  │
│  │ SKILL.md  │  │hooks.json│  │agents/   │  │  Servers      │  │
│  │ /command  │  │lifecycle │  │scoped    │  │  .mcp.json    │  │
│  │ context   │  │determin. │  │parallel  │  │  .lsp.json    │  │
│  └──────────┘  └──────────┘  └──────────┘  └───────────────┘  │
│                                                                 │
│  Installed via:  /plugin install <name>                         │
│  Namespace:      /plugin-name:skill-name                        │
└─────────────────────────────────────────────────────────────────┘
         │                │               │              │
         ▼                ▼               ▼              ▼
   User invokes      Lifecycle       Task spawns     Claude calls
   /slash-command     triggers        subagent       MCP tool
```

A **plugin** is the distribution unit. It can contain any combination of the other four extension types. You can also use skills, hooks, subagents, and MCP servers independently without wrapping them in a plugin.

---

## Quick Start

**Add your first skill (30 seconds):**

```bash
mkdir -p .claude/skills/hello
cat > .claude/skills/hello/SKILL.md << 'EOF'
---
name: hello
description: Say hello and summarize the current project
---
Greet the user and give a brief summary of this project based on the README and directory structure.
EOF
```

Then type `/hello` in Claude Code.

**Add your first hook (30 seconds):**

Add to `.claude/settings.json`:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "command": "echo 'File modified: check formatting'"
      }
    ]
  }
}
```

Every file edit will now log a reminder. Replace the echo with `prettier --write $FILE` for real formatting.

---

## Prerequisites

- Claude Code installed and authenticated (see [Install Guides](../../tools/claude-code/))
- Basic familiarity with Claude Code's interactive mode
- A terminal and text editor

---

## Related Sections

- [Claude Code Overview](../../tools/claude-code/README.md)
- [Claude Code Configuration](../../tools/claude-code/configuration.md)
- [Claude Code Tips & Tricks](../../tools/claude-code/tips.md)
- [MCP Ecosystem Guide](../mcp-ecosystem/) (if available)
