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
# source: android, topic: android

sors <- c("iOS", "Android","BlackBerry")
top <- c("iOS", "Android","Blackberry")

#later....
#sentim=c("positive", "negative")

#now
sentim="positive"

# create a data frame of specific size
collect1 <- matrix(0, length(sors), length(top))
row.names(collect1)=c(sors)
colnames(collect1)=c(top)


for (i in seq(1,length(sors))){
  for (j in seq(1,length(top))){
    #temp <- which(results$sources_cleaned==sors[i] & results$tweettopic==top[j])
    temp <- which(results$sources_cleaned==sors[i] & results$tweettopic==top[j] 
                         & results$sentiment==sentim)
    
    collect1[i,j] <- length(temp)
  }
}


#############################################################################################
# negative
#############################################################################################
sentim="negative"

# create a data frame of specific size
collect2 <- matrix(0, length(sors), length(top))
row.names(collect2)=c(sors)
colnames(collect2)=c(top)


for (i in seq(1,length(sors))){
  for (j in seq(1,length(top))){
    #temp <- which(results$sources_cleaned==sors[i] & results$tweettopic==top[j])
    temp <- which(results$sources_cleaned==sors[i] & results$tweettopic==top[j] 
                  & results$sentiment==sentim)
    
    collect2[i,j] <- length(temp)
  }
}


# collect3 <- collect1/collect2

#############################################
######################################
#  winter suggestion for positives divided by all
#################################################

collect3 <- collect1 +collect2

collectres <- collect1/collect3

############################################################

results2 <- subset(results, is.element(tweettopic,  c("iOS", "Android","Blackberry")))
results$tweettopic
summary(as.factor(results2$sources_cleaned))

############################################################
# yeygin's calculation



sentim="negative"

# create a data frame of specific size
collectall <- matrix(0, length(sors), length(top))
row.names(collect2)=c(sors)
colnames(collect2)=c(top)


for (i in seq(1,length(sors))){
  for (j in seq(1,length(top))){
    #temp <- which(results$sources_cleaned==sors[i] & results$tweettopic==top[j])
    temp <- which(results$sources_cleaned==sors[i] & results$tweettopic==top[j])
    
    collectall[i,j] <- length(temp)
  }
}

up = collect1 - collect2
resultsyegin= up/collectall

############################################################
# yue calculation
length(which(results$sources_cleaned=="iOS" & results$tweettopic=="iOS"))


up <- collect1 +collect2
resultsyue= up/collectall

############################################################
# pinar happiness calculation
length(which(results$sources_cleaned=="iOS" & results$sentiment=="positive"))/length(which(results$sources_cleaned=="iOS" & results$sentiment=="negative"))
length(which(results$sources_cleaned=="Android" & results$sentiment=="positive"))/length(which(results$sources_cleaned=="Android" & results$sentiment=="negative"))
length(which(results$sources_cleaned=="BlackBerry" & results$sentiment=="positive"))/length(which(results$sources_cleaned=="BlackBerry" & results$sentiment=="negative"))







