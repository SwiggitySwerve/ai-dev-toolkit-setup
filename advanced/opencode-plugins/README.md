# OpenCode Plugin Ecosystem

This section covers the OpenCode extension ecosystem -- how to discover, install, configure, and build plugins that extend OpenCode's capabilities far beyond its defaults.

---

## OpenCode Plugin Architecture Overview

OpenCode exposes a plugin system that lets third-party packages hook into the agent lifecycle. Plugins can:

- **Add tools** the agent can call (e.g., browser automation, search, notifications)
- **Modify agent behavior** by injecting system prompts, overriding models, or adjusting temperatures
- **Register hooks** that fire on events like session start, tool execution, or message completion
- **Integrate external services** such as MCPs, vector databases, issue trackers, and CI/CD pipelines
- **Bundle orchestration layers** that coordinate multiple sub-agents for complex workflows

Plugins are published to npm and installed through OpenCode's built-in plugin management commands. They follow a standardized interface that grants access to OpenCode internals while maintaining isolation between extensions.

---

## Sub-Guides

| Guide | Description |
|-------|-------------|
| [plugins-guide.md](./plugins-guide.md) | Comprehensive reference -- finding, installing, and developing OpenCode plugins. Covers 60+ plugins across 13 categories. |
| [oh-my-opencode.md](./oh-my-opencode.md) | Deep dive into Oh My OpenCode, the batteries-included orchestration layer with agents, hooks, MCPs, and background tasks. |

---

## Quick Comparison: OpenCode Plugins vs Claude Code Skills

| Aspect | OpenCode Plugins | Claude Code Skills |
|--------|------------------|--------------------|
| **Scope** | Full lifecycle hooks, tools, agents, MCPs, UI modifications | Prompt-based slash commands that inject context and instructions |
| **Installation** | `opencode plugin install <name>` (npm packages) | Markdown files in `.claude/commands/` or `~/.claude/commands/` |
| **Development** | TypeScript/JavaScript with plugin API, published to npm | Plain markdown with optional `$ARGUMENTS` templating |
| **Capabilities** | Can modify agent behavior, intercept events, add tools, manage background tasks | Inject system prompts, structure workflows, chain tool usage |
| **Complexity** | Higher -- requires understanding the plugin lifecycle and API surface | Lower -- write markdown, save to the right directory, done |
| **Distribution** | npm registry, GitHub repositories | Copy files, share repos, or embed in project `.claude/` directories |
| **Runtime** | Executes code in the OpenCode process with access to internals | Interpreted as additional context/instructions by the model |
| **Composability** | Plugins can depend on and interact with other plugins | Skills are independent; composition is manual |

In general, Claude Code skills are simpler and more accessible for prompt-engineering workflows, while OpenCode plugins offer deeper integration for teams that need programmatic control over the agent's behavior and tooling.

---

## Official Resources

- **OpenCode Plugin Documentation:** <https://opencode.ai/docs/plugins/>
- **awesome-opencode (GitHub):** <https://github.com/awesome-opencode/awesome-opencode>
- **awesome-opencode.com:** <https://awesome-opencode.com/>
- **awesomeopencode.com (Extension Schema Registry):** <https://awesomeopencode.com/>

---

## Getting Started

If you are new to OpenCode plugins, start with the [plugins-guide.md](./plugins-guide.md) to understand the ecosystem and pick plugins relevant to your workflow. If you want a fully managed setup with orchestration, agents, and hooks out of the box, jump to [oh-my-opencode.md](./oh-my-opencode.md).
