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

#length(twtest1$sources_cleaned[twtest1$sources_cleaned=="Android" & twtest1$tweettopic=="Android"])
#####################################
# get the same matrix as a percentage of the tweets from the same type of source
#number of tweets from an android device
source_summary <- c()
for (i in seq(1,length(s))){
  source_summary<- c(source_summary, length(which(twtest1$sources_cleaned==s[i])))
}

collect2 <- collect1
for (i in seq(1,length(s))){
  collect2[i,] <- collect1[i,]/source_summary[i]
}

#from collect2 keep only rows and columns we are interested in
collect3 <- collect2[c("Android", "iOS", "BlackBerry"),c("Android", "iOS", "Blackberry")]

length(twtest1$sources_cleaned[twtest1$sources_cleaned=="Android" & twtest1$tweettopic=="Android"])

#CREATE A HEATMAP
collect3 <- as.data.frame(collect3)
#reordering if needed
#collect3 <- with(collect3, reorder(Name, PTS))
library(ggplot2)
#library(reshape)
#collect3.m <- melt(collect3)
library(plyr)
 nba.m <- ddply(collect3, .(variable), transform,rescale=rescale(value))

heatmap(as.matrix(collect3))


item<-apply(ToyData,2,mean)
person<-apply(ToyData,1,sum)
ToyDataOrd<-ToyData[order(person),order(item)]

library(gplots)
heatmap.2(ToyDataOrd, Rowv=FALSE, Colv=FALSE, 
          dendrogram="none", col=redblue(16), 
          key=T, keysize=1.5, density.info="none", 
          trace="none", labRow=NA)

##### clean data set to include only unique tweets to eliminate the problem of 






