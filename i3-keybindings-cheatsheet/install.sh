#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INSTALL_DIR="$HOME/.local/bin"

echo "⌨  i3 Keybindings Cheatsheet — Installer"
echo ""

# Ensure install dir exists
mkdir -p "$INSTALL_DIR"

# Copy scripts
cp "$SCRIPT_DIR/i3-cheatsheet-server" "$INSTALL_DIR/"
cp "$SCRIPT_DIR/i3-cheatsheet-open" "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/i3-cheatsheet-server" "$INSTALL_DIR/i3-cheatsheet-open"
echo "✓ Scripts installed to $INSTALL_DIR"

# Check if already in i3 config
I3_CONFIG="$HOME/.config/i3/config"
if [ -f "$I3_CONFIG" ]; then
    if ! grep -q "i3-cheatsheet-server" "$I3_CONFIG"; then
        read -p "→ Add autostart to i3 config? [y/N] " yn
        if [[ "$yn" =~ ^[Yy]$ ]]; then
            echo "" >> "$I3_CONFIG"
            echo "# Keybinding cheatsheet server" >> "$I3_CONFIG"
            echo "exec --no-startup-id ~/.local/bin/i3-cheatsheet-server" >> "$I3_CONFIG"
            echo "✓ Added autostart to i3 config"
        fi
    else
        echo "✓ Autostart already in i3 config"
    fi
fi

# Check if polybar config exists
POLYBAR_CONFIG="$HOME/.config/polybar/config.ini"
if [ -f "$POLYBAR_CONFIG" ]; then
    if ! grep -q "module/cheatsheet" "$POLYBAR_CONFIG"; then
        read -p "→ Add cheatsheet module to polybar? [y/N] " yn
        if [[ "$yn" =~ ^[Yy]$ ]]; then
            echo ""
            echo "Add this to your polybar config.ini:"
            echo ""
            echo '  [module/cheatsheet]'
            echo '  type = custom/text'
            echo '  format = "  ⌨  "'
            echo '  format-font = 1'
            echo '  format-foreground = ${colors.foreground-alt}'
            echo '  format-padding = 1'
            echo '  click-left = ~/.local/bin/i3-cheatsheet-open'
            echo ""
            echo "Then add 'cheatsheet' to your modules-center or modules-right."
        fi
    else
        echo "✓ Polybar module already configured"
    fi
fi

# Start the server
if ! pgrep -f "i3-cheatsheet-server" > /dev/null 2>&1; then
    read -p "→ Start the server now? [Y/n] " yn
    if [[ ! "$yn" =~ ^[Nn]$ ]]; then
        nohup "$INSTALL_DIR/i3-cheatsheet-server" > /dev/null 2>&1 &
        echo "✓ Server started on http://127.0.0.1:9876"
    fi
else
    echo "✓ Server already running"
fi

echo ""
echo "Done! Open http://127.0.0.1:9876 or click the ⌨ icon on your polybar."
