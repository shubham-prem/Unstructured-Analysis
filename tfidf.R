library(tm)
data("crude")
dtm<- DocumentTermMatrix(crude,control = list(weighting =
                                                function(x)
                                                  weightTfIdf(x, normalize =
                                                                FALSE),
                                              stopwords = TRUE))
dtm
