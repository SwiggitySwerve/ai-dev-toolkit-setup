#!/usr/bin/env bash
#
# AI Dev Toolkit - Unix Setup Script
# One-command setup for AI-powered development tools.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/.../setup.sh | bash
#   or
#   bash setup.sh [OPTIONS]
#
# Options:
#   --help          Show this help message
#   --claude-only   Install only Claude Code
#   --opencode-only Install only OpenCode
#   --all           Install all tools (default: interactive prompt)
#   --no-aliases    Skip alias installation
#   --dry-run       Show what would be done without executing
#

set -euo pipefail

# ---------------------------------------------------------------------------
# Constants & Colors
# ---------------------------------------------------------------------------
readonly VERSION="1.0.0"
readonly SCRIPT_NAME="$(basename "$0")"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# ---------------------------------------------------------------------------
# State
# ---------------------------------------------------------------------------
INSTALL_CLAUDE=false
INSTALL_OPENCODE=false
SKIP_ALIASES=false
DRY_RUN=false
INTERACTIVE=true
OS_TYPE=""
DISTRO=""
SHELL_NAME=""
NODE_INSTALLED_BY_US=false

# ---------------------------------------------------------------------------
# Utility Functions
# ---------------------------------------------------------------------------
info()    { printf "${BLUE}[INFO]${RESET}  %s\n" "$*"; }
success() { printf "${GREEN}[OK]${RESET}    %s\n" "$*"; }
warn()    { printf "${YELLOW}[WARN]${RESET}  %s\n" "$*"; }
error()   { printf "${RED}[ERROR]${RESET} %s\n" "$*" >&2; }
step()    { printf "\n${BOLD}${CYAN}>>> %s${RESET}\n" "$*"; }

confirm() {
    local prompt="$1"
    local default="${2:-y}"
    local yn
    if [[ "$default" == "y" ]]; then
        read -r -p "$prompt [Y/n]: " yn
        yn="${yn:-y}"
    else
        read -r -p "$prompt [y/N]: " yn
        yn="${yn:-n}"
    fi
    [[ "$yn" =~ ^[Yy] ]]
}

run_cmd() {
    if $DRY_RUN; then
        info "(dry-run) $*"
    else
        "$@"
    fi
}

show_help() {
    cat <<EOF
${BOLD}AI Dev Toolkit Setup v${VERSION}${RESET}

Usage: ${SCRIPT_NAME} [OPTIONS]

Options:
  --help          Show this help message and exit
  --claude-only   Install only Claude Code
  --opencode-only Install only OpenCode
  --all           Install all available tools
  --no-aliases    Skip shell alias installation
  --dry-run       Preview actions without executing

Examples:
  ${SCRIPT_NAME}                  # Interactive mode
  ${SCRIPT_NAME} --all            # Install everything non-interactively
  ${SCRIPT_NAME} --claude-only    # Install only Claude Code
  ${SCRIPT_NAME} --dry-run --all  # Preview full installation
EOF
    exit 0
}

# ---------------------------------------------------------------------------
# Detection Functions
# ---------------------------------------------------------------------------
detect_os() {
    step "Detecting operating system"
    case "$(uname -s)" in
        Darwin*)
            OS_TYPE="macos"
            local ver
            ver="$(sw_vers -productVersion 2>/dev/null || echo 'unknown')"
            success "Detected macOS ${ver}"
            ;;
        Linux*)
            OS_TYPE="linux"
            if [ -f /etc/os-release ]; then
                # shellcheck disable=SC1091
                . /etc/os-release
                DISTRO="${ID:-unknown}"
                success "Detected Linux (${PRETTY_NAME:-$DISTRO})"
            else
                DISTRO="unknown"
                warn "Linux detected but could not determine distribution"
            fi
            ;;
        *)
            error "Unsupported operating system: $(uname -s)"
            error "This script supports macOS and Linux. For Windows, use setup.ps1."
            exit 1
            ;;
    esac
}

detect_shell() {
    step "Detecting shell"
    local login_shell
    login_shell="$(basename "${SHELL:-/bin/bash}")"
    case "$login_shell" in
        bash) SHELL_NAME="bash" ;;
        zsh)  SHELL_NAME="zsh"  ;;
        fish) SHELL_NAME="fish" ;;
        *)    SHELL_NAME="bash"; warn "Unknown shell '$login_shell', defaulting to bash" ;;
    esac
    success "Shell: ${SHELL_NAME}"
}

