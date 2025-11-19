#!/bin/bash
set -e

# Habilita serviços
systemctl enable NetworkManager.service
systemctl enable lightdm.service

# Gera o initramfs do kernel personalizado
echo "[SpeedOS] Gerando initramfs do linux-lqx..."
mkinitcpio -p linux-lqx

# Configurações XFCE
mkdir -p /root/.config/xfce4/xfconf/xfce-perchannel-xml/

cat <<EOF > /root/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xsettings" version="1.0">
  <property name="Net" type="empty">
    <property name="ThemeName" type="string" value="Sweet-Dark"/>
    <property name="IconThemeName" type="string" value="Tela-circle"/>
  </property>
</channel>
EOF

cat <<EOF > /root/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfwm4" version="1.0">
  <property name="general" type="empty">
    <property name="theme" type="string" value="Sweet-Dark"/>
  </property>
</channel>
EOF

cat <<EOF > /root/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-desktop" version="1.0">
  <property name="backdrop" type="empty">
    <property name="screen0" type="empty">
      <property name="monitor0" type="empty">
        <property name="workspace0" type="empty">
          <property name="color-style" type="int" value="0"/>
          <property name="image-style" type="int" value="5"/>
          <property name="last-image" type="string" value="/usr/share/backgrounds/speedos/wallpaper.png"/>
        </property>
      </property>
    </property>
  </property>
</channel>
EOF

# Copia configs para futuros usuários
mkdir -p /etc/skel/.config
cp -r /root/.config/xfce4 /etc/skel/.config/

echo "SpeedOS airootfs customizado com sucesso!"