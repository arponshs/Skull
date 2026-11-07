#!/data/data/com.termux/files/usr/bin/bash
# Skull intro animation for Termux
[ -t 1 ] || exit 0
C=$(tput cols); R=$(tput lines)
cleanup(){ tput cnorm; printf '\e[0m'; pkill -f "synth" 2>/dev/null; clear; exit 0; }
trap cleanup INT TERM
tput civis
case $((RANDOM%3)) in
  0) D1=52; D2=88; M=196; E=226;;
  1) D1=22; D2=28; M=46;  E=231;;
  *) D1=53; D2=93; M=201; E=51;;
esac
CH='ABCDEF0123456789@#$&*+=<>?/|:;'
MS=("WELCOME BACK, OPERATOR" "THE SYSTEM IS WATCHING YOU" "NO ONE ESCAPES THE GRID" "YOUR SOUL BELONGS TO ROOT" "ACCESS LEVEL: GOD MODE" "TRUST NO ONE. TRUST NOTHING.")
MSGTXT=""
S=0; command -v play >/dev/null && S=1
[ "$SKULL_MUTE" = 1 ] && S=0
snd(){ ((S)) && (play -q -n synth "$1" square "$2" vol 0.15 >/dev/null 2>&1 &); }
drone(){ ((S)) && (play -q -n synth 2.2 sine 50 sine 53 tremolo 6 vol 0.6 >/dev/null 2>&1 &); }
nap(){ read -rsn1 -t "$1" _ && cleanup; }

# Small screen: text-only effect
if ((R<22 || C<34)); then
  clear; t="${MS[RANDOM%${#MS[@]}]}"
  for((k=0;k<=${#t};k++)); do s="${t:0:k}"; for((i=k;i<${#t};i++)); do s+=${CH:RANDOM%${#CH}:1}; done
    printf '\r\e[38;5;%dm%s' $M "$s"; nap 0.03; done
  nap 0.6; cleanup
fi

# Left half of the skull; the right half is mirrored automatically
LH=(
"        ▄▄▄▄▄▄▄▄"
"    ▄▄██████████"
"  ▄█████████████"
" ▄██████████████"
" ███████████████"
" ███████████████"
" ███████▀▀▀█████"
" ██████▀     ▀██"
" ██████       ██"
" ███████▄   ▄███"
" ██████████▀▀▄"
"  ▀█████████████"
"     █▀█▀█▀█▀█▀█"
)
J1="      ▀█▀█▀█▀█▀█"; J2="        ▀▀▀▀▀▀▀▀"
mirror(){ local l r="" i; printf -v l '%-16s' "$1"; for((i=15;i>=0;i--)); do r+=${l:i:1}; done; MR="$l$r"; }
SK=(); for h in "${LH[@]}"; do mirror "$h"; SK+=("$MR"); done
mirror "$J1"; JA="$MR"; mirror "$J2"; JB="$MR"
top=$(((R-21)/2+1)); ((top<1))&&top=1
left=$(((C-32)/2+1)); ((left<1))&&left=1

at(){ printf '\e[%d;%dH' "$1" "$2"; }
draw_all(){ local i; for i in "${!SK[@]}"; do at $((top+i)) $left; printf '\e[38;5;%dm%s' $1 "${SK[i]}"; done; }
eyes(){ printf '\e[%d;%dH\e[1;38;5;%dm▓◉▓\e[%d;%dH▓◉▓\e[0m' $((top+8)) $((left+9)) $1 $((top+8)) $((left+20)); }
jaw(){ local k
  for k in 0 1 2 3 4; do at $((top+13+k)) $left; printf '%32s' ''; done
  at $((top+13+$1)) $left; printf '\e[38;5;%dm%s' $M "$JA"
  at $((top+14+$1)) $left; printf '\e[38;5;%dm%s' $M "$JB"; }
msg(){ local n=${#MSGTXT} cl; cl=$(((C-n)/2+1)); ((cl<1))&&cl=1
  at $((top+19)) 1; printf '\e[2K'; at $((top+19)) $cl; printf '\e[1;38;5;%dm%s\e[0m' $M "$MSGTXT"; }
scene(){ clear; draw_all $M; eyes $E; jaw 0; [ -n "$MSGTXT" ] && msg; }
glitch(){ local i y x w s j g='▓▒░█▄▀#@&'
  for i in 1 2 3 4 5 6 7 8; do
    y=$((RANDOM%R+1)); x=$((RANDOM%C+1)); w=$((RANDOM%14+3)); ((x+w>C+1))&&w=$((C-x+1)); s=""
    for((j=0;j<w;j++)); do s+=${g:RANDOM%9:1}; done
    printf '\e[%d;%dH\e[38;5;%dm%s' $y $x $M "$s"
  done; snd 0.04 $((RANDOM%1500+200)); nap 0.06; scene; }

# ================= ANIMATION =================
clear; drone
# 1) skull fades in
for i in "${!SK[@]}"; do at $((top+i)) $left; printf '\e[38;5;%dm%s' $D1 "${SK[i]}"; snd 0.02 $((150+i*40)); nap 0.05; done
draw_all $D2; nap 0.12; draw_all $M; nap 0.1
# 2) eyes ignite
for c in $D1 $D2 $M $E; do eyes $c; snd 0.05 $((300+c)); nap 0.14; done
for i in 1 2 3 4 5 6; do eyes $((RANDOM%2?E:231)); nap 0.05; eyes $D2; nap 0.04; done; eyes $E
# 3) jaw shake + glitch
for i in 1 2 3 4 5 6 7 8; do jaw 2; snd 0.05 $((120+RANDOM%100)); nap 0.08; jaw 0; nap 0.07; ((i%3==0))&&glitch; done
# 4) scary message decode
t="${MS[RANDOM%${#MS[@]}]}"; n=${#t}
for((k=0;k<=n;k++)); do
  s="${t:0:k}"; for((i=k;i<n;i++)); do s+=${CH:RANDOM%${#CH}:1}; done
  MSGTXT="$s"; msg; ((k%2==0))&&snd 0.02 $((900+k*25)); nap 0.03
done
MSGTXT="$t"; msg
jaw 2; nap 0.2; jaw 0; glitch; nap 0.3; glitch; nap 0.5
# 5) fade out
draw_all $D2; eyes $D2; nap 0.12; draw_all $D1; eyes $D1; nap 0.12
cleanup
