# Claude Code

## What Is Claude Code?

Claude Code is the **official command-line interface (CLI) tool from Anthropic** that brings Claude directly into your terminal. It is an agentic coding assistant that understands your entire codebase, can edit multiple files simultaneously, run commands, manage git workflows, and integrate with external tools through the Model Context Protocol (MCP).

Unlike browser-based AI assistants or inline code completions, Claude Code operates as a full-featured terminal agent. You describe what you want in natural language, and it reads files, proposes changes, executes commands, and iterates -- all within your existing development workflow.

## Key Features

- **Agentic Coding**: Claude Code does not just suggest snippets. It reads your codebase, plans multi-step changes, edits files, runs tests, and fixes errors autonomously.
- **Multi-File Editing**: It can create, modify, and delete multiple files in a single interaction, understanding cross-file dependencies.
- **Git Integration**: Built-in understanding of git. It can create commits, review diffs, manage branches, and generate pull request descriptions.
- **MCP Support**: Connect Claude Code to external tools and data sources through the Model Context Protocol -- databases, APIs, documentation systems, and more.
- **Permission System**: A granular permission model lets you control what Claude Code can do (read files, write files, execute commands) so you stay in control.
- **Project Context via CLAUDE.md**: Drop a `CLAUDE.md` file in your project root to give Claude persistent instructions, coding standards, and architectural context.
- **Conversation Management**: Resume previous conversations, continue where you left off, or run one-shot queries for quick answers.
- **Cost Transparency**: Built-in cost tracking so you always know how much you are spending.

## When to Use Claude Code

| Scenario | Best Tool | Why |
|---|---|---|
| Complex refactoring across many files | **Claude Code** | Agentic multi-file editing with codebase understanding |
| Quick inline completions while typing | **GitHub Copilot** | Optimized for real-time tab completions in-editor |
| General Q&A, brainstorming, non-code tasks | **ChatGPT / Claude.ai** | Browser-based, broad knowledge, no terminal needed |
| Debugging with full project context | **Claude Code** | Can read files, run tests, and iterate on fixes |
| Writing commit messages, PR descriptions | **Claude Code** | Native git integration |
| Learning a new language or concept | **ChatGPT / Claude.ai** | Conversational, no project setup required |
| CI/CD automation, scripted AI tasks | **Claude Code** | Headless mode, piping support, non-interactive execution |
| IDE-integrated AI with GUI | **Cursor / Copilot Chat** | Tighter IDE integration with visual diff review |

**In short**: Use Claude Code when you want an AI agent that operates in your terminal, understands your full project, and can take autonomous multi-step actions. Use browser-based assistants for conversational learning and quick questions. Use Copilot for real-time inline completions.

## Official Documentation

- **Anthropic Documentation**: [https://docs.anthropic.com/en/docs/claude-code/overview](https://docs.anthropic.com/en/docs/claude-code/overview)
- **GitHub Repository**: [https://github.com/anthropics/claude-code](https://github.com/anthropics/claude-code)
- **npm Package**: [https://www.npmjs.com/package/@anthropic-ai/claude-code](https://www.npmjs.com/package/@anthropic-ai/claude-code)
- **Model Context Protocol (MCP)**: [https://modelcontextprotocol.io](https://modelcontextprotocol.io)
- **Anthropic API Console**: [https://console.anthropic.com](https://console.anthropic.com)

## Installation Guides

Choose the guide for your operating system:

- [Install on macOS](install-macos.md)
- [Install on Linux](install-linux.md)
- [Install on Windows](install-windows.md)

## Next Steps

- [Configuration and Authentication](configuration.md) -- Set up your API key, project files, and preferences.
- [Getting Started](getting-started.md) -- Your first session with Claude Code.
- [Power User Tips](tips.md) -- Slash commands, MCP servers, headless mode, and more.
