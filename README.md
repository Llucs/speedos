# SpeedOS - O Sistema Operacional Minimalista e Otimizado

O SpeedOS é um sistema operacional Linux baseado em Debian, projetado para ser extremamente rápido, seguro e minimalista, com uma interface de usuário inspirada no macOS. É otimizado para rodar em hardware antigo, como laptops com 2GB de RAM.

## Características Principais

*   **Base Leve:** Debian 12 (Bookworm) com XFCE/Plank/Picom.
*   **Interface macOS-like:** Dock centralizada, painel superior minimalista (com Menu Global e Whisker Menu), e cantos de janela arredondados.
*   **Otimização Extrema:** Scripts proprietários (`speed-boost`, `speed-clean`, `speed-gamer-mode`) para gerenciamento agressivo de CPU, RAM e I/O.
*   **Segurança e Atualização:** Sistema de atualização robusto (`SpeedUpdate`) que gerencia pacotes do sistema (APT) e componentes proprietários (GitHub), similar ao ZorinOS.
*   **Primeiro Boot:** Assistente de configuração inicial para idioma, região, usuário e senha.
*   **Apps Básicos:** Navegador (Firefox-ESR), Terminal (Tilix), Gerenciador de Arquivos (Thunar), Editor de Texto (Mousepad), e Player de Mídia (VLC).

## Build da ISO (GitHub Actions)

O SpeedOS é construído usando `live-build` e o processo é totalmente automatizado via GitHub Actions.

1.  **Fork/Clone:** Faça um fork ou clone deste repositório.
2.  **Workflow:** O arquivo `.github/workflows/build-iso.yml` contém o fluxo de trabalho completo.
3.  **Execução:**
    *   **Push:** Um push para o branch `main` irá iniciar o build automaticamente.
    *   **Manual:** Você pode acionar o build manualmente através da aba "Actions" no GitHub, usando `workflow_dispatch`.
4.  **Resultado:** A ISO final (`SpeedOS_0.1_Bolt_Edition.iso`) será anexada à Release criada pelo workflow.

## Instalação

O script `src/install-speedos.sh` é fornecido para auxiliar na instalação do sistema em um disco rígido.

**AVISO:** O script de instalação é um *template* que assume que o usuário já particionou e montou o disco de destino.

1.  **Boot:** Inicialize o computador com a ISO do SpeedOS.
2.  **Particionamento:** Use uma ferramenta como `fdisk` ou `gparted` para particionar o disco de destino.
3.  **Montagem:** Monte a partição raiz em `/mnt/speedos_install`.
4.  **Execução:** Execute o script de instalação no ambiente Live:
    ```bash
    sudo /usr/local/bin/install-speedos.sh
    ```
    *   **Atenção:** Edite o script `install-speedos.sh` para definir o dispositivo de destino (`TARGET_DEVICE="/dev/sda"`).

## Créditos

*   **Desenvolvedor Principal:** Llucs
*   **Assistência na Arquitetura e Implementação:** Manus (AI)
