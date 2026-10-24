# Customer Loan Acceptance Prediction
# Group coursework | Refactored portfolio edition
# Purpose: Compare five classifiers for predicting personal-loan acceptance.
# Attribution: Collaborative class project; identify individual contributors in README.

# --- Dependencies -------------------------------------------------------------
library(caret)
library(naivebayes)
library(class)
library(C50)
library(NeuralNetTools)
library(fastDummies)

# --- Import and prepare -------------------------------------------------------
loan_data <- read.csv("UniversalBank.csv")
loan_data <- subset(loan_data, select = -c(ID, ZIP.Code))

categorical_fields <- c(
  "Education", "Family", "Personal.Loan", "Securities.Account",
  "CD.Account", "Online", "CreditCard"
)
loan_data[categorical_fields] <- lapply(loan_data[categorical_fields], factor)

str(loan_data)
summary(loan_data)

# --- Holdout partition --------------------------------------------------------
set.seed(1948)
train_rows <- createDataPartition(loan_data$Personal.Loan, p = 0.8, list = FALSE)
training_data <- loan_data[train_rows, ]
testing_data <- loan_data[-train_rows, ]

for (data_slice in list(loan_data, training_data, testing_data)) {
  print(proportions(table(data_slice$Personal.Loan)))
}

# --- Model configuration ------------------------------------------------------
ten_fold_cv <- trainControl(method = "cv", number = 10)
selected_predictors <- Personal.Loan ~ Age + Experience + Income + Family +
  CCAvg + Education + Mortgage + Securities.Account + CD.Account +
  Online + CreditCard

# Helper keeps the same positive-class interpretation for all holdout tests.
show_test_performance <- function(fitted_model) {
  holdout_predictions <- predict(fitted_model, testing_data)
  print(confusionMatrix(holdout_predictions, testing_data$Personal.Loan,
                        positive = "1"))
  invisible(holdout_predictions)
}

# --- 1. k-Nearest Neighbors ---------------------------------------------------
knn_fit <- train(
  Personal.Loan ~ ., data = training_data,
  method = "knn", metric = "Kappa",
  preProcess = c("center", "scale"),
  tuneLength = 10, trControl = ten_fold_cv
)
print(knn_fit)
plot(knn_fit)
knn_predictions <- show_test_performance(knn_fit)

# --- 2. Naive Bayes -----------------------------------------------------------
naive_bayes_options <- expand.grid(
  laplace = c(0, 1),
  usekernel = c(TRUE, FALSE),
  adjust = c(1, 1.5, 2)
)
nb_fit <- train(
  Personal.Loan ~ ., data = training_data,
  method = "naive_bayes", metric = "Kappa",
  tuneGrid = naive_bayes_options,
  trControl = ten_fold_cv
)
print(nb_fit)
plot(nb_fit)
nb_predictions <- show_test_performance(nb_fit)

# --- 3. C5.0 Decision Tree ----------------------------------------------------
c50_options <- expand.grid(
  model = c("rules", "tree"),
  winnow = c(TRUE, FALSE),
  trials = seq(1, 9, 2)
)
tree_fit <- train(
  selected_predictors, data = training_data,
  method = "C5.0", tuneGrid = c50_options,
  trControl = ten_fold_cv
)
print(tree_fit)
tree_predictions <- show_test_performance(tree_fit)

# --- 4. Artificial Neural Network ---------------------------------------------
network_options <- expand.grid(
  size = seq(5, 15, 5),
  decay = seq(0.1, 0.7, 0.2)
)
network_fit <- train(
  selected_predictors, data = training_data,
  method = "nnet", metric = "Kappa", maxit = 500,
  preProcess = c("center", "scale"), trace = FALSE,
  tuneGrid = network_options,
  trControl = trainControl(method = "cv", number = 5)
)
print(network_fit)
network_predictions <- show_test_performance(network_fit)

# --- 5. Radial Support Vector Machine ----------------------------------------
svm_options <- expand.grid(
  C = c(0.25, 0.5, 1, 2),
  sigma = c(0.01, 0.025, 0.05, 0.1)
)
svm_fit <- train(
  selected_predictors, data = training_data,
  method = "svmRadial",
  preProcess = c("center", "scale"),
  tuneGrid = svm_options,
  trControl = ten_fold_cv
)
print(svm_fit)
svm_predictions <- show_test_performance(svm_fit)
