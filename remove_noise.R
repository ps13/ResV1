###########################################################################################################################
# delete duplicated tweets from their tweet id
###########################################################################################################################

# find which rows are duplicated
temp <- which(duplicated(twtest1$tweetid))
twtest2 <- twtest1[-temp,]
# remove noise



###########################################################################################################################
# delete duplicated tweets and automatically created from games, apps etc
###########################################################################################################################
#save the ones that have been retweeted


# find which rows are duplicated
length(which(duplicated(twtest1$tweet)))



###########################################################################################################################
# find most frequently tweeted text
###########################################################################################################################
head(summary(as.factor(twtest1$tweet)))
summary(as.factor(twtest1$tweet[1:100]))




# delet all tweets that occured more than 10 












###########################################################################################################################
# find which rows contain the word "game"
###########################################################################################################################

game <- c()
kw <- c("game", "games", "play")
for (i in seq(1, length(kw))){
  game <- c(game, grep(kw[i], twtest1$tweet,ignore.case = TRUE))
}

#get only the unique values in the list
game <- unique(game)
length(game)
length(which(grep("game", twtest1$tweet,ignore.case = TRUE)))





