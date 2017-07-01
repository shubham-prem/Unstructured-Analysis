









library(streamR)
#load("Twitter.R")
my_oauth
filterStream(file.name = "tweets.json", # Save tweets in a json file
             track = c("#modi"), # Collect tweets mentioning either Affordable Care Act, ACA, or Obamacare
             language = "en",
             timeout = 120, # Keep connection alive for 60 seconds
             oauth = my_oauth) # Use my_oauth file as the OAuth credentials

tweets.df <- parseTweets("tweets.json", simplify = FALSE) # parse the json file and save to a data frame ctweets
