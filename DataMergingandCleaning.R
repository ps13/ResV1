################################################################################################################################################################
#
#
#
#        MERGE THE TWO DATA FILES - get all the tweets we have gathered
#       
#
#
################################################################################################################################################################


#first fix the final line of the file (probably missing elements)
# C:/Users/Harris/Dropbox/researthon


file0= "C:/Users/Harris/Dropbox/researthon/harris tweets/tweets0.csv"
tweets_folder="C:/Users/Harris/Dropbox/researthon/harris tweets/tweets"


twtest1 <- read.csv(file= file0 ,header = FALSE, sep ="\t")


for (i in seq(1,9)){
temp <- paste(tweets_folder, i,sep="")
fileauto <- paste(temp, ".csv",sep="")
twtest2 <- read.csv(file=fileauto,header = FALSE, sep ="\t")
twtest1<- rbind(twtest1,twtest2)
}


################################################################################################################################################################
#
#
#
#        SIMPLE IMPORT
#       
#
#
#############################################################################

#import the first dataset in a csv format (windows example)
#twtest1 <- read.csv(file= "C:/Users/Harris/Downloads/tweets0.csv",header = FALSE, sep ="\t")

# Add names in the columns
colnames(twtest1)<- c("tweetid", "userid", "date", "sources", "tweet", "elements")

#get a summary of the imported dataset
#summary(twtest1)
class(twtest1)
#twtest10 <- twtest1[,2:10]
#twtest1 <- twtest10
#rm(twtest10)


# simplify source
#for (i in seq(1, length(twtest1$sources))){  
#  sal <- strsplit(as.character(twtest1$sources[i]), ">")[[1]][2]
#  sal <- strsplit(sal, "<")[[1]][1]
#  twtest1$source2[i] <- sal
#}



# simplify source
temp <- c()
sal <- strsplit(as.character(twtest1$sources), ">")
sal <- sapply(sal,`[`,2)
head(sal)
sal <- strsplit(sal, "<")
sal <- sapply(sal,`[`,1)
head(sal)
twtest1$source2 <- sal




class(twtest1$source2)
  
#overwrite all data
twtest1$sourceall <- twtest1$sources
twtest1$sources <- twtest1$source2
twtest1$source2 <-NULL


# merge two datasets by rows
twtest3<- rbind(twtest1,twtest2)
twtest <- twtest3
rm(twtest1,twtest2, twtest3)
summary(twtest)
class(twtest)

################################################################################################################################################################
#
#
#
#           DECREASE THE NUMBER OF SOURCES IN ORDER TO BE ANALYZED
#
#
################################################################################################################################################################

################################################################################################################################################################
#Android
androidsource <- c()
kw <- c("Android","Falcon Pro","twicca","  HTC Peep","FalconPro","ZOOKEEPER BATTLE","LazyUnfollow - Droid","Gone Fishing mobile game","SwiftKey personalization")
for (i in seq(1, length(kw))){
  androidsource <- c(androidsource, grep(kw[i], twtest1$sources,ignore.case = TRUE))
}
#get only the unique values in the list
androidsource <- unique(androidsource)
length(androidsource)
twtest1$sources[androidsource][1:100]

################################################################################################################################################################
#iPhone
iphonesources <- c()
kw <- c("iPhone", "iOS", "iPad","Sylfeed", "TweetList!","Zite Personalized Magazine","iHoroscope")
for (i in seq(1, length(kw))){
  iphonesources <- c(iphonesources, grep(kw[i], twtest1$sources,ignore.case = TRUE))
}
#get only the unique values in the list
iphonesources <- unique(iphonesources)
length(iphonesources)
twtest1$sources[iphonesources][1:100]
################################################################################################################################################################

# blackberry
# find all positions of sourcess that contain Blackberry as sources
bbsources <- c()
kw <- c("Texas Hold'em King LIVE","QuickPull","Blackberry")

for (i in seq(1, length(kw))){
  bbsources <- c(bbsources, grep(kw[i], twtest1$sources,ignore.case = TRUE))
}
#get only the unique values in the list
bbsources <- unique(bbsources)
length(bbsources)
twtest1$sources[bbsources][1:100]

