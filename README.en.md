# Financial Market ML

[Português](README.md) | [English](README.en.md)

> An open Data Engineering and Machine Learning lab exploring next-day financial asset closing-price direction prediction — with an emphasis on data quality, data leakage prevention, and time-aware evaluation.

## Why this project exists

It is easy to produce attractive model metrics from financial time series. It is much harder to demonstrate that those metrics come from a valid experiment. Future information, transformations fitted on test data, and inappropriate random splits can create a false sense of predictive ability.

**Financial Market ML** is a public, incremental, educational project: build small and reproducible experiments, deliberately expose failure modes, and explain technical decisions with verifiable evidence.

We are not promising to beat the market. We are learning **when an ML experiment deserves trust — and when it does not**.

## The question we want to explore

**Using information available after today's market close, can we classify whether the next trading day's adjusted closing price will be higher?**

The initial task is binary classification:

- **1:** next adjusted closing price is higher than the current one;
- **0:** next adjusted closing price is lower than or equal to the current one.

The prediction timestamp is **after the current trading day's closing data becomes available**. No valid feature may depend on the following trading day.

The first version will use **a single synthetic daily OHLCV series** (open, high, low, close, volume). Real market data and multiple assets may be explored later, subject to validation and usage licenses.

## Learning goals

- Define and test data-quality contracts for financial time series.
- Engineer historical features such as returns, moving averages, and volatility without using future observations.
- Create chronological train, validation, and test splits.
- Compare a simple classifier, such as logistic regression, against a naive baseline.
- Reproduce a **deliberately invalid** experiment with data leakage and diagnose its impact.
- Record metrics, configurations, tests, and limitations for reproducibility.
- Practice defending modeling and architecture decisions with evidence.

## Planned MVP

| Stage | Expected deliverable |
| --- | --- |
| 1. Synthetic data | Deterministic, reproducible OHLCV series |
| 2. Quality gate | Schema, dates, duplicate and price-consistency checks |
| 3. Features and target | Indicators available at t and closing direction at t+1 |
| 4. Valid evaluation | Time-based split, baseline, classifier, and metrics |
| 5. Adversarial experiment | Controlled leakage, detection, and comparison |
| 6. Evidence | Tests, configurations, results, and technical report |

**Candidate metrics:** accuracy, precision, recall, F1, confusion matrix, and class distribution. No single metric will be treated as evidence of a trading edge.

### Experimental principles

1. **No future peeking:** features and transformations respect the prediction timestamp.
2. **No contamination:** the final test set does not drive training or hyperparameter selection.
3. **No fabricated results:** hypotheses, executed experiments, and observations are documented separately.
4. **Reproducibility:** track parameters, versions, random seeds, inputs, and outputs.
5. **Failures are useful evidence:** negative or inconclusive outcomes belong in the project.

## Roadmap: local → AWS

We will start with **Python and Docker locally**, focusing on low cost, simplicity, and a solid understanding of fundamentals. A future phase may explore AWS services such as Amazon S3 and Amazon SageMaker AI, provided there is a clear technical reason to do so.

The project is also a hands-on way to consolidate concepts from the **AWS Certified AI Practitioner (AIF-C01)** certification and Data Engineering practices. The learning cycle is study, implement, test, diagnose, defend, and provide evidence.

## Current status

**Phase: discovery and MVP specification.**

This README describes the intended direction, **not a finished implementation**. No pipeline, trained model, benchmark, or validated experimental results are published yet. Code, runnable instructions, tests, and evidence will be added as development progresses.

## Contributing

Discussions and contributions are welcome, especially around:

- time-aware validation and leakage prevention;
- OHLCV data-quality contracts;
- adversarial tests and reproducibility;
- transparent reporting of results and limitations.

Before larger changes, open an **Issue** to discuss the hypothesis, problem, and acceptance criteria. Pull requests should explain their motivation and include tests and evidence when applicable. Do not submit credentials, private data, or datasets without redistribution rights.

## References

- [AWS — AWS Certified AI Practitioner (AIF-C01)](https://aws.amazon.com/certification/certified-ai-practitioner/)
- [AWS — Machine learning: train, validation and test splits / leakage](https://docs.aws.amazon.com/prescriptive-guidance/latest/ml-operations-planning/splits-leakage.html)
- [scikit-learn — Common pitfalls and recommended practices](https://scikit-learn.org/stable/common_pitfalls.html)
- [scikit-learn — TimeSeriesSplit](https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.TimeSeriesSplit.html)

## Disclaimer

This is an **educational and experimental project**, not financial advice. It does not provide buy or sell signals, return guarantees, or validation of strategies for live trading. Synthetic series may not reflect actual market conditions.

---

**The goal is to learn in public, build rigorously, and share not only what works but also what can go wrong.**
