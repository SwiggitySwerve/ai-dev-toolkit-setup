#!/usr/bin/env bash
# Claude Code Aliases - Source this file in your .bashrc or .zshrc
# Part of ai-dev-toolkit-setup

# Core aliases
alias cc='claude'
alias ccc='claude --continue'
alias ccr='claude --resume'
alias ccp='claude --print'
alias ccd='claude doctor'
alias ccv='claude --version'
alias ccmod='claude --model'
alias cchelp='claude --help'

# Update (detect OS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    alias ccup='npm update -g @anthropic-ai/claude-code'
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    alias ccup='npm update -g @anthropic-ai/claude-code'
else
    alias ccup='npm update -g @anthropic-ai/claude-code'
fi

# Functions
ccask() {
    if [ -z "$1" ]; then
        echo "Usage: ccask \"your question here\""
        return 1
    fi
    claude --print "$*"
}

ccfix() {
    local last_cmd=$(fc -ln -1)
    local last_output=$(eval "$last_cmd" 2>&1)
    echo "$last_output" | claude --print "The command '$last_cmd' produced this output/error. Help me fix it:"
}

ccpr() {
    claude --print "Review this git diff for potential issues, bugs, and improvements:" <<< "$(git diff)"
}

ccinit() {
    if [ -f "CLAUDE.md" ]; then
        echo "CLAUDE.md already exists in this directory."
        return 1
    fi
    cat > CLAUDE.md << 'CLAUDEEOF'
# Project Instructions for Claude Code

## Project Overview
<!-- Describe your project here -->

## Key Conventions
<!-- List coding conventions, preferred patterns, etc. -->

## Important Files
<!-- List key files Claude should be aware of -->
CLAUDEEOF
    echo "Created CLAUDE.md - customize it for your project!"
}
