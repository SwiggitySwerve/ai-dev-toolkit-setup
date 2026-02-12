# Oh My OpenCode: In-Depth Guide

A comprehensive guide to Oh My OpenCode -- the batteries-included orchestration layer that transforms OpenCode into a fully managed, multi-agent development environment.

---

## Table of Contents

1. [What is Oh My OpenCode](#what-is-oh-my-opencode)
2. [Installation](#installation)
3. [Configuration](#configuration)
4. [Agent Architecture](#agent-architecture)
5. [Built-in Skills](#built-in-skills)
6. [Hooks System](#hooks-system)
7. [Built-in MCP Servers](#built-in-mcp-servers)
8. [Background Tasks](#background-tasks)
9. [tmux Integration](#tmux-integration)
10. [Advanced Features](#advanced-features)
11. [Oh My OpenCode Slim](#oh-my-opencode-slim)
12. [Official Resources](#official-resources)

---

## What is Oh My OpenCode

> "If OpenCode is Debian/Arch, Oh My OpenCode is Ubuntu/Omarchy."

Oh My OpenCode (OMOC) is a batteries-included orchestration layer that wraps OpenCode and provides a complete, opinionated development environment out of the box. Where raw OpenCode gives you building blocks and expects you to assemble them, Oh My OpenCode delivers a fully configured setup with agents, hooks, skills, MCPs, and background task management ready to go.

**Key characteristics:**

- **Heavily influenced by AmpCode and Claude Code** -- features from both have been ported and improved upon
- **Multi-agent orchestration** with a planning hierarchy (Sisyphus, Prometheus, Metis)
- **25+ built-in hooks** that automate common development tasks
- **Built-in MCP servers** for web search, documentation, and code search
- **Background task execution** with concurrency limits per provider and model
- **Domain-specific categories** for delegating tasks to specialized agents
- **tmux integration** for terminal layout management
- **JSONC configuration** with sensible defaults and granular overrides

**Links:**

- **Official Site:** <https://ohmyopencode.com/>
- **GitHub:** <https://github.com/code-yeongyu/oh-my-opencode>
- **Documentation:** <https://ohmyopencode.com/documentation/>

---

## Installation

### Prerequisites

- OpenCode installed and working
- Node.js 18+ or Bun runtime
- (Optional) tmux for terminal layout features
- (Optional) Active subscriptions to Claude, ChatGPT, and/or Gemini

### Install Oh My OpenCode

```bash
# Option 1: Install via bunx (recommended)
bunx oh-my-opencode install

# Option 2: Install globally via npm
npm install -g oh-my-opencode

# Option 3: Install as a project dependency
npm install --save-dev oh-my-opencode
```

### Launch

```bash
# Start OpenCode -- Oh My OpenCode activates automatically as a plugin
opencode
```

On first launch, you will be guided through initial setup:

1. **Select subscriptions:** Choose which AI providers you have active subscriptions for (Claude, ChatGPT, Gemini)
2. **GitHub Copilot prompt:** When asked about GitHub Copilot, select "Yes" if you want access to additional models through that integration
3. **Configuration file:** OMOC creates a default configuration file you can customize

### Verify Installation

```bash
# Check that Oh My OpenCode is loaded
opencode plugin list

# You should see oh-my-opencode in the active plugins list
# The startup banner will also indicate OMOC is active
```

---

## Configuration

Oh My OpenCode uses JSONC (JSON with Comments) configuration files, which support inline comments and trailing commas for a more developer-friendly editing experience.

### Configuration File Locations

| Level | Path | Scope |
|-------|------|-------|
| **Project** | `.opencode/oh-my-opencode.json` | Current project only |
| **User** | `~/.config/opencode/oh-my-opencode.json` | All projects (global defaults) |

Both files are auto-created on first use with sensible defaults.

### Configuration Precedence

Project-level settings override user-level settings. This lets you maintain global preferences while customizing per project.

### Key Configuration Options

```jsonc
{
  // ============================================================
  // Agent Configuration
  // ============================================================
  "agents": {
    "sisyphus": {
      "model": "claude-sonnet-4-20250514",  // Main orchestrator model
      "temperature": 0.3,
      "system_prompt_append": "",  // Extra instructions for this agent
      "permissions": {
        "file_write": true,
        "shell_execute": true,
        "browser": false
      }
    },
    "prometheus": {
      "model": "claude-sonnet-4-20250514",  // Planner model
      "temperature": 0.5
    },
    "metis": {
      "model": "gemini-2.5-pro",  // Plan consultant model
      "temperature": 0.4
    }
  },

  // ============================================================
  // Hook Management
  // ============================================================
  "hooks": {
    // Disable specific hooks by name
    "disabled_hooks": [
      "comment_checker",    // Disable TODO/FIXME comment enforcement
      "think_mode"          // Disable extended thinking prompts
    ]
  },

  // ============================================================
  // MCP Server Configuration
  // ============================================================
  "mcps": {
    "websearch": {
      "enabled": true,
      "provider": "exa",        // Exa-powered web search
      "api_key_env": "EXA_API_KEY"
    },
    "context7": {
      "enabled": true           // Documentation lookup
    },
    "grep_app": {
      "enabled": true           // GitHub code search
    }
  },

  // ============================================================
  // Background Tasks
  // ============================================================
  "background": {
    "concurrency": {
      "claude": 3,              // Max concurrent Claude tasks
      "openai": 2,              // Max concurrent OpenAI tasks
      "gemini": 5               // Max concurrent Gemini tasks
    },
    "timeout_minutes": 30,      // Kill tasks after this duration
    "persist_context": true     // Save context between background runs
  },

  // ============================================================
  // tmux Integration
  // ============================================================
  "tmux": {
    "enabled": true,
    "layout": "main-vertical",  // tmux layout algorithm
    "main_pane_width": "60%",   // Width of the primary pane
    "canvas_pane_height": "40%" // Height for canvas panes
  },

  // ============================================================
  // Categories (domain-specific task delegation)
  // ============================================================
  "categories": {
    "frontend": {
      "patterns": ["src/components/**", "src/pages/**", "*.css", "*.tsx"],
      "agent": "sisyphus",
      "model_override": "claude-sonnet-4-20250514"
    },
    "backend": {
      "patterns": ["src/api/**", "src/services/**", "*.py"],
      "agent": "sisyphus"
    },
    "infrastructure": {
      "patterns": ["terraform/**", "docker/**", "*.yaml"],
      "agent": "prometheus"
    }
  }
}
```

---

## Agent Architecture

Oh My OpenCode implements a three-tier agent hierarchy inspired by Greek mythology. Each agent has a distinct role in the planning and execution pipeline.

### The Agent Hierarchy

```
                    +------------------+
                    |     Sisyphus     |
                    | Main Orchestrator|
                    +--------+---------+
                             |
              +--------------+--------------+
              |                             |
    +---------+----------+       +----------+---------+
    |    Prometheus       |       |      Metis         |
    |   Planner Agent     |       |  Plan Consultant   |
    +---------------------+       +--------------------+
```

### Sisyphus (Main Orchestrator)

Sisyphus is the primary agent that the user interacts with. It receives tasks, decides whether planning is needed, delegates to sub-agents, executes tools, and delivers results.

**Responsibilities:**
- Receives and interprets user requests
- Delegates to Prometheus when a task requires strategic planning
- Executes tools (file operations, shell commands, browser automation)
- Manages the overall workflow and reports progress
- Handles error recovery and retries

**Configuration:**
```jsonc
{
  "agents": {
    "sisyphus": {
      "model": "claude-sonnet-4-20250514",
      "temperature": 0.3,
      "max_tokens": 8192
    }
  }
}
```

### Prometheus (Planner)

Prometheus is invoked by Sisyphus when a task is complex enough to require upfront planning. It analyzes the codebase, identifies dependencies, and produces a structured execution plan.

**Responsibilities:**
- Analyzes task complexity and codebase structure
- Creates step-by-step execution plans with dependencies
- Identifies risks, edge cases, and prerequisites
- Passes the plan to Metis for review before execution begins

**When Prometheus activates:**
- Multi-file refactoring tasks
- New feature implementation spanning several components
- Architecture changes with cross-cutting concerns
- Any task Sisyphus determines benefits from upfront planning

### Metis (Plan Consultant)

Metis reviews the plans generated by Prometheus. It acts as a second opinion, checking for gaps, risks, and improvements before Sisyphus begins execution.

**Responsibilities:**
- Reviews execution plans from Prometheus
- Identifies missing steps, incorrect assumptions, or risky approaches
- Suggests improvements and alternative strategies
- Approves the plan or requests revisions

**Why a separate consultant:**
Using a different model (e.g., Gemini for Metis while Prometheus uses Claude) provides diverse perspectives and catches blind spots that a single model might miss.

### Workflow Example

```
User: "Refactor the authentication module to support OAuth2"

1. Sisyphus receives the request
2. Sisyphus determines this is complex -> delegates to Prometheus
3. Prometheus analyzes the auth module, creates a 7-step plan
4. Prometheus sends the plan to Metis for review
5. Metis identifies a missing step (token refresh handling) and suggests an improvement
6. Prometheus revises the plan and sends it back to Metis
7. Metis approves the revised plan
8. Sisyphus receives the approved plan and begins execution
9. Sisyphus executes each step, using tools as needed
10. Sisyphus reports completion with a summary of changes
```

---

## Built-in Skills

Oh My OpenCode ships with pre-configured skills that Sisyphus can invoke.

### Playwright (Browser Automation)

Automates Chrome/Chromium for web interaction tasks.

```
/playwright "Navigate to localhost:3000 and take a screenshot of the dashboard"
```

**Capabilities:**
- Navigate to URLs, click elements, fill forms
- Take screenshots and analyze page content
- Wait for elements, handle dynamic loading
- Execute JavaScript in the browser context

### Git Master (Atomic Commits)

Manages git operations with a focus on clean, atomic commits.

```
/git-master "Create atomic commits for all the changes in the auth refactor"
```

**Capabilities:**
- Analyzes staged and unstaged changes
- Groups related changes into logical, atomic commits
- Generates descriptive commit messages following conventional commit format
- Handles interactive staging for partial file commits

---

## Hooks System

Oh My OpenCode includes 25+ built-in hooks that automate common tasks. Hooks fire on specific lifecycle events and can be individually enabled or disabled.

### Notable Hooks

| Hook | Event | Description |
|------|-------|-------------|
| **Ralph Loop** | On task completion | Validation loop that checks if the output meets requirements before reporting done |
| **Todo Enforcer** | On session start / file save | Scans for TODO/FIXME comments and reminds the agent to address them |
| **Comment Checker** | On code generation | Ensures generated code includes appropriate comments and documentation |
| **Think Mode** | On complex task detection | Prompts the agent to use extended thinking before executing complex operations |
| **Safety Guard** | On shell command | Intercepts potentially destructive commands for confirmation |
| **Context Pruner** | On context growth | Removes stale tool outputs to keep the context window efficient |

### Disabling Hooks

```jsonc
{
  "hooks": {
    "disabled_hooks": [
      "todo_enforcer",
      "comment_checker",
      "think_mode"
    ]
  }
}
```

### Hook Execution Order

Hooks execute in a defined order based on their event type. Multiple hooks on the same event run sequentially in priority order. You can adjust priority in configuration:

```jsonc
{
  "hooks": {
    "priority_overrides": {
      "safety_guard": 1,    // Runs first (lowest number = highest priority)
      "ralph_loop": 10,     // Runs later
      "think_mode": 5       // Runs in between
    }
  }
}
```

---

## Built-in MCP Servers

Oh My OpenCode bundles three MCP (Model Context Protocol) servers that provide the agent with external data access.

### Websearch (Exa)

Provides web search capabilities powered by the Exa API.

```bash
# Set your Exa API key
export EXA_API_KEY="your-key-here"
```

**Use cases:** Looking up documentation, researching libraries, finding solutions to errors.

### Context7 (Documentation)

Fetches and injects relevant documentation for libraries and frameworks detected in the project.

**Use cases:** Automatically provides API docs for packages in `package.json` or `requirements.txt`, reducing hallucination on API usage.

### grep_app (GitHub Code Search)

Searches GitHub repositories for code patterns and examples.

**Use cases:** Finding usage examples of APIs, discovering how other projects solve similar problems, locating relevant open-source implementations.

### MCP Configuration

```jsonc
{
  "mcps": {
    "websearch": {
      "enabled": true,
      "provider": "exa",
      "api_key_env": "EXA_API_KEY"
    },
    "context7": {
      "enabled": true,
      "auto_detect": true  // Automatically detect project dependencies
    },
    "grep_app": {
      "enabled": true,
      "max_results": 10
    }
  }
}
```

---

## Background Tasks

Oh My OpenCode supports background task execution, allowing the agent to work on multiple tasks concurrently with configurable limits per provider.

### How It Works

1. Tasks are queued and assigned to available model slots
2. Each provider has a configurable concurrency limit
3. Context is persisted between background runs (optional)
4. Tasks respect a timeout to prevent runaway execution
5. Results are collected and reported when the user returns attention

### Configuration

```jsonc
{
  "background": {
    "concurrency": {
      "claude": 3,       // Up to 3 concurrent Claude tasks
      "openai": 2,       // Up to 2 concurrent OpenAI tasks
      "gemini": 5        // Up to 5 concurrent Gemini tasks
    },
    "timeout_minutes": 30,
    "persist_context": true,
    "notify_on_complete": true  // Uses opencode-notify if installed
  }
}
```

### Example Usage

```
User: "Run tests for all three services in the background"

Sisyphus queues:
  - Background task 1 (Claude): Run and fix auth-service tests
  - Background task 2 (Claude): Run and fix api-gateway tests
  - Background task 3 (Claude): Run and fix user-service tests

All three execute concurrently within the Claude concurrency limit of 3.
Results are reported as each task completes.
```

---

## tmux Integration

Oh My OpenCode integrates with tmux to manage terminal layouts, enabling split-pane workflows where the agent, logs, and interactive canvases coexist.

### Setup

```bash
# Ensure tmux is installed
# macOS
brew install tmux

# Ubuntu/Debian
sudo apt install tmux

# Start OpenCode within tmux
tmux new-session -s opencode
opencode
```

### Configuration

```jsonc
{
  "tmux": {
    "enabled": true,
    "layout": "main-vertical",
    "main_pane_width": "60%",
    "canvas_pane_height": "40%",
    "auto_create_session": true  // Auto-create tmux session if not in one
  }
}
```

### Layout Options

| Layout | Description |
|--------|-------------|
| `main-vertical` | Primary pane on the left, secondary panes stacked on the right |
| `main-horizontal` | Primary pane on top, secondary panes below |
| `tiled` | Equal-sized panes in a grid |
| `even-vertical` | All panes stacked vertically with equal height |
| `even-horizontal` | All panes side-by-side with equal width |

---

## Advanced Features

### Ralph Loop

The Ralph Loop is a validation mechanism that runs after the agent completes a task. It re-examines the output against the original requirements and asks: "Did this actually accomplish what was asked?" If the answer is no, the agent automatically retries or adjusts.

This prevents the common failure mode where an agent declares a task complete but has missed edge cases, broken tests, or misunderstood the requirement.

### Todo Enforcer

Scans the codebase on session start and after code generation for TODO, FIXME, HACK, and XXX comments. The agent is reminded to address them before marking work as complete. This keeps technical debt from accumulating during AI-assisted development.

### Comment Checker

Validates that generated code includes appropriate comments. Configurable to enforce different standards:

```jsonc
{
  "hooks": {
    "comment_checker": {
      "require_function_docs": true,
      "require_complex_logic_comments": true,
      "max_uncommented_lines": 20
    }
  }
}
```

### Think Mode

When a complex task is detected (multi-file changes, architecture decisions, or unfamiliar patterns), Think Mode prompts the agent to use extended reasoning before executing. This results in better plans and fewer mistakes on complex work.

### Categories

Categories let you define domain-specific rules based on file patterns. When the agent works on files matching a category's patterns, it can use a different model, agent, or set of permissions.

```jsonc
{
  "categories": {
    "security": {
      "patterns": ["**/auth/**", "**/security/**", "**/*crypto*"],
      "model_override": "claude-opus-4-20250514",
      "require_review": true
    },
    "tests": {
      "patterns": ["**/*.test.*", "**/*.spec.*", "**/tests/**"],
      "model_override": "claude-haiku-4-20250514",
      "temperature": 0.2
    }
  }
}
```

---

## Oh My OpenCode Slim

For teams that want the orchestration benefits of Oh My OpenCode but are concerned about token consumption, **oh-my-opencode-slim** provides a lightweight alternative.

### What is Slim

Oh My OpenCode Slim strips out the heavier features (extended planning cycles, multiple consultation rounds, verbose hook outputs) while keeping the core orchestration, agent hierarchy, and essential hooks.

**GitHub:** <https://github.com/alvinunreal/oh-my-opencode-slim>

### Full vs Slim Comparison

| Feature | Full | Slim |
|---------|------|------|
| Agent hierarchy (Sisyphus/Prometheus/Metis) | Full 3-tier with consultation | 2-tier (Sisyphus + lightweight planner) |
| Built-in hooks | 25+ | ~10 essential hooks |
| MCP servers | 3 bundled | Optional, user-configured |
| Background tasks | Full concurrency management | Basic background support |
| Token overhead per session | Higher (richer prompts, more rounds) | 40-60% lower token usage |
| Ralph Loop | Full validation loop | Simplified single-pass check |
| Think Mode | Extended reasoning prompts | Disabled by default |
| tmux integration | Full layout management | Basic split support |

### When to Use Each

**Use Oh My OpenCode (Full) when:**
- You have generous API quotas or unlimited plans
- Tasks are complex and benefit from multi-round planning
- You want the full safety net of all hooks and validation
- You are working on large codebases with multiple domains

**Use Oh My OpenCode Slim when:**
- You are on metered API plans and need to control costs
- Tasks are mostly straightforward (single-file changes, bug fixes)
- You want orchestration without the token overhead
- You prefer to add features selectively rather than disable them

### Installation

```bash
# Install Slim instead of Full
bunx oh-my-opencode-slim install

# OR
npm install -g oh-my-opencode-slim
```

The configuration format is identical -- switching between full and slim requires only changing the installed package.

---

## Official Resources

| Resource | URL |
|----------|-----|
| Official Website | <https://ohmyopencode.com/> |
| Documentation | <https://ohmyopencode.com/documentation/> |
| Configuration Guide | <https://ohmyopencode.com/configuration/> |
| Installation Guide | <https://ohmyopencode.com/installation/> |
| GitHub Repository | <https://github.com/code-yeongyu/oh-my-opencode> |
| Slim Version (GitHub) | <https://github.com/alvinunreal/oh-my-opencode-slim> |
| OpenCode Plugin Docs | <https://opencode.ai/docs/plugins/> |
