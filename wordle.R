# word cloud

library("wordcloud")

m <- as.matrix(tweet.term1)
v <- sort(rowSums(m), decreasing=TRUE)
d1 <- data.frame(word=names(v), freq=v)
wordcloud(d1$word, d1$freq, min.freq=5)



# detect language
library("textcat")
textcat(c("This is an English sentence.", "Das ist ein deutscher Satz.", "Esta es una frase en espa~nol."))