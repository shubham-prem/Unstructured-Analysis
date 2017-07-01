# Classification Tree with rpart
library(rpart)
library(caret)
library(adabag)
library(rpart.plot)
mydata <- read.csv("binary.csv")
## view the first few rows of the data

trainIndex <- createDataPartition(y=mydata$admit, p=.8, list=FALSE, times=1)

head(trainIndex)

myDataTrain <- mydata[trainIndex,]
myDataTest <- mydata[-trainIndex,]

#To get the basic derivatives of data
summary(myDataTrain)

#to get the standard deviations of data
sapply(myDataTrain, sd)

attach(myDataTrain)

## two-way contingency table of categorical outcome and predictors
## we want to make sure there are not 0 cells
xtabs(~ admit + rank, data = myDataTrain)

#Logistic regression needs a categorical output variable

myDataTrain$rank <- factor(myDataTrain$rank)
myDataTrain$admit <- factor(myDataTrain$admit)
levels(myDataTest) <- levels(myDataTrain)
myDataTest$admit <- factor(myDataTest$admit)
myDataTest$rank <- factor(myDataTest$rank)

#fitRandomForest <- randomForest(admit ~ gre + gpa + rank,  data=myDataTrain, ntree=400)
adb <- boosting(admit ~ gre + gpa + rank, data=myDataTrain, boos=TRUE, mfinal=30)


cf <- predict(adb, myDataTest)

tableRF <- cf$confusion

accuracyRF <- sum(diag(tableRF))/sum(tableRF)
accuracyRF


#

t1<-adb$trees[[1]]
library(tree)
plot(t1)
text(t1,pretty=0)
rpart.plot(t1)

# Successive Errors and Trees
errorevol(adb,myDataTrain)

