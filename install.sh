#!/data/data/com.termux/files/usr/bin/bash

REPO_USER="vickyop725-hue"
REPO_NAME="vtx-pathcer"

echo ""
echo "═══════════════════════════════════════════"
echo "   🔧 VTX PATCHER INSTALLER"
echo "═══════════════════════════════════════════"
echo ""

echo "[*] Installing dependencies..."
pkg install -y python openjdk-21 apksigner zipalign openssl-tool curl

mkdir -p /sdcard/vtx

echo "[*] Downloading compiled script..."
# Yahan hum .enc ki jagah binary file (bina extension ke) download kar rahe hain
curl -sL "https://raw.githubusercontent.com/$REPO_USER/$REPO_NAME/main/vtx_binary" -o /sdcard/vtx/vtx_binary

if [ -f "/sdcard/vtx/vtx_binary" ]; then
    chmod +x /sdcard/vtx/vtx_binary
    echo "[✓] Binary downloaded and ready!"
else
    echo "[!] Download failed."
    exit 1
fi

# Launcher banao
echo "[*] Creating launcher..."
cat > /data/data/com.termux/files/usr/bin/vtxpatcher << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
/sdcard/vtx/vtx_binary
EOF

chmod +x /data/data/com.termux/files/usr/bin/vtxpatcher

echo ""
echo "═══════════════════════════════════════════"
echo "   ✅ INSTALLED SUCCESSFULLY"
echo "═══════════════════════════════════════════"
echo ""
echo "Ab chala: vtxpatcher"
