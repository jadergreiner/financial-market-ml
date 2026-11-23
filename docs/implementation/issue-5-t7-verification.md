# Evidência de verificação — Issue #5, T7

- **Data:** 23/11/2026
- **Ambientes comparados:** Windows local, Docker `linux/amd64` e Docker `linux/arm64`.
- **Imagem base:** `python:3.14.10-slim-bookworm@sha256:3fe1a0b6c2d6b2ebb572906cdabeca75aeb558c0c17db5ffefbcf8094871c32b`.
- **Falha controlada:** registrada separadamente em [evidência da falha T7](issue-5-t7-controlled-failure.md).

## Exclusão de arquivos locais e credenciais fictícias

Foi criado um clone descartável em `%TEMP%`, fora do repositório de trabalho, com estes marcadores sem conteúdo sensível: `.venv/t7-fake-env/marker.txt`, `__pycache__/t7_marker.cpython-314.pyc`, `.pytest_cache/t7-marker.txt`, `t7-marker.tmp`, `.env.local`, `.aws/credentials`, `secrets/t7-fake.pem` e `outputs/t7-fake.json`.

| Verificação | Resultado |
|---|---|
| `git check-ignore -v --no-index` nos oito marcadores | Código 0; todos corresponderam a regras do `.gitignore`. |
| Build de contexto com `COPY . /context` e asserções de ausência dos oito marcadores | Código 0; o `.dockerignore` excluiu todos do contexto recebido pelo container. |

Nenhum secret real foi criado ou usado. O clone temporário e a imagem temporária do teste de contexto foram removidos após a verificação.

## Comparação local e containers

| Ambiente | Python | uv | pytest | Resultado da verificação |
|---|---:|---:|---:|---|
| Windows local | 3.14.10 | 0.13.7 | 9.2.0 | 1 teste aprovado; ver [evidência T3/T6](issue-5-t3-verification.md). |
| Docker `linux/amd64` | 3.14.10 | 0.13.7 | 9.2.0 | 1 teste aprovado; ver [evidência T5](issue-5-t5-verification.md). |
| Docker `linux/arm64` | 3.14.10 | 0.13.7 | 9.2.0 | 1 teste aprovado nesta execução. |

Não houve divergência de versões ou resultado do teste entre os três ambientes. Sistema operacional e arquitetura diferem conforme esperado. O builder Buildx `desktop-linux` (BuildKit v0.31.1) anunciou suporte a `linux/arm64` e build multiplataforma.

## Comandos ARM64 executados

| Comando | Resultado |
|---|---|
| `docker buildx inspect --bootstrap` | Sucesso; builder `desktop-linux` ativo, plataforma `linux/arm64` anunciada. |
| `docker buildx build --platform linux/arm64 --load -t financial-market-ml:arm64 .` | Sucesso; imagem ARM64 carregada no Docker Engine local; `uv sync --locked` instalou o pacote e as dependências. |
| `docker run --rm --platform linux/arm64 financial-market-ml:arm64` | Código 0; 1 teste aprovado em 0,90 s. |
| `docker run --rm --platform linux/arm64 --entrypoint uv financial-market-ml:arm64 --version` | `uv 0.13.7 (aarch64-unknown-linux-gnu)`. |
| `docker run --rm --platform linux/arm64 --entrypoint python financial-market-ml:arm64 --version` | `Python 3.14.10`. |

A imagem `financial-market-ml:arm64` foi criada apenas no Docker Engine local e não foi publicada. A análise cobre o teste inicial e as versões registradas; não constitui validação de desempenho ou de modelos financeiros.
