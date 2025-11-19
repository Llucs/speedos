#!/bin/bash
set -e

PROFILE_DIR="$(pwd)"

echo "[*] Limpando build anterior…"
rm -rf work out

echo "[*] Instalando dependências e compilando kernel Liquorix…"
sudo pacman -Syu --noconfirm base-devel git

# Clonar e instalar o kernel Liquorix
if [ ! -d "linux-lqx" ]; then
    git clone https://aur.archlinux.org/linux-lqx.git
fi
cd linux-lqx
makepkg -si --noconfirm
cd ..

echo "[*] Iniciando build da SpeedOS…"
mkarchiso -v -w work -o out "$PROFILE_DIR"

echo "[✔] ISO compilada com sucesso!"
echo "Arquivo gerado em: out/"