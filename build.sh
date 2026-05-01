#!/bin/bash
set -e

# Diretórios
WORK_DIR="$(pwd)"
REPO_DIR="$WORK_DIR/local_repo"
PACMAN_CONF="$WORK_DIR/pacman.conf"

echo "[*] Iniciando build do SpeedOS..."

# =========================
# 0. Verificações
# =========================
if [ ! -f "$PACMAN_CONF" ]; then
    echo "[ERRO] pacman.conf não encontrado!"
    exit 1
fi

# =========================
# 1. Limpeza
# =========================
echo "[*] Limpando builds anteriores..."
rm -rf work out "$REPO_DIR"
mkdir -p "$REPO_DIR"

# =========================
# 2. Dependências
# =========================
echo "[*] Instalando dependências..."
sudo pacman -Syu --noconfirm --needed base-devel git wget archiso

# =========================
# 3. Função de build
# =========================
build_to_repo() {
    PKG_NAME=$1

    echo "------------------------------------------------"
    echo "[*] Buildando: $PKG_NAME"
    echo "------------------------------------------------"

    rm -rf "$PKG_NAME"
    git clone --depth=1 "https://aur.archlinux.org/$PKG_NAME.git"

    cd "$PKG_NAME"

    if ! makepkg -s --noconfirm --needed; then
        echo "[ERRO] Falha ao buildar $PKG_NAME"
        exit 1
    fi

    mv *.pkg.tar.zst "$REPO_DIR/" || true

    cd ..
    rm -rf "$PKG_NAME"
}

# =========================
# 4. Pacotes AUR
# =========================

# Kernel
build_to_repo "linux-lqx"
build_to_repo "linux-lqx-headers"

# Temas
build_to_repo "sweet-gtk-theme"
build_to_repo "tela-icon-theme"

# (Opcional)
# build_to_repo "sweet-theme-git"

# Calamares (melhor evitar git se possível)
build_to_repo "calamares"

# =========================
# 5. Criar repo
# =========================
echo "[*] Criando repositório..."
repo-add "$REPO_DIR/speedos_repo.db.tar.gz" "$REPO_DIR"/*.pkg.tar.zst

# =========================
# 6. Adicionar ao pacman.conf
# =========================
if ! grep -q "\[speedos_repo\]" "$PACMAN_CONF"; then
    echo "[*] Adicionando repo local..."

    cat <<EOT >> "$PACMAN_CONF"

[speedos_repo]
SigLevel = Optional TrustAll
Server = file://$REPO_DIR
EOT
fi

# =========================
# 7. Build ISO
# =========================
echo "[*] Gerando ISO..."
mkarchiso -v -w work -o out "$WORK_DIR"

echo "[✔] SpeedOS ISO pronta!"