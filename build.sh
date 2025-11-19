#!/bin/bash
set -e

# Diretórios
WORK_DIR="$(pwd)"
REPO_DIR="$WORK_DIR/local_repo"
PACMAN_CONF="$WORK_DIR/pacman.conf"

# Limpeza inicial
echo "[*] Limpando builds anteriores..."
rm -rf work out "$REPO_DIR"
mkdir -p "$REPO_DIR"

# Instalar dependências para compilar (no host)
sudo pacman -Syu --noconfirm base-devel git wget archiso

# Função para compilar pacote e mover para o repo local
build_to_repo() {
    PKG_NAME=$1
    echo "------------------------------------------------"
    echo "[*] Preparando pacote: $PKG_NAME"
    echo "------------------------------------------------"
    
    if [ -d "$PKG_NAME" ]; then
        rm -rf "$PKG_NAME"
    fi
    
    # Clona do AUR (funciona para kernel-lqx, temas e calamares-git)
    git clone "https://aur.archlinux.org/$PKG_NAME.git"
    
    cd "$PKG_NAME"
    # Compila sem instalar (-s: deps, -c: clean, --noconfirm)
    makepkg -s -c --noconfirm
    
    # Move o pacote compilado para o repo local
    mv *.pkg.tar.zst "$REPO_DIR/"
    cd ..
    rm -rf "$PKG_NAME"
}

# 1. Compilar Kernel LQX
build_to_repo "linux-lqx"
build_to_repo "linux-lqx-headers"

# 2. Compilar Temas e Ícones (Usando versões AUR/Git para facilitar)
build_to_repo "sweet-gtk-theme"
build_to_repo "sweet-theme-git" # Se preferir o git
build_to_repo "arc-gtk-theme"   # Versão AUR ou oficial
build_to_repo "tela-icon-theme"

# 3. Compilar Calamares (Usar o AUR é muito mais seguro que compilar raw source)
build_to_repo "calamares-git"
build_to_repo "calamares-extensions-git" # Se existir no AUR, senão remova

# 4. Criar a base de dados do repositório
echo "[*] Gerando base de dados do pacman..."
repo-add "$REPO_DIR/speedos_repo.db.tar.gz" "$REPO_DIR"/*.pkg.tar.zst

# 5. Injetar o repositório no pacman.conf
# Isso garante que o mkarchiso ache os pacotes que acabamos de criar
if ! grep -q "\[speedos_repo\]" "$PACMAN_CONF"; then
    echo "[*] Adicionando repo ao pacman.conf..."
    cat <<EOT >> "$PACMAN_CONF"

[speedos_repo]
SigLevel = Optional TrustAll
Server = file://$REPO_DIR
EOT
fi

# 6. Iniciar build da ISO
echo "[*] Iniciando build da SpeedOS..."
mkarchiso -v -w work -o out "$WORK_DIR"

echo "[✔] ISO compilada com sucesso!"
