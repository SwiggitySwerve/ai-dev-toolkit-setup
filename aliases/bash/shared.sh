#!/usr/bin/env bash
# Shared AI Workflow Aliases - Source this file in your .bashrc or .zshrc
# Part of ai-dev-toolkit-setup

# Set your default projects directory (customize this)
AI_PROJECTS_DIR="${AI_PROJECTS_DIR:-$HOME/Projects}"

alias aidir='cd "$AI_PROJECTS_DIR"'
alias gp='git push'

gac() {
    if [ -z "$1" ]; then
        echo "Usage: gac \"commit message\""
        return 1
    fi
    git add -A && git commit -m "$1"
}

gacp() {
    if [ -z "$1" ]; then
        echo "Usage: gacp \"commit message\""
        return 1
    fi
    git add -A && git commit -m "$1" && git push
}

newai() {
    if [ -z "$1" ]; then
        echo "Usage: newai project-name"
        return 1
    fi
    mkdir -p "$AI_PROJECTS_DIR/$1" && cd "$AI_PROJECTS_DIR/$1" && git init
    echo "# $1" > README.md
    echo "Created new project: $1"
}
