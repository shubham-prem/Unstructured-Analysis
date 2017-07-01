# Classification Tree with rpart
library(rpart)
library(caret)
library(e1071)
mydata <- read.csv("binary.csv")
## view the first few rows of the data

trainIndex <- createDataPartition(y=mydata$admit, p=.9, list=FALSE, times=1)

head(trainIndex)

myDataTrain <- mydata[trainIndex,]
myDataTest <- mydata[-trainIndex,]

#To get the basic derivative statistics of data
summary(myDataTrain)

#to get the standard deviations of data
sapply(myDataTrain, sd)

attach(myDataTrain)

## two-way contingency table of categorical outcome and predictors
## we want to make sure there are not 0 cells
xtabs(~ admit + rank, data = myDataTrain)

#tree needs a categorical output variable

myDataTrain$rank <- factor(myDataTrain$rank)
myDataTrain$admit <- factor(myDataTrain$admit)
levels(myDataTest) <- levels(myDataTrain)

fit<- svm(admit ~ gre + gpa + rank, data = myDataTrain)



myDataTest$rank <- factor(myDataTest$rank)

tta=table(predict(fit, myDataTest),myDataTest$admit)



tta

acc=sum(diag(tta))/sum(tta)
acc

