#!/data/data/com.termux/files/usr/bin/bash

# ==========================================
# VTX PATCHER TOOL - Menu Driven
# by @VICKYGAMING0
# ==========================================

VTX_DIR="/sdcard/vtx"
TARGET_SO="libEliteMods.so"

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

banner() {
    clear
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════╗"
    echo "║        🔧 VTX PATCHER TOOL           ║"
    echo "║          by @VICKYGAMING0            ║"
    echo "╚══════════════════════════════════════╝"
    echo -e "${NC}"
}

# ========== PATCH .SO ==========
patch_so() {
    local input="$1"
    local output="${input%.so}_patched.so"

    if [ ! -f "$input" ]; then
        echo -e "${RED}[!] File nahi mili: $input${NC}"
        return 1
    fi

    cp "$input" "$output"

    echo -e "${CYAN}[*] Patching: $input${NC}"

    python -c "
path = '$output'
with open(path, 'rb') as f:
    data = bytearray(f.read())

old = b'show'
new = b'hide'
count = 0
i = 0
while True:
    idx = data.find(old, i)
    if idx == -1: break
    before_ok = idx == 0 or not (chr(data[idx-1]).isalnum() or data[idx-1] == ord('_'))
    after_idx = idx + 4
    after_ok = after_idx >= len(data) or not (chr(data[after_idx]).isalnum() or data[after_idx] == ord('_'))
    if before_ok and after_ok:
        data[idx:idx+4] = new
        count += 1
    i = idx + 4

if count > 0:
    with open(path, 'wb') as f:
        f.write(data)
print(f'[+] Replaced: {count}')
"

    if [ -f "$output" ]; then
        echo -e "${GREEN}[✓] Patched: $output${NC}"
    fi
}

# ========== PATCH APK ==========
patch_apk() {
    local apk="$1"
    local out="$VTX_DIR/VTX_$(basename "$apk")"

    if [ ! -f "$apk" ]; then
        echo -e "${RED}[!] File nahi mili: $apk${NC}"
        return 1
    fi

    echo -e "${CYAN}[*] Looking for '$TARGET_SO'...${NC}"

    python -c "
import zipfile, shutil, sys
apk = '$apk'
out = '$out'
target = '$TARGET_SO'

with zipfile.ZipFile(apk, 'r') as zin:
    so_entry = None
    for n in zin.namelist():
        if n.endswith('/' + target) or n == target:
            so_entry = n
            break
    if not so_entry:
        print(f'[!] {target} not found')
        sys.exit(1)
    print(f'[*] Found: {so_entry}')
    data = zin.read(so_entry)

data = bytearray(data)
count = 0
i = 0
while True:
    idx = data.find(b'show', i)
    if idx == -1: break
    before_ok = idx == 0 or not (chr(data[idx-1]).isalnum() or data[idx-1] == ord('_'))
    after_idx = idx + 4
    after_ok = after_idx >= len(data) or not (chr(data[after_idx]).isalnum() or data[after_idx] == ord('_'))
    if before_ok and after_ok:
        data[idx:idx+4] = b'hide'
        count += 1
    i = idx + 4

if count == 0:
    print('[!] No exact show found')
    sys.exit(1)

print(f'[+] Replaced: {count}')

tmp = out + '.tmp'
with zipfile.ZipFile(apk, 'r') as zin:
    with zipfile.ZipFile(tmp, 'w', zipfile.ZIP_DEFLATED) as zout:
        for item in zin.infolist():
            if item.filename == so_entry:
                zout.writestr(item, bytes(data))
            else:
                zout.writestr(item, zin.read(item.filename))
shutil.move(tmp, out)
print(f'[+] APK: {out}')
"

    if [ ! -f "$out" ]; then
        echo -e "${RED}[!] Patch fail${NC}"
        return 1
    fi

    echo -e "${CYAN}[*] Signing...${NC}"
    uber="$VTX_DIR/uber-apk-signer.jar"
    if [ ! -f "$uber" ]; then
        echo -e "${YELLOW}[!] Uber download ho raha hai...${NC}"
        curl -sL "https://github.com/patrickfav/uber-apk-signer/releases/download/v1.3.0/uber-apk-signer-1.3.0.jar" -o "$uber"
    fi

    java -jar "$uber" --apks "$out" --allowResign --overwrite > /dev/null 2>&1

    for f in "${out%.apk}"*; do
        if [ "$f" != "$out" ] && [ -f "$f" ]; then
            rm -f "$f"
        fi
    done

    echo -e "${GREEN}[✓] Done: $out${NC}"
}

# ========== MENU ==========
menu() {
    banner
    echo "Kya karna hai bhai? Option select kar:"
    echo ""
    echo -e "  ${YELLOW}1.${NC} LIB Patch (.so file)"
    echo -e "  ${YELLOW}2.${NC} APK Patch ($TARGET_SO)"
    echo -e "  ${YELLOW}3.${NC} Help"
    echo -e "  ${YELLOW}4.${NC} Exit"
    echo ""
    read -p "$(echo -e ${CYAN}Enter choice [1-4]: ${NC})" choice

    case "$choice" in
        1)
            echo ""
            read -p "$(echo -e ${CYAN}.so file ka path daal: ${NC})" path
            echo ""
            patch_so "$path"
            ;;
        2)
            echo ""
            read -p "$(echo -e ${CYAN}APK file ka path daal: ${NC})" path
            echo ""
            patch_apk "$path"
            ;;
        3)
            echo ""
            echo -e "${YELLOW}USAGE:${NC}"
            echo "  LIB patch ke liye .so file ka path daal"
            echo "  APK patch ke liye .apk file ka path daal"
            echo ""
            echo -e "${YELLOW}EXAMPLES:${NC}"
            echo "  /sdcard/Download/libEliteMods.so"
            echo "  /sdcard/Download/app.apk"
            echo ""
            ;;
        4)
            echo "Bye bhai!"
            exit 0
            ;;
        *)
            echo -e "${RED}[!] Galat option${NC}"
            ;;
    esac

    echo ""
    read -p "$(echo -e ${YELLOW}Enter dabao aur menu pe wapas jaao...${NC})"
    menu
}

menu
