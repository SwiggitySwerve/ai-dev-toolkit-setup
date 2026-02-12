# Claude Code Power User Tips

This guide covers advanced features, slash commands, workflow optimizations, and integrations that will help you get the most out of Claude Code.

---

## Slash Commands Reference

All slash commands are typed at the Claude Code prompt during an interactive session.

| Command | Description |
|---|---|
| `/help` | Display all available commands and usage information |
| `/clear` | Clear the entire conversation history and start fresh |
| `/compact` | Summarize and compress the conversation to free context space |
| `/model` | View the current model or switch to a different one |
| `/model <name>` | Switch to a specific model (e.g., `/model claude-opus-4-20250514`) |
| `/cost` | Display token usage and estimated cost for the current session |
| `/doctor` | Run diagnostics to check your Claude Code installation and configuration |
| `/permissions` | View and manage the permission system |
| `/mcp` | Show status of connected MCP servers and their tools |
| `/quit` or `/exit` | End the session |

### When to Use Each Command

- **`/compact`**: Use this when you are deep into a long session and notice Claude Code starting to lose context or repeat itself. It compresses the conversation into a summary, preserving key decisions while freeing up the context window.
- **`/doctor`**: Run this if something seems broken -- authentication issues, MCP servers not connecting, or unexpected behavior. It checks your Node.js version, authentication status, and server connectivity.
- **`/cost`**: Check this periodically during long sessions to stay aware of your usage, especially if you are on API billing.

---

## One-Shot Queries with --print

For quick questions that do not need an interactive session, use the `--print` (or `-p`) flag:

```bash
claude --print "What does the main function in src/index.ts do?"
```

```bash
claude -p "List all the API endpoints defined in this project"
```

This runs a single query, prints the result, and exits. No interactive session, no conversation history. Useful for:

- Quick code explanations
- Scripting and automation
- Getting answers without starting a full session

You can combine `--print` with other flags:

```bash
# Use a specific model for a one-shot query
claude -p --model claude-opus-4-20250514 "Review this codebase for security issues"
```

---

## Conversation Management

### Continue the Last Conversation

If you exited a session and want to pick up where you left off:

```bash
claude --continue
```

This restores the most recent conversation with its full history.

### Resume a Specific Conversation

```bash
claude --resume
```

This shows a list of past conversations and lets you select one to resume. Useful when you have been working on multiple features or projects.

### Starting Fresh

If your conversation has gotten cluttered or you want to change direction:

```
/clear
```

Or simply exit and start a new session:

```bash
claude
```

---

## CLAUDE.md Best Practices

The `CLAUDE.md` file is your most powerful tool for getting consistent, project-aware results. Here are tips for writing effective project context files.

### Structure Your CLAUDE.md

```markdown
# Project Name

## Quick Reference
- Language: TypeScript 5.3
- Framework: Next.js 14 (App Router)
- Package Manager: pnpm
- Node Version: 20 LTS

## Architecture Overview
[Brief description of how the project is organized]

## Key Commands
- `pnpm dev` -- start dev server
- `pnpm test` -- run tests
- `pnpm lint` -- lint code
- `pnpm build` -- production build

## Coding Conventions
[Your team's specific rules and preferences]

## Do NOT
[Things Claude Code should avoid doing]
```

### Use "Do NOT" Sections

Explicitly tell Claude Code what to avoid:

```markdown
## Do NOT
- Do not modify anything in the /generated/ directory
- Do not use default exports; always use named exports
- Do not add console.log statements; use the logger from src/lib/logger
- Do not install new dependencies without asking first
```

### Subdirectory CLAUDE.md Files

Place focused instructions in subdirectories:

```
project/
  CLAUDE.md                  # General project context
  src/
    components/
      CLAUDE.md              # "All components must use CSS modules, not inline styles"
    api/
      CLAUDE.md              # "All endpoints must validate input with Zod schemas"
```

---

## Piping Input to Claude Code

Claude Code accepts piped input, making it composable with other Unix tools:

```bash
# Explain a file
cat src/complex-algorithm.ts | claude -p "Explain this code step by step"

# Review a diff
git diff | claude -p "Review these changes for bugs and suggest improvements"

# Analyze logs
cat error.log | claude -p "What is causing these errors?"

# Explain a command's output
npm audit | claude -p "Summarize the vulnerabilities and suggest fixes"

# Process multiple files
find src -name "*.test.ts" -exec cat {} + | claude -p "What test patterns are used in this project?"
```

You can also pipe Claude Code's output:

```bash
# Save Claude's explanation to a file
claude -p "Explain the auth flow" > docs/auth-explanation.txt

# Use Claude's output in another command
claude -p "Generate a .gitignore for a Node.js TypeScript project" > .gitignore
```

---

## IDE and Editor Integrations

### VS Code

Claude Code can be used alongside VS Code in several ways:

