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

Esta seção registra a validação local inicial em Windows; a execução Docker está registrada separadamente em [evidência T5](issue-5-t5-verification.md).

## Revalidação local em ambiente limpo para T6

- **Data:** 22/11/2026
- **Ambiente:** Windows PowerShell, uv 0.13.7, Python gerenciado 3.14.10, pytest 9.2.0.
- **Isolamento:** `UV_PROJECT_ENVIRONMENT` apontou para uma pasta temporária exclusiva em `%TEMP%`, verificada como inexistente antes da execução. O `.venv` do repositório não foi usado. A pasta temporária foi removida após todos os comandos passarem, e a variável foi limpa.

| Comando executado | Resultado | Código de saída |
|---|---|---:|
| `uv python install 3.14` | Sucesso; Python 3.14 já estava instalado pelo uv. | 0 |
| `uv sync --locked --python 3.14` | Sucesso; criou ambiente limpo e instalou 7 pacotes, incluindo o projeto e pytest, a partir do lockfile. | 0 |
| `uv run --locked python --version` | `Python 3.14.10`. | 0 |
| `uv run --locked pytest` | 1 teste aprovado em 0,05 s. | 0 |

O instalador PowerShell do uv 0.13.7 está documentado no README como pré-requisito; não foi executado nesta validação porque o `uv` já estava instalado. A [documentação oficial de instalação do uv](https://docs.astral.sh/uv/getting-started/installation/) descreve o instalador versionado.
