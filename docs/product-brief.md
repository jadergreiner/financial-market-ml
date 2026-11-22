# Financial Market ML — Product Brief

**Versão:** 0.1  
**Status:** Aprovado em 21/11/2026 (aprovação de conteúdo pelo responsável do projeto; integração ao repositório via Pull Request)  
**Metodologia:** BMad Method  
**Natureza:** Open Source · Educacional · Experimental  
**Repositório:** https://github.com/jadergreiner/financial-market-ml

---

## 1. Executive Summary

O **Financial Market ML** é um projeto open source de Engenharia de Dados e Machine Learning dedicado à investigação de modelos de classificação aplicados a séries temporais do mercado financeiro.

O projeto nasce com uma proposta educacional: construir experimentos pequenos, reproduzíveis e tecnicamente defensáveis, demonstrando como decisões sobre qualidade de dados, engenharia de atributos e validação temporal influenciam os resultados de modelos preditivos.

O primeiro laboratório investigará a previsão da direção do preço de fechamento de um ativo financeiro no próximo pregão.

Mais do que construir um modelo que apresente boas métricas, o objetivo é compreender **quais condições tornam a avaliação de um modelo confiável e quais práticas podem invalidar seus resultados**.

O desenvolvimento será incremental, iniciando em ambiente local com Python e Docker, com possibilidade de evolução para serviços AWS.

## 2. Problem Statement

Modelos de Machine Learning aplicados ao mercado financeiro enfrentam desafios que podem comprometer sua validade.

Entre os principais problemas estão:

- Dados históricos inconsistentes ou incompletos.
- Vazamento de informações futuras (*data leakage*).
- Divisões inadequadas entre treinamento, validação e teste.
- Overfitting e capacidade limitada de generalização.
- Mudanças nas distribuições dos dados ao longo do tempo.
- Resultados difíceis de reproduzir ou auditar.

Esses problemas podem fazer um modelo apresentar métricas aparentemente satisfatórias sem demonstrar capacidade preditiva confiável.

**Problema central:**

> Como desenvolver e avaliar um classificador de direção de preços financeiros garantindo qualidade dos dados, integridade temporal e resultados reproduzíveis?

## 3. Product Vision

Construir uma referência educacional aberta na qual engenheiros de dados, profissionais de Machine Learning e estudantes possam explorar, implementar e avaliar experimentos com séries financeiras.

O projeto deverá priorizar:

1. Rigor técnico.
2. Clareza arquitetural.
3. Reprodutibilidade.
4. Experimentação orientada por hipóteses.
5. Documentação de decisões e limitações.
6. Aprendizagem por implementação prática.

**Visão de longo prazo:**

Evoluir progressivamente de um laboratório local de classificação para uma plataforma experimental de Engenharia de Dados e Machine Learning, desde que cada nova capacidade seja justificada por um problema técnico e por evidências.

## 4. Target Audience

### Persona principal — Engenheiro de Dados

Profissional que deseja ampliar suas competências em Machine Learning, trabalhando com preparação de dados, contratos, pipelines, testes e reprodutibilidade.

**Necessidade:** compreender como decisões de Engenharia de Dados afetam o treinamento e a avaliação dos modelos.

### Persona secundária — Estudante de Machine Learning

Profissional ou estudante que deseja experimentar classificação supervisionada em séries temporais, explorando falhas comuns e boas práticas.

**Necessidade:** trabalhar com exemplos pequenos, verificáveis e progressivos.

### Persona complementar — Colaborador Open Source

Pessoa interessada em revisar experimentos, propor melhorias e compartilhar conhecimento sobre séries temporais, qualidade dos dados e MLOps.

## 5. Product Goals

### G1 — Qualidade dos dados

Construir um processo capaz de validar a integridade dos dados históricos antes de utilizá-los em modelos.

### G2 — Prevenção de Data Leakage

Garantir que o pipeline válido utilize exclusivamente informações disponíveis no instante da previsão.

### G3 — Avaliação confiável

Implementar avaliação temporal e comparar um classificador supervisionado com uma baseline simples.

### G4 — Reprodutibilidade

Permitir que experimentos sejam repetidos com configurações conhecidas, produzindo evidências verificáveis.

### G5 — Aprendizagem técnica

Consolidar competências de Engenharia de Dados e Machine Learning por meio de implementação independente, testes e defesa das decisões.

## 6. MVP — First Experiment

**Nome:** Lab 01 — Financial Asset Price Direction Classification

### Objetivo

Desenvolver um experimento de classificação binária para investigar se informações históricas de um ativo financeiro contêm sinais úteis para prever a direção do fechamento do próximo pregão.

### Definição do target

Após o fechamento do pregão atual, o modelo deverá estimar:

- Classe 1: o próximo preço de fechamento ajustado será maior que o atual.
- Classe 0: o próximo preço de fechamento ajustado será menor ou igual ao atual.

### Dataset

O MVP utilizará um ativo sintético com observações diárias OHLCV:

- Open
- High
- Low
- Close
- Volume

As features candidatas incluem retornos históricos, médias móveis e volatilidade.

O dataset deverá ser determinístico e reproduzível.

### Experimentos

**Experimento A — Pipeline inválido**

Introdução controlada de uma variável que contém informação futura, para observar e diagnosticar o impacto do vazamento.

**Experimento B — Pipeline válido**

Preparação de dados sem informações futuras, divisão cronológica e avaliação isolada.

O caminho inválido será utilizado exclusivamente como demonstração educacional.

### Métricas

- Accuracy
- Precision
- Recall
- F1-score
- Confusion Matrix
- Distribuição das classes
- Comparação com baseline

