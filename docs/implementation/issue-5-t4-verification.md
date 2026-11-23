# Evidência de verificação — Issue #5, T4

- **Data:** 22/11/2026
- **Escopo:** regras Git para ambientes locais, caches, temporários, credenciais e saídas geradas.

## Conferências executadas

- `git check-ignore -v --no-index` confirmou regras para `.venv`, `__pycache__`, `.pytest_cache`, `build`, `.coverage`, arquivos temporários, `.env`, `.aws`, `secrets/`, chaves e diretórios de dados/artefatos gerados.
- `.env.example` não é ignorado, permitindo versionar um modelo sem credenciais reais.
- `git status --short --untracked-files=all` não listou os bytecodes que antes apareciam como não rastreados; listou apenas os arquivos intencionais de T4/T5 ainda em preparação.
- Nenhum arquivo de credenciais ou secret real foi criado ou usado.

Arquivos sintéticos escolhidos para publicação podem ser adicionados explicitamente; diretórios comuns de dados e resultados gerados ficam ignorados por padrão.
