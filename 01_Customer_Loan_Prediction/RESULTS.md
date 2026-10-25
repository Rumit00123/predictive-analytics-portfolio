# Model results — Customer Loan Acceptance Prediction

These metrics were generated in RStudio from the provided project script using the Universal Bank dataset. They describe performance on the holdout test set, not live deployment performance.

## Test-set model comparison

| Model | Accuracy | Kappa | Precision | Recall | F1 score |
|---|---:|---:|---:|---:|---:|
| Decision Tree | 98.6% | 0.918 | 94.6% | 90.6% | 92.6% |
| Neural Network | 98.1% | 0.881 | 98.7% | 81.2% | 89.1% |
| SVM | 97.5% | 0.840 | 97.3% | 76.0% | 85.4% |
| kNN | 94.7% | 0.614 | 92.2% | 49.0% | 63.9% |
| Naive Bayes | 86.3% | 0.342 | 35.3% | 51.0% | 41.7% |

## Findings

- **C5.0 Decision Tree** ranked first by Kappa (0.918), test accuracy (98.6%), F1 (92.6%) and recall (90.6%). It is the strongest all-round performer in this experiment.
- **Neural Network** achieved the highest precision (98.7%) but lower recall (81.2%), so it identified fewer of the actual acceptances.
- **SVM** also performed well (F1 85.4%), while **kNN** and **Naive Bayes** performed less well on the reported metrics.
- Only **9.6%** of the original 5,000 customer records are positive. Predicting rejection for everyone would already achieve **90.4% accuracy** on the full dataset, which illustrates why accuracy alone is insufficient.

## Business interpretation

A bank could investigate using the Decision Tree to rank customers for a marketing campaign, while balancing missed likely acceptances against the cost of unnecessary outreach. These results do **not** establish incremental conversion lift or profitability; that requires prospective testing and campaign cost data.

## Reproducibility and limitations

- Input dataset: `UniversalBank.csv`; target: `Personal.Loan` (`1` = accepted).
- `ID` and `ZIP.Code` were removed; models used an 80/20 stratified train/test split with seed 1948.
- 10-fold CV was used for kNN, Naive Bayes, Decision Tree and SVM; ANN used 5-fold CV.
- Parameter selection for kNN, Naive Bayes and ANN used Kappa; Decision Tree and SVM used caret's default Accuracy metric.
- The source dataset contains 52 negative `Experience` values, which were not modified in this analysis.
- Model details such as exact tuning choices and package versions should be recorded for full reproducibility.
- Results are supplied from one user-executed run and have not been independently rerun in this environment.

Raw values are available in [`model_comparison_results.csv`](model_comparison_results.csv).
