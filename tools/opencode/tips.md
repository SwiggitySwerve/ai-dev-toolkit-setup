# OpenCode Tips and Tricks

This guide covers advanced techniques and power-user features that will help you get the most out of OpenCode. Read through the [Getting Started guide](getting-started.md) first if you have not already.

---

## Keybindings Reference

OpenCode's TUI uses keybindings for fast navigation. Here is a comprehensive reference.

### General

| Key            | Action                                   |
|---------------|------------------------------------------|
| `Enter`       | Send message                             |
| `Shift+Enter` | New line in input (without sending)      |
| `Ctrl+C`      | Cancel generation / Exit                 |
| `Ctrl+L`      | Clear screen                             |
| `Esc`         | Close dialog / Go back                   |
| `?` or `F1`   | Show help                                |

### Navigation

| Key            | Action                                   |
|---------------|------------------------------------------|
| `Tab`         | Cycle through panels                     |
| `Up/Down`     | Scroll conversation                      |
| `Page Up`     | Scroll up one page                       |
| `Page Down`   | Scroll down one page                     |
| `Home`        | Scroll to top                            |
| `End`         | Scroll to bottom                         |

### Sessions

| Key            | Action                                   |
|---------------|------------------------------------------|
| `Ctrl+N`      | New session                              |
| `Ctrl+S`      | Session switcher                         |

### Model and Provider

| Key            | Action                                   |
|---------------|------------------------------------------|
| `Ctrl+M`      | Open model selector                      |

> **Note:** Keybindings may vary between versions. Press `?` or `F1` within OpenCode to see the current keybindings for your version.

---

## Using LSP Integration

Language Server Protocol (LSP) integration gives OpenCode deeper understanding of your code by connecting it to the same language intelligence that powers your editor's autocomplete, go-to-definition, and error checking.

### What LSP provides

When LSP is active, OpenCode can see:

- **Diagnostics** -- Compiler errors, warnings, and linting issues in your code
- **Type information** -- Function signatures, variable types, and interface definitions
- **Symbol references** -- Where functions and variables are used across your codebase
- **Code structure** -- Class hierarchies, module exports, and dependency relationships

### How it works

OpenCode automatically detects and connects to LSP servers that are available on your system. Common language servers include:

| Language     | LSP Server             | Install Command                            |
|-------------|------------------------|-------------------------------------------|
| TypeScript  | `typescript-language-server` | `npm install -g typescript-language-server typescript` |
| Python      | `pyright`              | `npm install -g pyright`                  |
| Go          | `gopls`                | `go install golang.org/x/tools/gopls@latest` |
| Rust        | `rust-analyzer`        | Included with `rustup component add rust-analyzer` |
| C/C++       | `clangd`               | Install via your package manager          |

### Installing a language server

To enable LSP for your project, install the appropriate language server:

```bash
# For a TypeScript/JavaScript project
npm install -g typescript-language-server typescript

# For a Python project
npm install -g pyright
# or
pip install python-lsp-server

# For Go
go install golang.org/x/tools/gopls@latest
```

Once installed, OpenCode will detect the language server automatically the next time you start it in a project using that language.

### Leveraging LSP in prompts

When LSP is active, you can ask OpenCode about compiler errors directly:

```
What errors does the TypeScript compiler see in this project? Fix them.
```

```
Are there any unused imports or variables that the linter is flagging?
```

OpenCode will use LSP diagnostics to provide accurate, up-to-date information about your code's health.

---

## MCP Servers for Extended Functionality

MCP (Model Context Protocol) servers are plugins that extend what OpenCode can do. They connect OpenCode to external tools, databases, APIs, and more.

### Finding MCP servers