# ---------------------------------------------------------------------------
# Node.js
# ---------------------------------------------------------------------------
check_node() {
    step "Checking for Node.js"
    if command -v node &>/dev/null; then
        local node_ver
        node_ver="$(node --version)"
        local major="${node_ver#v}"
        major="${major%%.*}"
        if (( major >= 18 )); then
            success "Node.js ${node_ver} found (meets minimum v18)"
            return 0
        else
            warn "Node.js ${node_ver} found but v18+ is required"
            return 1
        fi
    else
        warn "Node.js not found"
        return 1
    fi
}

install_node() {
    step "Installing Node.js"
    if $DRY_RUN; then
        info "(dry-run) Would install Node.js LTS"
        NODE_INSTALLED_BY_US=true
        return 0
    fi

    case "$OS_TYPE" in
        macos)
            if command -v brew &>/dev/null; then
                info "Installing via Homebrew..."
                brew install node@20
                success "Node.js installed via Homebrew"
            else
                info "Homebrew not found. Installing Node.js via official installer script..."
                curl -fsSL https://nodejs.org/dist/latest-v20.x/ -o /dev/null
                warn "Please install Node.js manually from https://nodejs.org/"
                exit 1
            fi
            ;;
        linux)
            info "Installing Node.js v20 LTS via NodeSource..."
            if command -v apt-get &>/dev/null; then
                curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
                sudo apt-get install -y nodejs
            elif command -v dnf &>/dev/null; then
                curl -fsSL https://rpm.nodesource.com/setup_20.x | sudo bash -
                sudo dnf install -y nodejs
            elif command -v pacman &>/dev/null; then
                sudo pacman -Sy --noconfirm nodejs npm
            else
                warn "Could not detect package manager. Please install Node.js v18+ manually."
                exit 1
            fi
            success "Node.js installed"
            ;;
    esac
    NODE_INSTALLED_BY_US=true
}

# ---------------------------------------------------------------------------
# Tool Selection
# ---------------------------------------------------------------------------
prompt_tool_selection() {
    step "Tool Selection"
    echo ""
    echo "  Available tools:"
    echo "    1) Claude Code  - Anthropic's CLI for Claude"
    echo "    2) OpenCode     - Open-source AI coding assistant"
    echo "    3) Both         - Install all tools"
    echo ""
    local choice
    read -r -p "  Select [1/2/3] (default: 3): " choice
    choice="${choice:-3}"
    case "$choice" in
        1) INSTALL_CLAUDE=true  ;;
        2) INSTALL_OPENCODE=true ;;
        3) INSTALL_CLAUDE=true; INSTALL_OPENCODE=true ;;
        *) warn "Invalid selection, installing both."; INSTALL_CLAUDE=true; INSTALL_OPENCODE=true ;;
    esac
}

# ---------------------------------------------------------------------------
# Install Tools
# ---------------------------------------------------------------------------
install_tool() {
    local name="$1"
    local package="$2"

    if command -v "$name" &>/dev/null; then
        local current_ver
        current_ver="$("$name" --version 2>/dev/null || echo 'unknown')"
        success "${name} is already installed (${current_ver})"
        if confirm "  Reinstall / upgrade ${name}?" "n"; then
            info "Upgrading ${name}..."
            run_cmd npm install -g "$package"
            success "${name} upgraded"
        fi
    else
        info "Installing ${name}..."
        run_cmd npm install -g "$package"
        success "${name} installed"
    fi
}

install_selected_tools() {
    step "Installing tools"

    if $INSTALL_CLAUDE; then
        install_tool "claude" "@anthropic-ai/claude-code"
    fi

    if $INSTALL_OPENCODE; then
        install_tool "opencode" "opencode-ai"
    fi
}

