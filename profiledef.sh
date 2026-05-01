#!/usr/bin/env bash

iso_name="speedos"
iso_label="SPEEDOS"
iso_publisher="SpeedOS Project (Llucs)"
iso_application="SpeedOS Live Environment"
iso_version="1.0"

install_dir="speedos"

buildmodes=('iso')

bootmodes=('bios.syslinux' 'bios.grub.mbr' 'uefi.systemd-boot')

arch="x86_64"
pacman_conf="pacman.conf"

airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'zstd' '-Xcompression-level' '15')

pacman_args=(
  '--noconfirm'
  '--needed'
)

file_permissions=(
  ["/root/customize_airootfs.sh"]="0:0:755"
  ["/root/customize_root.sh"]="0:0:755"
  ["/root/customize_xfce.sh"]="0:0:755"
  ["/root/create_live_user.sh"]="0:0:755"
  ["/root/start_calamares_oem.sh"]="0:0:755"
  ["/usr/local/bin/gen-initramfs"]="0:0:755"
  ["/etc/skel/Desktop/Instalar SpeedOS.desktop"]="0:0:755"
)