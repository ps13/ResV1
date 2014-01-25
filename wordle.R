# word cloud

library("wordcloud")

m <- as.matrix(tweet.term1)
v <- sort(rowSums(m), decreasing=TRUE)
d1 <- data.frame(word=names(v), freq=v)
wordcloud(d1$word, d1$freq, min.freq=5)
