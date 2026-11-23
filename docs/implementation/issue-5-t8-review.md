# Revisão consolidada de evidências — Issue #5 / T01 (T8)

- **Data da revisão:** 23/11/2026
- **Issue:** [#5 — T01: Ambiente local reproduzível — Python e Docker](https://github.com/jadergreiner/financial-market-ml/issues/5)
- **Estado consultado da Issue:** aberta; a revisão local não a encerra.
- **Checkout consultado:** `feat/t01-local-environment`, HEAD `743deda6f99b6a97711b0eb21a64680bcdebcdc8` (`docs: record full T7 cross-platform verification`), sincronizado com `origin/feat/t01-local-environment`; árvore limpa antes desta consolidação.
- **Fonte normativa dos critérios e cenários:** corpo da Issue #5 consultado pelo conector GitHub em 23/11/2026. O texto identifica CA-T01.1 a CA-T01.4, seis testes positivos/adversariais e os gates. O estado remoto retornado foi `open`.
- **Documentos locais lidos:** `implementation-plan-issue-5.md`, `issue-5-t1-python-runtime.md`, `issue-5-t1-docker-runtime.md`, `issue-5-t3-verification.md`, `issue-5-t4-verification.md`, `issue-5-t5-verification.md`, `issue-5-t7-controlled-failure.md` e `issue-5-t7-verification.md`.

## Evidências consolidadas

### Configuração e instalação

- Python suportado: `>=3.14,<3.15`; `.python-version` indica 3.14. O lockfile fixa a resolução. Base Docker: `python:3.14.10-slim-bookworm@sha256:3fe1a0b6c2d6b2ebb572906cdabeca75aeb558c0c17db5ffefbcf8094871c32b`.
- Na validação local limpa (Windows PowerShell, 22/11/2026), `uv` 0.13.7 e CPython 3.14.10 já estavam disponíveis. `uv python install 3.14`, `uv sync --locked --python 3.14`, `uv run --locked python --version` e `uv run --locked pytest` tiveram código 0. O sync instalou 7 pacotes; o comando de versão imprimiu `Python 3.14.10`; pytest informou 1 teste aprovado em 0,05 s. O ambiente temporário foi removido e a variável de ambiente limpa. O `.venv` do repositório não foi usado. O instalador do uv documentado no README não foi executado.
- Na verificação local inicial (22/11), `uv sync --locked`, importação de `financial_market_ml` e `uv run --locked pytest` foram registrados como sucesso; foi reportado 1 teste aprovado. A evidência não guarda códigos de saída individuais para esta rodada.

### Docker e equivalência observada

- Em Docker Engine Linux `linux/amd64` (T5, 22/11), `docker build -t financial-market-ml:local .` construiu a imagem fixada e executou `uv sync --locked`; `docker run --rm financial-market-ml:local` executou pytest e reportou 1 teste aprovado. Python 3.14.10, uv 0.13.7 e pytest 9.2.0 foram registrados. A evidência T5 relata sucesso, mas não preserva códigos numéricos de saída para esses comandos.
- Em `linux/arm64` (T7, 23/11), `docker buildx inspect --bootstrap` confirmou builder `desktop-linux`, BuildKit 0.31.1 e suporte ARM64; `docker buildx build --platform linux/arm64 --load -t financial-market-ml:arm64 .` teve sucesso. `docker run --rm --platform linux/arm64 financial-market-ml:arm64` teve código 0 e 1 teste aprovado em 0,90 s. Os comandos de versão reportaram Python 3.14.10 e `uv 0.13.7 (aarch64-unknown-linux-gnu)`; pytest 9.2.0 foi registrado.
- Comparação documentada: Windows, Docker amd64 e Docker arm64 usaram Python 3.14.10, uv 0.13.7 e pytest 9.2.0; cada ambiente aprovou o teste inicial. SO e arquitetura variam como esperado. O registro compara esse teste pequeno e as versões listadas; não cobre desempenho, treinamento ou comportamento de modelos.

### Proteções e falha controlada

- T4 verificou regras Git para ambientes virtuais, caches, temporários, artefatos, arquivos de ambiente/credenciais e diretórios de dados/saídas; `.env.example` permanece versionável. Marcadores sintéticos confirmaram exclusão no contexto Docker para `.env.local`, `.aws/credentials`, `secrets/` e `outputs/`. O primeiro ensaio revelou ausência da regra `outputs/`; após adicioná-la, a repetição passou. A evidência T4 não informa códigos numéricos de saída.
- T7 repetiu em clone descartável a conferência de oito marcadores fictícios (`.venv`, `__pycache__`, `.pytest_cache`, temporário, `.env.local`, `.aws/credentials`, `secrets/` e `outputs/`). `git check-ignore -v --no-index` e a sondagem de contexto Docker tiveram código 0 e excluíram todos. Clone e imagem temporários foram removidos. Nenhum secret real foi criado ou usado.
- A falha controlada foi injetada apenas em cópia temporária: `requires-python` mudou para `>=3.12,<3.14`, enquanto `.python-version` ficou em 3.14 e o lock conservou `==3.14.*`. `uv sync --locked --python 3.14` falhou intencionalmente com código 2, informando que CPython 3.14.10 era incompatível com a faixa declarada. O hash do lock permaneceu igual; a cópia foi removida e o repositório não foi alterado por esse ensaio.

## Critérios de aceite da Issue

| Critério | Estado | Evidência e limite |
|---|---|---|
| CA-T01.1 — Dependências instaláveis pela configuração versionada | **Atendido** | Sync limpo com `uv sync --locked --python 3.14` instalou 7 pacotes; lockfile e versões estão registrados em T3/T6. A instalação foi no Windows indicado, sem reexecutar neste T8. |
| CA-T01.2 — Verificação automatizada inicial executada com resultado registrado | **Atendido** | Um teste passou no Windows local e em Docker amd64/arm64; comandos/saídas estão em T3/T5/T7. Os códigos numéricos das rodadas iniciais local/amd64 não foram preservados nas respectivas evidências; T6 local e T7 arm64 registram código 0. |
| CA-T01.3 — Ambientes local e Docker sob contratos equivalentes | **Atendido** | A mesma verificação, versões Python/uv/pytest e resultado foram comparados nos três ambientes em T7. O alcance é somente o teste inicial, não valida modelos ou desempenho. |
| CA-T01.4 — Arquivos gerados e sensíveis não publicados acidentalmente | **Atendido** | Regras Git/contexto Docker foram exercitadas com marcadores sintéticos em T4/T7; a falta inicial da regra `outputs/` foi corrigida e retestada. Nenhum segredo real foi usado. |

## Cenários positivos e adversariais da Issue

| Cenário descrito na Issue #5 | Estado | Evidência |
|---|---|---|
| Instalação em ambiente limpo conforme documentação | **Atendido** | T3/T6: ambiente temporário Windows, sync bloqueado pelo lock, 7 pacotes, remoção posterior; comandos e códigos de saída registrados. |
| Execução da verificação automatizada no ambiente local | **Atendido** | T3/T6: pytest, 1 teste aprovado; T6 registra código 0. |
| Execução da mesma verificação em Docker, comparando resultados | **Atendido** | T5/T7: amd64 e arm64, 1 teste aprovado em cada; T7 compara com Windows. |
| Diagnóstico documentado para falha deliberada de configuração/dependência | **Atendido** | T7 controlled failure: código 2 e incompatibilidade entre interpretador 3.14.10 e `project.requires-python`; ensaio isolado. |
| Conferência de exclusão de temporários, caches, ambientes virtuais e secrets fictícios do versionamento | **Atendido** | T4/T7: oito marcadores fictícios excluídos pelo Git e contexto Docker, códigos 0 na repetição T7. Nenhum secret real. |
| Conferência de diferenças de versões/configuração local e container | **Atendido** | T7 registra Python, uv e pytest iguais nos três ambientes e explica diferenças esperadas de SO/arquitetura. |

## Governança, limitações e estado de encerramento

- Decisões T1 foram registradas como assistidas (A1); essa evidência não demonstra compreensão ou implementação independente I0. O pedido atual consolida os registros, não reavalia competências nem substitui revisão V1 humana.
- Não foi executado build, teste ou instalação durante T8. Códigos não preservados nas evidências anteriores permanecem explicitamente não registrados; “sucesso” textual não foi convertido em código presumido.
- Não foram testados serviços AWS, dados reais, publicação de secrets, desempenho de modelos nem cenários além do único teste inicial. A imagem ARM64 ficou apenas no Docker Engine local.
- Os documentos locais são evidência revisável neste checkout. O estado da Issue permanece `open`; evidências no PR, revisão V1 e aceite final precisam ocorrer no fluxo autorizado. O gate M0 também exige T02. T8 concluída não significa Issue #5/T01 concluída nem autoriza avanço a T02.
