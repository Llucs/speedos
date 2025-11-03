#!/bin/bash
# =============================================================================
# SpeedOS Post-Install Hook - Executado DENTRO do chroot pelo live-build
# Objetivo: Configurar ambiente SpeedOS (XFCE, temas, serviços, usuários)
# =============================================================================

set -euo pipefail
IFS=$'\n\t'

# Cores para debug (opcional)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() { echo -e "${GREEN}[SpeedOS]${NC} $1"; }
warn() { echo -e "${YELLOW}[AVISO]${NC} $1"; }
error() { echo -e "${RED}[ERRO]${NC} $1" >&2; }

log "Iniciando pós-instalação do SpeedOS..."

# =============================================================================
# 1. Diretórios e Estrutura
# =============================================================================
SPEEDOS_ROOT="/opt/speedos"
ASSETS_SRC="/usr/local/src/speedos/assets"  # Ajuste se necessário
THEMES_DIR="$SPEEDOS_ROOT/assets/themes"
USER_SKEL="/etc/skel"

log "Criando estrutura em $SPEEDOS_ROOT..."
mkdir -p "$SPEEDOS_ROOT"/{speedcenter,speedstore,speedboost,speedhub}
mkdir -p /var/lib/speedos # Diretório para marcadores e dados de sistema
mkdir -p "$THEMES_DIR"
chmod 755 "$SPEEDOS_ROOT" -R

# =============================================================================
# 2. Copiar Assets (apenas dados, NÃO binários duplicados)
# =============================================================================
log "Copiando assets para $SPEEDOS_ROOT..."
cp -r "$ASSETS_SRC"/* "$SPEEDOS_ROOT/assets/" 2>/dev/null || warn "Alguns assets não encontrados em $ASSETS_SRC"

# Garante que o wallpaper do LightDM esteja no local correto
cp "$SPEEDOS_ROOT/assets/wallpaper.jpg" "$SPEEDOS_ROOT/assets/wallpaper.jpg" # Copia para si mesmo para garantir a presença


# =============================================================================
# 3. Configuração do Usuário Padrão (Live + Instalado)
# =============================================================================
log "Configurando usuário padrão em $USER_SKEL..."

# GTK Config
mkdir -p "$USER_SKEL/.config/gtk-3.0" "$USER_SKEL/.config/gtk-4.0"
cat > "$USER_SKEL/.config/gtk-3.0/settings.ini" << 'EOF'
[Settings]
gtk-application-prefer-dark-theme=true
gtk-theme-name=Adwaita-dark
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=Cantarell 11
EOF

cat > "$USER_SKEL/.config/gtk-4.0/settings.ini" << 'EOF'
[Settings]
gtk-application-prefer-dark-theme=true
gtk-theme-name=Adwaita-dark
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=Cantarell 11
EOF

# Picom (compositor)
mkdir -p "$USER_SKEL/.config"
cp "$SPEEDOS_ROOT/assets/picom.conf" "$USER_SKEL/.config/picom.conf"

# XFCE Panel + Plank (Configuração macOS-like)
# O painel superior deve ter o Whisker Menu (botão de opções) e o AppMenu (menu global)
mkdir -p "$USER_SKEL/.config/xfce4/xfconf/xfce-perchannel-xml"
cp "$SPEEDOS_ROOT/assets/themes/xfce-panel.xml" \
   "$USER_SKEL/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml"

# Configuração do Plank (Dock centralizada e arredondada)
mkdir -p "$USER_SKEL/.config/plank/dock1"
cp "$SPEEDOS_ROOT/assets/themes/plank-dock.conf" \
   "$USER_SKEL/.config/plank/dock1/settings"

# Configuração do LightDM (Tela de Bloqueio/Login)
# Usaremos o LightDM GTK Greeter com um tema simples e a opção de bloqueio de tela
LIGHTDM_CONF="/etc/lightdm/lightdm.conf"
if [ -f "$LIGHTDM_CONF" ]; then
    log "Configurando LightDM para tela de bloqueio..."
    # Garante que o greeter seja o gtk-greeter
    sed -i 's/^#greeter-session=.*/greeter-session=lightdm-gtk-greeter/' "$LIGHTDM_CONF"
    
    # Configurações do greeter para um visual mais limpo (se o tema for instalado)
    GTK_GREETER_CONF="/etc/lightdm/lightdm-gtk-greeter.conf"
    cat > "$GTK_GREETER_CONF" << 'EOF'
