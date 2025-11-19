#!/bin/bash
set -e

# Dar permissão de execução para todos os scripts em /root
chmod +x /root/*.sh 2>/dev/null || true

# Executar script de criação de usuário Live, se existir
if [ -f /root/create_live_user.sh ]; then
    /root/create_live_user.sh
fi

# Executar script de customização do XFCE, se existir
if [ -f /root/customize_xfce.sh ]; then
    /root/customize_xfce.sh
fi

# Habilitar serviços de otimização (se existirem)
if [ -e /usr/lib/systemd/system/zram-generator.service ]; then
    systemctl enable zram-generator.service || true
fi

if [ -e /usr/lib/systemd/system/haveged.service ]; then
    systemctl enable haveged.service || true
fi

# Configurar LightDM como display manager (se existir)
if [ -e /usr/lib/systemd/system/lightdm.service ]; then
    systemctl enable lightdm.service || true
fi

# Criar autostart do Calamares OEM
mkdir -p /etc/xdg/autostart
cat > /etc/xdg/autostart/speedos-oem-setup.desktop <<EOF
[Desktop Entry]
Type=Application
Name=SpeedOS OEM Setup
Exec=/root/start_calamares_oem.sh
NoDisplay=true
EOF

exit 0