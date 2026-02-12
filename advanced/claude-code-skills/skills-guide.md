# Claude Code Skills Guide

> How to find, install, create, and master Claude Code skills -- reusable markdown instructions that serve as slash commands and injectable context.

---

## Table of Contents

- [What Are Skills?](#what-are-skills)
- [The Agent Skills Open Standard](#the-agent-skills-open-standard)
- [Skill File Format](#skill-file-format)
- [Where Skills Live](#where-skills-live)
- [Invocation Control](#invocation-control)
- [Dynamic Context Injection](#dynamic-context-injection)
- [Creating Your First Skill](#creating-your-first-skill)
- [Advanced Skill Example](#advanced-skill-example)
- [Where to Find Community Skills](#where-to-find-community-skills)
- [Popular Community Skills](#popular-community-skills)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

---

## What Are Skills?

Skills are **markdown files** (named `SKILL.md`) that contain instructions, workflows, and domain knowledge for Claude Code. They serve two purposes simultaneously:

1. **User-invocable slash commands** -- Type `/skill-name` in Claude Code to activate a skill, just like a chat command.
2. **Model-invocable context** -- Claude can autonomously decide to load a skill when its description matches the current task.

Skills replaced the legacy `.claude/commands/` system (which used individual `.md` files as slash commands). If you have existing commands, they continue to work but are internally treated as skills.

### Why Skills Matter

- **Reusable workflows**: Define a code review checklist once, invoke it on every PR.
- **Domain knowledge injection**: Teach Claude about your project's architecture, conventions, or business rules.
- **Team standardization**: Commit skills to your repo so every team member gets the same workflows.
- **Cross-tool portability**: Skills follow the Agent Skills open standard, meaning they work across multiple AI coding tools.

---

## The Agent Skills Open Standard

Claude Code skills follow the **Agent Skills** open standard ([agentskills.io](https://agentskills.io/specification)), a cross-platform specification for AI coding tool extensions. This means skills you write for Claude Code are portable to:

| Tool | Support Level |
|------|--------------|
| Claude Code | Full native support |
| Codex CLI (OpenAI) | Reads SKILL.md files |
| GitHub Copilot | Agent Skills compatible |
| Cursor | Agent Skills compatible |
| Gemini CLI (Google) | Agent Skills compatible |
| Windsurf | Agent Skills compatible |

The standard defines the SKILL.md format, YAML frontmatter fields, and discovery conventions. Writing to this standard future-proofs your skills.

---

## Skill File Format

A skill is a **directory** containing a `SKILL.md` file, optionally accompanied by supporting files.

### Minimal Example

```
.claude/skills/greet/
  SKILL.md
```

**SKILL.md:**

```markdown
---
name: greet
description: Greet the user and summarize the project
---
Say hello to the user. Then read the README.md and give a one-paragraph project summary.
```

### Full SKILL.md Structure

```markdown
---
# Required
name: my-skill
description: One-line description (used for matching and discovery)

# Optional - Invocation Control
disable-model-invocation: false   # true = only user can invoke via slash command
user-invocable: true              # false = only Claude can invoke (background knowledge)

# Optional - Execution
argument-hint: "<file-path>"      # Hint shown in slash command autocomplete
allowed-tools:                    # Restrict which tools this skill can use
  - Read
  - Grep
  - Glob
model: claude-sonnet-4-5-20250929 # Override the model for this skill
context: fork                     # "fork" = run in isolated context (no side effects on main conversation)
agent: Explore                    # Which agent personality to use

# Optional - Lifecycle Hooks
hooks:
  PreToolUse:
    - matcher: "Write"
      command: "echo 'About to write a file'"
---

## Instructions

Your markdown instructions go here. Claude will follow these when the skill is activated.

You can use **any markdown formatting**: headers, lists, code blocks, tables.
```

### YAML Frontmatter Fields Reference

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `name` | string | directory name | Skill identifier, used as the slash command name |
| `description` | string | *required* | One-line description; used for discovery and matching |
| `argument-hint` | string | none | Placeholder text shown in autocomplete (e.g., `"<branch-name>"`) |
| `disable-model-invocation` | boolean | `false` | When `true`, only the user can invoke this skill (not Claude) |
| `user-invocable` | boolean | `true` | When `false`, only Claude can invoke this skill (background knowledge) |
| `allowed-tools` | string[] | all tools | Restrict the tools available when this skill runs |
| `model` | string | session default | Override the model used when executing this skill |
| `context` | string | `"main"` | `"fork"` runs in isolated context; `"main"` runs in the current conversation |
| `agent` | string | default | Agent personality (e.g., `"Explore"` for read-only research) |
| `hooks` | object | none | Lifecycle hooks scoped to this skill's execution |

### String Substitutions

Skills support dynamic placeholders that are replaced at invocation time:

| Placeholder | Resolves To | Example |
|-------------|------------|---------|
| `$ARGUMENTS` | Full argument string passed by user | `/review $ARGUMENTS` where user types `/review src/main.ts` |
| `$ARGUMENTS[0]` | First whitespace-delimited argument | First word of the argument string |
| `$ARGUMENTS[N]` | Nth argument (0-indexed) | Any positional argument |
| `$0`, `$1`, `$2`... | Aliases for `$ARGUMENTS[N]` | Shorthand positional args |
| `${CLAUDE_SESSION_ID}` | Current session identifier | Useful for logging or file naming |

**Example using substitutions:**

```markdown
---
name: explain
description: Explain a specific file in detail
argument-hint: "<file-path>"
---
Read the file at `$ARGUMENTS` and provide a detailed explanation of:
1. What it does
2. Key functions and their purposes
3. Dependencies and imports
4. Potential issues or improvements
```

Usage: `/explain src/utils/parser.ts`

---

## Where Skills Live

Skills are discovered from multiple locations, in order of precedence:

| Location | Path Pattern | Scope | Use Case |
|----------|-------------|-------|----------|
| **Enterprise** | Managed settings (admin-configured) | Organization | Company-wide standards |
| **Personal** | `~/.claude/skills/<skill-name>/SKILL.md` | User (all projects) | Personal workflows |
| **Project** | `.claude/skills/<skill-name>/SKILL.md` | Project (committed to git) | Team workflows |
| **Plugin** | `<plugin>/skills/<skill-name>/SKILL.md` | Depends on install scope | Third-party extensions |

### Auto-Discovery in Monorepos

Claude Code automatically discovers skills in nested directories. In a monorepo, each package can define its own skills:

```
monorepo/
  .claude/skills/            # Root-level skills
    deploy/SKILL.md
  packages/
    frontend/
      .claude/skills/        # Frontend-specific skills
        component/SKILL.md
    backend/
      .claude/skills/        # Backend-specific skills
        migration/SKILL.md
```

All skills from all levels are available when working anywhere in the monorepo.

### Context Budget

Skills consume context window space. Claude Code enforces limits:

- **Budget**: ~2% of the model's context window
- **Fallback**: ~16,000 characters if the context window size is unknown
- Skills are loaded on-demand (not all at once), so having many skills defined is fine
- Only the skill's content is injected when invoked, not every skill simultaneously

---

## Invocation Control

Skills support fine-grained control over who (or what) can invoke them:

### Invocation Control Matrix

| `disable-model-invocation` | `user-invocable` | User Can Invoke | Claude Can Invoke | Best For |
|:--------------------------:|:-----------------:|:---------------:|:-----------------:|----------|
| `false` (default) | `true` (default) | Yes | Yes | General-purpose skills (review, explain, etc.) |
| `true` | `true` | Yes | No | Side-effect actions (deploy, publish, commit) |
| `false` | `false` | No | Yes | Background knowledge (architecture docs, conventions) |
| `true` | `false` | No | No | Effectively disabled |

### When to Disable Model Invocation

Set `disable-model-invocation: true` for skills that have **side effects** or are **destructive**:

- Deployment workflows (`/deploy`)
- Git operations (`/commit`, `/push`, `/release`)
- Database migrations (`/migrate`)
- Notification-sending workflows (`/notify-team`)

This prevents Claude from autonomously triggering these actions. The user must explicitly type the slash command.

### When to Disable User Invocation

Set `user-invocable: false` for skills that provide **background knowledge** Claude should use automatically:

- Project architecture descriptions
- Coding conventions and style guides
- API documentation for internal services
- Domain-specific terminology glossaries

These skills are loaded by Claude when their description matches the current task context.

---

## Dynamic Context Injection

One of the most powerful skill features is **dynamic context injection** using the `` !`command` `` syntax. When Claude loads a skill, any `` !`command` `` placeholder is executed as a shell command, and the output replaces the placeholder in the skill content.

### Syntax

```markdown
!`shell-command-here`
```

The command runs in the project's working directory. Its stdout replaces the placeholder.

### Example: Inject Git Status

```markdown
---
name: status
description: Analyze the current state of the repository
---
## Current Repository State

### Git Status
!`git status --short`

### Recent Commits
!`git log --oneline -10`

### Current Branch
!`git branch --show-current`

## Task
Analyze the repository state above and suggest what to work on next.
```

### Example: Inject PR Context

```markdown
---
name: pr-review
description: Review the current pull request
context: fork
agent: Explore
---
## Pull Request Context

### PR Description
!`gh pr view --json title,body --jq '.title + "\n\n" + .body'`

### Changed Files
!`gh pr diff --name-only`

### Full Diff
!`gh pr diff`

### PR Comments
!`gh pr view --comments`

## Your Task
Review this pull request thoroughly. Check for:
1. Logic errors
2. Security issues
3. Performance concerns
4. Missing tests
5. Documentation gaps
```

### Security Note

Dynamic context commands run with your shell permissions. Be cautious about:

- Skills from untrusted sources (review before installing)
- Commands that could expose secrets (avoid `cat .env` in skills)
- Commands with side effects in a context-injection position (prefer read-only commands)

---

## Creating Your First Skill

Let's walk through creating a skill step by step.

### Step 1: Create the Directory

```bash
mkdir -p .claude/skills/review
```

### Step 2: Write the SKILL.md

Create `.claude/skills/review/SKILL.md`:

```markdown
---
name: review
description: Perform a thorough code review of staged changes
argument-hint: "[file-or-directory]"
disable-model-invocation: true
---

## Code Review Instructions

Review the following changes for quality, correctness, and maintainability.

### What to Check

1. **Correctness**: Does the code do what it intends?
2. **Error handling**: Are edge cases covered?
3. **Security**: Any injection, auth, or data exposure issues?
4. **Performance**: Any unnecessary loops, allocations, or blocking calls?
5. **Readability**: Are names clear? Is the logic easy to follow?
6. **Tests**: Are new behaviors covered by tests?

### Context

If a specific file or directory was provided (`$ARGUMENTS`), focus the review there.
Otherwise, review all staged changes:

!`git diff --cached --stat`

### Output Format

For each issue found, provide:
- **File and line**: Where the issue is
- **Severity**: Critical / Warning / Suggestion
- **Description**: What the problem is
- **Fix**: How to resolve it
```

### Step 3: Test the Skill

Open Claude Code in your project directory and type:

```
/review
```

Or with an argument:

```
/review src/auth/
```

### Step 4: Iterate

- Adjust the instructions based on Claude's output
- Add more specific rules for your project
- Consider adding `context: fork` if you want reviews to run in isolation

---

## Advanced Skill Example

Here is a more sophisticated skill that leverages multiple advanced features:

```yaml
---
name: pr-summary
description: Summarize changes in a pull request with context
context: fork
agent: Explore
allowed-tools:
  - Read
  - Grep
  - Glob
  - Bash
---

## Pull Request Context

### PR Metadata
- **Title**: !`gh pr view --json title --jq '.title'`
- **Author**: !`gh pr view --json author --jq '.author.login'`
- **Base branch**: !`gh pr view --json baseRefName --jq '.baseRefName'`

### PR Description
!`gh pr view --json body --jq '.body'`

### Review Comments
!`gh pr view --comments 2>/dev/null || echo "No comments yet"`

### Changed Files
!`gh pr diff --name-only`

### Diff Statistics
!`gh pr diff --stat`

### Full Diff
!`gh pr diff`

## Your Task

Provide a comprehensive pull request summary:

1. **Overview** (2-3 sentences): What does this PR do and why?
2. **Key Changes** (bulleted list): Major modifications grouped by area
3. **Risk Assessment**: What could go wrong? What needs careful testing?
4. **Test Coverage**: Are the changes adequately tested?
5. **Suggestions**: Any improvements or concerns?

Write the summary in a format suitable for pasting into a PR comment.
```

### Supporting Files

Skills can include supporting files in the same directory:

```
.claude/skills/pr-summary/
  SKILL.md
  templates/
    summary-template.md
  reference/
    review-checklist.md
```

Reference these files in your SKILL.md:

```markdown
Follow the review checklist in `review-checklist.md` (located in this skill's directory).
Use the template in `templates/summary-template.md` for formatting your output.
```

---

## Where to Find Community Skills

The Claude Code community has produced hundreds of reusable skills. Here are the best sources:

| Source | URL | Description |
|--------|-----|-------------|
| **Anthropic Skills Repo** | [github.com/anthropics/skills](https://github.com/anthropics/skills) | Official first-party skills from Anthropic |
| **Anthropic Official Plugins** | [github.com/anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official) | Official plugin marketplace with bundled skills |
| **awesome-claude-code** | [github.com/hesreallyhim/awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code) | Community-curated list of Claude Code resources |
| **awesome-agent-skills** | [github.com/VoltAgent/awesome-agent-skills](https://github.com/VoltAgent/awesome-agent-skills) | 300+ skills following the Agent Skills standard |
| **awesome-claude-skills** | [github.com/travisvn/awesome-claude-skills](https://github.com/travisvn/awesome-claude-skills) | Curated collection of Claude Code skills |
| **SkillsMP** | [skillsmp.com](https://skillsmp.com) | Agent Skills Marketplace (web-based browser) |

### Installing a Community Skill

**Manual installation (copy into your project):**

```bash
# Clone the skills repo
git clone https://github.com/anthropics/skills /tmp/skills

# Copy a specific skill to your project
cp -r /tmp/skills/code-review .claude/skills/code-review

# Or to your personal skills directory
cp -r /tmp/skills/code-review ~/.claude/skills/code-review
```

**Via plugin (recommended for skill collections):**

```
/plugin install plugin-name@claude-plugins-official
```

---

## Popular Community Skills

| Skill / Collection | Author | Description |
|-------------------|--------|-------------|
| **SuperClaude / Superpowers** | Community | Comprehensive development workflow skills: architecture, debugging, refactoring, TDD |
| **ui-ux-pro-max-skill** | Community | Design intelligence -- UI/UX review, accessibility audits, design system generation |
| **cc-devops-skills** | Community | DevOps validations, Dockerfile generators, CI/CD pipeline scaffolding |
| **Claude-Command-Suite** | Community | Professional slash commands for code analysis, documentation, and project management |
| **claude-sessions** | Community | Session tracking, conversation export, and session management utilities |
| **claude-skill-architect** | Community | Meta-skill for generating new skills from natural language descriptions |
| **claude-test-writer** | Community | Test generation for multiple frameworks (Jest, Pytest, Go testing, etc.) |
| **claude-git-workflow** | Community | Git workflow automation: conventional commits, branch management, release notes |

---

## Best Practices

### 1. Keep SKILL.md Under 500 Lines

Long skills consume excessive context budget and dilute Claude's focus. If your skill is growing large, split it into multiple focused skills or move reference material into supporting files.

### 2. Write Descriptions with Natural Keywords

The `description` field is how Claude matches skills to tasks. Write it using words a user would naturally say:

```yaml
# Good - matches natural language
description: Review code changes for bugs, security issues, and style violations

# Bad - too technical, doesn't match how people talk
description: Static analysis invocation wrapper v2
```

### 3. Use `disable-model-invocation` for Side-Effect Actions

Any skill that deploys, commits, publishes, sends notifications, or modifies external state should have `disable-model-invocation: true`. This prevents Claude from autonomously triggering consequential actions.

### 4. Use `context: fork` for Isolation

Skills that perform analysis or generate output without needing to modify the main conversation state should use `context: fork`. This:

- Prevents the skill's execution from polluting the main conversation context
- Allows the skill to use a different model or agent without affecting the session
- Makes the skill's behavior more predictable and reproducible

### 5. Include "ultrathink" for Extended Reasoning

For skills that require deep analysis (architecture review, complex debugging), include the word "ultrathink" in your skill content. This triggers Claude's extended thinking mode for more thorough reasoning:

```markdown
---
name: architecture-review
description: Deep review of system architecture
---
Perform an ultrathink analysis of this project's architecture...
```

### 6. Start Standalone, Convert to Plugin When Sharing

Begin by developing skills directly in `.claude/skills/`. Once they're stable and useful, package them into a plugin for distribution. This avoids premature packaging overhead.

### 7. Use Allowed-Tools to Limit Scope

If a skill should only read code (not modify it), restrict its tools:

```yaml
allowed-tools:
  - Read
  - Grep
  - Glob
```

This prevents accidental edits and makes the skill safer to run.

### 8. Test with Edge Cases

Test your skills with:

- Empty repositories (no files to analyze)
- Large repositories (context budget limits)
- Missing dependencies (e.g., `gh` not installed for PR skills)
- No arguments when arguments are expected

---

## Troubleshooting

### Skill Not Appearing in Autocomplete

- Verify the directory structure: `<location>/skills/<name>/SKILL.md` (not `<location>/skills/<name>.md`)
- Check that `SKILL.md` is capitalized exactly (case-sensitive on Linux/macOS)
- Ensure valid YAML frontmatter (no syntax errors between the `---` fences)
- Confirm `user-invocable` is not set to `false`

### Skill Loads but Claude Ignores Instructions

- Make the instructions more specific and actionable
- Use imperative language ("Do X", "Check Y", not "You might want to...")
- Add output format requirements so Claude knows what to produce
- Check if the skill content exceeds the context budget (~16,000 chars)

### Dynamic Context Commands Fail

- Test the command manually in your terminal first
- Ensure the command works from the project root (that's the working directory)
- Check that required CLI tools are installed (`gh`, `git`, `jq`, etc.)
- Use `2>/dev/null` to suppress stderr that might confuse Claude:
  ```markdown
  !`gh pr view --comments 2>/dev/null || echo "No PR found"`
  ```

### Skill Conflicts with Another Skill

- Skills are matched by name. If two skills share the same name, the highest-precedence location wins (Enterprise > Personal > Project > Plugin).
- Plugin skills are namespaced: `/plugin-name:skill-name`, so they cannot conflict with project skills.

---

## Further Reading

- [Official Skills Documentation](https://code.claude.com/docs/en/skills)
- [Agent Skills Specification](https://agentskills.io/specification)
- [Hooks Guide](hooks-guide.md) -- Deterministic lifecycle commands
- [Plugins Guide](plugins-guide.md) -- Packaging and distributing skills
- [Back to Overview](README.md)
