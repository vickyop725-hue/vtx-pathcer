#!/data/data/com.termux/files/usr/bin/bash

REPO_USER="vickyop725-hue"
REPO_NAME="vtx-patcher"

echo ""
echo "═══════════════════════════════════════════"
echo "   🔧 VTX PATCHER INSTALLER"
echo "═══════════════════════════════════════════"
echo ""

# Dependencies
echo "[*] Installing dependencies..."
pkg install -y python openjdk-21 apksigner zipalign openssl-tool curl

# Folders
mkdir -p ~/.local/bin
mkdir -p /sdcard/vtx

# Launcher banao
echo "[*] Creating launcher..."
cat > ~/.local/bin/vtx << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
openssl enc -aes-256-cbc -d -in /sdcard/vtx/vtx.enc -k "VTX2024SECRET" 2>/dev/null | bash
EOF

chmod +x ~/.local/bin/vtx

# PATH add
if ! grep -q '.local/bin' ~/.bashrc; then
    echo 'export PATH="$PATH:$HOME/.local/bin"' >> ~/.bashrc
fi

# Encrypted script download karo
echo "[*] Downloading encrypted script..."
curl -sL "https://raw.githubusercontent.com/$REPO_USER/$REPO_NAME/main/vtx.enc" -o /sdcard/vtx/vtx.enc

# Verify
if [ -f /sdcard/vtx/vtx.enc ]; then
    SIZE=$(stat -c%s /sdcard/vtx/vtx.enc 2>/dev/null)
    echo "[✓] Script downloaded ($SIZE bytes)"
else
    echo "[!] Download failed"
    exit 1
fi

echo ""
echo "═══════════════════════════════════════════"
echo "   ✅ INSTALLED SUCCESSFULLY"
echo "═══════════════════════════════════════════"
echo ""
echo "Ab chala:"
echo "  source ~/.bashrc"
echo "  vtx"
echo ""
