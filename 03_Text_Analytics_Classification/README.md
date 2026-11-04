# Text Analytics & Document Classification

**Tools:** R, RStudio, NLP, TF-IDF, Naive Bayes, Support Vector Machine (SVM)

## Business Problem

Organizations handling large volumes of advertising content need efficient ways to classify text and reduce manual review.

**Objective:** Develop and compare supervised machine-learning models to classify advertising documents using natural language processing (NLP) and text-based features.

## Dataset

The FarmAds dataset contains **4,143 text records** with document identifiers, advertising text, and binary classification labels (`-1` and `1`).

## Methodology

1. Cleaned text using lowercasing, punctuation removal, whitespace normalization, stopword removal, and stemming.
2. Created a Document-Term Matrix (DTM).
3. Applied TF-IDF weighting to represent document content numerically.
4. Used a stratified 80/20 train-test split.
5. Trained Naive Bayes and radial-kernel Support Vector Machine classifiers.
6. Evaluated model performance using accuracy, precision, recall, and F1 Score.

## Model Performance

| Model | Accuracy | Precision | Recall | F1 Score |
|---|---:|---:|---:|---:|
| **Naive Bayes** | **82.61%** | **82.11%** | 86.20% | **84.11%** |
| SVM | 77.90% | 70.79% | **99.77%** | 82.82% |

## Key Findings

**Naive Bayes achieved the strongest overall classification performance**, with the highest accuracy, precision, and F1 Score.

SVM achieved higher recall for documents labeled `1`, but its lower precision indicates more false-positive classifications.

These results demonstrate the trade-off between identifying more positive documents and reducing incorrect classifications.

## Business Applications

This analytical workflow could potentially support:

- Automated advertisement classification
- Text-based document categorization
- Content screening and review prioritization
- Reduced manual document processing

These are potential applications, not measured operational improvements.

## Project Files

- [R Classification Code](Text_Analytics_Classification.R)
- [FarmAds Dataset](FarmAds-1.csv)
- [Model Comparison Results](text_model_comparison.csv)

## Limitations

TF-IDF weighting and vocabulary selection were performed before the train-test split, which introduces potential information leakage. The reported test metrics should therefore be interpreted as preliminary rather than fully independent performance estimates.

The dataset uses binary labels `-1` and `1`; their precise business definitions have not been independently verified.

## Project Attribution

This project originated from collaborative academic coursework. The analysis presented here uses the project's original R-based text preprocessing and classification workflow.
