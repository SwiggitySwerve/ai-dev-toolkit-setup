# Shared AI Workflow Aliases for Fish Shell
# Part of ai-dev-toolkit-setup

set -gx AI_PROJECTS_DIR (test -n "$AI_PROJECTS_DIR"; and echo $AI_PROJECTS_DIR; or echo $HOME/Projects)

alias aidir='cd $AI_PROJECTS_DIR'
alias gp='git push'

function gac -d "Git add all and commit"
    if test (count $argv) -eq 0
        echo "Usage: gac \"commit message\""
        return 1
    end
    git add -A; and git commit -m "$argv"
end

function gacp -d "Git add, commit, and push"
    if test (count $argv) -eq 0
        echo "Usage: gacp \"commit message\""
        return 1
    end
    git add -A; and git commit -m "$argv"; and git push
end

function newai -d "Create new AI project"
    if test (count $argv) -eq 0
        echo "Usage: newai project-name"
        return 1
    end
    mkdir -p $AI_PROJECTS_DIR/$argv[1]; and cd $AI_PROJECTS_DIR/$argv[1]; and git init
    echo "# $argv[1]" > README.md
    echo "Created new project: $argv[1]"
end
