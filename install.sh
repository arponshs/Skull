#!/data/data/com.termux/files/usr/bin/bash
# BHHK Skull Intro Installer

CYAN='\033[0;36m'; PINK='\033[0;35m'; GREEN='\033[0;32m'
WHITE='\033[1;37m'; DIM='\033[2m'; NC='\033[0m'

clear
echo ""
echo -e "${CYAN}  ╔══════════════════════════════════════╗${NC}"
echo -e "${CYAN}  ║${NC}  ${PINK}💀 BHHK SKULL INTRO INSTALLER 💀${NC}  ${CYAN}║${NC}"
echo -e "${CYAN}  ╚══════════════════════════════════════╝${NC}"
echo ""

# Dependencies
echo -e "${CYAN}▸${NC} ${WHITE}Installing dependencies...${NC}"
pkg update -y > /dev/null 2>&1
for pkg in bash coreutils sox; do
    if dpkg -l "$pkg" > /dev/null 2>&1; then
        echo -e "  ${DIM}✓ ${pkg} already installed${NC}"
    else
        pkg install -y "$pkg" > /dev/null 2>&1
        echo -e "  ${GREEN}✓${NC} ${WHITE}${pkg} installed${NC}"
    fi
done
echo ""

# স্ক্রিপ্ট সেটআপ
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
MAIN="$SCRIPT_DIR/skull.sh"

if [ ! -f "$MAIN" ]; then
    echo -e "${PINK}✗ skull.sh not found${NC}"
    exit 1
fi

chmod +x "$MAIN"

# .bashrc তে অ্যাড করা
BASHRC="$HOME/.bashrc"
MARKER="# BHHK SKULL INTRO"

if grep -q "$MARKER" "$BASHRC" 2>/dev/null; then
    echo -e "  ${WHITE}⚠ Already installed in .bashrc${NC}"
else
    echo "" >> "$BASHRC"
    echo "$MARKER" >> "$BASHRC"
    echo "bash $MAIN" >> "$BASHRC"
    echo -e "  ${GREEN}✓ Auto-start enabled${NC}"
fi

echo ""
echo -e "${GREEN}  ✓ INSTALLATION COMPLETE!${NC}"
echo ""
echo -e "  ${WHITE}Restart Termux to see the magic!${NC}"
echo -e "  ${DIM}Or run manually: bash $MAIN${NC}"
echo -e "  ${DIM}To mute sound: SKULL_MUTE=1 bash $MAIN${NC}"
echo ""