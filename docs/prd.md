# Financial Market ML — Product Requirements Document (PRD)

**Versão:** 0.1  
**Status:** Aprovado pelo responsável do projeto (aprovação em conversa; integração via Pull Request)  
**Metodologia:** BMad Method  
**Referência:** [Product Brief v0.1](product-brief.md)  
**Projeto:** [Financial Market ML](https://github.com/jadergreiner/financial-market-ml)  
**MVP:** Lab 01 — Financial Asset Price Direction Classification

---

## 1. Objetivo do documento

Definir os requisitos do primeiro laboratório do Financial Market ML, estabelecendo funcionalidades, contratos de dados, restrições, critérios de aceite e evidências necessárias para avaliar sua conclusão.

O laboratório investigará a classificação da direção do fechamento do próximo pregão a partir de informações históricas de um ativo financeiro sintético. O foco principal não é maximizar a precisão preditiva, mas demonstrar a validade metodológica do experimento.

## 2. Problema e hipóteses

**Problema:** modelos aplicados a séries financeiras podem produzir métricas enganosas quando utilizam informações futuras, dados inconsistentes ou procedimentos inadequados de avaliação.

- **H1 — Data Leakage:** uma feature que contém informações futuras pode produzir avaliação artificialmente otimista.
- **H2 — Integridade temporal:** divisão cronológica e transformações ajustadas somente com dados de treinamento possibilitam avaliação metodologicamente válida, mas não garantem generalização futura.
- **H3 — Qualidade dos dados:** contratos explícitos detectam problemas antes que contaminem os experimentos.
- **H4 — Reprodutibilidade:** dados, parâmetros, sementes e ambientes equivalentes produzem resultados reproduzíveis dentro de tolerâncias documentadas.

A ausência de diferença significativa entre experimentos, ou de capacidade preditiva relevante, é resultado válido e deve ser documentada.

## 3. Definição da tarefa de Machine Learning

- **Tipo:** aprendizado supervisionado, classificação binária.
- **Unidade de observação:** um ativo financeiro em um pregão; o MVP usa somente um ativo sintético.
- **Instante de previsão:** após a disponibilização do fechamento oficial do pregão atual, período `t`.
- **Target:** `target_up = 1` se o fechamento ajustado em `t+1` for maior que em `t`; caso contrário, `target_up = 0`.

O rótulo pode ser calculado retrospectivamente para o treinamento, mas não pode entrar como feature. A última observação sem preço futuro disponível não recebe rótulo e não participa do treinamento ou avaliação supervisionada.

## 4. Escopo do MVP

**Incluído:** dataset sintético determinístico, contrato de qualidade OHLCV, features históricas, target, divisão temporal de treino/validação/teste, baseline, classificador simples, experimento deliberadamente inválido com leakage, comparação, testes automatizados e registro de evidências.

**Excluído:** trading automatizado, recomendação de investimento, dados em tempo real, corretoras, backtesting de estratégia de negociação, Deep Learning, otimização avançada, cloud obrigatória e interface web.

## 5. Requisitos funcionais

### RF-01 — Geração de dados sintéticos

O sistema deverá gerar série OHLCV reproduzível com identificação de ativo, calendário de pregões consistente, datas ordenáveis e únicas por ativo, preços e volumes válidos, seed e número de registros configuráveis e premissas de geração documentadas.

- **CA-01.1:** mesmos parâmetros e seed produzem os mesmos dados.
- **CA-01.2:** cada par `ticker + date` é único.
- **CA-01.3:** dados gerados satisfazem o contrato OHLCV.
- **CA-01.4:** dataset pode ser inspecionado independentemente do treinamento.

### RF-02 — Data Quality Gate

O sistema deverá verificar integridade antes da preparação das features.

**Regras:** `date` e `ticker` não nulos; preços positivos e finitos; volume não negativo e finito; `high >= low`; `high >= max(open, close)`; `low <= min(open, close)`; unicidade de `ticker + date`; identificação de schema inesperado.

- **CA-02.1:** registros inválidos são identificados.
- **CA-02.2:** a saída informa quais regras foram violadas.
- **CA-02.3:** dados inválidos não seguem silenciosamente para treinamento.
- **CA-02.4:** decisões de rejeição ou tratamento são rastreáveis.

### RF-03 — Feature Engineering

O sistema deverá construir features usando somente informações disponíveis até o instante de previsão `t`.

**Candidatas:** retorno diário, médias móveis de 5 e 20 pregões, volatilidade histórica de 20 pregões e volume atual.

- **CA-03.1:** features utilizam somente dados conhecidos até `t`.
- **CA-03.2:** observações sem histórico suficiente são tratadas explicitamente.
- **CA-03.3:** modificar registros futuros não altera features de datas passadas.
- **CA-03.4:** campos usados para construir target não entram indevidamente nas features.
- **CA-03.5:** períodos de cálculo e convenções estatísticas são documentados.

### RF-04 — Divisão temporal

Separar os dados cronologicamente em treinamento, validação e teste. Proporções iniciais **70%/15%/15%**, ajustáveis com justificativa.

- **CA-04.1:** nenhuma observação compartilhada entre conjuntos.
- **CA-04.2:** datas de treinamento precedem as de validação.
- **CA-04.3:** datas de validação precedem as de teste.
- **CA-04.4:** rótulos e janelas futuras não contaminam fronteiras.
- **CA-04.5:** transformações que aprendem parâmetros são ajustadas somente no treinamento.
- **CA-04.6:** teste permanece reservado até a avaliação final.

### RF-05 — Classificador e baseline

Treinar um classificador supervisionado simples (candidato: regressão logística) e compará-lo com baseline que prevê a classe majoritária do treinamento.

- **CA-05.1:** classificador usa somente features autorizadas.
- **CA-05.2:** treinamento não ajusta parâmetros a partir de validação ou teste.
- **CA-05.3:** baseline não consulta rótulos de validação/teste para selecionar classe.
- **CA-05.4:** resultados do classificador e baseline são comparáveis.
- **CA-05.5:** configurações do experimento são registradas.

### RF-06 — Experimento adversarial de Data Leakage

Reproduzir cenário deliberadamente inválido: uma cópia do experimento inclui `future_return_1d` como feature, informação indisponível em `t`.

- **CA-06.1:** cenário inválido é identificado como demonstração educacional.
- **CA-06.2:** pipeline válido rejeita features futuras proibidas.
- **CA-06.3:** comparação usa condições equivalentes exceto pelo defeito controlado.
- **CA-06.4:** relatório registra diferenças observadas.
- **CA-06.5:** diagnóstico identifica a causa da invalidação, independentemente das métricas.

### RF-07 — Avaliação

Gerar **accuracy, precision, recall, F1-score, confusion matrix** e distribuição das classes, comparando baseline e classificador.

- **CA-07.1:** rótulos corretamente alinhados às predições.
- **CA-07.2:** avaliação compara baseline e classificador.
- **CA-07.3:** classes ausentes ou divisões inadequadas são diagnosticadas.
- **CA-07.4:** métricas incluem limitações.
- **CA-07.5:** nenhuma métrica é apresentada como prova automática de rentabilidade.

### RF-08 — Evidências

Cada execução deve disponibilizar identificador, configuração/seed, versões de ambiente/dependências, identificação ou hash dos dados, tamanhos e fronteiras dos conjuntos, features utilizadas, modelo/baseline, métricas, resultados dos testes e limitações.

- **CA-08.1:** execução tem identificação rastreável.
- **CA-08.2:** evidências identificam dados e configurações.
- **CA-08.3:** distingue sucesso operacional de validade metodológica.
- **CA-08.4:** resultados negativos/inconclusivos são preservados.
- **CA-08.5:** não declara resultados de testes não executados.

## 6. Contrato lógico dos dados

### Dataset de mercado

| Campo | Tipo lógico | Obrigatório |
| --- | --- | --- |
| `ticker` | String | Sim |
| `date` | Date | Sim |
| `open` | Decimal/Float | Sim |
| `high` | Decimal/Float | Sim |
| `low` | Decimal/Float | Sim |
| `close` | Decimal/Float | Sim |
| `volume` | Number | Sim |

No MVP sintético, OHLC pertence a uma série ajustada coerente; não há tratamento de eventos societários reais. Tipos físicos e formato de armazenamento serão definidos na arquitetura.

### Dataset preparado

| Campo | Papel |
| --- | --- |
| `ticker` | Identificação |
| `date` | Ordenação temporal |
| `return_1d` | Feature candidata |
| `sma_5` | Feature candidata |
| `sma_20` | Feature candidata |
| `volatility_20` | Feature candidata |
| `volume` | Feature candidata |
| `target_up` | Target, nunca feature |

A existência de uma coluna não autoriza automaticamente seu uso no modelo.

## 7. Requisitos não funcionais

- **RNF-01 — Reprodutibilidade:** resultados equivalentes no mesmo ambiente controlado, conforme tolerâncias documentadas.
- **RNF-02 — Portabilidade:** execução local sem AWS obrigatória.
- **RNF-03 — Testabilidade:** qualidade, temporalidade e avaliação testáveis independentemente.
- **RNF-04 — Observabilidade:** falhas com indicação de etapa e causa.
- **RNF-05 — Simplicidade:** não introduzir infraestrutura distribuída desnecessária.
- **RNF-06 — Segurança:** sem credenciais de corretoras, dados financeiros pessoais ou datasets proprietários sem autorização.
- **RNF-07 — Manutenibilidade:** incrementos sem reformulação completa.

## 8. Testes adversariais obrigatórios

| ID | Cenário | Resultado esperado |
| --- | --- | --- |
| V1-01 | Duplicação de `ticker + date` | Identificação/rejeição |
| V1-02 | `high < low` | Falha de qualidade |
| V1-03 | Volume negativo | Falha de qualidade |
| V1-04 | Preço nulo, negativo ou não finito | Falha de qualidade |
| V1-05 | Feature que usa observações futuras | Violação temporal detectada |
| V1-06 | `future_return_1d` como feature válida | Bloqueio de leakage |
| V1-07 | Transformação ajustada no teste | Violação de isolamento |
| V1-08 | Rótulo de treino usando preço da validação | Violação de fronteira |
| V1-09 | Alteração de dados futuros | Features passadas não mudam |
| V1-10 | Reexecução com seed fixa | Resultados reproduzíveis |
| V1-11 | Classificador prevê uma única classe | Diagnóstico das métricas |
| V1-12 | Última observação sem preço futuro | Sem rótulo artificial |

A evidência adversarial deve demonstrar a falha ou a proteção, não somente a execução do código.

## 9. Histórias de usuário

### US-01 — Synthetic Market Data
**Como** engenheiro de dados, **quero** gerar série financeira sintética, **para** realizar experimentos reproduzíveis sem APIs externas.  
**Dependências:** nenhuma. **Aceite:** CA-01.1–CA-01.4.

### US-02 — Data Quality Gate
**Como** engenheiro de dados, **quero** validar a integridade, **para** impedir que dados inválidos contaminem etapas posteriores.  
**Dependência:** US-01. **Aceite:** CA-02.1–CA-02.4.

### US-03 — Temporal Feature Engineering
**Como** engenheiro de ML, **quero** produzir indicadores históricos e rótulos alinhados, **para** impedir uso indevido do futuro.  
**Dependência:** US-02. **Aceite:** RF-03 e RF-04.

### US-04 — Baseline Classification
**Como** pesquisador de ML, **quero** treinar e avaliar classificador simples, **para** estabelecer referência metodologicamente válida.  
**Dependência:** US-03. **Aceite:** RF-05 e RF-07.

### US-05 — Leakage Experiment
**Como** engenheiro de dados, **quero** reproduzir e diagnosticar vazamento futuro, **para** compreender seu efeito sobre avaliação.  
**Dependência:** US-04. **Aceite:** CA-06.1–CA-06.5.

### US-06 — Experiment Evidence
**Como** revisor, **quero** consultar configurações, métricas, testes e diagnósticos, **para** reproduzir e auditar o experimento.  
**Dependências:** US-01–US-05. **Aceite:** CA-08.1–CA-08.5.

A rastreabilidade mínima começa na US-01, mesmo que consolidada na US-06.

## 10. Critérios de saída do MVP

1. Histórias obrigatórias cumprem seus critérios de aceite.
2. Qualidade dos dados possui testes executados.
3. Pipeline válido satisfaz invariantes temporais.
4. Treino, validação e teste estão isolados.
5. Classificador é comparado à baseline.
6. Cenário adversarial de leakage é reproduzido e diagnosticado.
7. Evidências permitem auditoria e reprodução.
8. Decisões e limitações são documentadas.

Aceite funcional **não equivale à aprovação de competências**. Não há meta arbitrária de acurácia.

## 11. Governança Life Learning — LL-ADR-002

- **I0 — Independente:** estudante implementa sem receber código de solução.
- **A1 — Assistência declarada:** intervenções relevantes são identificadas.
- **V1 — Adversarial:** testes de falha, invariantes e defesa de decisões.
- **R1 — Retenção:** recuperação ativa e Recall.

Avaliação multidimensional e independente: compreensão, implementação, diagnóstico, arquitetura/trade-offs e comunicação.

## 12. Decisões pendentes da arquitetura

- Estrutura modular e organização do repositório.
- Contratos físicos e interfaces entre componentes.
- Gerador sintético e convenções de indicadores.
- Política exata para rótulos e fronteiras temporais.
- Persistência de evidências.
- Dependências e versões do ambiente.
- Comandos de execução e teste.

## 13. Roadmap futuro

**Fase 1 — MVP local:** Python, preparação, classificação, testes e evidências.  
**Fase 2 — Avaliação ampliada:** dados reais, mais ativos e validação walk-forward conforme revisão de escopo.  
**Fase 3 — AWS:** avaliar armazenamento, processamento e treinamento gerenciados somente quando tecnicamente justificados.

## 14. Aviso de finalidade

Projeto educacional e experimental. Não fornece recomendações de investimentos, garantia de precisão ou rentabilidade. Métricas em dados sintéticos não evidenciam desempenho em mercado real.

---

> **Build models. Challenge assumptions. Trust evidence.**
