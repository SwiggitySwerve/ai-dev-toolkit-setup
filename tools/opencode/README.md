# OpenCode

[OpenCode](https://github.com/opencode-ai/opencode) is an **open-source, terminal-based AI coding assistant** that brings powerful AI-assisted development directly into your terminal with a polished TUI (terminal user interface). If you prefer working in the terminal and want the flexibility to choose your own AI provider, OpenCode is an excellent choice.

## Why OpenCode?

Most AI coding assistants lock you into a single AI provider or require a GUI-based editor. OpenCode takes a different approach:

- **Open source and free** -- The tool itself costs nothing. You bring your own API keys (or use local models for zero cost).
- **Multi-provider support** -- Switch between AI providers without changing tools. OpenCode works with:
  - OpenAI (GPT-4o, GPT-4.1, o3, etc.)
  - Anthropic (Claude Sonnet, Claude Opus, etc.)
  - Google (Gemini 2.5 Pro, Gemini 2.5 Flash, etc.)
  - AWS Bedrock
  - Azure OpenAI
  - Local models via Ollama (Llama, Mistral, DeepSeek, etc.)
- **Terminal-native** -- No editor plugins or browser tabs required. Everything happens in your terminal.
- **Beautiful TUI** -- Unlike plain CLI tools, OpenCode provides a full terminal user interface with panels, syntax highlighting, and interactive navigation.

## Key Features

### File Editing
OpenCode can read, create, and modify files in your project. It understands your codebase context and makes targeted edits based on your instructions.

### Command Execution
Run shell commands directly through OpenCode. It can execute build scripts, run tests, install dependencies, and more -- all while explaining what each command does.

### LSP Integration
OpenCode integrates with Language Server Protocol (LSP) servers to provide intelligent code understanding. This means it can see diagnostics, errors, and type information from your project's language server, giving it deeper context about your code.

### MCP Support
Model Context Protocol (MCP) support lets you connect OpenCode to external tools and data sources. You can add MCP servers for databases, APIs, documentation, and more to extend what OpenCode can do.

### Multiple Sessions
Work on different tasks in separate sessions. Each session maintains its own conversation history, so you can context-switch between tasks without losing your place.

### Git-Aware
OpenCode understands your git repository structure and can help with commits, diffs, branch management, and code reviews.

## When to Use OpenCode

OpenCode is a great fit when:

- You want an **open-source** AI coding assistant with no vendor lock-in
- You need **provider flexibility** -- the ability to switch between OpenAI, Anthropic, Google, or local models
- You prefer working in the **terminal** rather than a GUI editor
- You want to use **local models** via Ollama for privacy or cost reasons
- You need **MCP support** for connecting to external tools and data sources
- You want a tool that works across **macOS, Linux, and Windows**

## When to Consider Alternatives

- If you want deep IDE integration, consider [GitHub Copilot](../copilot/README.md) or [Cursor](../cursor/README.md)
- If you need Anthropic-specific features with a polished CLI, consider [Claude Code](../claude-code/README.md)
- If you want a mature open-source CLI focused on pair programming, consider [Aider](../aider/README.md)

## Getting Started

Follow these guides in order:

### 1. Install OpenCode

Choose the guide for your operating system:

- [Install on macOS](install-macos.md)
- [Install on Linux](install-linux.md)
- [Install on Windows](install-windows.md)

### 2. [Configure OpenCode](configuration.md)

Set up your AI provider, API keys, model preferences, and optional features like MCP servers.

### 3. [Getting Started](getting-started.md)

Learn how to navigate the TUI, run your first prompts, and use OpenCode effectively in your projects.

### 4. [Tips and Tricks](tips.md)

Power-user techniques including keybindings, LSP integration, MCP servers, custom prompts, and git workflow integration.

## Links

- **GitHub Repository:** [https://github.com/opencode-ai/opencode](https://github.com/opencode-ai/opencode)
- **Website:** [https://opencode.ai](https://opencode.ai)
- **Documentation:** [https://opencode.ai/docs](https://opencode.ai/docs)

---

*Return to the main [AI Dev Toolkit Setup](../../README.md) guide to explore other tools.*
