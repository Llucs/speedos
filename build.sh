#!/bin/bash
set -e

PROFILE_DIR="$(pwd)"

echo "[*] Limpando build anterior…"
rm -rf work out

echo "[*] Instalando dependências base e compilando pacotes AUR…"
sudo pacman -Syu --noconfirm base-devel git

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
# Iniciar build da ISO
# -----------------------------
echo "[*] Iniciando build da SpeedOS…"
mkarchiso -v -w work -o out "$PROFILE_DIR"

echo "[✔] ISO compilada com sucesso!"
echo "Arquivo gerado em: out/"