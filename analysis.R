#converting "tweets.json" in to dataframe
library(streamR)
tweet.df <- parseTweets(file.choose(), simplify = FALSE,verbose = TRUE) # parse the json file and save to a data frame ctweets
library(tidytext)
library(dplyr)
#Tokenizing the text into words
tokenized_text <- tweet.df %>%
  unnest_tokens(word, text)

#Removing stopwords
data(stop_words)
custom_stop_words <- bind_rows(data_frame(word = c("rt","https","t.co"), 
                                          lexicon = c("custom")), 
                               stop_words)

tokenized_text <- tokenized_text %>% anti_join(custom_stop_words)

#finding most common words in text
tokenized_text %>%
  count(word, sort = TRUE) 
#Plotting most common words
library(ggplot2)

tokenized_text %>%
  count(word, sort = TRUE) %>%
  top_n(5)%>%
  filter(n > 10) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()
#WordCloud
library(wordcloud)

tokenized_text %>%
  anti_join(stop_words) %>%
  count(word) %>%
  with(wordcloud(word, n, max.words = 100))

#Bing
#Top 10 Positive and Negatiive Words
bing_word_counts <- tokenized_text %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort = TRUE) %>%
  ungroup()

bing_word_counts %>%
  group_by(sentiment) %>%
  ungroup() %>%
  mutate(word = reorder(word, n)) %>%
  top_n(10)%>%
  ggplot(aes(word, n, fill = sentiment)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~sentiment, scales = "free_y") +
  labs(y = "Contribution to sentiment",
       x = NULL) +
  coord_flip()

#Top 100 Positive and Negative words
library(reshape2)

tokenized_text %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort = TRUE) %>%
  acast(word ~ sentiment, value.var = "n", fill = 0) %>%
  comparison.cloud(colors = c("#F8766D", "#00BFC4"),
                   max.words = 100)

#Tweet Analysis
library(ggplot2)
afinn <- tokenized_text %>% 
  inner_join(get_sentiments("afinn")) %>% 
  group_by(index = created_at) %>%
  summarise(sentiment = sum(score)) %>% 
  mutate(method = "AFINN")

afinn %>% ggplot(aes( index , sentiment, fill = method)) +
  geom_col(show.legend = FALSE) +
  labs(y = "sentiment",
       x = "TIMESTAMP") +
  facet_wrap(~method, ncol = 1, scales = "free_y")

