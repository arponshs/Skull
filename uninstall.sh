#!/data/data/com.termux/files/usr/bin/bash
# BHHK Skull Intro Uninstaller

CYAN='\033[0;36m'; PINK='\033[0;35m'; GREEN='\033[0;32m'; WHITE='\033[1;37m'; NC='\033[0m'

clear
echo -e "${CYAN}▸${NC} ${WHITE}Removing BHHK Skull Intro...${NC}"

BASHRC="$HOME/.bashrc"
MARKER="# BHHK SKULL INTRO"

if grep -q "$MARKER" "$BASHRC" 2>/dev/null; then
    # মার্কার এবং তার নিচের লাইনটি ডিলিট করা
    grep -v "$MARKER" "$BASHRC" | grep -v "skull.sh" > "$BASHRC.tmp"
    mv "$BASHRC.tmp" "$BASHRC"
    echo -e "  ${GREEN}✓ Removed from auto-start${NC}"
else
    echo -e "  ${WHITE}⚠ Not installed in .bashrc${NC}"
fi

echo ""
echo -e "${GREEN}✓ Uninstall Complete!${NC}"
echo -e "  ${WHITE}Restart Termux to apply changes.${NC}"
echo ""