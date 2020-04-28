#logit model
rm(list = ls())
frDf <- read.table('frDf.csv',header = TRUE, sep = ",")
#library(ggplot2)
#ggplot(frDf, aes(df)) + geom_bar(aes(fill = df)) + theme_bw()
#make test dataset and train dataset
library(caTools)
set.seed(545)
split <- sample.split(frDf, SplitRatio = 0.8, group = NULL)
first_test <- subset(frDf, split == FALSE)
first_train <- subset(frDf, split == TRUE)
#now df is a category variable
first_train$df <- factor(first_train$df)
#fit logistic regression model (logit)
#independent variables -- finantial, nonfinantial and fr ratings, dependent (output) variable -- df
glm_mod_logit<- glm(formula = df ~ finr + nfinr + fr, family = binomial(link = "logit"), data = first_train)

library(pscl)
pR2(glm_mod_logit)

summary(glm_mod_logit)

#predict values using logit model
first_train$predicted <- predict(glm_mod_logit, type = 'response', newdata = first_train)
PseudoR2(glm_mod_logit)

#Creation of a set of classes 0 and 1 for the train dataset:
df_pred = ifelse(first_train$predicted > 0.5, 1, 0)

#get information about proportion of true and false results
print(table(first_train$df, first_train$predicted > 0.5))
rate_error <- round(mean(df_pred != first_test$df), 4)
print(paste("rate_error: ", rate_error))

library(caret)
#obtain the results of the model: Sensitivity, Specificity, Accuracy etc (positive = "0"!)
print(caret::confusionMatrix(first_train$df, factor(df_pred), positive = "0"))

library(InformationValue)
#visualisation of ROC curve
plotROC(first_train$df, first_train$predicted)
#culculate AUROC (The Area Under an ROC Curve)
#measure of the discriminatory power of a logistic model, the area under the ROC curve 
auroc <- round(AUROC(first_train$df, first_train$predicted), 4)
#culculate Gini coefficient (accuracy ratio). A higher Gini means more predictive power
gini <- 2*auroc - 1
print(paste("auroc: ", auroc, "; gini: ", gini, ".", sep = ""))

# make a normal QQ plot of predicted values
qqnorm(first_train$predicted, pch = 1, frame = FALSE)

#make the same operations to check the model on the test dataset
first_test$df <- factor(first_test$df)
first_test$predicted <- predict(glm_mod_logit, type = 'response', newdata = first_test)

#Creation of a set of classes 0 and 1 for the test dataset:
df_pred_test = ifelse(first_test$predicted > 0.5, 1, 0)

#get information about proportion of true and false results
print(table(first_test$df, first_test$predicted > 0.5))
#obtain the results of the model: Sensitivity, Specificity, Accuracy etc (positive = "0"!)
library(caret)
print(caret::confusionMatrix(first_test$df, factor(df_pred_test), positive = "0"))
plotROC(first_train$df, first_train$predicted)
#culculate AUROC (The Area Under an ROC Curve)
#measure of the discriminatory power of a logistic model, the area under the ROC curve 
auroc <- round(AUROC(first_test$df, first_test$predicted), 4)
#culculate Gini coefficient (accuracy ratio). A higher Gini means more predictive power
gini <- 2*auroc - 1
print(paste("auroc: ", auroc, "; gini: ", gini, ".", sep = ""))
