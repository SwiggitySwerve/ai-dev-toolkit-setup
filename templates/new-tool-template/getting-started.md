# Getting Started with [Tool Name]

## First Run

After [installing](README.md#installation) and [configuring](configuration.md) [Tool Name], launch it for the first time:

```bash
[tool-name]
```

On first run, [Tool Name] will:
1. [Describe what happens on first launch, e.g., prompt for API key]
2. [Create default configuration files]
3. [Any other first-run behavior]

## Basic Usage

### Starting a Session

```bash
# Start an interactive session in the current directory
[tool-name]

# Start with a specific prompt
[tool-name] "Explain the architecture of this project"

# Start in a specific directory
[tool-name] --directory /path/to/project
```

### Core Commands

Once inside an interactive session:

| Command | Description |
|---------|-------------|
| `[command-1]` | [Description of command 1] |
| `[command-2]` | [Description of command 2] |
| `[command-3]` | [Description of command 3] |
| `exit` or `quit` | End the session |

### Getting Help

```bash
# View all available commands
[tool-name] --help

# Get help for a specific command
[tool-name] [command] --help
```

## Common Workflows

### Workflow 1: [Code Review / Explanation]

Use [Tool Name] to understand unfamiliar code:

```bash
[tool-name] "Review this file and explain the key patterns used"
```

Example output:
```
[Show realistic example output]
```

### Workflow 2: [Code Generation / Editing]

Ask [Tool Name] to make changes to your codebase:

```bash
[tool-name] "Add error handling to the API client in src/api.ts"
```

[Tool Name] will:
1. Read the relevant files
2. Propose changes
3. [Ask for confirmation / apply directly, depending on tool behavior]

### Workflow 3: [Debugging / Troubleshooting]

When you hit an error:

```bash
[tool-name] "I'm getting a TypeError on line 42 of src/main.py. Help me fix it."
```

### Workflow 4: [Documentation / Tests]

Generate documentation or tests:

```bash
[tool-name] "Write unit tests for src/utils.ts"
```

## Example Session

Here is a complete example session to illustrate typical usage:

```
$ [tool-name]

[Tool Name] v1.x.x
> What would you like to do?

You: Summarize this project structure and tell me where the main entry point is.

[Tool Name]: Looking at the project structure...

  [Realistic example of tool output showing project analysis]

You: Add input validation to the createUser function in src/users.ts

[Tool Name]: I'll add input validation. Here are the changes:

  [Realistic example of tool output showing proposed changes]

You: Looks good, apply those changes.

[Tool Name]: Changes applied to src/users.ts.

You: exit
```

## Next Steps

Now that you know the basics:

- Read [Tips & Tricks](tips.md) for keyboard shortcuts and power-user features
- Explore [Configuration](configuration.md) to customize [Tool Name] to your workflow
- Check the official [Tool Name] documentation for the full command reference
