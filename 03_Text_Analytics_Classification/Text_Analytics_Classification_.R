
############################################################
# Text Analytics and Document Classification
# Dataset: FarmAds-1.csv
# Models: Naive Bayes and Support Vector Machine
############################################################
install.packages(c(
  "tm", "SnowballC", "caret",
  "naivebayes", "class", "kernlab"
))
# 1. Libraries
install.packages(c(
  "tm", "SnowballC", "caret",
  "naivebayes", "class", "kernlab"
))


library(tm)
library(SnowballC)
library(caret)
library(naivebayes)
library(class)




# 2. Data Loading
ads <- read.csv("FarmAds-1.csv",
                stringsAsFactors = FALSE)

ads$label <- factor(ads$label)

str(ads)
table(ads$label)

# 3. Text Preprocessing
corpus <- VCorpus(VectorSource(ads$text))

corpus <- tm_map(corpus, stripWhitespace)
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, stemDocument)
corpus <- tm_map(corpus, removeWords, stopwords("english"))

# 4. Document-Term Matrix and TF-IDF
dtm <- DocumentTermMatrix(corpus)
dtm <- removeSparseTerms(dtm, 0.99)

tfidf <- weightTfIdf(dtm)

model_data <- as.data.frame(as.matrix(tfidf))
model_data$label <- ads$label

# 5. Train-Test Split
set.seed(1947)

idx <- createDataPartition(
  model_data$label,
  p = 0.8,
  list = FALSE
)

train_data <- model_data[idx, ]
test_data <- model_data[-idx, ]

print(prop.table(table(train_data$label)))
print(prop.table(table(test_data$label)))

# 6. Naive Bayes
nb_grid <- expand.grid(
  laplace = c(0, 1),
  usekernel = c(TRUE, FALSE),
  adjust = c(1, 1.5, 2)
)

nb_model <- train(
  label ~ .,
  data = train_data,
  method = "naive_bayes",
  tuneGrid = nb_grid,
  trControl = trainControl(method = "cv", number = 3)
)

print(nb_model)

nb_pred <- predict(nb_model, test_data)

nb_result <- confusionMatrix(
  nb_pred, test_data$label, positive = "1"
)

print(nb_result)

# 7. Support Vector Machine
svm_grid <- expand.grid(
  C = c(0.5, 1),
  sigma = c(0.01, 0.05)
)

svm_model <- train(
  label ~ .,
  data = train_data,
  method = "svmRadial",
  preProcess = c("center", "scale"),
  tuneGrid = svm_grid,
  trControl = trainControl(method = "cv", number = 3)
)

print(svm_model)

svm_pred <- predict(svm_model, test_data)

svm_result <- confusionMatrix(
  svm_pred, test_data$label, positive = "1"
)

print(svm_result)

# 8. Model Performance Comparison
results <- data.frame(
  Model = c("Naive Bayes", "SVM"),
  Accuracy = c(
    nb_result$overall["Accuracy"],
    svm_result$overall["Accuracy"]
  ),
  Precision = c(
    nb_result$byClass["Precision"],
    svm_result$byClass["Precision"]
  ),
  Recall = c(
    nb_result$byClass["Recall"],
    svm_result$byClass["Recall"]
  ),
  F1_Score = c(
    nb_result$byClass["F1"],
    svm_result$byClass["F1"]
  )
)

print(results)

write.csv(
  results,
  "text_model_comparison.csv",
  row.names = FALSE
)

cat("\nTEXT ANALYTICS COMPLETED!\n")

