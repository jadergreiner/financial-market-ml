# Financial Market ML — Implementation Plan

**Versão:** 0.1  
**Status:** Aprovado pelo responsável do projeto; publicação via Pull Request  
**Metodologia:** BMad Method  
**Escopo:** Lab 01 — Financial Asset Price Direction Classification  
**Governança:** Life Learning LL-ADR-002  
**Modo de execução:** I0 — Independent Implementation

## 1. Referências e escopo

Este plano deriva dos documentos aprovados:

- [Product Brief v0.1](product-brief.md)
- [PRD v0.1](prd.md)
- [Architecture v0.1](architecture.md)

Objetivo: implementar um laboratório local de classificação da direção do fechamento ajustado do próximo pregão de um ativo sintético, demonstrando qualidade, isolamento temporal, prevenção de leakage, avaliação comparativa e reprodutibilidade.

**Fora do escopo:** trading, dados em tempo real, infraestrutura AWS, modelos complexos e sistemas distribuídos.

## 2. Contrato de execução

**Estudar → Implementar → Testar → Diagnosticar → Defender → Evidenciar.**

- **I0 — Independente:** o estudante desenvolve algoritmos, interfaces e testes sem solução pronta.
- **A1 — Assistência declarada:** intervenções posteriores devem ser identificadas.
- **V1 — Adversarial:** injetar falhas, verificar invariantes e exigir diagnóstico.
- **R1 — Retenção:** revisitar os conceitos em exemplos novos e recuperação ativa.

Uma tarefa não é concluída apenas porque existe código: requer execução, testes e evidências.

## 3. Marcos e sequência

| Marco | Tarefas | Gate |
|---|---|---|
| M0 — Fundação e contratos | T01–T02 | Ambiente reproduzível e contratos verificáveis |
| M1 — Dados sintéticos e qualidade | T03–T05 | OHLCV íntegro, reprodutível e validado |
| M2 — Features e integridade temporal | T06–T09 | Dataset supervisionado temporalmente válido |
| M3 — Baseline e classificação | T10–T12 | Classificador e baseline avaliados corretamente |
| M4 — Experimento de leakage | T13–T14 | Vazamento reproduzido, identificado e explicado |
| M5 — Evidências e revisão | T15–T16 | MVP verificado; competências avaliadas separadamente |

Marcos são indicadores de progresso, **não novas posições ou sessões** do Life Learning. Sem estimativas de horas como gate.

## 4. M0 — Fundação

### T01 — Ambiente local reproduzível

**Objetivo:** estabelecer ambiente executável localmente e em Docker.

**Escopo:** organizar projeto Python, dependências/versões, execução local e container, testes iniciais e política de artefatos gerados e secrets.

**Aceite:**
- CA-T01.1: dependências instaladas conforme configuração versionada.
- CA-T01.2: verificação automatizada inicial executa.
- CA-T01.3: local e Docker obedecem contratos equivalentes.
- CA-T01.4: arquivos gerados não são publicados acidentalmente.

**Evidências:** comandos executados, resultados, versões de ambiente.  
**Dependências:** nenhuma.

### T02 — Contratos e configuração do experimento

**Objetivo:** formalizar parâmetros e contratos antes dos algoritmos.

**Escopo:** seed, ticker, data inicial, número de pregões, schema e restrições OHLCV, instante de previsão, horizonte de target, features permitidas e proibidas.

**Aceite:**
- CA-T02.1: entradas inválidas são identificáveis.
- CA-T02.2: configuração inspecionável.
- CA-T02.3: features e target têm papéis distintos.
- CA-T02.4: contrato temporal documentado.

**Evidências:** contratos e testes de configuração.  
**Dependências:** T01.

**Gate M0:** ambiente reproduzível e contratos verificáveis.

## 5. M1 — Synthetic Market Data & Quality

### T03 — Gerador de dados OHLCV

**Objetivo:** produzir série sintética reproduzível.

**Escopo:** geração determinística com seed, calendário sintético de dias úteis, OHLCV consistente, um ticker, serialização.

**Aceite:**
- CA-T03.1: mesmos parâmetros e seed geram a mesma série.
- CA-T03.2: datas únicas.
- CA-T03.3: contrato OHLCV satisfeito.
- CA-T03.4: leitura dos dados persistidos preserva contrato.

**Testes:** geração repetida, seed diferente, quantidade mínima e consistência OHLC.  
**Evidências:** dataset sintético, parâmetros, hash, testes executados.  
**Dependências:** T02.

### T04 — Data Quality Gate

**Objetivo:** impedir que dados inválidos entrem na preparação.

**Escopo:** schema, unicidade de `ticker + date`, preços/volume, nulos/não finitos, violações, fail-closed.

**Aceite:**
- CA-T04.1: dataset válido aceito.
- CA-T04.2: violações identificadas individualmente.
- CA-T04.3: dados inválidos não passam silenciosamente.
- CA-T04.4: falhas produzem diagnóstico compreensível.

**Testes:** válido e V1-01 a V1-04.  
**Evidências:** testes e exemplos de diagnóstico.  
**Dependências:** T03.

