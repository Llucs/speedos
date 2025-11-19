#!/bin/bash

# Cria o usuário speedos
useradd -m -G wheel,audio,video,storage,power -s /bin/bash speedos

# Define a senha (vazia para login automático)
echo "speedos:speedos" | chpasswd

# Copia as configurações do XFCE para o novo usuário
cp -r /etc/skel/.config /home/speedos/

# Corrige as permissões
chown -R speedos:speedos /home/speedos

# Adiciona o usuário speedos ao sudoers (sem senha)
echo "speedos ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/speedos
chmod 0440 /etc/sudoers.d/speedos
