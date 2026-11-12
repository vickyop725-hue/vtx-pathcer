#!/data/data/com.termux/files/usr/bin/bash

# Apna repo name sahi set karo
REPO_USER="vickyop725-hue"
REPO_NAME="DIGLOGKILLER"

echo "[*] Installing dependencies..."
pkg install -y python openjdk-21 apksigner zipalign openssl-tool curl

mkdir -p ~/.local/bin
mkdir -p /sdcard/vtx

echo "[*] Creating launcher..."
cat > ~/.local/bin/vtxpatcher << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
openssl enc -aes-256-cbc -d -in /sdcard/vtx/vtx.enc -k "VTX2024SECRET" 2>/dev/null | bash
EOF

chmod +x ~/.local/bin/vtxpatcher

if ! grep -q '.local/bin' ~/.bashrc; then
    echo 'export PATH="$PATH:$HOME/.local/bin"' >> ~/.bashrc
fi

# Yahan apni encrypted file ka sahi link hai
echo "[*] Downloading encrypted script..."
curl -sL "https://raw.githubusercontent.com/$REPO_USER/$REPO_NAME/main/vtx.enc" -o /sdcard/vtx/vtx.enc

if [ -f /sdcard/vtx/vtx.enc ]; then
    SIZE=$(stat -c%s /sdcard/vtx/vtx.enc 2>/dev/null)
    echo "[✓] Script downloaded ($SIZE bytes)"
else
    echo "[!] Download failed"
    exit 1
fi

echo ""
echo "✅ INSTALLED SUCCESSFULLY"
echo "Ab chala: source ~/.bashrc && vtxpatcher"
