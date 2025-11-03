#!/bin/bash
# =============================================================================
# SpeedOS - First Boot Setup Launcher
# Executa o assistente de configuração inicial (GUI) e desativa a si mesmo.
# =============================================================================

MARKER_FILE="/var/lib/speedos/first_boot_done"
FIRST_BOOT_APP="/opt/speedos/speedcenter/first_boot.py"

# Verifica se o setup já foi concluído
if [ -f "$MARKER_FILE" ]; then
    # Se o marcador existir, desativa o serviço de primeiro boot
    systemctl disable speedos-first-boot.service
    exit 0
fi

# Executa o assistente de configuração inicial (GUI)
# Deve ser executado como o usuário logado (se houver) ou como root no ambiente LightDM
# No ambiente LightDM, podemos usar loginctl para encontrar a sessão ativa, mas para simplificar,
# vamos assumir que o script é chamado pelo LightDM antes do ambiente de desktop ser carregado.

# Para o live-build, vamos apenas garantir que o script Python seja executado.
# No ambiente real, o LightDM seria configurado para chamar este script.

# Se estiver em ambiente gráfico (Xorg/Wayland), executa a interface GTK
if [ -n "$DISPLAY" ]; then
    # Executa o script Python como o usuário atual (não root)
    # No ambiente real, o script de pós-instalação deve garantir que o script Python
    # esteja no PATH ou seja chamado corretamente.
    python3 "$FIRST_BOOT_APP"
    
    # Após a execução (e se o usuário clicou em Finalizar), o marcador é criado.
    # Se o marcador existir, desativa o serviço.
    if [ -f "$MARKER_FILE" ]; then
        systemctl disable speedos-first-boot.service
    fi
fi

exit 0
