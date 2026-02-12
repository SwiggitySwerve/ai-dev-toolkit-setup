#!/usr/bin/env bash
# AI Dev Toolkit - Bash/Zsh Alias Installer
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ALIAS_FILES=("claude-code.sh" "opencode.sh" "shared.sh")

# Detect shell config file
if [ -n "$ZSH_VERSION" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    SHELL_RC="$HOME/.bashrc"
else
    SHELL_RC="$HOME/.bashrc"
fi

echo "AI Dev Toolkit - Alias Installer"
echo "================================"
echo "Shell config: $SHELL_RC"
echo ""

for file in "${ALIAS_FILES[@]}"; do
    source_line="source \"$SCRIPT_DIR/$file\""
    if grep -qF "$source_line" "$SHELL_RC" 2>/dev/null; then
        echo "Already installed: $file"
    else
        echo "" >> "$SHELL_RC"
        echo "# AI Dev Toolkit - $file" >> "$SHELL_RC"
        echo "$source_line" >> "$SHELL_RC"
        echo "Installed: $file -> $SHELL_RC"
    fi
done

echo ""
echo "Done! Run 'source $SHELL_RC' or restart your terminal to activate."
