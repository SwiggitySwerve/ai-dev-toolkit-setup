# Claude Code Hooks Guide

> How to use Claude Code hooks to run deterministic shell commands at lifecycle events -- guaranteeing actions that Claude cannot skip.

---

## Table of Contents

- [What Are Hooks?](#what-are-hooks)
- [Hooks vs Skills: When to Use Which](#hooks-vs-skills-when-to-use-which)
- [Hook Events Reference](#hook-events-reference)
- [Hook Types](#hook-types)
- [Exit Code Semantics](#exit-code-semantics)
- [Hook Input (JSON on stdin)](#hook-input-json-on-stdin)
- [Configuration Locations](#configuration-locations)
- [Practical Examples](#practical-examples)
- [Advanced Patterns](#advanced-patterns)
- [Debugging Hooks](#debugging-hooks)
- [Best Practices](#best-practices)

---

## What Are Hooks?

Hooks are **deterministic shell commands** that execute at specific points in Claude Code's lifecycle. Unlike skills (which are advisory -- Claude can choose to follow or ignore them), hooks are **guaranteed to run** every time their trigger event occurs.

Use hooks when you need to:

- **Guarantee** that code is formatted after every edit
- **Block** modifications to protected files or directories
- **Validate** inputs before Claude processes them
- **Notify** external systems when events occur
- **Inject** context that must always be present
- **Audit** every tool call Claude makes

### Key Properties

- **Deterministic**: They run every time, no exceptions. Claude does not decide whether to run them.
- **Synchronous**: The lifecycle event waits for the hook to complete before proceeding.
- **Composable**: Multiple hooks can be attached to the same event.
- **Scoped**: Hooks can be global (personal), project-level, or plugin-provided.

---

## Hooks vs Skills: When to Use Which

| Requirement | Use a Hook | Use a Skill |
|-------------|:----------:|:-----------:|
| Must always execute (no exceptions) | Yes | |
| Claude should decide when to apply | | Yes |
| Needs to block/gate an action | Yes | |
| Provides instructions or workflows | | Yes |
| Runs a shell command at a lifecycle point | Yes | |
| Provides domain knowledge or context | | Yes |
| User invokes via slash command | | Yes |
| Triggered by an internal Claude Code event | Yes | |

**Rule of thumb**: If the action MUST happen, use a hook. If Claude should CHOOSE when to apply it, use a skill.

---

## Hook Events Reference

Claude Code exposes the following lifecycle events:

| Event | When It Fires | Common Use Cases |
|-------|--------------|------------------|
| **SessionStart** | At the beginning of a Claude Code session | Load environment, inject standing context, set up temp files |
| **SessionEnd** | When a session terminates | Cleanup temp files, save session state, send analytics |
| **UserPromptSubmit** | After the user submits a prompt, before Claude processes it | Validate input, inject extra context, modify prompt |
| **PreToolUse** | Before Claude executes any tool call | Block dangerous operations, validate tool inputs, log tool usage |
| **PostToolUse** | After a tool call completes successfully | Auto-format edited files, run linters, update indexes |
| **PostToolUseFailure** | After a tool call fails | Retry logic, error reporting, fallback actions |
| **PermissionRequest** | When Claude requests permission to use a tool | Custom approval workflows, audit logging |
| **Notification** | When Claude Code emits a notification | Desktop notifications, Slack alerts, sound alerts |
| **SubagentStart** | When a subagent is spawned | Log subagent creation, inject subagent-specific context |
| **SubagentStop** | When a subagent completes | Collect subagent results, cleanup subagent resources |
| **Stop** | When Claude finishes generating a response | Post-response validation, output formatting |
| **TeammateIdle** | When a teammate agent becomes idle | Load-balancing, task reassignment |
| **TaskCompleted** | When a delegated task finishes | Aggregate results, trigger follow-up tasks |
| **PreCompact** | Before context compaction occurs | Save important context, inject must-keep information |

---

## Hook Types

Hooks support three execution types:

### 1. Command Hook (Default)

Runs a shell command directly.

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "command": "prettier --write \"$CLAUDE_FILE_PATH\""
      }
    ]
  }
}
```

### 2. Prompt Hook

Performs a single-turn LLM evaluation. Uses a fast model (Haiku by default) to evaluate a condition or transform content. The LLM does not have tool access.

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "type": "prompt",
        "prompt": "Does this user prompt contain any requests to delete production data or drop database tables? Respond with ONLY 'yes' or 'no'.",
        "exitOnYes": 2
      }
    ]
  }
}
```

### 3. Agent Hook

Spawns a multi-turn subagent with tool access. The subagent can read files, run commands, and make multiple tool calls to complete its task.

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "type": "agent",
        "prompt": "Check if the edited file has any TypeScript errors. If so, fix them.",
        "allowedTools": ["Read", "Edit", "Bash"]
      }
    ]
  }
}
```

---

## Exit Code Semantics

The exit code of a hook command determines what happens next:

| Exit Code | Meaning | Behavior |
|:---------:|---------|----------|
| **0** | Success / Allow | The action proceeds normally. For `UserPromptSubmit` and `SessionStart`, stdout is added to the conversation context. |
| **2** | Block / Reject | The action is **blocked**. Stderr is sent back to Claude as feedback (Claude sees why the action was rejected). |
| **Other** (1, 3, etc.) | Error / Warning | The action proceeds anyway. Stderr is logged for debugging but does not block. |

### Exit Code 0: Proceed and Inject

```bash
#!/bin/bash
# SessionStart hook: inject project context
echo "This project uses TypeScript strict mode. Always use explicit types."
echo "Test framework: Vitest. Run tests with: npm test"
exit 0
```

The echoed text becomes part of Claude's context for the session.

### Exit Code 2: Block the Action

```bash
#!/bin/bash
# PreToolUse hook: block edits to protected files
FILE="$1"
if [[ "$FILE" == *"migrations/"* ]] || [[ "$FILE" == *".env"* ]]; then
  echo "BLOCKED: Cannot modify $FILE. Migration files and .env are protected." >&2
  exit 2
fi
exit 0
```

Claude receives the stderr message and adjusts its approach.

### Other Exit Codes: Warn but Continue

```bash
#!/bin/bash
# PostToolUse hook: warn if lint fails but don't block
eslint "$1" 2>&1 || echo "Lint warnings detected (non-blocking)" >&2
exit 0
```

---

## Hook Input (JSON on stdin)

Hooks receive a JSON object on stdin containing context about the triggering event. The exact fields vary by event, but the base structure is:

```json
{
  "session_id": "abc123-def456",
  "cwd": "/home/user/project",
  "hook_event_name": "PreToolUse",
  "tool_name": "Edit",
  "tool_input": {
    "file_path": "/home/user/project/src/main.ts",
    "old_string": "const x = 1",
    "new_string": "const x = 2"
  }
}
```

### Reading Hook Input in a Script

**Bash:**

```bash
#!/bin/bash
# Read JSON from stdin
INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name')
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

if [[ "$TOOL_NAME" == "Edit" ]] && [[ "$FILE_PATH" == *"protected/"* ]]; then
  echo "Cannot edit files in the protected/ directory" >&2
  exit 2
fi
exit 0
```

**Python:**

```python
#!/usr/bin/env python3
import json, sys

data = json.load(sys.stdin)
tool = data.get("tool_name", "")
file_path = data.get("tool_input", {}).get("file_path", "")

if tool == "Edit" and "/migrations/" in file_path:
    print("Migration files are read-only", file=sys.stderr)
    sys.exit(2)
```

**PowerShell:**

```powershell
$input_json = $input | ConvertFrom-Json
$toolName = $input_json.tool_name
$filePath = $input_json.tool_input.file_path

if ($toolName -eq "Edit" -and $filePath -match "protected") {
    Write-Error "Cannot edit protected files"
    exit 2
}
exit 0
```

### Event-Specific Fields

| Event | Additional Fields |
|-------|------------------|
| `PreToolUse` / `PostToolUse` | `tool_name`, `tool_input`, `tool_output` (PostToolUse only) |
| `UserPromptSubmit` | `user_prompt` |
| `Notification` | `notification_type`, `notification_message` |
| `SubagentStart` / `SubagentStop` | `subagent_id`, `subagent_name` |
| `SessionStart` | `session_type` (e.g., `"new"`, `"continue"`, `"resume"`, `"compact"`) |
| `PreCompact` | `context_size`, `target_size` |

---

## Configuration Locations

Hooks can be defined in multiple locations, each with different scope and precedence:

| Location | File | Scope | Precedence | Committed to Git? |
|----------|------|-------|:----------:|--------------------|
| **Managed Policy** | Admin-configured | Organization-wide | Highest | N/A (admin) |
| **Personal** | `~/.claude/settings.json` | All your projects | High | No |
| **Project (shared)** | `.claude/settings.json` | This project (all team) | Medium | Yes |
| **Project (local)** | `.claude/settings.local.json` | This project (just you) | Medium | No (gitignored) |
| **Plugin** | `<plugin>/hooks/hooks.json` | Plugin scope | Low | Plugin-dependent |
| **Skill** | SKILL.md frontmatter `hooks:` field | Skill execution only | During skill | Skill-dependent |

### Configuration Format

Hooks are defined under the `"hooks"` key in settings JSON files:

```json
{
  "hooks": {
    "EventName": [
      {
        "matcher": "regex-pattern",
        "command": "shell-command-to-run"
      }
    ]
  }
}
```

**Matcher**: A regex pattern that filters when the hook runs. For `PreToolUse` and `PostToolUse`, it matches against the tool name. For other events, it can match against event-specific fields.

**Multiple hooks on the same event** run in sequence (array order):

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "command": "prettier --write \"$CLAUDE_FILE_PATH\""
      },
      {
        "matcher": "Edit|Write",
        "command": "eslint --fix \"$CLAUDE_FILE_PATH\""
      }
    ]
  }
}
```

---

## Practical Examples

### 1. Auto-Format Code After Edits

Automatically run Prettier on any file Claude edits or writes:

**`.claude/settings.json`:**

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "command": "npx prettier --write \"$CLAUDE_FILE_PATH\" 2>/dev/null || true"
      }
    ]
  }
}
```

The `|| true` ensures the hook doesn't fail if Prettier isn't installed or the file isn't a supported type.

### 2. Block Edits to Protected Files

Prevent modifications to migration files, lock files, and environment configs:

**`.claude/settings.json`:**

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|Write",
        "command": "python3 .claude/hooks/protect-files.py"
      }
    ]
  }
}
```

