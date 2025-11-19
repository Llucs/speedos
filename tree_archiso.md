# Estrutura de Build da SpeedOS (Archiso) - Versão Final para Compilação

A estrutura de diretórios foi finalizada e otimizada para ser compatível com a ferramenta `archiso`, pronta para a compilação da ISO.

```
speedos_archiso
├── airootfs
│   ├── etc
│   │   ├── lightdm
│   │   │   └── lightdm-gtk-greeter.conf
│   │   ├── pacman.d
│   │   │   └── hooks
│   │   │       └── 99-speedos-customize.hook
│   │   ├── skel
│   │   ├── systemd
│   │   │   └── system
│   │   │       └── getty@tty1.service.d
│   │   │           └── autologin.conf
│   │   └── xdg
│   │       └── autostart
│   │           └── speedos-firstboot.desktop
│   ├── root
│   │   └── customize_root.sh
│   └── usr
│       └── share
│           └── backgrounds
│               └── speedos
│                   └── wallpaper.png
├── build.sh
├── packages.x86_64
├── pacman.conf
├── profiledef.sh
└── tree_archiso.md
```

## Descrição dos Arquivos de Build (Atualizada)

| Caminho | Descrição |
| :--- | :--- |
| `build.sh` | **Script principal de build.** Utiliza `sudo mkarchiso -v -w work -o out "$PROFILE_DIR"` para iniciar a compilação da ISO. |
| `profiledef.sh` | **Definição do perfil Archiso.** Contém metadados da ISO (`iso_name="speedos"`, `iso_version="1.0"`) e as configurações de boot (BIOS/UEFI) essenciais para a ISO ser bootável. |
| `pacman.conf` | Arquivo de configuração do Pacman, incluindo o repositório `[lqx]` para o Kernel Liquorix. |
| `packages.x86_64` | **Lista completa de pacotes** essenciais para o sistema live, incluindo `base`, `linux-lqx`, `xfce4`, `lightdm`, temas e utilitários. |
| `airootfs/root/customize_root.sh` | Script de customização que configura o ambiente live (autologin, temas XFCE) e prepara as configurações padrão para novos usuários via `/etc/skel`. |
| `airootfs/etc/pacman.d/hooks/99-speedos-customize.hook` | Hook do Pacman para garantir que o script de customização seja executado automaticamente durante a instalação dos pacotes. |
| `airootfs/etc/systemd/system/getty@tty1.service.d/autologin.conf` | Configuração do Systemd para habilitar o **autologin** no console TTY1 como usuário `root` (padrão para ambientes live). |
| `airootfs/etc/lightdm/lightdm-gtk-greeter.conf` | Configuração da tela de login (LightDM) com o tema `Sweet-Dark`. |
| `airootfs/etc/xdg/autostart/speedos-firstboot.desktop` | Arquivo para iniciar o `xfce4-firstboot` na primeira sessão gráfica. |
| `airootfs/usr/share/backgrounds/speedos/wallpaper.png` | Arquivo *placeholder* para o wallpaper. |
| `airootfs/etc/skel` | Diretório que armazena as configurações padrão para novos usuários. |
