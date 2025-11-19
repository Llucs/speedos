#!/bin/bash
set -e

PROFILE_DIR="$(pwd)"

echo "[*] Limpando build anterior…"
rm -rf work out

echo "[*] Instalando dependências base…"
sudo pacman -Syu --noconfirm base-devel git wget

# -----------------------------
# Clonar e instalar o kernel Liquorix
# -----------------------------
if [ ! -d "linux-lqx" ]; then
    git clone https://aur.archlinux.org/linux-lqx.git
fi
cd linux-lqx
makepkg -si --noconfirm
cd ..

# -----------------------------
# Clonar e instalar pacotes AUR adicionais
# -----------------------------
AUR_PKGS=(preload sweet-gtk-theme sweet-gtk-theme-dark sweet-theme-git)

for pkg in "${AUR_PKGS[@]}"; do
  if [ ! -d "$pkg" ]; then
    git clone "https://aur.archlinux.org/${pkg}.git"
  fi
  cd "$pkg"
  makepkg -si --noconfirm
  cd ..
done

# -----------------------------
# Instalar pacotes do GitHub (Arc, Tela, Calamares)
# -----------------------------

# Arc GTK Theme
if [ ! -d "arc-gtk-theme" ]; then
    git clone https://github.com/horst3180/arc-theme.git arc-gtk-theme
fi
cd arc-gtk-theme
./autogen.sh --prefix=/usr
make
sudo make install
cd ..

# Tela Icon Theme
if [ ! -d "tela-icon-theme" ]; then
    git clone https://github.com/vinceliuice/Tela-icon-theme.git
fi
cd Tela-icon-theme
./install.sh
cd ..

# Calamares + Extensions
if [ ! -d "calamares" ]; then
    git clone https://github.com/calamares/calamares.git
fi
cd calamares
mkdir -p build && cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/usr
make -j$(nproc)
sudo make install
cd ../..

if [ ! -d "calamares-extensions" ]; then
    git clone https://github.com/calamares/calamares-extensions.git
fi
cd calamares-extensions
mkdir -p build && cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/usr
make -j$(nproc)
sudo make install
cd ../..

# -----------------------------
# Iniciar build da ISO
# -----------------------------
echo "[*] Iniciando build da SpeedOS…"
mkarchiso -v -w work -o out "$PROFILE_DIR"

echo "[✔] ISO compilada com sucesso!"
echo "Arquivo gerado em: out/"