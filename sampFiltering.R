library(tm)

spam_df <- read.csv("sms_spam.csv", stringsAsFactors = FALSE)

sms_corpus <- Corpus(VectorSource(spam_df$text))


print(sms_corpus)

inspect(sms_corpus[1:3])

#translate all letters to lower case
clean_corpus <- tm_map(sms_corpus,tolower)

#remove numbers
clean_corpus <-tm_map(clean_corpus, removeNumbers)

#remove punctuation
clean_corpus <-tm_map(clean_corpus, removePunctuation)

#Function stopWords() removes non content words like to, and, the ...
stopwords()[1:10] #prints first 10 stop words out of 175 such words

#remove stopWords
clean_corpus <- tm_map(clean_corpus, removeWords, stopwords())


#Removal of excess white space
clean_corpus <- tm_map(clean_corpus, stripWhitespace)

#inspect the clean corpus
inspect(clean_corpus[1:3])

#Tokenize the corpus
#A token is a single element in a text string 

sms_dtm <- DocumentTermMatrix(clean_corpus)

inspect(sms_dtm[1:4, 30:35])

#Using a Naive Bayes classifier to build a spam filter based on the words in a passage

spam_indices <- which(spam_df$type == "spam")
spam_indices[1:3]

ham_indices <- which(spam_df$type == "ham")
ham_indices[1:3]

#Word CLoud for Ham
library(wordcloud)

wordcloud(clean_corpus[ham_indices], min.freq = 40)

wordcloud(clean_corpus[spam_indices], min.freq = 40)

#Naive Bayes Classifier assigns a probablity that a new sample is in one class or another

#1. Divide the corpus into train and test dataset
sms_raw_train <- spam_df[1:4180,]
sms_raw_test <- spam_df[4181:5573,]

#2 Divide the DTM and clean corpus too into 75% and 25%
sms_dtm_train <- sms_dtm[1:4180,]
sms_dtm_test <- sms_dtm[4181:5573,]
sms_corpus_train <- clean_corpus[1:4180]
sms_corpus_test <- clean_corpus[4181:5573]

#Seperate train data into spam and ham
spam <- subset(sms_raw_train, type="spam")
ham <- subset(sms_raw_train, type="ham")

#Identify the words appearning atleast 5 times

five_times_words <- findFreqTerms(sms_dtm_train, 5)
length(five_times_words)

five_times_words[1:5]

#Create a DTM with frequently occuring words
sms_train <- DocumentTermMatrix(sms_corpus_train, control = list(dictionary = five_times_words))

sms_test <- DocumentTermMatrix(sms_corpus_test, control=list(dictionary = five_times_words))

#Convert count info to Yes or No as NaiveBayes needs present or absent info of each word in a message
convert_count <- function(x) {
  y <- ifelse(x > 0, 1,0)
  y <- factor(y, levels=c(0,1), labels=c("No", "Yes"))
  y
}


#Convert DTMs
sms_train <- apply(sms_train, 2, convert_count)
sms_test <- apply(sms_test, 2, convert_count)

library(e1071)

#Create the classifier using the train data
sms_classifier <- naiveBayes(sms_train, factor(sms_raw_train$type))
class(sms_classifier)

#Now evaluate the performance on the test data set
sms_test_pred <- predict(sms_classifier, newdata=sms_test)

#Generate the confusion matrix
t <- table(sms_test_pred, sms_raw_test$type)

#Accuracy
sum(diag(t))/sum(t)


