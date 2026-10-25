# Customer Loan Acceptance Prediction

**R | Supervised Machine Learning | Collaborative Academic Project**

## Business Problem

Can customer demographic information and banking behavior help predict which customers are most likely to accept a personal loan offer?

This project evaluates five supervised machine-learning algorithms to identify potential loan customers and support more targeted banking marketing strategies.

## Dataset

The Universal Bank dataset contains:
- **5,000 customer records**
- **14 original variables**
- **480 customers (9.6%)** who accepted a personal loan offer

The target variable is `Personal.Loan`. Customer IDs and ZIP codes were excluded from modeling.

## Machine Learning Models

Five classification algorithms were developed and compared:

1. k-Nearest Neighbors (kNN)
2. Naive Bayes
3. C5.0 Decision Tree
4. Artificial Neural Network (ANN)
5. Support Vector Machine (SVM)

## Methodology

- Data preparation and categorical variable conversion
- Stratified 80/20 training and testing split
- Cross-validation and hyperparameter tuning
- Model evaluation using Accuracy, Kappa, Precision, Recall, and F1 Score

## Model Performance

| Model | Accuracy | Kappa | F1 Score |
|---|---:|---:|---:|
| **Decision Tree** | **98.6%** | **0.918** | **92.55%** |
| Neural Network | 98.1% | 0.881 | 89.14% |
| SVM | 97.5% | 0.840 | 85.38% |
| kNN | 94.7% | 0.614 | 63.95% |
| Naive Bayes | 86.3% | 0.342 | 41.70% |

## Key Findings

The **C5.0 Decision Tree** achieved the strongest overall performance among the five evaluated models.

- Test accuracy: **98.6%**
- Recall: **90.63%**
- F1 Score: **92.55%**
- Kappa: **0.918**

The Neural Network achieved higher precision, but the Decision Tree demonstrated a better overall balance of classification metrics.

These findings suggest that predictive modeling could help banks prioritize customers for personal loan marketing campaigns. The results are based on an offline academic analysis, not a deployed model.

## Project Files

- [R Modeling Code](Customer_Loan_Acceptance_Prediction.R)
- [Model Results](RESULTS.md)
- [Performance Comparison CSV](model_comparison_results.csv)
- [Universal Bank Dataset](UniversalBank.csv)

## Tools and Technologies

**Language:** R

**Environment:** RStudio

**Libraries:** caret, naivebayes, C50, nnet, kernlab

**Techniques:** Predictive Modeling, Classification, Cross-Validation, Hyperparameter Tuning, Model Evaluation

## Limitations

The dataset contains 52 negative experience values retained from the original coursework. Loan acceptance is relatively uncommon, making class imbalance an important consideration. Additional validation would be necessary before operational deployment.

## Project Attribution

This project originated from collaborative academic coursework. The repository presents the shared analytical work and its reproducible modeling workflow.
