#!/bin/bash
set -e

PROFILE_DIR="$(pwd)"

echo "[*] Limpando build anterior…"
rm -rf work out

echo "[*] Iniciando build da SpeedOS…"
mkarchiso -v -w work -o out "$PROFILE_DIR"

echo "[✔] ISO compilada com sucesso!"
echo "Arquivo gerado em: out/"
