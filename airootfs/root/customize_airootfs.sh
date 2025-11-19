#!/bin/bash

# Dar permissão de execução para todos os scripts no /root
chmod 755 /root/*.sh 2>/dev/null

# Executar script de criação de usuário Live
if [ -f /root/create_live_user.sh ]; then
    /root/create_live_user.sh
fi

# Executar script de customização do XFCE
if [ -f /root/customize_xfce.sh ]; then
    /root/customize_xfce.sh
endif

# Habilitar serviços de otimização
systemctl enable zram-generator.service
systemctl enable haveged.service

# Configurar LightDM como display manager
systemctl enable lightdm.service

# Criar diretório de autostart (garantia)
mkdir -p /etc/xdg/autostart

# Iniciar o Calamares em modo OEM no primeiro boot
cat <<EOF > /etc/xdg/autostart/speedos-oem-setup.desktop
[Desktop Entry]
Type=Application
Name=SpeedOS OEM Setup
Exec=/root/start_calamares_oem.sh
NoDisplay=true
EOF

# Remover scripts que não serão mais usados no sistema instalado
rm -f /root/customize_xfce.sh
rm -f /root/create_live_user.sh