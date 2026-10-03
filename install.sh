#!/data/data/com.termux/files/usr/bin/bash

REPO_USER="TERA_GITHUB_USERNAME"
REPO_NAME="vtx-patcher"

echo "[*] Installing VTX Patcher..."

pkg install -y python openjdk-17 curl

mkdir -p ~/.local/bin
mkdir -p /sdcard/vtx

cat > ~/.local/bin/vtx << EOF
#!/data/data/com.termux/files/usr/bin/bash
VTX_SCRIPT="/sdcard/vtx/vtx.sh"
GITHUB_RAW="https://raw.githubusercontent.com/$REPO_USER/$REPO_NAME/main/vtx.sh"

if [ ! -f "\$VTX_SCRIPT" ]; then
    mkdir -p /sdcard/vtx
    curl -sL "\$GITHUB_RAW" -o "\$VTX_SCRIPT"
fi

bash "\$VTX_SCRIPT"
EOF

chmod +x ~/.local/bin/vtx

if ! grep -q '.local/bin' ~/.bashrc; then
    echo 'export PATH="$PATH:$HOME/.local/bin"' >> ~/.bashrc
fi

if [ ! -f "/sdcard/vtx/uber-apk-signer.jar" ]; then
    echo "[*] Downloading uber-apk-signer..."
    curl -sL "https://github.com/patrickfav/uber-apk-signer/releases/download/v1.3.0/uber-apk-signer-1.3.0.jar" -o "/sdcard/vtx/uber-apk-signer.jar"
fi

echo "[✓] Installed!"
echo ""
echo "Ab chala:"
echo "  vtx"