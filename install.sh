#!/data/data/com.termux/files/usr/bin/bash
# BHHK Skull Intro - Installer

CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
WHITE='\033[1;37m'
DIM='\033[2m'
RST='\033[0m'

clear
echo -e "${CYAN}=======================================${RST}"
echo -e "  💀 BHHK Skull Intro Installer ${RST}"
echo -e "${CYAN}=======================================${RST}"
echo ""

# ১. সাউন্ড প্যাকেজ (ঐচ্ছিক, তবে থাকলে আরও সুন্দর লাগে)
echo -e "${CYAN}▸${RST} Installing dependencies (sox)..."
pkg install sox -y > /dev/null 2>&1

# ২. ফাইল কপি করা
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKULL_SRC="$SCRIPT_DIR/skull.sh"
SKULL_DEST="$HOME/.skull_intro.sh"

if [ ! -f "$SKULL_SRC" ]; then
    echo -e "${RED}✗ skull.sh not found!${RST}"
    exit 1
fi

cp "$SKULL_SRC" "$SKULL_DEST"
chmod +x "$SKULL_DEST"
echo -e "${GREEN}✓${RST} skull.sh copied to ~/.skull_intro.sh"

# ৩. .bashrc তে যুক্ত করা (যাতে Termux খুললেই চলে)
BASHRC="$HOME/.bashrc"
if ! grep -q "skull_intro.sh" "$BASHRC" 2>/dev/null; then
    echo "" >> "$BASHRC"
    echo "# BHHK Skull Intro" >> "$BASHRC"
    echo "~/.skull_intro.sh" >> "$BASHRC"
    echo -e "${GREEN}✓${RST} Added to ~/.bashrc (Auto-start enabled)"
else
    echo -e "${DIM}✓ Already in ~/.bashrc${RST}"
fi

echo ""
echo -e "${CYAN}=======================================${RST}"
echo -e "${GREEN}✓ Installation Complete!${RST}"
echo -e "${CYAN}=======================================${RST}"
echo -e "Restart Termux to see the magic. 💀"
echo ""

# ৪. সাথে সাথে টেস্ট করার অপশন
printf "  ${DIM}Do you want to test it now? [Y/n]: ${RST}"
read -r ans
case "$ans" in
    n|N) echo -e "\n  ${DIM}Run ~/.skull_intro.sh manually anytime.${RST}\n";;
    *) bash "$SKULL_DEST";;
esac