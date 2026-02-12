# Configuring OpenCode

This guide explains how to configure OpenCode with your preferred AI provider, model settings, and optional features. OpenCode is highly configurable -- you can use it with cloud AI providers or completely local models.

## Configuration File Locations

OpenCode looks for configuration in two places:

### Project-level configuration (recommended for teams)

Place a file named `opencode.json` in the root of your project:

```
my-project/
  opencode.json       <-- project-specific settings
  src/
  package.json
```

This file is checked into version control so your entire team shares the same OpenCode settings.

### Global configuration

For personal settings that apply across all projects, create a config file at:

- **macOS/Linux:** `~/.config/opencode/config.json`
- **Windows:** `%APPDATA%\opencode\config.json`

> **Note:** Project-level configuration takes precedence over global configuration. If both exist, project settings override global settings for any overlapping keys.

---

## Setting Up AI Providers

OpenCode supports multiple AI providers. You need to configure at least one provider with an API key to get started.

### API Keys via Environment Variables

The most common approach is to set API keys as environment variables. Add these to your shell profile (`~/.bashrc`, `~/.zshrc`, or Windows environment variables).

#### OpenAI

```bash
export OPENAI_API_KEY="sk-your-openai-api-key-here"
```

#### Anthropic

```bash
export ANTHROPIC_API_KEY="sk-ant-your-anthropic-api-key-here"
```

#### Google (Gemini)

```bash
export GOOGLE_API_KEY="your-google-api-key-here"
```

#### AWS Bedrock

```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_REGION="us-east-1"
```

#### Azure OpenAI

```bash
export AZURE_OPENAI_API_KEY="your-azure-key"
export AZURE_OPENAI_ENDPOINT="https://your-resource.openai.azure.com"
```

On Windows (PowerShell), set environment variables like this:

```powershell
$env:OPENAI_API_KEY = "sk-your-openai-api-key-here"
```

To make them permanent on Windows, use the System Properties dialog or:

```powershell
[Environment]::SetEnvironmentVariable("OPENAI_API_KEY", "sk-your-openai-api-key-here", "User")
```

> **Security note:** Never put API keys directly in configuration files that are checked into version control. Always use environment variables or a `.env` file that is listed in your `.gitignore`.

---

## Model Selection

### In the configuration file

You can specify your preferred model in `opencode.json`:

```json
{
  "provider": "anthropic",
  "model": "claude-sonnet-4-20250514"
}
```

Common model identifiers:

| Provider   | Model ID                              | Description              |
|-----------|---------------------------------------|--------------------------|
| OpenAI    | `gpt-4o`                             | GPT-4o (fast, capable)   |
| OpenAI    | `gpt-4.1`                            | GPT-4.1                  |
| OpenAI    | `o3`                                 | o3 reasoning model       |
| Anthropic | `claude-sonnet-4-20250514`           | Claude Sonnet 4          |
| Anthropic | `claude-opus-4-20250514`             | Claude Opus 4            |
| Google    | `gemini-2.5-pro`                     | Gemini 2.5 Pro           |
| Google    | `gemini-2.5-flash`                   | Gemini 2.5 Flash (fast)  |

### Switching models at runtime

You can switch models directly in the OpenCode TUI without changing your configuration. Use the model selector (typically the `m` key or through the command palette) to pick a different model on the fly.

---

## Using Local Models with Ollama

One of OpenCode's most powerful features is the ability to use completely free, local AI models through [Ollama](https://ollama.ai). This means zero API costs and full privacy -- your code never leaves your machine.

### Step 1: Install Ollama

```bash
# macOS
brew install ollama

# Linux
curl -fsSL https://ollama.ai/install.sh | sh

# Windows
# Download from https://ollama.ai/download
```

### Step 2: Pull a model

```bash
# A capable coding model
ollama pull qwen2.5-coder:32b

# Or a smaller model for faster responses
ollama pull qwen2.5-coder:7b

# Or DeepSeek Coder
ollama pull deepseek-coder-v2

# Or Llama
ollama pull llama3.1:70b
```

### Step 3: Start Ollama (if not running automatically)

```bash
ollama serve
```

### Step 4: Configure OpenCode to use Ollama

In your `opencode.json`:

```json
{
  "provider": "ollama",
  "model": "qwen2.5-coder:32b"
}
```

Or set the environment variable:

```bash
export OLLAMA_HOST="http://localhost:11434"
```

> **Tip:** Local models require significant RAM and a capable GPU for good performance. For coding tasks, models with at least 7B parameters are recommended, and 32B+ models provide noticeably better results.

---

## MCP Server Configuration

Model Context Protocol (MCP) servers extend OpenCode's capabilities by connecting it to external tools and data sources. You configure MCP servers in your `opencode.json` file.

### Basic MCP configuration

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/allowed/dir"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "your-github-token"
      }
    }
  }
}
```

### Common MCP servers

| Server | Purpose | Package |
|--------|---------|---------|
| Filesystem | Read/write files outside the project | `@modelcontextprotocol/server-filesystem` |
| GitHub | Access GitHub repos, issues, PRs | `@modelcontextprotocol/server-github` |
| PostgreSQL | Query databases | `@modelcontextprotocol/server-postgres` |
| Brave Search | Web search capabilities | `@modelcontextprotocol/server-brave-search` |
| Memory | Persistent memory across sessions | `@modelcontextprotocol/server-memory` |

### Environment variables in MCP config

You can reference environment variables in MCP server configurations to avoid hardcoding secrets:

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

---

## Custom Instructions

You can provide custom system-level instructions that shape how OpenCode behaves in your project. This is useful for enforcing coding standards, specifying frameworks, or giving project context.

### In the configuration file

```json
{
  "instructions": "This is a TypeScript React project using Next.js 14 with the App Router. Always use TypeScript strict mode. Prefer server components unless client interactivity is needed. Use Tailwind CSS for styling."
}
```

### Via a project file

You can also create a `.opencode` file in your project root with custom instructions:

```
This project uses Python 3.12 with FastAPI.
Use pydantic v2 for data validation.
Follow Google's Python style guide.
Always include type hints.
Write pytest tests for new functions.
```

---

## Full Configuration Example

Here is a complete `opencode.json` showing many available options:

```json
{
  "provider": "anthropic",
  "model": "claude-sonnet-4-20250514",
  "instructions": "This is a Go microservices project. Follow standard Go project layout. Write table-driven tests.",
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

---

## Configuration Reference

| Field          | Type   | Description                                      |
|---------------|--------|--------------------------------------------------|
| `provider`    | string | AI provider: `openai`, `anthropic`, `google`, `ollama`, `azure`, `bedrock` |
| `model`       | string | Model identifier (provider-specific)              |
| `instructions`| string | Custom system instructions for the AI             |
| `mcpServers`  | object | MCP server configurations                         |

---

## Next Steps

With OpenCode configured, head to the [Getting Started guide](getting-started.md) to learn how to use the TUI and start coding with AI assistance.
