import numpy as np
from sklearn.pipeline import Pipeline
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.svm import LinearSVC
from sklearn.feature_extraction.text import TfidfTransformer
from sklearn.multiclass import OneVsRestClassifier
import csv, random
import nltk
from sklearn.metrics import f1_score,classification_report, confusion_matrix

username="pinarozturk"
fp = open( '/Users/'+username+'/Dropbox/researthon/sentiment/android.csv', 'rb' )
reader = csv.reader( fp, delimiter=',', quotechar='"', escapechar='\\' )
tweets = []
for row in reader:
    try:
        #if row[1]!='irrelevant':
            tweets.append( [row[0].encode('utf-8',"replace"), row[1] ])
    except UnicodeDecodeError: 
        pass
        
#fpt = open( '/Users/'+username+'/Dropbox/researthon/sentiment/ios.csv', 'rb' )
#reader = csv.reader( fpt, delimiter=',', quotechar='"', escapechar='\\' )
#for row in reader:
#    try:
#        tweets.append( [row[0].encode('utf-8',"replace"), row[1] ])
#    except UnicodeDecodeError: 
#        pass
#        
#fpt2 = open( '/Users/'+username+'/Dropbox/researthon/sentiment/android.csv', 'rb' )
#reader = csv.reader( fpt2, delimiter=',', quotechar='"', escapechar='\\' )
#for row in reader:
#    try:
#        tweets.append( [row[0].encode('utf-8',"replace"), row[1] ])
#    except UnicodeDecodeError: 
#        pass
        
random.shuffle( tweets )                
X_train=[]
y_train=[]
X_test=[]
Y_test=[]
#print 0.8*len(tweets)
num_train = int(0.8 * len(tweets))
for i in range(0,num_train):
    X_train.append(tweets[i][0])
    y_train.append(tweets[i][1])
    
X_train=np.array(X_train)

testfp = open( '/Users/'+username+'/Desktop/twtest6.csv', 'rb' )
reader = csv.reader( testfp, delimiter=',', quotechar='"' )
testtweets = []
for row in reader:
    #print row[5]
    try:
        testtweets.append( [row[5].encode('utf-8',"replace"),row[0],row[1],row[2],row[3],row[4],row[6],row[7],row[8], row[9], row[10]])
    except UnicodeDecodeError: 
        pass
print len(testtweets)
for i in range(0, len(testtweets)):
    X_test.append(testtweets[i][0])


#print len(testtweets)
#for i in range(num_train, len(tweets)):
#    X_test.append(tweets[i][0])
#    Y_test.append(tweets[i][1])
    
X_test=np.array(X_test)
  
target_names=['positive','negative','neutral'] 
#print type(target_names)
   
classifier = Pipeline([
    ('vectorizer', CountVectorizer(min_df=1)),
    ('tfidf', TfidfTransformer()),
    ('clf', OneVsRestClassifier(LinearSVC()))])
classifier.fit(X_train, y_train)
predicted = classifier.predict(X_test)
print len(predicted)
#print predicted

with open('/Users/'+username+'/Desktop/tweet6predictions.csv','wb') as f:
    writer = csv.writer(f)
    for i in range(0,len(predicted)):
        writer.writerow([predicted[i],testtweets[i][0],testtweets[i][1],testtweets[i][2],testtweets[i][3],testtweets[i][4],testtweets[i][5],testtweets[i][6],testtweets[i][7],testtweets[i][8],testtweets[i][9],testtweets[i][10]])
f.close

#right=0
#wrong=0
#for i in range(0, len(predicted)):
#    #print Y_test[i] + " is predicted as " + predicted[i]
#    if predicted[i]==Y_test[i]:
#        right+=1
#    else:
#        wrong+=1
#        print Y_test[i] + " is predicted as " + predicted[i]
#
#print right
#print wrong
#
#predictedlist=predicted.tolist()
#print nltk.ConfusionMatrix( Y_test, predictedlist )
#
#dic={'positive':0, 'neutral':1, 'negative':2}
#y_true=map(lambda x: dic[x], Y_test)
#y_predict=map(lambda x: dic[x], predictedlist)
#
#print(classification_report(y_true,y_predict,target_names=dic.keys()))
#
#print f1_score(Y_test, predictedlist, average='micro')