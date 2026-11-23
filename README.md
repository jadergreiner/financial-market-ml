# Financial Market ML

[Português](README.md) | [English](README.en.md)

> Um laboratório aberto de Engenharia de Dados e Machine Learning para investigar a previsão da direção do próximo fechamento de ativos financeiros — com atenção especial à qualidade dos dados, ao vazamento de informações (*data leakage*) e à avaliação temporal.

## Por que este projeto existe?

É fácil obter métricas atraentes ao treinar modelos com séries financeiras. É muito mais difícil demonstrar que essas métricas representam uma avaliação válida. Informações do futuro, transformações ajustadas com dados de teste e divisões aleatórias inadequadas podem criar uma falsa impressão de capacidade preditiva.

O **Financial Market ML** nasce como um projeto público, incremental e educacional: construir experimentos pequenos e reproduzíveis, expor falhas deliberadas e explicar as decisões técnicas com evidências verificáveis.

Não buscamos prometer que um modelo vai acertar o mercado. Buscamos aprender **quando confiar — e quando não confiar — em um experimento de ML**.

## O que vamos investigar?

A primeira questão é simples de formular:

**Com informações disponíveis após o fechamento do pregão atual, é possível classificar se o fechamento ajustado do próximo pregão será maior que o atual?**

A tarefa inicial é uma classificação binária:

- **1:** próximo fechamento ajustado maior que o fechamento atual;
- **0:** próximo fechamento ajustado menor ou igual ao atual.

O instante de previsão é **após a disponibilização do fechamento do pregão atual**. Nenhuma feature válida pode depender de informações do pregão seguinte.

A primeira versão utilizará **uma única série sintética de preços diários OHLCV** (abertura, máxima, mínima, fechamento e volume). Dados reais e múltiplos ativos poderão ser considerados em evoluções futuras, sujeitos a validação e licença de uso.

## Objetivos de aprendizagem

- Definir e testar contratos de qualidade para séries financeiras.
- Construir features históricas como retornos, médias móveis e volatilidade sem observar o futuro.
- Separar treino, validação e teste em ordem cronológica.
- Comparar um classificador simples, como regressão logística, com uma baseline ingênua.
- Reproduzir um experimento **deliberadamente inválido**, com data leakage, para diagnosticar seu impacto.
- Registrar métricas, configuração, testes e limitações de forma reproduzível.
- Praticar a defesa de decisões de arquitetura e de avaliação de modelos.

## MVP planejado

| Etapa | Entrega esperada |
| --- | --- |
| 1. Dados sintéticos | Série OHLCV determinística e reproduzível |
| 2. Quality gate | Verificações de schema, datas, duplicidade e consistência de preços |
| 3. Features e rótulo | Indicadores disponíveis em t e direção do fechamento em t+1 |
| 4. Avaliação válida | Divisão temporal, baseline, classificador e métricas |
| 5. Experimento adversarial | Vazamento controlado, detecção e comparação |
| 6. Evidências | Testes, configurações, resultados e relatório técnico |

**Métricas candidatas:** acurácia, precisão, recall, F1, matriz de confusão e distribuição das classes. Nenhuma métrica isolada será tratada como prova de vantagem financeira.

### Princípios do experimento

1. **Sem olhar o futuro:** features e transformações respeitam o instante da previsão.
2. **Sem contaminação:** o teste final não orienta o treinamento ou a seleção de hiperparâmetros.
3. **Sem resultados inventados:** documentamos hipóteses, experimentos executados e resultados separadamente.
4. **Reprodutibilidade:** parâmetros, versões, seeds, entradas e saídas devem ser rastreáveis.
5. **Falhas também ensinam:** resultados negativos ou inconclusivos fazem parte do projeto.

## Evolução prevista: local → AWS

Começaremos com **Python e Docker em ambiente local**, priorizando baixo custo, simplicidade e compreensão dos fundamentos. Uma etapa futura poderá explorar serviços AWS, como Amazon S3 e Amazon SageMaker AI, apenas quando houver requisitos e evidências que justifiquem a evolução.

O projeto também funciona como laboratório de consolidação de conceitos da **AWS Certified AI Practitioner (AIF-C01)** e de práticas de Engenharia de Dados. O aprendizado segue um ciclo de estudar, implementar, testar, diagnosticar, defender e evidenciar.

## Pré-requisitos

- **Ambiente local:** PowerShell e `uv` 0.13.7, com acesso à rede para baixar Python 3.14 e as dependências do projeto. O `uv` pode gerenciar a instalação do Python; não é necessário instalar Python separadamente.
- **Docker:** Docker Engine em modo Linux e acesso à rede para baixar a imagem base e as dependências. A execução validada foi em `linux/amd64`; ARM64 ainda está pendente.

Se `uv` 0.13.7 ainda não estiver instalado, use o instalador oficial no PowerShell:

```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/0.13.7/install.ps1 | iex"
```

Consulte também a [documentação oficial de instalação do uv](https://docs.astral.sh/uv/getting-started/installation/).

## Instalação e verificação local

Na raiz do repositório, execute:

```powershell
uv python install 3.14
uv sync --locked --python 3.14
uv run --locked python --version
uv run --locked pytest
```

`uv sync --locked` cria `.venv` se o ambiente ainda não existir e instala o pacote e as dependências registradas em `uv.lock`. `uv run` executa os comandos nesse ambiente sem exigir ativação manual. O teste inicial verifica se o pacote pode ser importado.

## Verificação em Docker

Com Docker Engine em modo Linux, construa e execute a mesma verificação:

```powershell
docker build -t financial-market-ml:local .
docker run --rm financial-market-ml:local
```

O container usa a imagem Python 3.14.10 fixada por digest e uv 0.13.7.

## Estado atual

**Fase: fundação técnica local do Lab 01.**

O projeto já tem um pacote Python instalável e uma verificação automatizada inicial, mas isso **não representa uma implementação concluída do MVP**. Ainda não há pipeline, modelo treinado, benchmark ou resultados validados publicados.

## Como participar

Discussões e contribuições são bem-vindas, especialmente sobre:

- estratégias de validação temporal e prevenção de leakage;
- contratos de qualidade para OHLCV;
- testes adversariais e reprodutibilidade;
- formas honestas de relatar resultados e limitações.

Antes de propor mudanças maiores, abra uma **Issue** para discutir a hipótese, o problema e os critérios de aceite. Pull requests devem incluir motivação e, quando aplicável, testes e evidências. Não envie credenciais, dados privados ou datasets sem direito de redistribuição.

## Referências

- [AWS — AWS Certified AI Practitioner (AIF-C01)](https://aws.amazon.com/certification/certified-ai-practitioner/)
- [AWS — Machine learning: train, validation and test splits / leakage](https://docs.aws.amazon.com/prescriptive-guidance/latest/ml-operations-planning/splits-leakage.html)
- [scikit-learn — Common pitfalls and recommended practices](https://scikit-learn.org/stable/common_pitfalls.html)
- [scikit-learn — TimeSeriesSplit](https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.TimeSeriesSplit.html)

## Aviso

Este é um **projeto educacional e experimental**, não uma ferramenta de aconselhamento financeiro. Não oferece sinais de compra ou venda, promessas de rentabilidade ou validação de estratégias para negociação real. Séries sintéticas não representam necessariamente as condições de mercado.

---

**O propósito é aprender em público, construir com rigor e compartilhar não apenas o que funciona, mas também o que pode dar errado.**