### T05 — Integração dos dados

**Objetivo:** comprovar geração → persistência → leitura → validação.

**Aceite:**
- CA-T05.1: dataset válido percorre o fluxo.
- CA-T05.2: dados corrompidos são rejeitados.
- CA-T05.3: nenhuma transformação silenciosa mascara inconsistências.
- CA-T05.4: execução reproduzível.

**Evidências:** testes integrados executados.  
**Dependências:** T03 e T04.

**Gate M1:** dataset íntegro, reprodutível e validado.

## 6. M2 — Temporal Feature Engineering

### T06 — Features históricas

**Objetivo:** indicadores apenas com informações disponíveis até `t`.

**Candidatas:** `return_1d`, `sma_5`, `sma_20`, `volatility_20`, `volume`.

**Aceite:**
- CA-T06.1: definição matemática documentada.
- CA-T06.2: respeito à ordem temporal.
- CA-T06.3: histórico insuficiente tratado explicitamente.
- CA-T06.4: dados futuros não alteram features passadas.

**Testes:** referências calculadas independentemente, histórico insuficiente, V1-05 e V1-09.  
**Evidências:** testes, comparações e convenções.  
**Dependências:** T05.

### T07 — Target e alinhamento

**Objetivo:** construir classificação da direção do fechamento de `t+1`.

**Contrato:** 1 se próximo fechamento ajustado > atual; 0 se <= atual; ausente se próximo fechamento não conhecido.

**Aceite:**
- CA-T07.1: target alinhado à data de origem da previsão.
- CA-T07.2: target não é feature válida.
- CA-T07.3: observação sem próximo fechamento não recebe classe artificial.
- CA-T07.4: instante de disponibilidade do rótulo identificável.

**Testes:** alta, queda, estabilidade, ausência de futuro e V1-12.  
**Evidências:** casos controlados e testes.  
**Dependências:** T06.

### T08 — Temporal Splitter

**Objetivo:** dividir cronologicamente as observações elegíveis.

**Configuração proposta:** 70% treino, 15% validação, 15% teste.

**Aceite:**
- CA-T08.1: conjuntos disjuntos.
- CA-T08.2: datas em ordem cronológica.
- CA-T08.3: excluir rótulos que ultrapassem fronteiras quando necessário.
- CA-T08.4: registrar datas, quantidades e exclusões.
- CA-T08.5: manter teste reservado.

**Testes:** fronteiras, conjuntos pequenos e V1-08.  
**Evidências:** manifesto da divisão e resultados dos testes.  
**Dependências:** T07.

### T09 — Testes de integridade temporal

**Objetivo:** demonstrar ausência das violações temporais especificadas.

**Escopo:** alterar futuro, comparar features passadas, verificar disponibilidade dos rótulos, features proibidas e isolamento.

**Aceite:**
- CA-T09.1: mudança futura não altera features anteriores.
- CA-T09.2: features proibidas rejeitadas.
- CA-T09.3: rótulos não contaminam fronteiras.
- CA-T09.4: violação possui diagnóstico.

**Testes:** V1-05, V1-06, V1-08, V1-09.  
**Evidências:** testes positivos e adversariais executados.  
**Dependências:** T06, T07, T08.

**Gate M2:** dataset supervisionado preparado, alinhado e temporalmente válido.

## 7. M3 — Baseline & Classification

### T10 — Baseline

**Objetivo:** referência ingênua de classificação.

**Regra:** prever a classe majoritária exclusivamente do treino.

**Aceite:**
- CA-T10.1: classe definida só no treino.
- CA-T10.2: validação e teste não influenciam a escolha.
- CA-T10.3: predições alinhadas às observações.
- CA-T10.4: configurações/resultados rastreáveis.

**Evidências:** predições, configurações e testes.  
**Dependências:** T08 e T09.

### T11 — Classificador supervisionado

**Objetivo:** treinar modelo simples (candidato: regressão logística).

**Aceite:**
- CA-T11.1: somente features autorizadas.
- CA-T11.2: transformações ajustadas apenas no treino.
- CA-T11.3: parâmetros reaplicados sem reajuste em validação/teste.
- CA-T11.4: configuração registrada.
- CA-T11.5: testes detectam ajuste indevido usando teste.

**Testes:** válido, configuração inadequada, V1-07.  
**Evidências:** modelo treinado, configuração e testes.  
**Dependências:** T09.

### T12 — Avaliação comparativa

**Objetivo:** avaliar baseline e classificador sobre observações comparáveis.

**Métricas:** accuracy, precision, recall, F1-score, confusion matrix e distribuição das classes.

**Aceite:**
- CA-T12.1: predições/targets alinhados.
- CA-T12.2: baseline e classificador comparáveis.
- CA-T12.3: classes ausentes/predição constante diagnosticadas.
- CA-T12.4: limitações incluídas.
- CA-T12.5: não declarar vantagem financeira.

**Testes:** casos controlados e V1-11.  
**Evidências:** métricas e testes.  
**Dependências:** T10 e T11.

**Gate M3:** baseline e classificador avaliados com integridade metodológica.