[greeter]
background=/opt/speedos/assets/wallpaper.jpg # Wallpaper padrão
theme-name=Adwaita-dark
icon-theme-name=Papirus-Dark
font-name=Cantarell 11
xft-antialias=true
xft-dpi=96
xft-hintstyle=hintfull
show-clock=true
indicators=~host;~spacer;~session;~a11y;~language;~power
EOF
fi

# Desktop Entry do SpeedCenter
mkdir -p "$USER_SKEL/.local/share/applications"
cat > "$USER_SKEL/.local/share/applications/com.speedos.SpeedCenter.desktop" << 'EOF'
[Desktop Entry]
Name=SpeedCenter
Comment=Centro de Controle do SpeedOS
Exec=speedcenter
Icon=speedos-control-center
Terminal=false
Type=Application
Categories=System;Settings;
StartupNotify=true
Keywords=performance;boost;gaming;ai;
EOF

# Ícone (copiado para tema global)
mkdir -p /usr/share/icons/hicolor/scalable/apps
cp "$SPEEDOS_ROOT/assets/icons/speedos-control-center.svg" \
   /usr/share/icons/hicolor/scalable/apps/speedos-control-center.svg || true
update-icon-caches /usr/share/icons/* || true

# =============================================================================
# 4. Serviços Systemd
# =============================================================================
log "Habilitando serviços SpeedOS..."
systemctl enable speed-ai-monitor.service
systemctl enable speedos-first-boot.service # Novo serviço de primeiro boot
systemctl enable speedos-update.timer # Habilita o timer de atualização diária

# =============================================================================
# 5. Plymouth Theme (Boot Splash - SpeedOS Bolt)
# =============================================================================
if command -v plymouth-set-default-theme >/dev/null; then
    log "Instalando tema Plymouth 'speedos'..."
    THEME_DIR="/usr/share/plymouth/themes/speedos"
    mkdir -p "$THEME_DIR"
    
    cat > "$THEME_DIR/speedos.plymouth" << 'EOF'
[Plymouth Theme]
Name=SpeedOS
Description=Tema de boot oficial do SpeedOS
ModuleName=script

[script]
ImageDir=/usr/share/plymouth/themes/speedos
ScriptFile=/usr/share/plymouth/themes/speedos/speedos.script
EOF

    # Script simples de animação (SVG centralizado)
    cat > "$THEME_DIR/speedos.script" << 'EOF'
speedos_image = Image("bolt-logo.svg")
screen_width = Window.GetWidth()
screen_height = Window.GetHeight()
x = (screen_width - speedos_image.GetWidth()) / 2
y = (screen_height - speedos_image.GetHeight()) / 2
sprite = Sprite(speedos_image)
sprite.SetPosition(x, y, 10000)
EOF

    cp "$SPEEDOS_ROOT/assets/icons/bolt-logo.svg" "$THEME_DIR/bolt-logo.svg"
    chmod 644 "$THEME_DIR"/*

    plymouth-set-default-theme -R speedos
    log "Tema Plymouth 'speedos' instalado e ativado."
else
    warn "Plymouth não encontrado. Pulando tema de boot."
fi

# =============================================================================
# 6. Permissões e Finalização
# =============================================================================
log "Garantindo permissões de execução para scripts..."
chmod +x /usr/local/bin/speed-boost
chmod +x /usr/local/bin/speed-clean
chmod +x /usr/local/bin/speed-gamer-mode
chmod +x /usr/local/bin/speed-update
chmod +x /usr/local/bin/speedos-first-boot.sh

log "Limpeza e Finalização..."
log "Atualizando initramfs e caches..."
update-initramfs -u -k all

log "Pós-instalação do SpeedOS concluída com sucesso!"
exit 0