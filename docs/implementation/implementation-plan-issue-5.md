# Plano de implementação — Issue #5

- **Issue:** [#5 — T01: Ambiente local reproduzível — Python e Docker](https://github.com/jadergreiner/financial-market-ml/issues/5)
- **Escopo:** somente a fundação técnica do Lab 01.
- **Governança:** LL-ADR-002, modo I0 — implementação independente.
- **Tipo deste documento:** lista de tarefas; não contém código de solução.
- **Registro separado de decisões e progresso:** [Issue #5, T1 — versão de Python](issue-5-t1-python-runtime.md).

## Objetivo

Preparar um ambiente Python que possa ser instalado e verificado localmente e em Docker, com dependências e versões registradas, uma verificação automatizada inicial, proteção contra publicação acidental de arquivos e evidências reproduzíveis.

## Tarefas

### T1 — Fixar as decisões do ambiente

- [x] Definir e registrar a versão de Python suportada ([decisão registrada](issue-5-t1-python-runtime.md)).
- [x] Escolher o gerenciador de dependências e a forma de registrar versões reproduzíveis: `uv`, com dependências declaradas em `pyproject.toml` e versões resolvidas registradas em `uv.lock` ([decisão registrada](issue-5-t1-python-runtime.md)).
- [x] Definir a imagem e a versão base do Docker ([decisão e digest registrados](issue-5-t1-docker-runtime.md)); validação de build fica para as tarefas de execução.
- [x] Registrar os motivos das escolhas e os requisitos mínimos para executar os comandos ([registro T1](issue-5-t1-docker-runtime.md)); versões exatas das ferramentas de execução serão fixadas nas tarefas de configuração.

**Pronto quando:** as versões e ferramentas necessárias estiverem explícitas e forem compatíveis entre si.

### T2 — Preparar a estrutura mínima do projeto

- Criar a estrutura Python mínima necessária para instalar e importar o pacote.
- Criar apenas diretórios e arquivos usados nesta tarefa; não antecipar módulos de dados, features ou modelos.
- Configurar o projeto para instalação conforme as decisões registradas em T1.

**Pronto quando:** a estrutura puder ser instalada a partir da configuração versionada, sem arquivos vazios desnecessários.

### T3 — Registrar dependências e verificação inicial

- Declarar as dependências de execução e desenvolvimento necessárias à fundação.
- Registrar versões de forma reproduzível e manter a configuração alinhada à escolhida em T1.
- Definir uma verificação automatizada inicial pequena, executável e documentada.

**Pronto quando:** uma instalação limpa puder resolver as dependências e a verificação inicial puder ser invocada pelo procedimento documentado.

### T4 — Proteger arquivos locais e artefatos

- Definir regras de exclusão para ambientes virtuais, caches, arquivos temporários, artefatos gerados e arquivos de ambiente ou credenciais.
- Manter no Git apenas arquivos de configuração e evidências sintéticas selecionadas para divulgação.
- Conferir o estado de versionamento para verificar que exemplos de secrets e arquivos locais não sejam incluídos.

**Pronto quando:** a política estiver versionada e a conferência não encontrar arquivos locais ou sensíveis indevidamente incluídos.

### T5 — Disponibilizar o ambiente Docker

- Criar a configuração de imagem e execução para o ambiente do projeto usando as versões definidas em T1.
- Documentar como construir e executar a mesma verificação automatizada usada localmente.
- Manter as dependências e os comandos consistentes com a configuração versionada do projeto.

**Pronto quando:** a verificação inicial puder ser executada no container seguindo as instruções documentadas.

### T6 — Documentar instalação e uso local

- Documentar pré-requisitos, instalação limpa, ativação do ambiente quando aplicável e comandos de verificação local.
- Documentar comandos de construção e execução em Docker.
- Registrar somente comandos que tenham sido efetivamente executados, distinguindo instruções planejadas de resultados observados.

**Pronto quando:** outra pessoa puder seguir as instruções e identificar versões, comandos e resultados esperados em cada ambiente.

### T7 — Verificar equivalência e comportamento adversarial

- Executar a mesma verificação automatizada localmente e em Docker, comparando os resultados esperados.
- Introduzir uma falha controlada de configuração ou dependência e registrar como identificá-la e diagnosticá-la.
- Conferir as versões e configurações efetivas dos dois ambientes e explicar divergências relevantes.
- Verificar a política de arquivos excluídos com exemplos de arquivos temporários, caches, ambientes virtuais e secrets fictícios.

**Pronto quando:** as verificações tiverem resultados registrados, divergências estiverem explicadas e nenhum secret real for usado ou publicado.

### T8 — Consolidar evidências e revisar os critérios

- Registrar comandos realmente executados, códigos de saída, versões do ambiente e dependências relevantes.
- Registrar os resultados da verificação automatizada local e em Docker, incluindo a comparação entre ambientes.
- Registrar o resultado da conferência de arquivos excluídos, limitações conhecidas, intervenções assistidas e erros encontrados.
- Revisar os critérios CA-T01.1 a CA-T01.4 e os cenários de verificação da Issue #5 com base nessas evidências.

**Pronto quando:** cada critério tiver evidência revisável ou estiver explicitamente marcado como não atendido; nenhum resultado não executado for declarado como aprovado.

## Mapeamento dos critérios de aceite

| Critério | Tarefas | Evidência necessária |
|---|---|---|
| CA-T01.1 — Dependências instaláveis pela configuração versionada | T1, T2, T3 | Instalação limpa e versões registradas |
| CA-T01.2 — Verificação automatizada inicial executada | T3, T6, T7 | Comando e resultado efetivamente obtido em cada ambiente |
| CA-T01.3 — Contratos equivalentes entre local e Docker | T1, T5, T6, T7 | Mesma verificação executada nos dois ambientes e comparação documentada |
| CA-T01.4 — Proteção contra publicação acidental de arquivos | T4, T7 | Política versionada e resultado da conferência do estado de versionamento |

## Limites e encerramento

- Esta tarefa não inclui gerador OHLCV, quality gate, features, target, classificador ou experimento de data leakage.
- Não inclui infraestrutura AWS, credenciais reais, publicação de secrets, commit ou Pull Request.
- A sequência termina com a revisão V1 e evidências associadas à Issue #5; não avança automaticamente para T02.
- Este plano descreve o trabalho a realizar e não afirma que qualquer tarefa, teste ou critério já foi concluído.