################################################################################################################################################################
#windows phone
wnphone <- c()
kw <- c("Windows Phone", "rowi for Windows Phone","winph0","Social by Nokia")
for (i in seq(1, length(kw))){
  wnphone <- c(wnphone, grep(kw[i], twtest1$sources,ignore.case = TRUE))
}
#get only the unique values in the list
wnphone <- unique(wnphone)
length(wnphone)
twtest1$sources[wnphone]

################################################################################################################################################################
#mobile-not identified
#mobile_ufo
mobufosources <- c()
kw <- c( "Janetter", "Write Longer", "Neatly BB10", "PicsArt Photo Studio","UnfolllowID","GREE","RuleKingdom","Airport City Mobile", "runtastic", 
         "Echofon","Truecaller","Scoop.it","Pulse News", "Mobile Web (M2)" , "Mobile Web (M5)" ,"Flipboard", "Instagram", "Viber")
for (i in seq(1, length(kw))){
  mobufosources <- c(mobufosources, grep(kw[i], twtest1$sources,ignore.case = TRUE))
}
#get only the unique values in the list
mobufosources <- unique(mobufosources)
length(mobufosources)
twtest1$sources[mobufosources][1:100]

################################################################################################################################################################
#web
websources1 <- c()
kw <- c("Google", "twitterfeed", "Tweet Button", "Hotot for Chrome", "TweetDeck", "Facebook","Tweet Old Post","WordPress.com","WP Twítter","NetworkedBlogs","Megamobilecontent")
for (i in seq(1, length(kw))){
  websources1 <- c(websources1, grep(kw[i], twtest1$sources,ignore.case = TRUE))
}
#get the plain web ones
websources2 <- grep("web", twtest1$sources, fixed = TRUE)
#get only the unique values in the list
websources <- unique(c(websources1,websources2))
length(websources)
twtest1$sources[websources]

################################################################################################################################################################
#mac
macsources <- c()
kw <- c("Tweetbot for Mac","YoruFukurou", "Twееtbot for Mac","Twitter for Mac", "OS X" )
for (i in seq(1, length(kw))){
  macsources <- c(macsources, grep(kw[i], twtest1$sources,ignore.case = TRUE))
}
#get only the unique values in the list
macsources <- unique(macsources)
length(macsources)
################################################################################################################################################################
#Windows Desktop
wndesk <- c()
kw <- c("Tween","Windows Live Writer")
for (i in seq(1, length(kw))){
  wndesk <- c(wndesk, grep(kw[i], twtest1$sources,ignore.case = TRUE))
}
#get only the unique values in the list
wndesk <- unique(wndesk)
twtest1$sources[wndesk]
length(wndesk)
################################################################################################################################################################
#Business Suites
bussources <- c()
kw <- c("Buffer" ,"HootSuite","IFTTT" ,"Scope App","WPTweetily","dlvr.it","Spread The Next Web","Thirst for Topics",
        "SocialEngage","SocialOomph","SharedBy", "MarketMeSuite","Sprout Social","SNS Analytics","GroupTweet")
for (i in seq(1, length(kw))){
  bussources <- c(bussources, grep(kw[i], twtest1$sources,ignore.case = TRUE))
}
#get only the unique values in the list
bussources <- unique(bussources)
length(bussources)
################################################################################################################################################################
#ufos
# no idea what they are and personalized sourcess
ufos <- c()
kw <- c("hisobot","txt","Gravity!","multibt","GamerNews","AboutDiablo.com",
        "Water Filters Cartridges Site","byodrt","socnet2socnet","imbetjoy","Twit Posts RU","Rewwwind","FileDir.com", "LinkedIn")
for (i in seq(1, length(kw))){
  ufos <- c(ufos, grep(kw[i], twtest1$sources,ignore.case = TRUE))
}
#get only the unique values in the list
ufos <- unique(ufos)
length(ufos)

#UFOS
# no idea what they are
#    "hisobot","txt","Gravity!"
#personalized
#    "multibt","GamerNews","AboutDiablo.com","Water Filters Cartridges Site","byodrt","socnet2socnet","imbetjoy","Twit Posts RU","Rewwwind","FileDir.com"

