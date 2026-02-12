#!/usr/bin/env bash
# OpenCode Aliases - Source this file in your .bashrc or .zshrc
# Part of ai-dev-toolkit-setup

alias oc='opencode'
alias ocv='opencode --version'
alias ochelp='opencode --help'

# Update based on install method
if command -v brew &>/dev/null; then
    alias ocup='brew upgrade opencode'
elif command -v go &>/dev/null; then
    alias ocup='go install github.com/opencode-ai/opencode@latest'
else
    alias ocup='curl -fsSL https://opencode.ai/install | bash'
fi
