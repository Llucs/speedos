#!/bin/bash

# Este script simula o comportamento de iniciar o Calamares em modo OEM
# para o setup inicial elegante.

# Verifica se é o primeiro boot (pode ser feito de forma mais robusta)
if [ ! -f /etc/speedos-oem-setup-done ]; then
    # Inicia o Calamares em modo OEM
    /usr/bin/calamares --oem
    
    # Marca o setup como concluído
    touch /etc/speedos-oem-setup-done
fi