1. **VS Code Terminal**: Open the integrated terminal (`` Ctrl+` ``) and run `claude` directly. This is the simplest approach.

2. **Claude Code Extension**: Anthropic provides an official VS Code extension that integrates Claude Code into the editor with a dedicated panel.

3. **Side-by-Side Workflow**: Keep VS Code open for browsing and editing while running Claude Code in a separate terminal. Claude Code edits files on disk, and VS Code picks up changes automatically.

> **Tip**: Enable VS Code's "Auto Save" feature (`File > Auto Save`) when working with Claude Code so your editor always shows the latest state of files.

### Vim / Neovim

Claude Code works naturally alongside terminal-based editors:

1. **Split Panes**: Use tmux or a tiling terminal to run Claude Code in one pane and vim/neovim in another.

2. **Quick Queries**: From vim, you can run Claude Code commands without leaving your editor:

   ```vim
   :!claude -p "Explain the function under cursor"
   ```

3. **Pipe Selections**: Send selected code to Claude Code for explanation:

   ```vim
   :'<,'>!claude -p "Refactor this to use async/await"
   ```

4. **Terminal Buffer**: In Neovim, use `:terminal claude` to open an interactive Claude Code session in a buffer.

---

## Headless / CI Mode

Claude Code can run non-interactively for automation, CI/CD pipelines, and scripting.

### Basic Headless Usage

```bash
# Run a single task and exit
claude -p "Generate a changelog from the last 10 commits" > CHANGELOG.md
```

### In CI/CD Pipelines

```yaml
# Example GitHub Actions step
- name: AI Code Review
  env:
    ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
  run: |
    npm install -g @anthropic-ai/claude-code
    git diff origin/main...HEAD | claude -p "Review this PR diff. Flag any bugs, security issues, or style violations." > review.md
```

### Accepting All Permissions Automatically

For fully automated pipelines where no human is present, use the `--dangerously-skip-permissions` flag:

```bash
claude --dangerously-skip-permissions -p "Fix all lint errors and commit"
```

> **Warning**: This flag bypasses all permission checks. Only use it in controlled CI/CD environments, never on your local machine with untrusted code. The flag name is intentionally alarming.

---

## Cost Management Tips

### Monitor Usage

Check your session cost regularly:

```
/cost
```

### Use the Right Model

- **Sonnet** (default): Fast and cost-effective. Handles 90% of coding tasks well.
- **Opus**: More expensive but more capable. Reserve for complex architectural decisions and nuanced refactors.

```
/model claude-sonnet-4-20250514
```

### Use /compact to Manage Context

Long conversations consume more tokens. Use `/compact` periodically to compress the conversation:

```
/compact
```

This reduces the token count of subsequent requests by summarizing earlier parts of the conversation.

### Use --print for Quick Queries

Every interactive session carries overhead from loading the conversation history. For quick questions, use `--print` to avoid that overhead:

```bash
claude -p "What is the return type of fetchUsers in src/api.ts?"
```

### Batch Related Changes

Instead of making many small requests, batch related changes together:

```
# Less efficient (multiple requests, each loading context)
claude> Add a name field to the User type
claude> Add validation for name in createUser
claude> Add name to the user creation form
claude> Add a test for name validation

# More efficient (single request, one context load)
claude> Add a "name" field to the User type, add validation for it in
        createUser, update the user creation form to include it, and
        add tests for the name validation.
```

---

## Useful Patterns

### Exploratory Analysis

When joining a new project:

```
claude> Give me a high-level overview of this codebase. What is it,
        how is it structured, and what are the key technologies?
```

```
claude> What are the main entry points? How does a request flow through
        the system?
```

```
claude> Are there any obvious code smells or architectural concerns?
```

### Test Generation

```
claude> Look at the existing tests in this project for style and patterns.
        Then generate tests for src/services/payment.ts following those
        same patterns.
```

### Migration Assistance

```
claude> We need to migrate from Express to Fastify. Analyze the current
        Express setup and create a migration plan. Then start with the
        main app.ts file.
```

### Documentation Generation

```
claude> Generate JSDoc comments for all exported functions in
        src/utils/ that don't already have documentation.
```

### Code Review

```bash
git diff main | claude -p "Review this diff. Focus on:
1. Bugs or logic errors
2. Security issues
3. Performance concerns
4. Missing error handling
5. Style consistency"
```

---

## Troubleshooting Quick Reference

| Issue | Solution |
|---|---|
| Claude Code seems to forget context | Use `/compact` to compress, or start a new session |
| Responses are slow | Check your internet connection; try `/model claude-sonnet-4-20250514` for faster responses |
| Permission prompts are annoying | Type **a** (always allow) for safe operations like file reads |
| MCP server not connecting | Run `/doctor` then `/mcp` to diagnose; check your MCP config JSON for syntax errors |
| Claude Code suggests incorrect file paths | Make sure you are running from the project root |
| High token usage | Use `/compact` regularly; batch related requests; use `--print` for quick queries |
| Authentication expired | Run `claude` and go through the OAuth flow again, or check your API key |

---

## Further Reading

- [Official Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code/overview)
- [Model Context Protocol Specification](https://modelcontextprotocol.io)
- [MCP Server Directory](https://github.com/modelcontextprotocol/servers)
- [Claude Code README](README.md)
- [Configuration Guide](configuration.md)
- [Getting Started Guide](getting-started.md)
