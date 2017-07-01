
library(tidytext)
library(tokenizers)
library(dplyr)
tweet.df <- readLines(file.choose())

tokenized_text <- tokenize_words(tweet.df)

length(tokenized_text)
words <- tokenized_text
sentences <- tokenize_sentences(tweet.df)
length(sentences)
sentences
#Tokenizing the text into words

sentence_words <- tokenize_words(sentences[[1]])
sentence_words

length(words)
tab <- table(words[[1]])
tab <- data_frame(word = names(tab), count = as.numeric(tab))
tab <- arrange(tab, desc(count))
tab
