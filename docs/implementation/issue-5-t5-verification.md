# Evidência de verificação — Issue #5, T5

- **Data:** 22/11/2026
- **Plataforma:** Docker Engine Linux, `linux/amd64`
- **Imagem base:** `python:3.14.10-slim-bookworm@sha256:3fe1a0b6c2d6b2ebb572906cdabeca75aeb558c0c17db5ffefbcf8094871c32b`
- **Ferramentas no container:** Python 3.14.10, uv 0.13.7, pytest 9.2.0

## Comandos executados

| Comando | Resultado |
|---|---|
| `docker build -t financial-market-ml:local .` | Sucesso; imagem construída com o digest fixado. `uv sync --locked` instalou o pacote e as dependências do lockfile. |
| `docker run --rm financial-market-ml:local` | Sucesso; `uv run --locked pytest` executou 1 teste, aprovado. |

O teste inicial passou tanto no ambiente local Windows quanto no container `linux/amd64`. Isso valida esse teste e plataforma; a validação ARM64 e a equivalência mais ampla permanecem pendentes.
