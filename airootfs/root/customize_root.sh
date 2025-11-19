#!/bin/bash
set -e

echo "[SpeedOS] Iniciando customizações do sistema..."

# -----------------------------------------------
# 1. Habilitar Serviços do Sistema
# -----------------------------------------------
# Habilita serviços essenciais. O '|| true' evita que o build pare se o serviço não existir.
systemctl enable NetworkManager.service || true
systemctl enable lightdm.service || true

if [ -e /usr/lib/systemd/system/zram-generator.service ]; then
    systemctl enable zram-generator.service || true
fi

if [ -e /usr/lib/systemd/system/haveged.service ]; then
    systemctl enable haveged.service || true
fi

# -----------------------------------------------
# 2. Configurações do XFCE (Aplicadas ao /etc/skel)
# -----------------------------------------------
# É mais seguro aplicar direto no skel para novos usuários
TARGET_DIR="/etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml"
mkdir -p "$TARGET_DIR"

echo "[SpeedOS] Aplicando tema Sweet-Dark e ícones Tela-circle..."

# Tema e Ícones
cat <<EOF > "$TARGET_DIR/xsettings.xml"
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xsettings" version="1.0">
  <property name="Net" type="empty">
    <property name="ThemeName" type="string" value="Sweet-Dark"/>
    <property name="IconThemeName" type="string" value="Tela-circle"/>
  </property>
</channel>
EOF

# Tema do Gerenciador de Janelas
cat <<EOF > "$TARGET_DIR/xfwm4.xml"
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfwm4" version="1.0">
  <property name="general" type="empty">
    <property name="theme" type="string" value="Sweet-Dark"/>
  </property>
</channel>
EOF

# Wallpaper
cat <<EOF > "$TARGET_DIR/xfce4-desktop.xml"
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

# Copiar também para o root (caso logue como root na live)
mkdir -p /root/.config
cp -r /etc/skel/.config/xfce4 /root/.config/

echo "[✔] SpeedOS airootfs customizado com sucesso!"
