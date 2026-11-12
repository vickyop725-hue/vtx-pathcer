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
# File ko Termux ke internal folder me download kar rahe hain
curl -sL "https://raw.githubusercontent.com/$REPO_USER/$REPO_NAME/main/vtx_binary" -o /data/data/com.termux/files/home/vtx_binary

if [ -f "/data/data/com.termux/files/home/vtx_binary" ]; then
    chmod +x /data/data/com.termux/files/home/vtx_binary
    echo "[✓] Binary downloaded and ready!"
else
    echo "[!] Download failed."
    exit 1
fi

# Launcher banao
echo "[*] Creating launcher..."
cat > /data/data/com.termux/files/usr/bin/vtxpatcher << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
/data/data/com.termux/files/home/vtx_binary
EOF

chmod +x /data/data/com.termux/files/usr/bin/vtxpatcher

echo ""
echo "═══════════════════════════════════════════"
echo "   ✅ INSTALLED SUCCESSFULLY"
echo "═══════════════════════════════════════════"
echo ""
echo "Ab chala: vtxpatcher"