## 8. M4 — Data Leakage Experiment

### T13 — Experimento inválido

**Objetivo:** investigar impacto de incluir informação futura.

**Defeito controlado:** `future_return_1d` como feature.

**Aceite:**
- CA-T13.1: execução inválida isolada.
- CA-T13.2: cenário explicitamente rotulado.
- CA-T13.3: conjuntos, target e demais condições comparáveis.
- CA-T13.4: pipeline válido rejeita feature proibida.

**Evidências:** configuração do cenário, resultados e testes de isolamento.  
**Dependências:** T12.

### T14 — Diagnóstico comparativo

**Objetivo:** explicar comportamentos dos experimentos.

**Aceite:**
- CA-T14.1: comparação apresenta métricas obtidas.
- CA-T14.2: causa do leakage demonstrada tecnicamente.
- CA-T14.3: conclusão não depende de diferença mínima arbitrária de acurácia.
- CA-T14.4: limitações e explicações alternativas documentadas.

**Evidências:** relatório comparativo e defesa técnica.  
**Dependências:** T13.

**Gate M4:** vazamento reproduzido, identificado e explicado.

## 9. M5 — Evidence & Validation

### T15 — Registro reproduzível

**Objetivo:** consolidar artefatos e metadados para auditoria.

**Conteúdo:** identificador, seed, configuração, versões, hash, fronteiras, features, modelos, métricas, testes executados e limitações.

**Aceite:**
- CA-T15.1: execução identificável.
- CA-T15.2: resultado vinculado a dados/configuração.
- CA-T15.3: falha de persistência detectada.
- CA-T15.4: testes não executados não figuram como aprovados.
- CA-T15.5: reprodução demonstrada em ambiente controlado.

**Evidências:** manifestos, artefatos e reprodução documentada.  
**Dependências:** T14.

### T16 — Revisão adversarial integrada

**Objetivo:** validação final do laboratório.

**Escopo:** reexecutar testes unitários e integração, cobrir V1-01 a V1-12, conferir temporalidade, rastreabilidade e decisões, documentar limitações.

**Aceite:**
- CA-T16.1: requisitos do PRD com evidências rastreáveis.
- CA-T16.2: invariantes críticos protegidos por testes.
- CA-T16.3: falhas diagnosticadas.
- CA-T16.4: relatório distingue resultados verificados de hipóteses.
- CA-T16.5: defesa técnica independente realizada.

**Evidências:** relatório V1, testes, avaliação multidimensional.  
**Dependências:** T01–T15.

**Gate M5:** MVP funcional verificado e competências avaliadas separadamente.

## 10. Rastreabilidade

| História | Tarefas | Requisitos principais |
|---|---|---|
| US-01 | T02, T03 | RF-01 |
| US-02 | T04, T05 | RF-02 |
| US-03 | T06–T09 | RF-03, RF-04 |
| US-04 | T10–T12 | RF-05, RF-07 |
| US-05 | T13, T14 | RF-06 |
| US-06 | T01, T15, T16 | RF-08, RNF-01–07 |

A rastreabilidade começa no primeiro incremento, e não apenas na T15.

## 11. Branches e Pull Requests

1. Abrir Issue ou tarefa vinculada ao requisito.
2. Criar branch curta.
3. Implementar em I0.
4. Executar testes e preservar evidências.
5. Abrir PR.
6. Revisar tecnicamente e adversarialmente.
7. Integrar somente após satisfazer regras da `main`.

Criação de commits, Issues e PRs de implementação exige autorização operacional específica.

## 12. Gate de competência — Life Learning

Avaliação independente em **compreensão, implementação, diagnóstico, arquitetura/trade-offs e comunicação**. Não usar média compensatória. Conclusão de tarefa/marco não aprova competência.

## 13. Critérios gerais de conclusão

1. Todos os marcos obrigatórios satisfazem seus gates.
2. Testes unitários, integração e adversariais têm resultados executados e preservados.
3. Pipeline válido demonstra invariantes críticos.
4. Experimento inválido identificado e diagnosticado.
5. Baseline e classificador avaliados de forma comparável.
6. Resultados reproduzidos dentro do contrato.
7. Decisões e limitações documentadas.
8. I0 e assistência posterior distinguíveis.
9. Competências avaliadas independentemente do aceite funcional.

Não há meta arbitrária de acurácia.

## 14. Decisões pendentes para iniciar

- Versões das dependências.
- Configuração inicial do gerador sintético.
- Convenções estatísticas de features.
- Contrato físico detalhado dos artefatos.
- Comandos de execução e teste.
- Organização das primeiras Issues/branches.

Registrar cada decisão quando necessária à tarefa; evitar detalhamento antecipado sem valor demonstrado.

## 15. Próxima ação

Após publicação do plano aprovado, preparar operacionalmente **T01 — Ambiente local reproduzível**, mediante autorização específica.

A aprovação do plano não autoriza implementar código, provisionar infraestrutura ou criar automaticamente Issues e branches de implementação.

---

> **Implement independently. Test deliberately. Diagnose precisely. Preserve evidence.**
