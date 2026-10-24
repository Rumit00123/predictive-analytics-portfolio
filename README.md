# Customer Loan Acceptance Prediction

**Group coursework | Predictive analytics portfolio project | R**

## Project overview
This project compares five supervised-learning approaches to predict whether a customer accepts a personal loan offer. It uses the Universal Bank dataset and explores how customer demographics, financial attributes, and account relationships inform loan-campaign targeting.

> **Collaboration note:** This analysis originated as a group class project. The portfolio owner should describe their individual contributions accurately and acknowledge collaborators. Do not interpret this repository as claiming sole authorship of the original coursework.

## Business question
Can a bank identify customers who are more likely to accept a personal loan offer, so that marketing teams can prioritize outreach?

## Data summary
- **Observations:** 5,000 customers
- **Original columns:** 14
- **Target:** `Personal.Loan` (1 = accepted, 0 = did not accept)
- **Observed acceptances:** 480 (9.6%); non-acceptances: 4,520 (90.4%)
- **Missing cells:** 0
- **Data quality note:** `Experience` contains 52 negative values in the supplied dataset. The original modeling approach leaves them unchanged; this limitation should be investigated in a revised analysis.
- The identifiers `ID` and `ZIP.Code` are excluded from the model inputs.

## Methods
The script treats `Education`, `Family`, `Personal.Loan`, `Securities.Account`, `CD.Account`, `Online`, and `CreditCard` as factors. It creates a stratified 80% training / 20% holdout split using `caret::createDataPartition` with seed `1948`.

| Model | R `caret` method | Tuning / validation |
| --- | --- | --- |
| k-Nearest Neighbors | `knn` | 10-fold CV, Kappa; centering/scaling; 10 tuning candidates |
| Naive Bayes | `naive_bayes` | 10-fold CV, Kappa; Laplace, kernel, and bandwidth adjustment grid |
| C5.0 Decision Trees | `C5.0` | 10-fold CV; rules/tree, winnowing, and trials grid; default accuracy metric |
| Artificial Neural Network | `nnet` | 5-fold CV, Kappa; network size and weight decay grid; centering/scaling |
| Radial Support Vector Machine | `svmRadial` | 10-fold CV; C/sigma grid; centering/scaling; default accuracy metric |

The code evaluates each tuned model against the holdout test set using a confusion matrix with `1` (loan accepted) designated as the positive class.

## How to run
1. Install [R](https://cran.r-project.org/) and [RStudio](https://posit.co/download/rstudio-desktop/) if needed.
2. Download or clone this repository and open its folder in RStudio.
3. Install the packages used by the script (only necessary once):

   ```r
   install.packages(c("caret", "naivebayes", "class", "C50", "NeuralNetTools", "fastDummies", "nnet", "kernlab"))
   ```

4. Set the working directory to the folder containing `UniversalBank.csv` and run `Customer_Loan_Acceptance_Prediction.R`.
5. View model tuning summaries, plots (where generated), and confusion matrices in RStudio.

## Project files
- `Customer_Loan_Acceptance_Prediction.R` — data preparation, model training and evaluation.
- `UniversalBank.csv` — project dataset; confirm permission to redistribute this copy before making the repository public.
- `README.md` — project overview and reproduction steps.

## Results and interpretation
**Model performance has not yet been reproduced or independently verified.** Run the script in RStudio and use its printed confusion matrices to report accuracy, sensitivity (recall for acceptance), specificity, precision, and Kappa. No model is described as the winner until measured results are available.

Because only 9.6% of cases are positive, a classifier that predicts every customer will reject the offer would already be 90.4% accurate. Pay particular attention to identifying actual acceptances and the business trade-off between missed offers and unnecessary outreach.

## Potential improvements
- Check and resolve negative `Experience` values with a documented rule.
- Compare precision, recall, F1 and ROC-AUC on the holdout set.
- Consider business-sensitive thresholds and campaign economics.
- Record R and package versions for stronger reproducibility.

## Skills demonstrated
R · Predictive Modeling · Data Preparation · Cross-Validation · Model Tuning · Classification · Confusion Matrices · Business Analytics
