# TWITTER ANALYSIS

#add file with tweets
analysisfile ="C:/Users/Harris/Dropbox/researthon/dataframes_csv/twtest1.Rda"
load(analysisfile)


##### clean data set to include only unique tweets to eliminate the problem of 



# find tweets that come from android devices
temp <- which(twtest1$sources_cleaned=="Android")
# among, them find the topic of those twee
summary(as.factor(twtest1$tweettopic[temp]))
temp <- which(twtest1$sources_cleaned=="iOS")
# among, them find the topic of those twee
summary(as.factor(twtest1$tweettopic[temp]))


temp <- levels(as.factor(twtest1$tweettopic))

for( i in seq(1,))
# for each topic, find how many people discussed about it


levels(as.factor(twtest1$sources_cleaned))

