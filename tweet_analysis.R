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

levels(as.factor(twtest1$tweettopic))


# aggregate data frame mtcars by cyl and vs, returning means
# for numeric variables
attach(mtcars)
aggdata <-aggregate(mtcars, by=list(cyl,vs),
                    FUN=mean, na.rm=TRUE)
print(aggdata)
detach(mtcars)




