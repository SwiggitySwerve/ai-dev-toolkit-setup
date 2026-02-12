# Getting Started with Claude Code

This guide walks you through your first Claude Code session, basic commands, and a typical development workflow.

---

## Starting Claude Code

Navigate to your project directory and run:

```bash
cd /path/to/your/project
claude
```

Claude Code starts an interactive session. It reads your project structure and is ready for instructions.

You will see a prompt where you can type natural language requests:

```
claude>
```

> **Tip**: Always run Claude Code from the root of your project so it has the best context about your codebase.

---

## Basic Prompting

Claude Code understands natural language. You do not need special syntax -- just describe what you want.

### Asking Questions About Your Code

```
claude> What does the handleAuth function in src/auth.ts do?
```

```
claude> Explain the database schema in this project.
```

```
claude> How are API routes organized in this codebase?
```

Claude Code reads the relevant files and gives you a detailed answer.

### Requesting Changes

```
claude> Add input validation to the createUser endpoint in src/api/users.ts
```

```
claude> Refactor the logger module to use Winston instead of console.log
```

```
claude> Create a new React component called UserProfile that displays name, email, and avatar
```

Claude Code will:
1. Read the relevant files to understand context.
2. Plan the changes.
3. Show you what it wants to modify.
4. Wait for your approval before writing to disk.

### Multi-File Operations

Claude Code excels at changes that span multiple files:

```
claude> Rename the User model to Account across the entire codebase,
        including all imports, type references, and database queries.
```

```
claude> Add error handling to all API route handlers. Use the AppError
        class from src/utils/errors.ts and add try-catch blocks where missing.
```

---

## Common Slash Commands

Slash commands control Claude Code's behavior. Type them at the prompt:

| Command | Description |
|---|---|
| `/help` | Show all available commands and usage information |
| `/clear` | Clear the conversation history and start fresh |
| `/compact` | Condense the conversation to save context window space |
| `/model` | View or change the current model |
| `/cost` | Show token usage and estimated cost for this session |
| `/permissions` | View and manage the permission system |

### Examples

```
claude> /help
```

```
claude> /model claude-opus-4-20250514
```

```
claude> /cost
```

```
claude> /compact
```

> **Tip**: Use `/compact` when you notice Claude Code losing context in a long conversation. It summarizes the conversation so far, freeing up the context window for new information.

---

## Understanding the Permission System

Claude Code uses a permission system to keep you in control. When it wants to perform an action, it asks for your approval:

### Permission Categories

- **Read files**: Claude Code reads files to understand your codebase. This is generally safe.
- **Write files**: Claude Code wants to create or modify a file. It shows you the diff before writing.
- **Execute commands**: Claude Code wants to run a shell command (e.g., `npm install`, `git commit`). It shows you the command first.

### Responding to Permission Requests

When Claude Code asks for permission, you can:

- **y** (yes) -- Allow this specific action.
- **n** (no) -- Deny this action.
- **a** (always) -- Allow this type of action for the rest of the session.

Example interaction:

```
Claude wants to edit src/api/users.ts:

  + import { validateEmail } from '../utils/validation';

    export async function createUser(req, res) {
  +   if (!validateEmail(req.body.email)) {
  +     return res.status(400).json({ error: 'Invalid email' });
  +   }
      // ... existing code

Allow this edit? [y/n/a]
```

> **Tip**: Use **a** (always allow) for file reads early in a session to avoid repeated prompts. Be more selective with write and execute permissions.

---

## Reviewing and Accepting Changes

When Claude Code proposes file changes, it shows a diff-style view:

- Lines starting with `+` (green) are additions.
- Lines starting with `-` (red) are deletions.
- Surrounding lines provide context.

**Before accepting**, review the changes carefully:

1. Does the code look correct?
2. Does it follow your project's coding standards?
3. Are there any unintended side effects?

If you are unsure about a change, you can ask Claude Code to explain:

```
claude> Why did you add that null check on line 42?
```

Or request modifications:

```
claude> Looks good, but use a guard clause instead of wrapping everything in an if block.
```

---

## Working with Git Integration

Claude Code understands git and can help with your version control workflow.

### Viewing Status

```
claude> What files have I changed since the last commit?
```

```
claude> Show me the current git diff.
```

### Creating Commits

```
claude> Commit the changes to src/api/users.ts with an appropriate message.
```

Claude Code will:
1. Stage the relevant files.
2. Generate a descriptive commit message.
3. Ask for your approval before committing.

### Working with Branches

```
claude> Create a new branch called feature/user-validation and switch to it.
```

```
claude> What commits are on this branch that aren't on main?
```

### Pull Request Descriptions

```
claude> Generate a pull request description for the current branch compared to main.
```

Claude Code examines all the commits and changes on your branch and writes a comprehensive PR description.

---

## Example Workflow: Fixing a Bug

Here is a complete example of using Claude Code to find and fix a bug:

```
claude> Users are reporting that the password reset email is not being sent.
        Can you find the relevant code and identify the issue?
```

Claude Code reads the relevant files and identifies the problem:

```
I found the issue. In src/services/email.ts, the sendPasswordReset function
has a conditional check on line 47 that accidentally inverts the logic...
```

```
claude> Fix the bug.
```

Claude Code proposes the fix, shows the diff, and waits for approval.

```
claude> Add a test for this fix to make sure it doesn't regress.
```

Claude Code creates a test file or adds to an existing test suite.

```
claude> Run the tests to make sure everything passes.
```

Claude Code executes your test command and reports results.

```
claude> Commit the fix and the test with an appropriate message.
```

Claude Code creates a commit with a clear message like: `fix: correct inverted condition in password reset email logic`.

---

## Example Workflow: Adding a Feature

```
claude> I need to add a rate limiting middleware to our Express API.
        It should limit each IP to 100 requests per 15 minutes.
        Use express-rate-limit.
```

Claude Code will:
1. Check if `express-rate-limit` is already installed.
2. If not, offer to install it (`npm install express-rate-limit`).
3. Create the middleware file.
4. Integrate it into your Express app setup.
5. Add appropriate types if using TypeScript.

```
claude> Add tests for the rate limiter.
```

```
claude> Commit everything.
```

---

## Tips for Effective Prompting

1. **Be specific**: "Add input validation to the createUser function" is better than "improve the code."
2. **Provide context**: "We use Zod for validation in this project" helps Claude Code match your patterns.
3. **Iterate**: Start with the main change, then refine. "Now add error handling" or "Also update the tests."
4. **Reference files**: "Look at src/api/orders.ts for how we handle validation there" helps Claude Code follow existing patterns.
5. **Ask questions first**: If you are unsure where to start, ask Claude Code to explain the relevant code before requesting changes.

---

## Next Steps

- [Power User Tips](tips.md) -- Slash commands, headless mode, MCP, and more.
- [Configuration](configuration.md) -- CLAUDE.md files, model selection, MCP setup.
