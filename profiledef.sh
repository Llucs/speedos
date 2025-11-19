#!/usr/bin/env bash
iso_name="speedos"
iso_label="SPEEDOS_$(date +%Y%m)"
iso_publisher="SpeedOS Project"
iso_application="SpeedOS Live ISO"
iso_version="1.0"
install_dir="arch"
buildmodes=('iso')

# Boot modes CORRETOS
bootmodes=('bios.syslinux' 'uefi.systemd-boot')

arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-b' '1M' '-Xdict-size' '1M')

# CRÍTICO: Argumentos do Pacman para build não-interativo
# Isso impede que o pacman pare e peça confirmação para grupos de pacotes (como xfce4)
pacman_args=(
    '--noconfirm'
    '--needed'
)

# Permissões de arquivos (Completo)
file_permissions=(
  ["/root/customize_airootfs.sh"]="0:0:755"
  ["/root/customize_root.sh"]="0:0:755"
  ["/root/customize_xfce.sh"]="0:0:755"
  ["/root/create_live_user.sh"]="0:0:755"
  ["/root/start_calamares_oem.sh"]="0:0:755"
  
  # Outros executáveis e arquivos de desktop
  ["/usr/local/bin/gen-initramfs"]="0:0:755"
  ["/etc/skel/Desktop/Instalar SpeedOS.desktop"]="0:0:755"
)
