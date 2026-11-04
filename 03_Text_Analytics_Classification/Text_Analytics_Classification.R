library (caret)
library(NeuralNetTools)
library(nnet)
getwd()

#Q1prepare dataset
set.seed(1203)

# read data.
bank_raw <- read.csv("UniversalBank.csv")
str(bank_raw)
summary(bank_raw)
head(bank_raw)


#remove non predictive id columns
bank <- subset(bank_raw,select = -c(ID,ZIP.Code))

#convert target to factors for classification
bank$Personal.Loan <- factor(bank$Personal.Loan,levels = c(0,1))

#quiuck check
str(bank)


#train test data 70/30
train_index <- createDataPartition(bank$Personal.Loan, p=0.7, list = FALSE)
train_data <-bank [train_index,]
test_data <-bank [-train_index,]

#check class balance in train vs test
prop.table(table(train_data$Personal.Loan))
prop.table(table(test_data$Personal.Loan))



#Q2BUILD AND TUNE ANN CLASSIFIER USING CARET METHOD="NNET")
#Lookup tuneable parameters for nnet
modelLookup("nnet")

#define tuning control-kfold-cv
ctrl <- trainControl(method = "cv",
                     number = 5,
                     classProbs = TRUE,
                     summaryFunction = twoClassSummary)

#imp:caret expects positive class to be the first level for some metrics
#we will relabel 1 as yes and 0 as no to be explicit
train_data$Personal.Loan <- factor(ifelse(train_data$Personal.Loan== 1, "yes","No"))
test_data$Personal.Loan <- factor(ifelse(test_data$Personal.Loan== 1, "yes","No"))

# yes = accepted loan NO = rejected loan


#define tuning grid for ann
ann_grid <- expand.grid(size= c(3,5,7),
                        decay= c(0.1,0.3,0.5))


#trai ann model
ann_model<- train(Personal.Loan ~. ,
                  data = train_data,
                  method="nnet",
                  metric="kappa",
                  preProcess = c("center","scale"),
                  trControl = ctrl,
                  tune_grid = ann_grid,
                  maxit = 500,
                  trace= FALSE
                  )

#view tuning results and best model
ann_model
ann_model$bestTune




#evaluate on test set

test_pred_class <- predict(ann_model,newdata = test_data)
confusionMatrix(test_pred_class,test_data$Personal.Loan)

#Optional:visualize final network
plotnet(ann_model$finalModel)

#Q3 PREDICT FOR THE GIVEN NEW CUSTOMER
#NEWCUSTOMER


new_customer <- data.frame(Age = 40,
                           Experience = 10,
                           Income = 84,
                           Family = 2,
                           CCAvg = 2,
                           Education = 2,
                           Mortgage = 0,
                           Securities.Account = 0,
                           CD.Account = 0,
                           Online = 1,
                           CreditCard = 1)

#predict class (yes/no)
new_pred_class <- predict(ann_model, new_customer)

#predict probability
new_pred_prob <- predict(ann_model, new_customer,type = "prob")
new_pred_class
new_pred_prob