**`.claude/hooks/protect-files.py`:**

```python
#!/usr/bin/env python3
import json, sys, re

PROTECTED_PATTERNS = [
    r"migrations/",
    r"\.env",
    r"package-lock\.json",
    r"yarn\.lock",
    r"pnpm-lock\.yaml",
    r"\.claude/settings\.json",
]

data = json.load(sys.stdin)
file_path = data.get("tool_input", {}).get("file_path", "")

for pattern in PROTECTED_PATTERNS:
    if re.search(pattern, file_path):
        print(f"BLOCKED: {file_path} matches protected pattern '{pattern}'. "
              f"This file should only be modified manually.", file=sys.stderr)
        sys.exit(2)

sys.exit(0)
```

### 3. Desktop Notifications When Claude Needs Input

Send a system notification when Claude finishes a response and is waiting for input:

**macOS:**

```json
{
  "hooks": {
    "Notification": [
      {
        "command": "osascript -e 'display notification \"Claude Code needs your attention\" with title \"Claude Code\"'"
      }
    ]
  }
}
```

**Linux:**

```json
{
  "hooks": {
    "Notification": [
      {
        "command": "notify-send 'Claude Code' 'Claude needs your attention'"
      }
    ]
  }
}
```

**Windows (PowerShell):**

```json
{
  "hooks": {
    "Notification": [
      {
        "command": "powershell -Command \"[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); [System.Windows.Forms.MessageBox]::Show('Claude needs your attention','Claude Code')\""
      }
    ]
  }
}
```

