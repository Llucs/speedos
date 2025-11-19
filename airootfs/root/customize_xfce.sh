#!/bin/bash

# Diretório de configuração padrão dos usuários
XFCE_CONFIG_DIR="/etc/skel/.config/xfce4"

echo "[*] Configurando XFCE..."

# Criar diretórios necessários
mkdir -p "$XFCE_CONFIG_DIR/xfconf/xfce-perchannel-xml"
mkdir -p "$XFCE_CONFIG_DIR/panel"

# ================================
# 1. Configurar Desktop (ícones)
# ================================
cat << EOF > "$XFCE_CONFIG_DIR/xfconf/xfce-perchannel-xml/xfce4-desktop.xml"
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-desktop" version="1.0">
  <property name="desktop-icons" type="empty">
    <property name="file-icons" type="empty">
      <property name="show-home" type="bool" value="false"/>
      <property name="show-filesystem" type="bool" value="false"/>
      <property name="show-trash" type="bool" value="false"/>
      <property name="show-removable" type="bool" value="true"/>
    </property>
  </property>
</channel>
EOF

# ================================
# 2. Configurar tema Sweet-Dark e Tela-dark
# ================================
cat << EOF > "$XFCE_CONFIG_DIR/xfconf/xfce-perchannel-xml/xsettings.xml"
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xsettings" version="1.0">
  <property name="Net" type="empty">
    <property name="ThemeName" type="string" value="Sweet-Dark"/>
    <property name="IconThemeName" type="string" value="Tela-dark"/>
    <property name="DoubleClickTime" type="int" value="400"/>
    <property name="DoubleClickDistance" type="int" value="5"/>
    <property name="DndDragThreshold" type="int" value="5"/>
    <property name="CursorBlink" type="bool" value="true"/>
    <property name="CursorBlinkTime" type="int" value="1200"/>
    <property name="CursorThemeName" type="string" value="Adwaita"/>
    <property name="CursorThemeSize" type="int" value="24"/>
    <property name="WindowTiling" type="bool" value="true"/>
  </property>
  <property name="Xft" type="empty">
    <property name="DPI" type="int" value="96"/>
    <property name="Antialias" type="bool" value="true"/>
    <property name="Hinting" type="bool" value="true"/>
    <property name="HintStyle" type="string" value="hintfull"/>
    <property name="RGBA" type="string" value="rgb"/>
  </property>
</channel>
EOF

# ================================
# 3. Configurar painel estilo Zorin
# ================================
cat << EOF > "$XFCE_CONFIG_DIR/xfconf/xfce-perchannel-xml/xfce4-panel.xml"
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-panel" version="1.0">
  <property name="configver" type="int" value="2"/>
  <property name="panels" type="array">
    <value type="int" value="1"/>
  </property>
  <property name="panel-1" type="empty">
    <property name="position" type="string" value="p=6;x=0;y=0"/>
    <property name="length" type="uint" value="100"/>
    <property name="position-locked" type="bool" value="true"/>
    <property name="size" type="uint" value="30"/>
    <property name="plugin-ids" type="array">
      <value type="int" value="1"/>
      <value type="int" value="2"/>
      <value type="int" value="3"/>
      <value type="int" value="4"/>
      <value type="int" value="5"/>
      <value type="int" value="6"/>
      <value type="int" value="7"/>
      <value type="int" value="8"/>
      <value type="int" value="9"/>
    </property>
  </property>

  <property name="plugins" type="empty">
    <property name="plugin-1" type="string" value="whiskermenu"/>
    <property name="plugin-2" type="string" value="tasklist"/>
    <property name="plugin-3" type="string" value="separator"/>
    <property name="plugin-4" type="string" value="systray"/>
    <property name="plugin-5" type="string" value="pulseaudio"/>
    <property name="plugin-6" type="string" value="power-manager-plugin"/>
    <property name="plugin-7" type="string" value="notification-plugin"/>
    <property name="plugin-8" type="string" value="clock"/>
    <property name="plugin-9" type="string" value="actions"/>
  </property>
</channel>
EOF

# ================================
# 4. Configurar Whiskermenu
# ================================
cat << EOF > "$XFCE_CONFIG_DIR/xfconf/xfce-perchannel-xml/xfce4-whiskermenu.xml"
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-panel" version="1.0">
  <property name="plugins" type="empty">
    <property name="whiskermenu" type="empty">
      <property name="button-icon" type="string" value="start-here"/>
      <property name="button-title" type="string" value="SpeedOS"/>
      <property name="show-button-title" type="bool" value="false"/>
      <property name="show-command-line" type="bool" value="true"/>
      <property name="show-recent-files" type="bool" value="true"/>
      <property name="view-mode" type="int" value="0"/>
    </property>
  </property>
</channel>
EOF

echo "[✔] XFCE configurado com sucesso!"