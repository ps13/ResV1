# TWITTER ANALYSIS

#add file with tweets
analysisfile ="C:/Users/Harris/Dropbox/researthon/dataframes_csv/twtest1.Rda"
load(analysisfile)


# source: android, topic: android

s <- levels(as.factor(twtest1$sources_cleaned))
t <- levels(as.factor(twtest1$tweettopic))
# create a data frame of specific size
collect1 <- matrix(0, length(s), length(t))
row.names(collect1)=c(s)
colnames(collect1)=c(t)


for (i in seq(1,length(s))){
  for (j in seq(1,length(t))){
temp <- which(twtest1$sources_cleaned==s[i] & twtest1$tweettopic==t[j])
collect1[i,j] <- length(temp)
  }
}

#####################################
# get the same matrix as a percentage of the tweets from the same type of source
#number of tweets from an android device
for (i in seq(1,length(s))){
  length(which(twtest1$sources_cleaned=="Android"))
  
}



length(twtest1$sources_cleaned[twtest1$sources_cleaned=="Android" & twtest1$tweettopic=="Android"])



##### clean data set to include only unique tweets to eliminate the problem of 






