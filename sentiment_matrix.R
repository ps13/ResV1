######################################################################################################
# LOAD DATA
######################################################################################################
#yegin
fileresults= "C:/Users/Harris/Dropbox/researthon/dataframes_csv/twtest6_withSentiments2.csv"
#pinar
fileresults= "C:/Users/Harris/Dropbox/researthon/dataframes_csv/tweet6predictions.csv"

results <- read.csv(file= fileresults ,header = TRUE, sep =",")

######################################################################################################
# CREATE A MATRIX FOR iOS
######################################################################################################
summary(as.factor(results$sentiment))

sors="iOS"
top="iOS"
sentim="positive"

summary(as.factor(results$sentiment))
# tweets from ios about ios positive
length(which(results$sources_cleaned==sors & results$tweettopic==top & results$sentiment==sentim))

# tweets from ios about ios negative
sentim="negative"
length(which(results$sources_cleaned==sors & results$tweettopic==top & results$sentiment==sentim))

# tweets from ios about android positive
top="Android"
sentim="positive"
length(which(results$sources_cleaned==sors & results$tweettopic==top & results$sentiment==sentim))

# tweets from ios about android negative
top="Android"
sentim="negative"
length(which(results$sources_cleaned==sors & results$tweettopic==top & results$sentiment==sentim))

# tweets from ios about BB positive
top="Blackberry"
sentim="positive"
length(which(results$sources_cleaned==sors & results$tweettopic==top & results$sentiment==sentim))

# tweets from ios about BB negative
top="Blackberry"
sentim="negative"
length(which(results$sources_cleaned==sors & results$tweettopic==top & results$sentiment==sentim))

results$tweet[which(results$sources_cleaned=="iOS" & results$sentiment=="positive")]