# ---------------------------------------------------------------------------
# Aliases
# ---------------------------------------------------------------------------
install_aliases() {
    if $SKIP_ALIASES; then
        info "Skipping alias installation (--no-aliases)"
        return
    fi

    step "Installing shell aliases"

    local alias_block=""
    alias_block+=$'\n# --- AI Dev Toolkit Aliases ---\n'
    if $INSTALL_CLAUDE; then
        alias_block+='alias cc="claude"'$'\n'
        alias_block+='alias cch="claude --help"'$'\n'
    fi
    if $INSTALL_OPENCODE; then
        alias_block+='alias oc="opencode"'$'\n'
        alias_block+='alias och="opencode --help"'$'\n'
    fi
    alias_block+='# --- End AI Dev Toolkit Aliases ---'$'\n'

    local rc_file=""
    case "$SHELL_NAME" in
        bash)
            rc_file="$HOME/.bashrc"
            [[ "$OS_TYPE" == "macos" ]] && rc_file="$HOME/.bash_profile"
            ;;
        zsh)
            rc_file="$HOME/.zshrc"
            ;;
        fish)
            rc_file="$HOME/.config/fish/config.fish"
            mkdir -p "$HOME/.config/fish"
            # Fish uses 'abbr' instead of 'alias'; rewrite block
            alias_block=$'\n# --- AI Dev Toolkit Aliases ---\n'
            if $INSTALL_CLAUDE; then
                alias_block+='abbr -a cc claude'$'\n'
                alias_block+='abbr -a cch "claude --help"'$'\n'
            fi
            if $INSTALL_OPENCODE; then
                alias_block+='abbr -a oc opencode'$'\n'
                alias_block+='abbr -a och "opencode --help"'$'\n'
            fi
            alias_block+='# --- End AI Dev Toolkit Aliases ---'$'\n'
            ;;
    esac

    if [ -z "$rc_file" ]; then
        warn "Could not determine shell config file. Skipping aliases."
        return
    fi

    # Idempotent: remove old block first
    if [ -f "$rc_file" ] && grep -q "AI Dev Toolkit Aliases" "$rc_file"; then
        info "Removing previous AI Dev Toolkit aliases from ${rc_file}"
        if ! $DRY_RUN; then
            sed -i.bak '/# --- AI Dev Toolkit Aliases ---/,/# --- End AI Dev Toolkit Aliases ---/d' "$rc_file"
            rm -f "${rc_file}.bak"
        fi
    fi

    info "Adding aliases to ${rc_file}"
    if ! $DRY_RUN; then
        printf '%s' "$alias_block" >> "$rc_file"
    fi
    success "Aliases installed in ${rc_file}"
    info "Run 'source ${rc_file}' or open a new terminal to activate."
}

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
print_summary() {
    step "Setup Complete"
    echo ""
    echo "  Installed tools:"
    $INSTALL_CLAUDE   && echo "    - Claude Code (claude)"
    $INSTALL_OPENCODE && echo "    - OpenCode    (opencode)"
    echo ""
    if ! $SKIP_ALIASES; then
        echo "  Aliases added to your ${SHELL_NAME} config:"
        $INSTALL_CLAUDE   && echo "    cc  -> claude"
        $INSTALL_OPENCODE && echo "    oc  -> opencode"
        echo ""
    fi
    echo "  Next steps:"
    echo "    1. Open a new terminal (or source your shell config)"
    echo "    2. Run 'claude' or 'opencode' to get started"
    echo "    3. See the docs/ folder for configuration guides"
    echo ""
    success "Happy coding!"
}

# ---------------------------------------------------------------------------
# Parse Arguments
# ---------------------------------------------------------------------------
parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --help|-h)       show_help ;;
            --claude-only)   INSTALL_CLAUDE=true;  INTERACTIVE=false ;;
            --opencode-only) INSTALL_OPENCODE=true; INTERACTIVE=false ;;
            --all)           INSTALL_CLAUDE=true; INSTALL_OPENCODE=true; INTERACTIVE=false ;;
            --no-aliases)    SKIP_ALIASES=true ;;
            --dry-run)       DRY_RUN=true; warn "Dry-run mode enabled" ;;
            *)               error "Unknown option: $1"; show_help ;;
        esac
        shift
    done
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
main() {
    echo ""
    printf "${BOLD}${CYAN}"
    echo "  ====================================="
    echo "   AI Dev Toolkit Setup v${VERSION}"
    echo "  ====================================="
    printf "${RESET}\n"

    parse_args "$@"

    detect_os
    detect_shell

    # Node.js
    if ! check_node; then
        if confirm "Install Node.js v20 LTS now?"; then
            install_node
        else
            error "Node.js v18+ is required. Aborting."
            exit 1
        fi
    fi

    # Tool selection
    if $INTERACTIVE; then
        prompt_tool_selection
    fi

    if ! $INSTALL_CLAUDE && ! $INSTALL_OPENCODE; then
        warn "No tools selected. Nothing to install."
        exit 0
    fi

    install_selected_tools
    install_aliases
    print_summary
}

main "$@"
