#!/usr/bin/env bash
set -e
REPO_URL="https://github.com/Lifantel/ytcli.git"
INSTALL_DIR="$HOME/.local/share/ytcli"
VENV_DIR="$INSTALL_DIR/venv"
echo "=== ytcli kurulum scripti ==="
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO_ID="$ID"
else
    echo "HATA: Distro tespit edilemedi (/etc/os-release yok)."
    exit 1
fi
install_system_deps() {
    case "$DISTRO_ID" in
        fedora)
            sudo dnf install -y python3 python3-pip python3-virtualenv mpv git
            ;;
        ubuntu|debian|linuxmint|pop)
            sudo apt update
            sudo apt install -y python3 python3-pip python3-venv mpv git
            ;;
        arch|cachyos|manjaro|endeavouros)
            sudo pacman -Sy --needed --noconfirm python python-pip mpv git
            ;;
        opensuse*|suse)
            sudo zypper install -y python3 python3-pip python3-virtualenv mpv git
            ;;
        *)
            echo "HATA: Desteklenmeyen distro: $DISTRO_ID"
            echo "Lütfen python3, pip, venv, mpv ve git paketlerini manuel kurun."
            exit 1
            ;;
    esac
}
echo "[1/5] Sistem bağımlılıkları kuruluyor ($DISTRO_ID)..."
install_system_deps
echo "[2/5] Repo klonlanıyor..."
if [ -d "$INSTALL_DIR/.git" ]; then
    echo "Repo zaten mevcut, güncelleniyor..."
    git -C "$INSTALL_DIR" pull
else
    rm -rf "$INSTALL_DIR"
    git clone "$REPO_URL" "$INSTALL_DIR"
fi
echo "[3/5] Sanal ortam oluşturuluyor..."
if [ ! -d "$VENV_DIR" ]; then
    python3 -m venv "$VENV_DIR"
fi
source "$VENV_DIR/bin/activate"
echo "[4/5] Python bağımlılıkları kuruluyor..."
pip install --upgrade pip
if [ -f "$INSTALL_DIR/requirements.txt" ]; then
    pip install -r "$INSTALL_DIR/requirements.txt"
else
    pip install yt-dlp
fi
echo "[5/5] ytcli başlatılıyor..."
python "$INSTALL_DIR/src/ytcli.py"

deactivate
