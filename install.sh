#!/data/data/com.termux/files/usr/bin/bash
# Skull Intro installer for Termux
# Usage:  bash install.sh            (install)
#         bash install.sh uninstall  (remove)

# >>> CHANGE THIS to your own GitHub username and repo name <<<
RAW="https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main"

DIR="$HOME/.skull"
BRC="$HOME/.bashrc"
MARK="# --- Skull intro ---"

if [ "$1" = "uninstall" ]; then
  sed -i "/$MARK/,/^fi\$/d" "$BRC" 2>/dev/null
  rm -rf "$DIR"
  echo "[+] Skull intro removed. Restart Termux."
  exit 0
fi

echo "[*] Installing dependencies..."
pkg install -y curl sox pulseaudio >/dev/null 2>&1

mkdir -p "$DIR"

# Use local skull.sh if it sits next to install.sh, otherwise download it
SRC="$(cd "$(dirname "$0")" 2>/dev/null && pwd)/skull.sh"
if [ -f "$SRC" ]; then
  cp "$SRC" "$DIR/skull.sh"
else
  echo "[*] Downloading skull.sh..."
  curl -fsSL "$RAW/skull.sh" -o "$DIR/skull.sh" || { echo "[!] Download failed. Check the RAW URL in install.sh"; exit 1; }
fi
chmod +x "$DIR/skull.sh"

# Add startup hook (only once)
touch "$BRC"
if ! grep -q "$MARK" "$BRC"; then
  cat >> "$BRC" << 'EOF'

# --- Skull intro ---
if [[ $- == *i* && -z "$SKULL_DONE" ]]; then
  export SKULL_DONE=1
  bash "$HOME/.skull/skull.sh"
fi
EOF
fi

# Quiet the default Termux welcome message
touch "$HOME/.hushlogin"

# Shortcut command
grep -q "alias skull=" "$BRC" || echo "alias skull='bash \$HOME/.skull/skull.sh'" >> "$BRC"

echo "[+] Done! Type 'exit' and reopen Termux, or run: skull"
