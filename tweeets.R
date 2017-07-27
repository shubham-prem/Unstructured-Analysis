#install.packages("streamR", "RCurl", "ROAuth", "RJSONIO")
library(streamR)
library(RCurl)
library(RJSONIO)
library(stringr)
# PART 1: Declare Twitter API Credentials & Create Handshake
#Access the url https://apps.twitter.com/app/13630418/keys
#to get the keys
library(ROAuth)
requestURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"
consumerKey <- "" # From dev.twitter.com
consumerSecret <- "" # From dev.twitter.com

my_oauth <- OAuthFactory$new(consumerKey = consumerKey,
                             consumerSecret = consumerSecret,
                             requestURL = requestURL,
                             accessURL = accessURL,
                             authURL = authURL)

my_oauth$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))
