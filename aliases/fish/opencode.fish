# OpenCode Aliases for Fish Shell
# Part of ai-dev-toolkit-setup

alias oc='opencode'
alias ocv='opencode --version'
alias ochelp='opencode --help'

if command -q brew
    alias ocup='brew upgrade opencode'
else if command -q go
    alias ocup='go install github.com/opencode-ai/opencode@latest'
else
    alias ocup='curl -fsSL https://opencode.ai/install | bash'
end
