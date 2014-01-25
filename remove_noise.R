###########################################################################################################################
# find most frequently tweeted text
###########################################################################################################################
head(summary(as.factor(twtest1$tweet)))
summary(as.factor(twtest1$tweet[1:100]))



###########################################################################################################################
# delete duplicated tweets from their tweet id
###########################################################################################################################

# find which rows are duplicated
temp <- which(duplicated(twtest1$tweetid))
twtest2 <- twtest1[-temp,]
# remove noise
#summary(as.factor(twtest1$tweet[temp]))

###########################################################################################################################
# delete duplicated tweets depending on the tweet content
###########################################################################################################################
# find which rows are duplicated
temp <- which(duplicated(twtest2$tweet))
length(temp)
twtest3 <- twtest2[-temp,]
# find which rows are duplicated
#length(which(duplicated(twtest1$tweet)))

###########################################################################################################################
# find which rows contain the word "game"
###########################################################################################################################

game <- c()
kw <- c("game", "games", "play")
for (i in seq(1, length(kw))){
  game <- c(game, grep(kw[i], twtest3$tweet,ignore.case = TRUE))
}
#get only the unique values in the list
game <- unique(game)
length(game)
head(game)
twtest4 <- twtest3[-game,]


head(twtest4$tweet)
save(twtest4, file="twtest4.Rda")
write.csv(twtest4, "twtest4.csv", row.names=TRUE)






