# [Tool Name] Tips & Tricks

## Keyboard Shortcuts

These shortcuts work during an interactive session:

| Shortcut | Action |
|----------|--------|
| `Ctrl+C` | Cancel the current operation |
| `Ctrl+D` | Exit the session |
| `Up/Down` | Navigate prompt history |
| `Tab` | Autocomplete commands and file paths |
| `[shortcut]` | [Description] |
| `[shortcut]` | [Description] |

## Advanced Features

### Context Management

Control what files [Tool Name] can see and reference:

```bash
# Include specific directories
[tool-name] --include "src/**" --include "tests/**"

# Exclude large or irrelevant directories
[tool-name] --exclude "node_modules/**" --exclude "dist/**"
```

### Conversation History

[Tool Name] maintains conversation history within a session. You can reference earlier context:

```
You: Look at the User model we discussed earlier and add an email validation method.
```

To start a fresh session with no history:
```bash
[tool-name] --new-session
```

### Custom System Prompts

Tailor [Tool Name]'s behavior with custom instructions:

```bash
# Use a system prompt file
[tool-name] --system-prompt ./.ai-instructions.md

# Inline system prompt
[tool-name] --system "You are a senior Python developer. Prefer type hints and dataclasses."
```

### Piping and Non-Interactive Use

Use [Tool Name] in scripts and pipelines:

```bash
# Pipe input
cat error.log | [tool-name] "Analyze these errors and suggest fixes"

# Use in a script
RESULT=$([tool-name] --no-interactive "Generate a regex for email validation")
echo "$RESULT"
```

### Multiple Models

Switch between models for different tasks:

```bash
# Use a faster model for simple tasks
[tool-name] --model [fast-model] "Rename this variable to camelCase"

# Use a more capable model for complex tasks
[tool-name] --model [advanced-model] "Refactor this module to use dependency injection"
```

## Integration

### Editor Integration

**VS Code:**
- Install the [Tool Name] extension from the marketplace.
- Open the command palette (`Ctrl+Shift+P`) and search for "[Tool Name]".

**Vim / Neovim:**
```vim
" Add to your init.vim or .vimrc
Plug '[tool-name]/vim-plugin'

" Usage: select code, then run
:'<,'>![tool-name] "Refactor this selection"
```

**JetBrains IDEs:**
- Go to Settings > Plugins > Marketplace.
- Search for "[Tool Name]" and install.

### Git Integration

Use [Tool Name] as part of your git workflow:

```bash
# Generate commit messages from staged changes
git diff --staged | [tool-name] "Write a conventional commit message for these changes"

# Review changes before pushing
git diff main...HEAD | [tool-name] "Review these changes for bugs or issues"
```

### CI/CD Integration

Run [Tool Name] in automated pipelines for code review:

```yaml
# Example GitHub Actions step
- name: AI Code Review
  run: |
    npm install -g [tool-package-name]
    git diff ${{ github.event.pull_request.base.sha }}..HEAD | \
      [tool-name] --no-interactive "Review for security issues and bugs"
```

## Performance Tips

### Speed Up Responses

- **Reduce context size:** Use `--include` and `--exclude` to limit which files are sent as context. Smaller context means faster responses.
- **Use a faster model:** For simple tasks like renaming or formatting, a smaller model responds more quickly.
- **Disable streaming** if you only need the final result:
  ```bash
  [tool-name] --no-stream "Your prompt"
  ```

### Reduce Token Usage

- Be specific in your prompts. "Add null checks to the processOrder function in src/orders.ts" is better than "Add error handling to the codebase."
- Use project-level configuration to set sensible default includes/excludes so irrelevant files are never sent.
- Break large tasks into smaller, focused requests.

### Working with Large Codebases

- Use `.gitignore`-aware context loading (enabled by default in most tools).
- Create a `.[tool-name].json` project config to define what the tool should index.
- Consider running [Tool Name] from a subdirectory to naturally limit scope:
  ```bash
  cd src/api && [tool-name] "Optimize the database queries in this module"
  ```

### Offline / Air-Gapped Environments

If you need to use [Tool Name] without internet access:
- [Describe any offline capabilities or local model support]
- [Describe how to pre-cache or pre-download required resources]
