#!/bin/bash
set -e

# Habilita serviços essenciais que devem iniciar com o sistema
systemctl enable NetworkManager.service
systemctl enable lightdm.service

# Configura o autologin para o usuário root no ambiente live
# Isso será feito através de um arquivo de configuração do systemd
# em /etc/systemd/system/getty@tty1.service.d/autologin.conf

# O script de customização do archiso é executado como root dentro do chroot.
# As configurações de tema e aparência para o ambiente live (que rodará como root)
# precisam ser aplicadas diretamente no home do root.

# Garante que os diretórios de configuração do XFCE existam
mkdir -p /root/.config/xfce4/xfconf/xfce-perchannel-xml/

# Define o tema GTK e de ícones padrão para o usuário root
cat <<EOF > /root/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xsettings" version="1.0">
  <property name="Net" type="empty">
    <property name="ThemeName" type="string" value="Sweet-Dark"/>
    <property name="IconThemeName" type="string" value="Tela-circle"/>
  </property>
</channel>
EOF

# Define o tema do gerenciador de janelas (XFWM4) para o usuário root
cat <<EOF > /root/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfwm4" version="1.0">
  <property name="general" type="empty">
    <property name="theme" type="string" value="Sweet-Dark"/>
  </property>
</channel>
EOF

# Define o wallpaper padrão para o usuário root
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

# Copia a configuração padrão para o /etc/skel, para que novos usuários criados
# no sistema instalado também recebam o tema e as configurações da SpeedOS.
mkdir -p /etc/skel/.config
cp -r /root/.config/xfce4 /etc/skel/.config/

# O arquivo para o First Boot Wizard já está no lugar certo (/etc/xdg/autostart)
# e será iniciado automaticamente quando o XFCE carregar.

echo "SpeedOS airootfs customizado com sucesso!"