################################################################################################################################################################
#JAPAN
japansources <- c()
kw <- c("WIWA SERVICE","Sylfeed","rakubo2","OpenTween","twittbot.net","EasyBotter","bot_manager","upmeetup","YoruFukurou")
for (i in seq(1, length(kw))){
  japansources <- c(japansources, grep(kw[i], twtest1$sources,ignore.case = TRUE))
}
#get only the unique values in the list
japansources <- unique(japansources)
length(japansources)
################################################################################################################################################################


sources_cleaned <- c()
for (i in seq(1, length(twtest1$sources))){
  if (is.element(i, androidsource)){
    sources_cleaned <- c(sources_cleaned, "Android")
  }else if (is.element(i, iphonesources)){
    sources_cleaned <- c(sources_cleaned, "iOS")
  }else if (is.element(i, bbsources)){
    sources_cleaned <- c(sources_cleaned, "BlackBerry")
  }else if (is.element(i, wnphone)){
    sources_cleaned <- c(sources_cleaned, "WindowsPhone")
  }else if (is.element(i, mobufosources)){
    sources_cleaned <- c(sources_cleaned, "MobileUFO")
  }else if (is.element(i, websources)){
    sources_cleaned <- c(sources_cleaned, "Web")
  }else if (is.element(i, macsources)){
    sources_cleaned <- c(sources_cleaned, "Mac")
  }else if (is.element(i, wndesk)){
    sources_cleaned <- c(sources_cleaned, "WindowsDesktop")
  }else if (is.element(i, bussources)){
    sources_cleaned <- c(sources_cleaned, "BusinessSuite")
  }else if (is.element(i, ufos)){
    sources_cleaned <- c(sources_cleaned, "Personalized")
  }else if (is.element(i, websources)){
    sources_cleaned <- c(sources_cleaned, "Web")
  }else if (is.element(i, japansources)){
    sources_cleaned <- c(sources_cleaned, "JapanWebsite")
  }else{
    sources_cleaned <- c(sources_cleaned, "NotIdentified")
  }
}

## check if all went well
sources_cleaned[1:40]
class(sources_cleaned)


#change all of the columns from factors to character or number variables
class(twtest1$user)
twtest1$user <- as.character(twtest1$user)
#
# twtest1$date

# Add a sources_Cleaned column
twtest1 <- cbind(twtest1,sources_cleaned)
#how many unidentified
length(twtest1$sources[twtest1$sources_cleaned =="NotIdentified"])

#find the sources of the "NotIdentified"
sort(twtest1$sources[twtest1$sources_cleaned =="NotIdentified"], decreasing=FALSE)


################################################################################################################################################################
#
#
#
#           TWEET TOPIC - ADD A COLUMN WITH WHAT THE TWEET IS ABOUT 
#
#
################################################################################################################################################################

#Firefox OS
kwios <- c(grep("iOS", twtest1$tweet,ignore.case = TRUE), grep("iPhone", twtest1$tweet,ignore.case = TRUE))
length(kwios)
kwandroid <- c(grep('Android', twtest1$tweet,ignore.case = TRUE), grep('Android OS', twtest1$tweet,ignore.case = TRUE))
kwblackberry <- c(grep('Blackberry', twtest1$tweet,ignore.case = TRUE), grep('Blackberry OS', twtest1$tweet,ignore.case = TRUE))
kwwinphone <- c(grep('Windows Phone OS', twtest1$tweet,ignore.case = TRUE),grep('Windows Phone', twtest1$tweet,ignore.case = TRUE))

# check how many tweets have been classified
length(kwios) +   length(kwandroid) +   length(kwblackberry) +   length(kwwinphone) #12928
#number of total tweets is less 
length(twtest1$user) #12678

# create special cases for tweets with multiple mentions
# interference of two
android_ios <- intersect(kwios,kwandroid)
android_bb <- intersect(kwandroid, kwblackberry)
ios_bb <-   intersect(kwios,kwblackberry) 
android_winphone <- intersect(kwandroid, kwwinphone) 
ios_winphone <-   intersect(kwios,kwwinphone)
bb_winphone <-   intersect(kwblackberry,kwwinphone) 

length(android_ios)
length(android_bb)
length(ios_bb)
length(android_winphone)  
length(ios_winphone)
length(bb_winphone)

