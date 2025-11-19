#!/bin/bash

# Executar script de criação de usuário Live
/root/create_live_user.sh

# Executar script de customização do XFCE
/root/customize_xfce.sh

# Habilitar serviços de otimização
systemctl enable zram-generator.service
systemctl enable haveged.service

# Configurar LightDM como display manager
systemctl enable lightdm.service

# Iniciar o Calamares em modo OEM no primeiro boot
echo "[Desktop Entry]
Type=Application
Name=SpeedOS OEM Setup
Exec=/root/start_calamares_oem.sh
NoDisplay=true
" > /etc/xdg/autostart/speedos-oem-setup.desktop

# Limpar
rm /root/customize_xfce.sh
rm /root/create_live_user.sh
