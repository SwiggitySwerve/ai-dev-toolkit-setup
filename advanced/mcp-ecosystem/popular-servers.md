# Popular MCP Servers for Software Development

This guide catalogs the most useful MCP servers for software development, organized by category. Star counts are approximate and change frequently. All servers listed here are compatible with Claude Code, OpenCode, Cursor, and other MCP-compatible clients.

---

## Discovery Resources

Before diving into individual servers, here is where to find and explore MCP servers:

| Resource | URL | Description |
|----------|-----|-------------|
| awesome-mcp-servers | [github.com/punkpeye/awesome-mcp-servers](https://github.com/punkpeye/awesome-mcp-servers) | ~75k+ stars. The largest curated list of MCP servers. Community-maintained with categories and descriptions. |
| Official MCP Registry | [registry.modelcontextprotocol.io](https://registry.modelcontextprotocol.io) | Official centralized registry by the MCP project. The canonical source for discovering published servers. |
| Smithery.ai | [smithery.ai](https://smithery.ai) | One-click install hub. Browse, search, and install MCP servers with minimal configuration. |
| Glama.ai | [glama.ai/mcp/servers](https://glama.ai/mcp/servers) | Hosted MCP platform with server discovery, analytics, and managed hosting options. |
| MCP.so | [mcp.so](https://mcp.so) | Community recommendations and reviews of MCP servers. Good for finding battle-tested options. |
| MCP Market | [mcpmarket.com](https://mcpmarket.com) | Top 100 leaderboard ranked by GitHub stars. Quick way to see what is trending. |
| PulseMCP | [pulsemcp.com](https://pulsemcp.com) | 513+ MCP clients catalogued. Useful for understanding the broader MCP ecosystem beyond servers. |
| awesome-opencode.com | [awesome-opencode.com](https://awesome-opencode.com) | OpenCode-focused resources including MCP server recommendations tested with OpenCode. |

---

## Tier 1: Essential Servers

These are the servers every developer should know about. They cover fundamental capabilities that enhance any AI coding workflow.

| Server | Stars | What It Does | Install Command |
|--------|-------|--------------|-----------------|
| **Context7** | ~45k | Fetches up-to-date, version-specific documentation and code examples for any library. Eliminates hallucinated API calls by grounding the AI in real docs. | `npx -y @upstash/context7-mcp` |
| **GitHub MCP** | ~27k | Full GitHub integration: create and review PRs, search issues, browse repos, manage branches, read code, and more. Official server from GitHub. | `npx -y @github/mcp-server` |
| **Playwright MCP** | ~27k | Microsoft's browser automation server. Uses accessibility snapshots instead of screenshots for faster, more reliable web interaction. | `npx -y @playwright/mcp` |
| **Filesystem** | Official | Secure file operations (read, write, move, search) with configurable access controls. Restricts the AI to specific directories. | `npx -y @modelcontextprotocol/server-filesystem /path` |
| **Memory** | Official | Knowledge graph-based persistent memory across sessions. The AI can store and recall facts, decisions, and context. | `npx -y @modelcontextprotocol/server-memory` |
| **Sequential Thinking** | Official | Structured multi-step reasoning and problem solving. Helps the AI break down complex tasks and think through problems methodically. | `npx -y @modelcontextprotocol/server-sequential-thinking` |
| **Git** | Official | Git repository operations: log, diff, status, branches, commits. Gives the AI direct access to version control. | `npx -y @modelcontextprotocol/server-git` |
| **Fetch** | Official | Web content fetching and conversion to Markdown. Lets the AI read web pages, API responses, and online documentation. | `npx -y @modelcontextprotocol/server-fetch` |

### Why These Are Essential

- **Context7** solves the single biggest problem with AI coding: outdated or hallucinated library APIs. It fetches live documentation so the AI always uses correct, current syntax.
- **GitHub MCP** turns the AI into a full GitHub collaborator. Instead of copy-pasting between the terminal and chat, the AI can directly create PRs, comment on issues, and search code.
- **Filesystem** and **Git** give the AI controlled access to your project files and history without exposing your entire system.
- **Memory** provides continuity across sessions so the AI remembers architectural decisions, preferences, and project context.
- **Sequential Thinking** improves output quality on complex tasks by encouraging structured reasoning before code generation.

---

## Tier 2: Development Workflow

These servers enhance your day-to-day development workflow with automation, task management, and advanced tooling.

| Server | Stars | What It Does | Install Command |
|--------|-------|--------------|-----------------|
| **MarkItDown** | ~87k | Converts PDF, DOCX, PPTX, images, audio, and more to clean Markdown. Lets the AI read virtually any document format. | `pip install markitdown[all]` |
| **Claude Task Master** | ~25k | AI-powered task management designed for dev workflows. Breaks down PRDs into tasks, tracks progress, manages dependencies. | `npx -y task-master-ai` |
| **Browser MCP (Puppeteer)** | ~27k | Puppeteer-based browser automation. Navigate pages, fill forms, take screenshots, extract data. | `npx -y @anthropic/mcp-server-puppeteer` |
| **Serena** | ~20k | LSP-based coding agent toolkit. Provides language-aware code navigation, refactoring, and analysis through the Language Server Protocol. | `pip install serena` |
| **Desktop Commander** | ~5k | Terminal command execution, process management, and filesystem operations. Gives the AI a full desktop environment. | `npx @wonderwhy-er/desktop-commander@latest setup` |

### Use Cases

- **MarkItDown** is invaluable when you need the AI to understand a PDF specification, a Word document with requirements, or a PowerPoint with architecture diagrams.
- **Claude Task Master** works well for managing complex multi-step projects, turning a product requirements document into an actionable task list.
- **Serena** provides IDE-level code intelligence (go to definition, find references, rename symbol) to MCP clients that lack built-in LSP support.
- **Desktop Commander** is useful when you need the AI to run long-lived processes, manage background services, or interact with desktop applications.

---

## Tier 3: Database Servers

Direct database access lets the AI query data, inspect schemas, and help with migrations without leaving the conversation.

| Server | What It Does | Install Command |
|--------|--------------|-----------------|
| **PostgreSQL** | Execute SQL queries, inspect schemas, list tables, analyze query plans. Read-only by default for safety. | `npx -y @modelcontextprotocol/server-postgres postgres://user:pass@host/db` |
| **Supabase** | 20+ tools for Supabase projects: tables, migrations, edge functions, storage, auth. Official server from Supabase. | `npx -y @supabase/mcp-server-supabase@latest --read-only --project-ref=<ref>` |
| **SQLite** | Schema inspection, CRUD operations, custom SQL queries. Great for local development databases. | `npx -y @modelcontextprotocol/server-sqlite` |

### Safety Notes

- **Always start with read-only mode.** Both the PostgreSQL and Supabase servers support `--read-only` flags. Enable write access only when you explicitly need it.
- **Never expose production credentials** directly in config files. Use environment variables or secret managers.
- **Connection strings** in the examples above are placeholders. Replace `user:pass@host/db` with your actual connection details.

---

## Tier 4: Search and Research

These servers give the AI the ability to search the web, find code, and gather information in real time.

| Server | What It Does | Install Command |
|--------|--------------|-----------------|
| **Brave Search** | Privacy-first web search. Returns results without tracking. Good for general queries and technical searches. | `npx -y @anthropic/mcp-server-brave-search` |
| **Exa** | Semantic search engine with strong GitHub code context. Excellent for finding code examples and understanding how libraries are used in practice. | `npx -y exa-mcp-server` |
| **Tavily** | Real-time search, web crawling, and site mapping. Optimized for AI agents with structured output. | Via Tavily SDK |
| **Firecrawl** | Converts any URL to clean Markdown. Handles JavaScript-rendered pages, sitemaps, and batch crawling. | `npx -y firecrawl-mcp-server` |

### Environment Variables Required

| Server | Required Variable | How to Get |
|--------|-------------------|------------|
| Brave Search | `BRAVE_API_KEY` | [brave.com/search/api](https://brave.com/search/api) - Free tier: 2,000 queries/month |
| Exa | `EXA_API_KEY` | [exa.ai](https://exa.ai) |
| Tavily | `TAVILY_API_KEY` | [tavily.com](https://tavily.com) |
| Firecrawl | `FIRECRAWL_API_KEY` | [firecrawl.dev](https://firecrawl.dev) |

---

## Tier 5: Cloud and Infrastructure

Manage cloud resources and infrastructure directly from your AI coding session.

| Server | What It Does | Install Command |
|--------|--------------|-----------------|
| **AWS MCP** | Manage EC2 instances, S3 buckets, IAM roles, CloudWatch logs, Lambda functions, and more. Official multi-server suite from AWS. | See [github.com/aws/aws-mcp](https://github.com/aws/aws-mcp) |
| **Azure MCP** | Access 40+ Azure services including App Service, Functions, Cosmos DB, Storage, and AKS. Official server from Microsoft. | `npx -y @azure/mcp@latest server start` |
| **Cloudflare** | Manage Workers, KV namespaces, R2 storage, D1 databases, DNS records, and more. | `npx workers-mcp install:claude` |
| **Kubernetes** | Interact with pods, deployments, services, config maps, and logs. Read cluster state and troubleshoot issues. | `npx -y mcp-server-kubernetes` |
| **Docker** | Container lifecycle management: list, start, stop, inspect containers and images. | Via [ckreiling/mcp-server-docker](https://github.com/ckreiling/mcp-server-docker) |

### Prerequisites

- **AWS MCP** requires configured AWS credentials (`~/.aws/credentials` or environment variables). Uses your existing IAM permissions.
- **Azure MCP** requires Azure CLI authentication (`az login`).
- **Kubernetes** requires a valid kubeconfig. Uses your current context by default.
- **Docker** requires the Docker daemon to be running.

### Safety Warning

Cloud and infrastructure servers can make real changes to your production environment. Always:
1. Use read-only modes where available
2. Test with non-production accounts first
3. Review any destructive operations before confirming
4. Consider using IAM roles with minimal permissions

---

## Tier 6: Monitoring and Error Tracking

Connect your observability stack so the AI can help diagnose issues, analyze errors, and understand system behavior.

| Server | What It Does | Install Command |
|--------|--------------|-----------------|
| **Sentry** | Error tracking and issue analysis. Browse issues, view stack traces, analyze error frequency, find related code. Official server from Sentry. | `npx @sentry/mcp-server@latest --access-token=<token>` |
| **Grafana** | Query Prometheus and Loki, manage incidents, view dashboards, configure alerts. | Via [grafana/mcp-grafana](https://github.com/grafana/mcp-grafana) |

### Workflow Example

A powerful workflow combines Sentry with GitHub:

1. The AI reads the latest Sentry errors
2. It correlates stack traces with your codebase via the Filesystem or GitHub server
3. It proposes a fix and creates a PR via the GitHub server
4. All within a single conversation

---

## Tier 7: Communication and Productivity

Integrate your team's communication and project management tools so the AI can read context, update status, and coordinate work.

| Server | What It Does | Install Command |
|--------|--------------|-----------------|
| **Slack** | Read channels, send messages, manage reactions, search message history, view user profiles. | `npx -y @modelcontextprotocol/server-slack` |
| **Notion** | Access pages, databases, and docs. Search content, create and update pages. Official server from Notion. | `npx -y @notionhq/mcp-server-notion` |
| **Linear** | Manage issues, projects, teams, and cycles. Official remote MCP server from Linear. | `npx -y mcp-remote https://mcp.linear.app/mcp` |
| **Jira** | JQL search, project management, issue creation and updates, sprint tracking. | `npx -y @aashari/mcp-server-atlassian-jira` |

### Environment Variables Required

| Server | Required Variable | How to Get |
|--------|-------------------|------------|
| Slack | `SLACK_BOT_TOKEN` | Create a Slack app at [api.slack.com/apps](https://api.slack.com/apps) |
| Notion | `NOTION_API_KEY` | Create an integration at [notion.so/my-integrations](https://www.notion.so/my-integrations) |
| Linear | OAuth (handled by remote server) | Authenticate via browser when prompted |
| Jira | `ATLASSIAN_API_TOKEN` + `ATLASSIAN_EMAIL` | Generate at [id.atlassian.com/manage-profile/security/api-tokens](https://id.atlassian.com/manage-profile/security/api-tokens) |

---

## Choosing the Right Servers

### By Role

| Role | Recommended Servers |
|------|---------------------|
| **Frontend Developer** | Context7, GitHub, Playwright, Filesystem, Fetch |
| **Backend Developer** | Context7, GitHub, PostgreSQL/SQLite, Git, Sequential Thinking |
| **Full Stack Developer** | Context7, GitHub, PostgreSQL, Filesystem, Memory, Browser |
| **DevOps/SRE** | GitHub, Kubernetes, Docker, AWS/Azure, Sentry, Grafana |
| **Data Engineer** | PostgreSQL, Supabase, MarkItDown, Filesystem, Memory |
| **Mobile Developer** | Context7, GitHub, Filesystem, Firebase (community), Fetch |

### By Project Size

| Project Size | Recommendation |
|--------------|----------------|
| **Solo / Side Project** | Context7 + Filesystem + Memory (3 servers) |
| **Small Team** | Add GitHub + PostgreSQL + Slack (6 servers) |
| **Enterprise** | Add Sentry + Kubernetes + Jira + Sequential Thinking (10+ servers) |

### Performance Considerations

- Each MCP server runs as a separate process. Running 10+ servers simultaneously is fine on modern hardware but will increase memory usage.
- Servers that make network requests (GitHub, Brave Search, cloud servers) add latency proportional to the API response time.
- Local servers (Filesystem, Git, SQLite) are nearly instantaneous.
- If startup time matters, prefer servers distributed as npm packages (`npx`) over Docker-based servers.

---

## See Also

- [Setup Guide](setup-guide.md) - How to configure these servers with Claude Code, OpenCode, and other clients
- [README](README.md) - Overview of the MCP ecosystem section
