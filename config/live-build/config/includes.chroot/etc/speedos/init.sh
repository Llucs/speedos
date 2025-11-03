#!/bin/bash
# SpeedOS - Script de Inicialização Principal
# Executado no boot para configurar o ambiente gráfico e otimizações.

# 1. Configuração do ambiente gráfico (XFCE ou Openbox)
# O script de instalação deve garantir que o XFCE/Openbox esteja instalado.

# 2. Configuração do Compositor (Picom)
# O Picom é iniciado para efeitos leves e transparência.
# O arquivo de configuração ~/.config/picom.conf deve ser criado na fase 4.
# O comando 'pgrep' verifica se o picom já está rodando.
if ! pgrep "picom" > /dev/null; then
    picom --config ~/.config/picom.conf -b
fi

# 3. Configuração de Tema e Ícones
# O tema Arc-Dark e os ícones Papirus são definidos para o usuário.
# Esta configuração é feita via arquivos de configuração do GTK.

# 4. Inicialização da Dock (Exemplo de Plank, se for usado)
# Para uma dock leve e moderna.
# Exemplo: if command -v plank > /dev/null; then plank & fi

# 5. Inicialização dos Módulos SpeedOS
# Inicia o SpeedCenter em background para monitoramento.
# O SpeedCenter deve ser um aplicativo GTK leve.
if [ -f /opt/speedos/speedcenter/main.py ]; then
    /opt/speedos/speedcenter/main.py &
fi

# 6. Aplicação de Otimizações de Boot
# Executa o script de otimização de boot (que será criado na fase 5).
if [ -f /usr/local/bin/speed-boost-boot ]; then
    /usr/local/bin/speed-boost-boot
fi

exit 0
