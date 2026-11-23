# Evidência de falha controlada — Issue #5, T7

- **Data:** 22/11/2026
- **Ambiente:** Windows PowerShell, uv 0.13.7, CPython 3.14.10.
- **Isolamento:** cópia descartável do projeto em diretório exclusivo sob `%TEMP%`; nenhuma configuração do repositório foi alterada para provocar a falha.

## Falha injetada

Na cópia temporária, a faixa do projeto foi alterada de `>=3.14,<3.15` para `>=3.12,<3.14`, mantendo `.python-version` em `3.14` e o lockfile com `requires-python = "==3.14.*"`. A configuração efetiva do projeto, o ambiente `.venv` e o `uv.lock` do repositório não foram modificados.

Comando executado na cópia:

```powershell
uv sync --locked --python 3.14
```

## Resultado e diagnóstico

O comando falhou como esperado, com código de saída **2**:

```text
Using CPython 3.14.10
error: The requested interpreter resolved to Python 3.14.10, which is incompatible with the project's Python requirement: `>=3.12, <3.14` (from `project.requires-python`)
```

O diagnóstico é uma incompatibilidade entre o interpretador solicitado e `project.requires-python`. Para localizar a causa, conferir em conjunto `pyproject.toml`, `.python-version` e `uv.lock`. O hash SHA-256 do `uv.lock` na cópia permaneceu idêntico antes e depois da execução.

Após o ensaio, a cópia temporária foi removida. O `.venv` e as configurações versionadas do repositório permaneceram intactos.