#sets of three
android_ios_bb <- intersect(android_ios,kwblackberry)
android_ios_winphone <- intersect(android_ios, kwwinphone)
android_bb_winphone <- intersect(android_bb, kwwinphone)
ios_bb_winphone <- intersect(ios_bb, kwwinphone)

length(android_ios_bb)
length(android_ios_winphone)
length(android_bb_winphone)
length(ios_bb_winphone)

#set of all 4 mobile OS
all4 <- intersect(android_ios,bb_winphone)
length(all4)

# create an empty list to put the topics!
tweettopic <- rep("NoTweetKeywords", length(twtest1$tweet))
#one
tweettopic[kwios] <- "iOS"
tweettopic[kwblackberry] <- "Blackberry"
tweettopic[kwwinphone] <- "WindowsPhone"
tweettopic[kwandroid] <- "Android"
#two
tweettopic[android_ios] <- "Android_iOS"
tweettopic[android_winphone] <- "Android_WindowsPhone"
tweettopic[android_bb] <- "Android_BB"
tweettopic[ios_winphone] <- "iOS_WindowsPhone"
tweettopic[bb_winphone] <- "BB_WindowsPhone"
tweettopic[ios_bb] <- "iOS_BB"
#three
tweettopic[android_ios_bb] <- "Android_iOS_BB"
tweettopic[android_ios_winphone] <- "Android_iOS_WindowsPhone"
tweettopic[android_bb_winphone] <- "Android_BB_WindowsPhone"
tweettopic[ios_bb_winphone] <- "iOS_BB_WindowsPhone"
# all 4 topics
tweettopic[all4] <- "AllOperatingSystems"


#confirm that unclassified tweets are indeed unrelated
twtest1$tweet[tweettopic == "NoTweetKeywords"][1:100]


# Add a Topic of the Tweet Column
length(tweettopic)
twtest1<- cbind(twtest1,tweettopic)

# find how many of the tweets did not have any of the keywords
length(twtest1$tweet[twtest1$tweettopic == "NoTweetKeywords"])

# delete the tweets that did not contain any of the keywords
twtest12 <- subset(twtest1, tweettopic!="NoTweetKeywords")
length(twtest12$user)  
length(twtest1$user)
twtest1 <- twtest12
rm(twtest12)

# Write to a file, with row names
write.csv(twtest1, "Tweets_all_merged_with_topic_and sources_30398.csv", row.names=TRUE)

################################################################################################################################################################
#
#
#
#           POSITION OF TWEETS FOR EACH OF THE CATEGORIES
#
#
################################################################################

#1. MOBILE VS. DESKTOP
#MOBILE ALL
c(androidsources,iphonesources,bbsources, wnphone, mobufosources)
#DESKTOP ALL
c(websources, macsources, wndesk, bussources
  ###############################################################################
  #2. ANDROID VS. IOS USERS VS. WINDOWS PHONE VS. BLACKBERRY
  #ANDROID USERS
  androidsources
  #ios users
  iphonesources
  # win phone users
  wnphone
  # blackberry
  bbsources
  ###############################################################################
  # 3. GOOGLE VS. APPLE USERS
  # ANDROID AND CHROME USERS
  c(androidsources, grep("Chrome", twtest1$sources,ignore.case = TRUE))
  # APPLE USERS
  c(iphonesources, macsources)
  ###############################################################################
  # 4. UNIDENTIFIED (COMPARE WITH THEMSELVES :p)
  c(ufos, JAPAN)
  ###############################################################################
  
  ####directory#########################################
  #Android --- androidsources
  #iPhone ---- iphonesources
  # blackberry ---bbsources
  #windows phone --- wnphone
  #mobile not identified --- mobufosources 
  ###########################################33
  # desktop all
  #web --- websources
  #mac ---- macsources
  #Windows Desktop ---- wndesk
  #Business Suites --- bussources
  ########################################
  #unidentified
  #ufos --- ufos
  #JAPAN --- japansources
  ########################################  
  
  ##############
  grepl returns a logical vector. You can use the ! operator if you want the opposite result.
  data$ID[!grepl("xyx", data$ID) & data$age>60]
  ################

  
  message(sprintf("On %s I realized %s was...\n%s by the street", Sys.Date(), person, action))
  # Write to a file, with row names
  #write.csv(twtest1, "tweets_clean_sources.csv", row.names=TRUE)
  
  
  