Browse available MCP servers at:
- [MCP Server Registry](https://github.com/modelcontextprotocol/servers)
- [Awesome MCP Servers](https://github.com/punkpeye/awesome-mcp-servers)

### Useful MCP server setups

#### Web search

Give OpenCode the ability to search the web for documentation and solutions:

```json
{
  "mcpServers": {
    "brave-search": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-brave-search"],
      "env": {
        "BRAVE_API_KEY": "${BRAVE_API_KEY}"
      }
    }
  }
}
```

#### Database access

Let OpenCode query your development database to understand your schema and data:

```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_CONNECTION_STRING": "postgresql://user:pass@localhost:5432/mydb"
      }
    }
  }
}
```

#### GitHub integration

Connect OpenCode to your GitHub repositories for issues, PRs, and code:

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  }
}
```

Then you can ask things like:

```
List the open issues on this repository and summarize them.
```

```
Create a pull request with my current changes. Title it "Add user validation" and
write a description based on the diff.
```

#### Persistent memory

Give OpenCode memory that persists across sessions:

```json
{
  "mcpServers": {
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"]
    }
  }
}
```

### Running MCP servers with Docker

For better isolation, you can run MCP servers in Docker containers:

```json
{
  "mcpServers": {
    "postgres": {
      "command": "docker",
      "args": [
        "run", "--rm", "-i",
        "-e", "POSTGRES_CONNECTION_STRING=postgresql://user:pass@host.docker.internal:5432/mydb",
        "mcp/postgres"
      ]
    }
  }
}
```

---

## Working with Multiple Sessions

Sessions are one of OpenCode's most underappreciated features. Used well, they dramatically improve your workflow.

### Session strategies

#### Task-based sessions

Create a session for each distinct task:
- **Session 1:** "Implement user authentication"
- **Session 2:** "Fix pagination bug on /products"
- **Session 3:** "Write API documentation"

This keeps each conversation focused and prevents context from bleeding between unrelated tasks.

#### Role-based sessions

Use different sessions for different "modes" of work:
- **Code session:** For writing and editing code
- **Review session:** For code reviews and refactoring suggestions
- **Debug session:** For troubleshooting issues
- **Docs session:** For generating documentation

#### Exploration sessions

Start a throwaway session when you want to explore an idea without cluttering your main session:

```
I want to experiment with a different approach to the caching layer.
Let me try using Redis instead of in-memory cache. Walk me through it.
```

If the exploration pans out, you can implement it in your main session. If not, just leave the exploration session behind.

### Session management tips

- **Name your sessions** with descriptive titles so you can find them later
- **Close completed sessions** to keep the session list manageable
- **Start fresh** when you change tasks -- it is better to have many focused sessions than one long unfocused one

---

## Provider Switching Mid-Conversation

OpenCode lets you switch AI providers or models during a conversation. This is useful when:

- You want a **faster model** for simple questions (Gemini Flash, GPT-4o-mini) and a **stronger model** for complex reasoning (Claude Opus, o3)
- You hit a **rate limit** on one provider and want to continue with another
- You want to **compare answers** from different models

### How to switch

Press `Ctrl+M` (or the configured key) to open the model selector. Choose a different model and your next message will use that model. The conversation context is preserved.

### Strategy: tiered model usage

A cost-effective approach:

1. **Start with a fast, cheap model** (e.g., Gemini Flash, GPT-4o-mini) for initial exploration, file reading, and simple questions
2. **Switch to a strong model** (e.g., Claude Opus, o3) for complex code generation, architectural decisions, and debugging difficult issues
3. **Switch back to the fast model** for follow-up questions, cleanup, and documentation

---

## Custom System Prompts

Custom system prompts shape how OpenCode behaves throughout a session. Use them to set coding standards, specify technologies, and provide project context.

### Project-level instructions

Create a `.opencode` file in your project root:

```
Project: E-commerce API
Stack: Node.js, TypeScript, Express, Prisma, PostgreSQL

Coding standards:
- Use functional programming patterns where possible
- All functions must have JSDoc comments
- Use zod for runtime validation
- Error handling must use custom error classes from src/errors/
- Database queries go through the repository pattern in src/repositories/
- API responses follow the format: { success: boolean, data?: T, error?: string }

