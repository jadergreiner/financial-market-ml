# Registro de implementação — Issue #5, T1: versão de Python

- **Issue:** [#5 — T01: Ambiente local reproduzível — Python e Docker](https://github.com/jadergreiner/financial-market-ml/issues/5)
- **Estado:** Python e gerenciador confirmados; instalação local e validação Docker em `linux/amd64` e `linux/arm64` registradas.
- **Governança:** LL-ADR-002. Decisão registrada com assistência (A1); não representa evidência de implementação independente (I0).

## Decisão registrada

- Versão suportada: **Python 3.14.x**.
- Faixa de compatibilidade planejada: `>=3.14,<3.15`.
- Aceitar atualizações de patch dentro da série 3.14. A imagem inicial fixa Python 3.14.10; ver [registro Docker](issue-5-t1-docker-runtime.md).
- Confirmação do responsável: manter Python 3.14.x; a menção a Python 3.12.16 foi um deslize.
- Gerenciador de dependências: **uv**.
- Declarar dependências e metadados do projeto em `pyproject.toml`; registrar versões exatas resolvidas em `uv.lock` e versionar esse arquivo.
- Tratar `uv.lock` como arquivo gerado e mantido pelo uv, sem edição manual.
- Usar a combinação `uv + pyproject.toml + uv.lock` no MVP local e mantê-la como base de dependências numa evolução para AWS; a integração de build e instalação será confirmada quando os serviços AWS forem escolhidos.

## Justificativa

- Python 3.14 é uma série estável com suporte upstream de correções previsto até outubro de 2030.
- NumPy 2.4 declara suporte a Python 3.14, e pandas 2.3.3 declara compatibilidade com essa série.
- Restringir o projeto à série 3.14 mantém a combinação de ambientes local e Docker explícita; a instalação efetiva ainda precisa ser verificada nas tarefas seguintes.

## Evidência e pendências

- Referência ao ciclo de suporte: [Python Downloads](https://www.python.org/downloads/).
- Compatibilidade de NumPy: [NumPy 2.4 release notes](https://numpy.org/doc/stable/release/2.4.0-notes.html).
- Compatibilidade de pandas: [pandas release notes](https://pandas.pydata.org/docs/whatsnew/).
- Comportamento do gerenciador e do lockfile: [uv — Working on projects](https://docs.astral.sh/uv/guides/projects/) e [uv — Locking and syncing](https://docs.astral.sh/uv/concepts/projects/sync/).
- Instalação e importação locais validadas em Windows com Python 3.14.10 e uv 0.13.7; ver [evidência T3](issue-5-t3-verification.md).
- A instalação e a execução da verificação no container foram validadas em `linux/amd64` (T5) e `linux/arm64` (T7); consulte [evidência T8](issue-5-t8-review.md) para a consolidação e limites.
