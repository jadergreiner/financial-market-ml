# Registro de implementação — Issue #5, T1: imagem Docker

- **Issue:** [#5 — T01: Ambiente local reproduzível — Python e Docker](https://github.com/jadergreiner/financial-market-ml/issues/5)
- **Estado:** proposta aceita; build e verificação em `linux/amd64` e `linux/arm64` validados (T5/T7). A versão do Docker Engine não foi registrada.
- **Data da aceitação:** 21/11/2026.
- **Governança:** LL-ADR-002. Decisão registrada com assistência (A1); não representa evidência de implementação independente (I0).

## Decisão aceita

| Dimensão | Decisão |
|---|---|
| Sistema operacional | Debian 12 Bookworm |
| Variante | Slim |
| Python | 3.14.10; linha suportada 3.14.x |
| Gerenciador | uv |
| Imagem | `python:3.14.10-slim-bookworm` |
| Fixação | Tag e digest do índice OCI multiarch |
| Plataforma de referência | `linux/amd64` |
| Plataforma adicional | `linux/arm64`; build e execução validados em T7 |
| Ambiente local | Docker como referência; execução nativa opcional |
| Evolução AWS | Reutilizar container quando compatível com o serviço escolhido |

Referência fixada no momento do registro:

`python:3.14.10-slim-bookworm@sha256:3fe1a0b6c2d6b2ebb572906cdabeca75aeb558c0c17db5ffefbcf8094871c32b`

O digest acima é do índice OCI multiarch consultado no Registry v2 da Docker Official Image `library/python`, em 21/11/2026. O manifesto lista `linux/amd64` e `linux/arm64`, além de outras plataformas e entradas de metadados. A presença no manifesto não substitui a validação de build e execução do projeto.

## Justificativa e trade-off

- Debian Bookworm slim fornece uma base Linux compacta com Python 3.14.10 e corresponde à estratégia Docker-first aprovada.
- Fixar patch, tag e digest torna explícita a versão e evita que uma alteração posterior da tag mude silenciosamente a imagem usada.
- O trade-off aceito é manter disciplina de atualização da imagem para preservar estabilidade e reprodutibilidade.
- A imagem é a referência para desenvolvimento local. Execução nativa continua opcional e deve respeitar a faixa Python 3.14.x.
- A reutilização na AWS será condicionada à compatibilidade do container com o serviço definido; nenhum serviço AWS está selecionado neste T1.

## Requisitos mínimos para executar os comandos

- **Fluxo de referência:** Docker CLI instalado e com acesso a um Docker Engine/daemon ativo em modo Linux, além de acesso de rede ao Docker Hub e ao índice de pacotes Python usado pelo projeto.
- **Host Windows:** usar uma versão do Windows ainda suportada pelo Docker Desktop. Com backend WSL 2, exigir WSL 2.1.5 ou superior, virtualização de hardware habilitada e os requisitos de CPU/memória definidos pelo Docker Desktop. A documentação consultada lista CPU x64 com SLAT e 8 GB de RAM como requisitos do WSL 2.
- **Plataforma principal:** executar ou construir para `linux/amd64`; hosts de outra arquitetura precisam de emulação ou de um builder compatível.
- **Validação ARM64:** build e execução do projeto foram demonstrados com Docker Buildx/BuildKit em T7. A evidência registra builder/plataforma, mas não a versão do Docker Engine.
- **Execução nativa opcional:** Python 3.14.x e `uv` disponível com suporte a Python 3.14 e aos fluxos de projeto/lock. A versão exata do executável `uv` será registrada na configuração do ambiente nas tarefas seguintes.
- **AWS:** credenciais e conta AWS não são necessárias para T1; a adaptação será decidida quando o serviço alvo for definido.

## Evidências e pendências

- [Manifesto de imagens oficiais Python](https://github.com/docker-library/official-images/blob/master/library/python) lista `3.14.10-slim-bookworm` para `amd64` e `arm64`.
- [Dockerfile oficial slim-bookworm para Python 3.14](https://github.com/docker-library/python/blob/master/3.14/slim-bookworm/Dockerfile) declara a base Debian Bookworm slim e Python 3.14.10.
- [Requisitos oficiais do Docker Desktop no Windows](https://docs.docker.com/desktop/setup/install/windows-install/) e [backend WSL 2](https://docs.docker.com/desktop/features/wsl) fundamentam os pré-requisitos de host.
- [Builds multi-plataforma do Docker](https://docs.docker.com/build/building/multi-platform/) descrevem Buildx, emulação QEMU e builders nativos.
- [Suporte de Python pelo uv](https://docs.astral.sh/uv/reference/policies/python/) lista Python 3.14 como Tier 1.
- Digest consultado diretamente no Registry v2 para a tag indicada: `sha256:3fe1a0b6c2d6b2ebb572906cdabeca75aeb558c0c17db5ffefbcf8094871c32b`.
- Build e verificação inicial concluídos em `linux/amd64`; ver [evidência T5](issue-5-t5-verification.md).
- Build e execução em `linux/arm64`, além da comparação do teste e das versões entre Windows, amd64 e arm64, registrados em [evidência T7](issue-5-t7-verification.md).
- A versão do Docker Engine não foi registrada nas evidências T5/T7. A política de atualização da imagem permanece fora da validação de T01.