Testing:
- Write tests using Vitest
- Aim for >80% code coverage on new code
- Use factory functions from tests/factories/ for test data
```

### Role-specific prompts

You can change OpenCode's behavior by describing a role:

```
You are a senior security engineer reviewing this codebase. Focus on:
- SQL injection vulnerabilities
- XSS attack vectors
- Authentication and authorization flaws
- Secrets management issues
- Dependency vulnerabilities

For each issue found, rate its severity (critical/high/medium/low) and
provide a concrete fix.
```

### Framework-specific prompts

Tailor OpenCode to your specific framework:

```
This is a Next.js 14 project using the App Router. Key conventions:
- Server Components by default, "use client" only when needed
- Data fetching in Server Components using fetch with revalidation
- Server Actions for mutations
- Metadata API for SEO
- Route handlers in app/api/ for API endpoints
- Tailwind CSS for styling, no CSS modules
```

---

## Integration with Git Workflows

OpenCode is git-aware and can help with many git-related tasks.

### Commit messages

```
Look at the staged changes (git diff --cached) and write a conventional
commit message for them.
```

### Code review

```
Show me the diff between the main branch and this branch. Review the changes
for bugs, security issues, and code quality. Be thorough.
```

### Branch management

```
What branches exist in this repo? Which ones have been merged into main
and can be safely deleted?
```

### Resolving merge conflicts

```
I have merge conflicts in src/config.ts. Show me the conflicts and help
me resolve them by keeping the most complete version of each conflicting section.
```

### Pre-commit workflow

A useful workflow is to ask OpenCode to review your changes before committing:

1. Make your code changes
2. Ask OpenCode: "Review my staged changes. Look for bugs, missing error handling, and suggest improvements."
3. Address any issues
4. Ask OpenCode to write a commit message
5. Commit

---

## Performance Tips

### Keep context focused

OpenCode works best when the conversation is focused on a specific task. If your conversation gets long and unfocused:

- Start a new session for a new task
- Be specific about which files you want OpenCode to look at
- Avoid asking unrelated questions in the same session

### Use the right model for the task

- **Quick questions and simple edits:** Use a fast model (GPT-4o-mini, Gemini Flash)
- **Complex code generation:** Use a strong model (Claude Opus, GPT-4.1, Gemini 2.5 Pro)
- **Large codebase analysis:** Use a model with a large context window (Gemini 2.5 Pro with 1M tokens)

### Terminal performance

- Use a modern terminal emulator (Windows Terminal, Kitty, Alacritty, WezTerm, Ghostty) for the best TUI rendering performance
- If the TUI feels sluggish, try reducing your terminal's scrollback buffer
- A Nerd Font improves the visual experience but is not required

---

## Useful Command Patterns

Here are some prompt patterns that work well across different projects.

### "Explain then fix" pattern

```
Explain what this function does, then fix the bug where it returns
null instead of an empty array when there are no results.
```

### "Test-first" pattern

```
Write a failing test for the feature I am about to describe, then
implement the feature to make the test pass: [describe feature]
```

### "Refactor with constraints" pattern

```
Refactor the UserService class to use dependency injection instead of
direct imports. Keep the same public API so nothing else needs to change.
```

### "Audit" pattern

```
Audit src/api/ for any endpoints that do not validate their input.
List each one with the file, line number, and what validation is missing.
```

### "Teach me" pattern

```
I do not understand how the event system in src/events/ works.
Walk me through it step by step, starting from when an event is emitted
to when it is handled.
```

---

## Staying Up to Date

OpenCode is actively developed. To keep up with new features:

- **Watch the GitHub repo:** [github.com/opencode-ai/opencode](https://github.com/opencode-ai/opencode)
- **Update regularly:**
  ```bash
  # Homebrew
  brew update && brew upgrade opencode

  # Scoop
  scoop update opencode

  # Go
  go install github.com/opencode-ai/opencode@latest

  # Shell script
  curl -fsSL https://opencode.ai/install | bash
  ```

- **Check the changelog** on the GitHub releases page for breaking changes before updating

---

*Return to the [OpenCode overview](README.md) or the main [AI Dev Toolkit Setup](../../README.md) guide.*
