# Prerequisites for AI Coding Tools

Before you install AI-powered coding assistants like Claude Code, GitHub Copilot CLI, Aider, or similar tools, you need a handful of foundational pieces in place on your machine. This guide walks you through each one so you can hit the ground running.

## Why Prerequisites Matter

Most AI coding tools are distributed as **npm packages**, **pip packages**, or standalone binaries that rely on your system's **PATH**, **shell configuration**, and **package managers**. If any of these foundations are missing or misconfigured, installation commands will fail with cryptic errors. Spending 10 minutes setting up prerequisites now saves hours of debugging later.

## What You Need

Work through these three guides in order. Each one builds on the previous:

### 1. [Package Managers](package-managers.md)

Package managers are the programs that install other programs. On macOS you need Homebrew; on Windows you should set up Scoop or winget; on Linux your distro's package manager is usually ready to go. **Start here** because the other guides assume you have a working package manager.

### 2. [Node.js and npm/npx](nodejs.md)

Many AI coding tools (Claude Code, for example) are installed with `npm` or run with `npx`. This guide covers how to install Node.js 18+ on every major operating system, including version-manager approaches like `nvm` that let you switch Node versions painlessly.

### 3. [Shell Setup and PATH](shell-setup.md)

Your shell is the program that interprets your commands. Understanding where its configuration file lives, how `PATH` works, and what "sourcing" means is essential for making newly installed tools available in your terminal. This knowledge is also critical for the alias and configuration steps that come later in the toolkit setup.

## Quick Self-Check

If you can run all three of these commands and get sensible output, your prerequisites are in good shape:

```bash
# Check that Node.js is installed and is version 18 or higher
node --version

# Check that npm is available
npm --version

# Check that npx is available
npx --version
```

If any of those commands fail or return a version below 18 for Node.js, work through the guides above to get everything set up.

## Assumed Knowledge

These guides are written for **beginners** who may be opening a terminal for the first time. No prior command-line experience is required. Each guide explains every step and includes copy-paste commands for all major operating systems.

---

*Next step after completing prerequisites: return to the main [AI Dev Toolkit Setup](../README.md) guide to install your first AI coding tool.*