### 4. Re-Inject Context After Compaction

When Claude's context window fills up and compaction occurs, important context can be lost. Use a `SessionStart` hook (which fires on compact events) to re-inject critical information:

**`.claude/settings.json`:**

```json
{
  "hooks": {
    "SessionStart": [
      {
        "command": "cat .claude/hooks/standing-context.txt"
      }
    ]
  }
}
```

**`.claude/hooks/standing-context.txt`:**

```
IMPORTANT PROJECT CONTEXT (re-injected after compaction):
- This project uses TypeScript 5.x with strict mode
- Test framework: Vitest (not Jest)
- Package manager: pnpm (not npm)
- All API routes must include authentication middleware
- Database: PostgreSQL via Prisma ORM
- Deployment: Vercel (serverless functions)
```

The `SessionStart` event fires both at the beginning of a new session AND after context compaction, making it ideal for standing context injection.

### 5. Lint on Save

Run ESLint after any file edit, reporting warnings as context for Claude:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "command": "npx eslint \"$CLAUDE_FILE_PATH\" --format compact 2>&1 | head -20 || true"
      }
    ]
  }
}
```

Claude will see the lint output and can choose to fix the issues in its next action.

### 6. Auto-Run Tests After Code Changes

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "command": "npm test -- --bail --silent 2>&1 | tail -5 || true"
      }
    ]
  }
}
```