Nenhuma métrica isolada será considerada evidência de capacidade de gerar retornos financeiros.

## 7. MVP Scope

### Incluído

- Geração de dados sintéticos.
- Contratos de qualidade.
- Feature engineering.
- Construção do target.
- Divisão temporal de treino, validação e teste.
- Classificador inicial simples.
- Baseline de comparação.
- Experimento adversarial de leakage.
- Testes automatizados.
- Registro de métricas e evidências.

### Excluído

- Trading automatizado.
- Integração com corretoras.
- Recomendações de compra ou venda.
- Garantias de rentabilidade.
- Estratégias financeiras de produção.
- Deep Learning e modelos complexos.
- Dados financeiros em tempo real.
- Infraestrutura AWS no MVP inicial.
- Interface web ou dashboards operacionais.

## 8. Technical Principles

### Data Integrity First

Dados devem satisfazer contratos mínimos de qualidade antes de alimentar o modelo.

### Temporal Integrity

Nenhuma feature poderá utilizar informações futuras em relação ao instante de previsão.

### Reproducible by Design

Parâmetros, seeds, versões de dependências e configurações devem ser identificáveis.

### Evidence over Assumptions

Hipóteses, resultados e conclusões devem ser registrados separadamente.

### Small, Independent Experiments

Cada incremento deverá possuir objetivo, critérios de aceite e evidências próprios.

### Simplicity Before Scalability

O projeto somente introduzirá infraestrutura ou complexidade quando houver uma necessidade demonstrada.

## 9. Success Criteria

O MVP será considerado tecnicamente concluído quando:

1. Os dados sintéticos puderem ser reproduzidos.
2. O contrato de qualidade identificar os defeitos definidos nos testes.
3. As features do pipeline válido respeitarem o instante de previsão.
4. Treino, validação e teste permanecerem temporalmente isolados.
5. O classificador e a baseline forem avaliados com métricas documentadas.
6. O experimento com vazamento for reproduzido e corretamente diagnosticado.
7. Os testes automatizados forem executados com resultados registrados.
8. As decisões arquiteturais e as limitações forem explicadas tecnicamente.

**Não é critério de sucesso atingir uma acurácia mínima arbitrária.**

A ausência de capacidade preditiva relevante é um resultado experimental válido.

## 10. Risks and Assumptions

| Risco | Tratamento |
|---|---|
| Leakage temporal | Testes de invariância e auditoria de features |
| Dados sintéticos irreais | Documentar hipóteses e limitações da geração |
| Overfitting | Avaliação temporal e baseline |
| Complexidade excessiva | Limitar o MVP a um ativo e um classificador |
| Métricas enganosas | Análise de classes, comparação com baseline e limitações |
| Falta de reprodutibilidade | Configurações, seeds e rastreabilidade |

**Premissas iniciais:**

- O problema utilizará dados diários, não intradiários.
- A previsão ocorrerá após a disponibilização do fechamento do pregão atual.
- O MVP trabalhará com uma única série sintética.
- Não haverá execução de operações financeiras reais.

## 11. Technology Direction

### Fase 1 — Local

Tecnologias candidatas:

- Python
- Pandas
- NumPy
- scikit-learn
- Pytest
- Docker

A seleção definitiva de dependências e a organização dos componentes serão tratadas na especificação arquitetural.

### Fase 2 — AWS

Possível evolução para:

- Amazon S3
- Amazon SageMaker AI
- AWS Glue, caso exista necessidade demonstrada de processamento distribuído
- Amazon CloudWatch

A migração não faz parte dos critérios de conclusão do primeiro laboratório.

## 12. Community and Open Source

O Financial Market ML será desenvolvido publicamente, incentivando colaboração e revisão técnica.

A comunidade poderá contribuir por meio de:

- Issues com problemas, hipóteses e sugestões.
- Pull Requests com melhorias e evidências.
- Revisões de código e testes.
- Discussões arquiteturais.
- Novos cenários de falha e experimentos.

As contribuições deverão priorizar clareza, reprodutibilidade e justificativa técnica.

A branch principal seguirá as regras de proteção configuradas no repositório.

A política formal de licenciamento e contribuição deverá ser definida antes de aceitar contribuições externas substanciais.

## 13. Learning Governance

O projeto será utilizado como laboratório prático no contexto do Life Learning LL-ADR-002.

A implementação seguirá três etapas:

**I0 — Independent Implementation**

O estudante desenvolve a solução sem receber código pronto.

**A1 — Assisted Improvement**

A assistência técnica poderá ser utilizada posteriormente, com registro das intervenções relevantes.

**V1 — Adversarial Validation**

A implementação será submetida a testes de falha, revisão de invariantes e defesa das decisões.

A competência demonstrada será avaliada independentemente da conclusão do laboratório.

## 14. Future Opportunities

Evoluções candidatas, não compromissos do MVP:

- Utilização de séries históricas reais.
- Comparação entre diferentes ativos.
- Validação walk-forward.
- Detecção de mudanças de distribuição.
- Feature stores e pipelines de treinamento.
- Rastreamento de experimentos.
- Execução de workloads na AWS.
- Observabilidade e monitoramento de modelos.

Cada evolução deverá partir de uma hipótese e de um problema verificável.

## 15. Disclaimer

O Financial Market ML é um projeto educacional e experimental.

Não fornece aconselhamento financeiro, recomendações de investimento, estratégias validadas de negociação ou garantias de rentabilidade.

Os resultados obtidos com dados sintéticos não devem ser interpretados como evidência de desempenho em mercados reais.

---

**Princípio orientador:**

> Build models. Challenge assumptions. Trust evidence.

Construir modelos. Questionar premissas. Confiar em evidências.
