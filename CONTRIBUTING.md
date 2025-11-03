# Diretrizes de Contribuição para o SpeedOS

Agradecemos o seu interesse em contribuir para o SpeedOS! Para garantir um processo de desenvolvimento suave e coeso, siga estas diretrizes:

## Como Contribuir

1.  **Fork** o repositório `github.com/Llucs/speedos`.
2.  **Clone** o seu fork localmente.
3.  Crie um **Branch** para a sua feature ou correção (`git checkout -b feature/minha-nova-feature`).
4.  Faça suas alterações e **Commit** (`git commit -m 'feat: Adiciona nova funcionalidade X'`).
5.  **Push** para o seu branch (`git push origin feature/minha-nova-feature`).
6.  Abra um **Pull Request (PR)** para o repositório principal.

## Padrões de Código

*   **Scripts Shell:** Devem ser robustos, usar `set -euo pipefail` e incluir comentários claros.
*   **Python (SpeedCenter):** Siga o padrão PEP 8 e utilize o GTK4/Adwaita para a interface.
*   **Minimalismo:** Mantenha o código o mais leve e eficiente possível, priorizando a performance em hardware antigo.

## Relatório de Bugs

Se encontrar um bug, por favor, abra uma **Issue** no GitHub com as seguintes informações:

*   Passos para reproduzir o bug.
*   Comportamento esperado.
*   Comportamento atual.
*   Versão do SpeedOS.

## Sugestões de Recursos

Para sugerir um novo recurso, abra uma **Issue** e use o prefixo `feat:`. Descreva o recurso e por que ele seria benéfico para o SpeedOS.