### 7. Audit Log of All Tool Calls

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "command": "echo \"$(date -Iseconds) | $CLAUDE_TOOL_NAME | $CLAUDE_FILE_PATH\" >> .claude/audit.log; exit 0"
      }
    ]
  }
}
```

---

## Advanced Patterns

### Conditional Hooks Based on Branch

Only run deployment validations on the main branch:

```bash
#!/bin/bash
BRANCH=$(git branch --show-current)
if [[ "$BRANCH" != "main" ]] && [[ "$BRANCH" != "master" ]]; then
  exit 0  # Skip validation on non-main branches
fi
# Run deployment validation...
```

### Hook Chaining with Temp Files

Pass data between hooks using temp files:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit",
        "command": "cat > /tmp/claude-pre-edit.json"
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Edit",
        "command": "diff <(jq '.tool_input.old_string' /tmp/claude-pre-edit.json) <(echo '$CLAUDE_NEW_STRING') || true"
      }
    ]
  }
}
```

### Matcher Patterns

The `matcher` field accepts regex patterns matched against tool names:

| Pattern | Matches |
|---------|---------|
| `"Edit"` | Only the Edit tool |
| `"Edit\|Write"` | Edit or Write tools |
| `"Bash"` | Only Bash tool calls |
| `".*"` | All tools (use sparingly) |
| `"Read\|Grep\|Glob"` | Read-only tools |
| `"^(?!Read).*$"` | Everything except Read |

---

## Debugging Hooks

### Common Issues

**Hook doesn't seem to run:**
- Check that the event name is spelled correctly (case-sensitive)
- Verify the matcher regex matches the expected tool name
- Look for JSON syntax errors in your settings file
- Ensure the command is executable and in your PATH

**Hook runs but has no effect:**
- Check the exit code (use `echo $?` after manual testing)
- Verify stdout/stderr are going to the right streams
- Test the command manually with sample input piped via stdin

**Hook blocks unexpectedly:**
- An exit code of 2 blocks the action. Make sure your script only exits with 2 when intentional.
- Check that error paths in your script don't accidentally produce exit code 2

### Testing Hooks Manually

Simulate hook input by piping JSON to your hook script:

```bash
echo '{"session_id":"test","cwd":"/project","hook_event_name":"PreToolUse","tool_name":"Edit","tool_input":{"file_path":"/project/src/main.ts","old_string":"x","new_string":"y"}}' | bash .claude/hooks/protect-files.sh
echo "Exit code: $?"
```

### Verbose Logging

Add logging to your hooks for debugging:

```bash
#!/bin/bash
echo "[HOOK $(date)] Event: $CLAUDE_HOOK_EVENT Tool: $CLAUDE_TOOL_NAME" >> /tmp/claude-hooks.log
# ... rest of hook logic
```

---

## Best Practices

### 1. Keep Hooks Fast

Hooks run synchronously and block the lifecycle event. Slow hooks degrade the interactive experience.

- Target < 500ms execution time
- Avoid network calls in frequently-triggered hooks (PreToolUse, PostToolUse)
- Use `timeout 5 your-command` to prevent runaway processes

### 2. Always Handle Errors Gracefully

A hook crash should not break Claude Code. Use defensive patterns:

```bash
#!/bin/bash
set -euo pipefail
your-command 2>/dev/null || true  # Don't let failures propagate
exit 0
```

### 3. Use Exit Code 2 Sparingly

Blocking actions (exit 2) should be reserved for genuinely dangerous operations. Over-blocking makes Claude Code frustrating to use.

### 4. Scope Hooks Appropriately

- **Personal hooks** (`~/.claude/settings.json`): Your personal workflow preferences
- **Project hooks** (`.claude/settings.json`): Team standards (committed to git)
- **Local hooks** (`.claude/settings.local.json`): Your overrides for this project (gitignored)

### 5. Use Matchers to Limit Scope

Don't attach hooks to all tools when you only need them for specific ones. A `PostToolUse` hook with no matcher runs after every single tool call, including Read, Grep, Glob, etc.

### 6. Document Your Hooks

Add comments to your settings file and keep hook scripts well-documented. Future team members (and future you) will thank you.

### 7. Test Before Committing

Always test hooks locally before committing them to `.claude/settings.json`. A broken `PreToolUse` hook that always exits with code 2 will lock out Claude from using any tools.

---

## Further Reading

- [Official Hooks Documentation](https://code.claude.com/docs/en/hooks-guide)
- [Skills Guide](skills-guide.md) -- Advisory instructions and workflows
- [Plugins Guide](plugins-guide.md) -- Packaging hooks in distributable plugins
- [Back to Overview](README.md)
