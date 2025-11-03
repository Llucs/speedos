#!/bin/bash
# =============================================================================
# SpeedOS Installer - Transforma qualquer Debian/Ubuntu em SpeedOS
# Uso: sudo ./install-speedos.sh
# =============================================================================

set -euo pipefail
IFS=$'\n\t'

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { echo -e "${GREEN}[SpeedOS]${NC} $1"; }
warn() { echo -e "${YELLOW}[AVISO]${NC} $1"; }
error() { echo -e "${RED}[ERRO]${NC} $1"; exit 1; }
info() { echo -e "${BLUE}[INFO]${NC} $1"; }

# Verificações iniciais
[[ $EUID -ne 0 ]] && error "Este script deve ser executado como root (use sudo)."
[[ ! -d "/opt/speedos" ]] && error "Diretório /opt/speedos não encontrado. Execute no ambiente SpeedOS Live."

# Diretórios
SPEEDOS_ROOT="/opt/speedos"
BIN_DIR="/usr/local/bin"
CONFIG_DIR="/etc/speedos"
ASSETS_SRC="$SPEEDOS_ROOT/assets"
USER_HOME=$(getent passwd "$(logname)" | cut -d: -f6)
[[ -z "$USER_HOME" || ! -d "$USER_HOME" ]] && error "Usuário atual não encontrado ou sem home."

log "Iniciando instalação do SpeedOS no sistema..."
info "Usuário detectado: $(logname) | Home: $USER_HOME"

# =============================================================================
# 1. Atualizar Sistema e Instalar Dependências
# =============================================================================
log "Atualizando sistema e instalando pacotes essenciais..."
apt update -qq
apt install -y \
    xfce4 xfce4-goodies lightdm \
    network-manager-gnome \
    firefox-esr thunar \
    picom papirus-icon-theme \
    python3-gi python3-gi-cairo \
    gir1.2-gtk-4.0 gir1.2-adw-1 \
    libadwaita-1-dev \
    plank \
    plymouth plymouth-themes \
    python3-psutil libnotify-bin \
    || error "Falha ao instalar pacotes."

# =============================================================================
# 2. Criar Estrutura e Copiar Binários
# =============================================================================
log "Copiando scripts para $BIN_DIR..."
mkdir -p "$BIN_DIR" "$CONFIG_DIR"

# Scripts de otimização
for script in speed-boost speed-clean speed-gamer-mode speed-update speed-theme speed-benchmark; do
    cp "$SPEEDOS_ROOT/speedboost/$script" "$BIN_DIR/" && chmod 755 "$BIN_DIR/$script"
done

# SpeedCenter
install -Dm755 "$SPEEDOS_ROOT/speedcenter/main.py" "$BIN_DIR/speedcenter"

# Config e init
install -Dm644 "$SPEEDOS_ROOT/init.sh" "$CONFIG_DIR/init.sh"
install -Dm644 "$SPEEDOS_ROOT/speedos.conf" "$CONFIG_DIR/speedos.conf"

# =============================================================================
# 3. Configurar Usuário (GTK, Picom, XFCE, Plank)
# =============================================================================
log "Configurando ambiente do usuário: $USER_HOME"

USER_CONFIG="$USER_HOME/.config"
mkdir -p "$USER_CONFIG"/{gtk-3.0,gtk-4.0,picom,xfce4/xfconf/xfce-perchannel-xml,plank/dock1}

# GTK Settings
cat > "$USER_CONFIG/gtk-3.0/settings.ini" << 'EOF'
[Settings]
gtk-application-prefer-dark-theme=true
gtk-theme-name=Adwaita-dark
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=Cantarell 11
gtk-cursor-theme-name=Bibata-Modern-Classic
EOF

cp "$USER_CONFIG/gtk-3.0/settings.ini" "$USER_CONFIG/gtk-4.0/settings.ini"

# Picom
install -Dm644 "$ASSETS_SRC/picom.conf" "$USER_CONFIG/picom/picom.conf"

# XFCE Panel
install -Dm644 "$ASSETS_SRC/themes/xfce-panel.xml" \
    "$USER_CONFIG/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml"

# Plank
install -Dm644 "$ASSETS_SRC/themes/plank-dock.conf" \
    "$USER_CONFIG/plank/dock1/settings"

# Desktop Entry
mkdir -p "$USER_HOME/.local/share/applications"
cat > "$USER_HOME/.local/share/applications/com.speedos.SpeedCenter.desktop" << 'EOF'
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

# Ícone global
install -Dm644 "$ASSETS_SRC/icons/speedos-control-center.svg" \
    /usr/share/icons/hicolor/scalable/apps/speedos-control-center.svg
gtk-update-icon-cache /usr/share/icons/hicolor/ || true

chown -R "$(logname):$(logname)" "$USER_HOME/.config" "$USER_HOME/.local"

# =============================================================================
# 4. Habilitar Serviços
# =============================================================================
log "Habilitando serviços SpeedOS..."
systemctl enable speed-ai-monitor.service
systemctl daemon-reload

# =============================================================================
# 5. Plymouth Theme (Boot Splash)
# =============================================================================
if command -v plymouth-set-default-theme >/dev/null; then
    log "Instalando tema Plymouth 'speedos'..."
    THEME_DIR="/usr/share/plymouth/themes/speedos"
    mkdir -p "$THEME_DIR"
    
    cat > "$THEME_DIR/speedos.plymouth" << 'EOF'
[Plymouth Theme]
Name=SpeedOS
Description=Tema oficial do SpeedOS com animação SVG
ModuleName=script
[script]
ImageDir=/usr/share/plymouth/themes/speedos
ScriptFile=/usr/share/plymouth/themes/speedos/speedos.script
EOF

    cat > "$THEME_DIR/speedos.script" << 'EOF'
speedos_image = Image("bolt-logo.svg")
screen_width = Window.GetWidth()
screen_height = Window.GetHeight()
x = (screen_width - speedos_image.GetWidth()) / 2
y = (screen_height - speedos_image.GetHeight()) / 2
sprite = Sprite(speedos_image)
sprite.SetPosition(x, y, 10000)
EOF

    install -Dm644 "$ASSETS_SRC/icons/bolt-logo.svg" "$THEME_DIR/bolt-logo.svg"
    plymouth-set-default-theme -R speedos
    log "Tema de boot SpeedOS ativado!"
else
    warn "Plymouth não disponível. Pulando splash screen."
fi

# =============================================================================
# 6. Finalização
# =============================================================================
update-initramfs -u -k all
log "SpeedOS instalado com sucesso!"
echo
echo "=========================================="
echo "   SpeedOS PRONTO!"
echo "   Reinicie o sistema para aplicar."
echo "   Abra o SpeedCenter pelo menu ou dock."
echo "=========================================="