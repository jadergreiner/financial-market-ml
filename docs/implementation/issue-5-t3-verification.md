# Evidência de verificação — Issue #5, T3

- **Data:** 22/11/2026
- **Ambiente:** Windows, Python 3.14.10, uv 0.13.7
- **Escopo:** instalação local e verificação inicial; Docker não foi validado nesta execução.

## Comandos executados

| Comando | Resultado |
|---|---|
| `uv sync --locked` | Sucesso; 7 pacotes resolvidos e conferidos sem alterar o lockfile. |
| `uv run --locked python -c "import sys, financial_market_ml; print(sys.version.split()[0]); print(financial_market_ml.__file__)"` | Sucesso; Python 3.14.10 e importação do pacote em `src/financial_market_ml/__init__.py`. |
| `uv run --locked pytest` | Sucesso; 1 teste aprovado. |

## Limites

Esta evidência cobre somente o ambiente local Windows. A validação em Docker e a comparação entre ambientes permanecem pendentes para T5 e T7.
