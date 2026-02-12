# Getting Started with OpenCode

This guide walks you through your first session with OpenCode. You will learn how to launch the TUI, navigate its interface, and use it to accomplish real coding tasks.

## Prerequisites

Before starting, make sure you have:

1. **OpenCode installed** -- See the install guide for [macOS](install-macos.md), [Linux](install-linux.md), or [Windows](install-windows.md)
2. **At least one AI provider configured** -- See the [Configuration guide](configuration.md) for setting up API keys

Verify everything is ready:

```bash
opencode --version
```

---

## Launching OpenCode

### Start in your project directory

Navigate to the root of a project you want to work on, then run:

```bash
cd ~/my-project
opencode
```

OpenCode will start and automatically detect your project structure, including files, directories, and git status. It uses this context to give better answers about your codebase.

### Start with a specific directory

You can also point OpenCode at a directory without changing into it:

```bash
opencode --dir ~/my-project
```

### What you see on launch

When OpenCode starts, you will see the TUI (terminal user interface). It has several key areas:

```
+--------------------------------------------------+
|  OpenCode                          [model name]   |
+--------------------------------------------------+
|                                                    |
|  Conversation area                                 |
|  (messages between you and the AI appear here)     |
|                                                    |
|                                                    |
|                                                    |
+--------------------------------------------------+
|  > Type your message here...                       |
+--------------------------------------------------+
```

- **Top bar** -- Shows the OpenCode name, current model, and session info
- **Conversation area** -- The main panel where your conversation with the AI is displayed
- **Input area** -- Where you type your messages and prompts

---

## Your First Conversation

### Asking about your codebase

Type a question and press **Enter** to send it:

```
What does this project do? Give me a high-level overview.
```

OpenCode will scan your project files and provide a summary. This is a great way to orient yourself in an unfamiliar codebase.

### Asking for code explanations

```
Explain the main function in src/server.ts
```

OpenCode will read the file and explain what the code does in plain language.

### Making edits

```
Add error handling to the database connection function in src/db.ts
```

OpenCode will:
1. Read the current file
2. Show you the proposed changes
3. Apply the edits after your confirmation

When OpenCode proposes file edits, you will see a diff view showing what will change. You can approve or reject the changes.

### Running commands

```
Run the test suite and tell me about any failures
```

OpenCode can execute shell commands in your project. It will show you the command it wants to run and ask for confirmation before executing it.

---

## Navigating the TUI

### Essential keybindings

These keybindings work from the main conversation view:

| Key           | Action                              |
|--------------|-------------------------------------|
| `Enter`      | Send your message                   |
| `Ctrl+C`     | Cancel current generation / Exit    |
| `Ctrl+L`     | Clear the screen                    |
| `?` or `F1`  | Show help / keybindings             |
| `Tab`        | Cycle through UI panels             |
| `Esc`        | Go back / Close dialog              |

### Multi-line input

To type a multi-line message, use **Shift+Enter** (or the configured key) to create a new line without sending the message. Press **Enter** when you are ready to send.

### Scrolling through conversation history

Use the **arrow keys** or **Page Up / Page Down** to scroll through your conversation history. On some terminals, mouse scrolling also works.

---

## Working with Sessions

Sessions let you maintain separate conversation threads for different tasks. Each session has its own message history and context.

### Creating a new session

Use the session management keybinding (typically `Ctrl+N` or accessible through the command palette) to start a new session. Your previous session is preserved and you can return to it later.

### Switching between sessions

Use the session switcher (typically `Ctrl+S` or through the command palette) to see all your sessions and switch between them. Each session shows a preview of its conversation.

### Why use multiple sessions?

- **Task separation** -- Keep a debugging session separate from a feature development session
- **Context management** -- Each session maintains its own context, so switching tasks does not pollute your conversation history
- **Parallel work** -- Start a session for code review while keeping your implementation session active

---

## File Editing Workflow

OpenCode can edit files in your project. Here is the typical workflow:

### Step 1: Describe what you want

Be specific about what you want changed and where:

```
In src/utils/validation.ts, add a function called validateEmail that takes a string
and returns true if it is a valid email address. Use a regex pattern.
```

### Step 2: Review the proposed changes

OpenCode will show you a diff of the changes it wants to make. Review the diff carefully:

```diff
+ export function validateEmail(email: string): boolean {
+   const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
+   return emailRegex.test(email);
+ }
```

### Step 3: Approve or request modifications

If the changes look good, approve them. If you want adjustments, tell OpenCode what to change:

```
That looks good, but also add JSDoc comments to the function.
```

### Step 4: Verify the changes

After edits are applied, you can ask OpenCode to verify:

```
Run the TypeScript compiler to check for any type errors.
```

---

## Example Tasks

Here are some common tasks to try with OpenCode to get comfortable with its capabilities.

### Explaining code

```
Explain the authentication middleware in src/middleware/auth.ts.
What design patterns does it use?
```

### Writing tests

```
Write unit tests for the calculateDiscount function in src/pricing.ts.
Use Jest and cover edge cases like negative prices and discounts over 100%.
```

### Refactoring

```
Refactor src/api/handlers.ts to use async/await instead of .then() chains.
Keep the same functionality but make the code more readable.
```

### Debugging

```
I am getting a "Cannot read property 'map' of undefined" error when I run the app.
The error points to src/components/UserList.tsx line 42. Help me debug this.
```

### Adding features

```
Add a rate limiting middleware to the Express server in src/server.ts.
Use a sliding window approach with a limit of 100 requests per minute per IP.
```

### Code review

```
Review the changes in the last 3 git commits. Look for potential bugs,
security issues, and suggest improvements.
```

### Documentation

```
Generate JSDoc comments for all exported functions in src/utils/string-helpers.ts.
```

---

## Tips for Effective Prompting

### Be specific

Instead of "fix the bug", say "the login function in src/auth.ts returns undefined when the password is correct -- fix this so it returns the user object."

### Provide context

If OpenCode does not have enough context, give it more:

```
This project uses Express.js with TypeScript. The database is PostgreSQL
accessed through Prisma ORM. The frontend is React with Next.js.
Fix the API endpoint at /api/users that returns a 500 error.
```

### Iterate

You do not have to get everything right in one prompt. Start with a basic request and refine:

1. "Create a basic React component for a user profile card."
2. "Add a loading skeleton state to the component."
3. "Make the card responsive using Tailwind CSS."
4. "Add prop validation with TypeScript interfaces."

### Reference files directly

You can mention specific files and OpenCode will read them:

```
Look at the database schema in prisma/schema.prisma and create a
TypeScript interface that matches the User model.
```

---

## Exiting OpenCode

To exit OpenCode:

- Press **Ctrl+C** (you may need to press it twice if a generation is in progress)
- Or type `/quit` or `/exit` in the input area

Your session history is saved automatically, so you can pick up where you left off next time.

---

## Next Steps

Now that you know the basics, check out the [Tips and Tricks guide](tips.md) for advanced techniques including keybindings, LSP integration, MCP servers, and git workflow integration.
