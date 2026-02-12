#!/usr/bin/env fish
# AI Dev Toolkit - Fish Alias Installer
# Part of ai-dev-toolkit-setup

set SCRIPT_DIR (dirname (status filename))
set CONF_DIR "$HOME/.config/fish/conf.d"

echo "AI Dev Toolkit - Fish Alias Installer"
echo "======================================"

mkdir -p $CONF_DIR

for file in claude-code.fish opencode.fish shared.fish
    set src "$SCRIPT_DIR/$file"
    set dst "$CONF_DIR/ai-toolkit-$file"
    if test -f $dst
        echo "Already installed: $file"
    else
        cp $src $dst
        echo "Installed: $file -> $dst"
    end
end

echo ""
echo "Done! Restart your terminal or run 'source ~/.config/fish/config.fish'"
