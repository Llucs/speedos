#!/usr/bin/env bash
iso_name="speedos"
iso_label="SPEEDOS_$(date +%Y%m)"
iso_publisher="SpeedOS Project"
iso_application="SpeedOS Live ISO"
iso_version="1.0"
install_dir="arch"
buildmodes=('iso')
bootmodes=('bios.syslinux.mbr' 'bios.syslinux.eltorito' 'uefi-x64.systemd-boot')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-b' '1M' '-Xdict-size' '1M')
file_permissions=(
)
