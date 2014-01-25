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
        tweets.append( [row[0].encode('utf-8',"replace"), row[1] ])
    except UnicodeDecodeError: 
        pass
random.shuffle( tweets )                
X_train=[]
y_train=[]
X_test=[]
Y_test=[]
#print 0.8*len(tweets)
num_train = int(1 * len(tweets))
for i in range(0,num_train):
    X_train.append(tweets[i][0])
    y_train.append(tweets[i][1])
    
X_train=np.array(X_train)

testfp = open( '/Users/'+username+'/Dropbox/researthon/sentiment/ios.csv', 'rb' )
reader = csv.reader( testfp, delimiter=',', quotechar='"', escapechar='\\' )
testtweets = []
for row in reader:
    try:
        testtweets.append( [row[0].encode('utf-8',"replace"), row[1] ])
    except UnicodeDecodeError: 
        pass
for i in range(0, len(testtweets)):
    X_test.append(testtweets[i][0])
    Y_test.append(testtweets[i][1])
    
X_test=np.array(X_test)
  
target_names=['positive','negative','neutral'] 
#print type(target_names)
   
classifier = Pipeline([
    ('vectorizer', CountVectorizer(min_df=1)),
    ('tfidf', TfidfTransformer()),
    ('clf', OneVsRestClassifier(LinearSVC()))])
classifier.fit(X_train, y_train)
predicted = classifier.predict(X_test)
print type(predicted)

right=0
wrong=0
for i in range(0, len(predicted)):
    #print Y_test[i] + " is predicted as " + predicted[i]
    if predicted[i]==Y_test[i]:
        right+=1
    else:
        wrong+=1
        print Y_test[i] + " is predicted as " + predicted[i]

print right
print wrong

predictedlist=predicted.tolist()
print nltk.ConfusionMatrix( Y_test, predictedlist )

dic={'positive':0, 'neutral':1, 'negative':2}
y_true=map(lambda x: dic[x], Y_test)
y_predict=map(lambda x: dic[x], predictedlist)

print(classification_report(y_true,y_predict,target_names=dic.keys()))

print f1_score(Y_test, predictedlist, average='micro')