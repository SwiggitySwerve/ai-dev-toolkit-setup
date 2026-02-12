# Claude Code Aliases for Fish Shell
# Part of ai-dev-toolkit-setup

alias cc='claude'
alias ccc='claude --continue'
alias ccr='claude --resume'
alias ccp='claude --print'
alias ccd='claude doctor'
alias ccv='claude --version'
alias ccmod='claude --model'
alias cchelp='claude --help'
alias ccup='npm update -g @anthropic-ai/claude-code'

function ccask -d "Quick one-shot question to Claude Code"
    if test (count $argv) -eq 0
        echo "Usage: ccask \"your question here\""
        return 1
    end
    claude --print $argv
end

function ccfix -d "Pipe last error into Claude Code"
    set -l last_status $status
    history | head -1 | read -l last_cmd
    eval $last_cmd 2>&1 | claude --print "The command '$last_cmd' produced this output/error. Help me fix it:"
end

function ccinit -d "Initialize CLAUDE.md in current project"
    if test -f CLAUDE.md
        echo "CLAUDE.md already exists."
        return 1
    end
    echo "# Project Instructions for Claude Code

## Project Overview
<!-- Describe your project here -->

## Key Conventions
<!-- List coding conventions -->

## Important Files
<!-- List key files -->" > CLAUDE.md
    echo "Created CLAUDE.md"
end
