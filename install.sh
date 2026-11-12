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

echo "[*] Downloading compiled engine..."
# Binary ko HOME directory mein download kar rahe hain taaki direct chale
BINARY_PATH="/data/data/com.termux/files/home/vtx_binary"
curl -sL "https://raw.githubusercontent.com/$REPO_USER/$REPO_NAME/main/vtx_binary" -o "$BINARY_PATH"

if [ -f "$BINARY_PATH" ]; then
    chmod +x "$BINARY_PATH"
    echo "[✓] Engine downloaded and ready!"
else
    echo "[!] Download failed. Check GitHub repo."
    exit 1
fi

echo "[*] Creating launcher..."
# Launcher banayenge jo direct home wali binary ko run karega
cat > /data/data/com.termux/files/usr/bin/vtxpatcher << EOF
#!/data/data/com.termux/files/usr/bin/bash
$BINARY_PATH
EOF

# Permissions set karo
chmod +x /data/data/com.termux/files/usr/bin/vtxpatcher

echo ""
echo "═══════════════════════════════════════════"
echo "   ✅ INSTALLED SUCCESSFULLY"
echo "═══════════════════════════════════════════"
echo ""
echo "Ab terminal mein bas ye type karo:"
echo "  vtxpatcher"
echo ""
