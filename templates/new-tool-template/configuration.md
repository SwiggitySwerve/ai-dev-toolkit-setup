# Configuring [Tool Name]

## Configuration File

[Tool Name] stores its configuration in:

| Platform | Path |
|----------|------|
| macOS    | `~/.config/[tool-name]/config.json` |
| Linux    | `~/.config/[tool-name]/config.json` |
| Windows  | `%APPDATA%\[tool-name]\config.json` |

The configuration file uses [JSON/YAML/TOML] format. An example:

```json
{
  "setting_one": "value",
  "setting_two": true,
  "setting_three": 42
}
```

## Authentication

### Step 1: Obtain an API Key

1. Go to [provider's website/dashboard URL].
2. Navigate to Settings > API Keys.
3. Click "Create new key" and copy the value.

### Step 2: Configure the API Key

**Option A -- Environment variable (recommended):**
```bash
export [TOOL_NAME]_API_KEY="your-api-key-here"
```

Add this to your shell config file (`~/.bashrc`, `~/.zshrc`, or PowerShell `$PROFILE`) to persist across sessions.

**Option B -- Configuration file:**
```bash
[tool-name] auth login
```

This will open an interactive prompt or browser-based OAuth flow.

**Option C -- Pass directly:**
```bash
[tool-name] --api-key "your-api-key-here" [command]
```

> **Security note:** Avoid passing API keys directly on the command line in shared environments, as they may be visible in shell history or process listings.

## Key Settings

| Setting | Description | Default |
|---------|-------------|---------|
| `model` | The AI model to use for completions | `[default-model]` |
| `max_tokens` | Maximum tokens per response | `4096` |
| `temperature` | Response randomness (0.0 - 1.0) | `0.7` |
| `timeout` | Request timeout in seconds | `30` |
| `editor` | Preferred editor for file operations | `$EDITOR` or `vim` |
| `theme` | Color theme for terminal output | `auto` |
| `log_level` | Logging verbosity (debug, info, warn, error) | `info` |

To modify a setting:
```bash
[tool-name] config set model "[model-name]"
```

Or edit the configuration file directly.

## Environment Variables

| Variable | Description |
|----------|-------------|
| `[TOOL_NAME]_API_KEY` | API key for authentication |
| `[TOOL_NAME]_CONFIG_DIR` | Override default config directory |
| `[TOOL_NAME]_MODEL` | Override the default model |
| `[TOOL_NAME]_LOG_LEVEL` | Override log level |
| `[TOOL_NAME]_NO_COLOR` | Set to `1` to disable colored output |
| `[TOOL_NAME]_TIMEOUT` | Override request timeout (seconds) |
| `HTTP_PROXY` / `HTTPS_PROXY` | Proxy settings for network requests |

## Project-Level Configuration

[Tool Name] also supports project-level config files. Place a `.[tool-name].json` file in your project root to override global settings for that project:

```json
{
  "model": "[project-specific-model]",
  "context": {
    "include": ["src/**", "docs/**"],
    "exclude": ["node_modules/**", "dist/**"]
  }
}
```

Project-level settings take precedence over global settings.
