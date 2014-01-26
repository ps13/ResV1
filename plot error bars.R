#####  plot error bars
# delete the 
results4 <- subset(results2, is.element(sources_cleaned,  c("iOS", "BlackBerry", "Android")))

# keep only the ones that have the topic we are interested in:
results5 <- subset(results4, is.element(tweettopic,  c("iOS")))

results3 <- subset(results5, is.element(sentiment,  c("positive", "negative")))

#summary(as.factor(results3$tweettopic))

# merge the other two in one
t <- which(is.element(results3$sources_cleaned, c("BlackBerry","Android")))
results3$sources_cleaned[t] <- c("Other Sources")
summary(as.factor(results3$sources_cleaned))

#TWO STANDARD DEVIATIONS
bla0 <- which((results3$tweettopic == "iOS" & results3$sources_cleaned == "iOS"))
bla1 <- which((results3$tweettopic == "iOS" & results3$sources_cleaned == "BlackBerry"))
bla2 <- which((results3$tweettopic == "iOS" & results3$sources_cleaned == "Android"))

############################################################################################################################################################################
############################################################################################################################################################################
###    PLOTS WITH ERROR BARS
############################################################################################################################################################################
############################################################################################################################################################################
############################################################################################################################################################################
results3$binary <- 0
results3$binary[results3$sentiment=="positive"] <- 1
summary(as.factor(results3$binary))
class(results3$sentiment)
results3$sentiment <- as.integer(results3$sentiment)
head(which(results$sentiment=="positive"))

df <- data.frame(y = results3$binary, x = results3$sources_cleaned)
pairwise.t.test(results3$binary, results3$sources_cleaned)

#create a new columns
class(df$category)
df$category <- "None"
df$category[bla0] <- "iOS"
df$category[bla1] <- "BlackBerry"
df$category[bla2] <- "Android" 

df$category <- as.factor(df$category)
summary(df$category)
#which(df$category=="None")
df <- subset(df, category!="None")


# sort them
df <- within(df, category <- factor(category, 
                                      levels=names(sort(table(category), 
                                                        decreasing=TRUE))))


############################################################################################################################################################################
############################################################################################################################################################################
############################################################################################################################################################################
### error bars 2

############################################################################################################################################################################
# RUN IT (no questions asked)
summarySE <- function(data=NULL, measurevar, groupvars=NULL, na.rm=FALSE, conf.interval=.95, .drop=TRUE) {
  require(plyr)
  
  # New version of length which can handle NA's: if na.rm==T, don't count them
  length2 <- function (x, na.rm=FALSE) {
    if (na.rm) sum(!is.na(x))
    else       length(x)
  }
  # This is does the summary; it's not easy to understand...
  datac <- ddply(data, groupvars, .drop=.drop,
                 .fun= function(xx, col, na.rm) {
                   c( N    = length2(xx[,col], na.rm=na.rm),
                      mean = mean   (xx[,col], na.rm=na.rm),
                      sd   = sd     (xx[,col], na.rm=na.rm)
                   )
                 },
                 measurevar,
                 na.rm
  )
  
  # Rename the "mean" column    
  datac <- rename(datac, c("mean"=measurevar))
  
  datac$se <- datac$sd / sqrt(datac$N)  # Calculate standard error of the mean
  
  # Confidence interval multiplier for standard error
  # Calculate t-statistic for confidence interval: 
  # e.g., if conf.interval is .95, use .975 (above/below), and use df=N-1
  ciMult <- qt(conf.interval/2 + .5, datac$N-1)
  datac$ci <- datac$se * ciMult
  
  return(datac)
}
############################################################################################################################################################################
library(ggplot2)
dfc <- summarySE(df, measurevar="y", groupvars=c("category"))

# Use category as a factor rather than numeric
dfc2 <- dfc
dfc2$category <- factor(dfc2$category)


#specify the colors you want to use
rhg_cols1<- c("#6698FF","#FF7F50","#C5908E","#89C35C", "#B40486", 
  "#0080FF", "#3ADF00", "#B404AE", "#D7DF01", "#FF4000",
  "#81F781", "#DBA901", "#DF3A01", "#DF01D7", "#BDBDBD",
  "#04B486")

library(ggplot2)
# Error bars represent standard error of the mean
ggplot(dfc, aes(x=category, y=y, fill=category)) + 
  geom_bar(position=position_dodge(), stat="identity") +
  geom_errorbar(aes(ymin=y-se, ymax=y+se),
                width=.2,         # Width of the error bars
                position=position_dodge(.9))+
  scale_fill_manual(values = rhg_cols1)+
  opts(axis.line = theme_segment(colour = "black"),
      panel.grid.major = theme_blank(),
      panel.grid.minor = theme_blank(),
      panel.border = theme_blank(),
      panel.background = theme_blank(),
      axis.title.x = theme_text(size = 15, colour = 'black'),
      axis.title.y = theme_text(size = 15, colour = 'black', angle = 90))+
  xlab("Source") +
  ylab("Popularity") #+
  #ggtitle("Topic iOS")

pairwise.t.test(df$y, df$category)

# Use 95% confidence intervals instead of SEM
ggplot(dfc2, aes(x=category, y=y, fill=category)) + 
  geom_bar(position=position_dodge(), stat="identity") +
  geom_errorbar(aes(ymin=y-ci, ymax=y+ci),
                width=.2,                    # Width of the error bars
                position=position_dodge(.9))
############################################################################################################################################################################


ggplot(dfc2, aes(x=category, y=y, fill=category)) + 
  geom_bar(position=position_dodge(), stat="identity",
           colour="black", # Use black outlines,
           size=.3) +      # Thinner lines
  geom_errorbar(aes(ymin=y-se, ymax=y+se),
                size=.3,    # Thinner lines
                width=.2,
                position=position_dodge(.9)) +
  xlab("Standard Deviation of Originality") +
  ylab("Popularity") +
  scale_fill_hue(name="Categories", # Legend label, use darker colors
                 breaks=c("OJ", "VC")) +
  ggtitle("The Effect of Novelty in Innovation") +
  theme_bw()


############################################################################################################################################################################
# trying to get the right order- not working!!!
############################################################################################################################################################################
############################################################################################################################################################################
############################################################################################################################################################################


dfc11 <- dfc
dfc11 <-dfc11[order(factor(dfc11$category,
                           levels=c(c("MinusThree", "MinusTwo", "MinusOne", "One", "Two", "Three", "Four")))),]

# using label names:
summary(dfc11$category)
dfc11$category <- reorder(dfc11$category, new.order=c("MinusThree", "MinusTwo", "MinusOne", "One", "Two", "Three", "Four"))
summary(dfc11)


# Error bars represent standard error of the mean
ggplot(dfc11, aes(x=category, y=y, fill=category)) + 
  geom_bar(position=position_dodge(), stat="identity") +
  geom_errorbar(aes(ymin=y-se, ymax=y+se),
                width=.2,         # Width of the error bars
                position=position_dodge(.9))

levels(dfc11$category)
############################################################################################################################################################################


# High Density Scatterplot with Binning
library(hexbin)
xplot <- Thingiverse$n1_post
yplot <- Thingiverse$Num_Likes
bin<-hexbin(xplot, yplot, xbins=50)
plot(bin, main="Hexagonal Binning of Originality & Popularity",xlab="Originality", ylab="Popularity") 
par(mgp=c(3,2,2))
?plot
