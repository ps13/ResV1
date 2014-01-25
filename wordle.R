

###########################################################################################################

# detect language
###########################################################################################################

library("textcat")
class(twtest4$tweet)
twtest4$tweet <- as.character(twtest4$tweet)
temp <- textcat(twtest4$tweet)
summary(as.factor(temp))
#add them as an attribute to the dataset
twtest4$language <- temp
# create a submatrix containing the ones in english
eng<- which(twtest4$language=="english")
twtest5 <- twtest4[eng,]



###########################################################################################################
#SENTIMENT ANALYSIS USING tm Package in R
library("tm")
install.packages("tm.plugin.tags", repos = "http://datacube.wu.ac.at", type = "source")
library('tm.plugin.tags')




temp <- textcat(as.character(twtest4$tweet))
twtest4$language <- temp

as.character(twtest4$tweet)
class(c("This is an English sentence.", "Das ist ein deutscher Satz.", "Esta es una frase en espa~nol."))


###########################################################################################################
# word cloud

library("wordcloud")

m <- as.matrix(tweet.term1)
v <- sort(rowSums(m), decreasing=TRUE)
d1 <- data.frame(word=names(v), freq=v)
wordcloud(d1$word, d1$freq, min.freq=5)
