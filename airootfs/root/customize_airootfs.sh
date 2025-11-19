#!/bin/bash
set -e

umask 022

# 1. Garante que os scripts auxiliares sejam executáveis
chmod +x /root/*.sh 2>/dev/null || true

# 2. Cria usuário live (se o script existir)
if [ -f /root/create_live_user.sh ]; then
    /root/create_live_user.sh
fi

# 3. Executa a customização principal (XFCE, temas, etc)
# CORREÇÃO: Apontando para o nome correto do arquivo que você criou
if [ -f /root/customize_root.sh ]; then
    /root/customize_root.sh
fi

# 4. Configura o autostart do instalador OEM/Calamares
mkdir -p /etc/xdg/autostart
cat > /etc/xdg/autostart/speedos-oem-setup.desktop <<EOF
[Desktop Entry]
Type=Application
Name=SpeedOS OEM Setup
Exec=/root/start_calamares_oem.sh
NoDisplay=true
EOF

exit 0
