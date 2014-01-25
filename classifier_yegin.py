from sklearn.feature_extraction.text import TfidfTransformer, TfidfVectorizer
from sklearn.svm import LinearSVC, SVC
from sklearn.metrics import f1_score,classification_report, confusion_matrix
import pandas as pd
from pprint import pprint
from collections import Counter

df=pd.read_csv('texts.csv')
df2=pd.read_csv('/Users/yegingenc/Dropbox/researthon/sentiment/android.csv')
df2.columns=['text','sentiment']

df3=pd.read_csv('/Users/yegingenc/Dropbox/researthon/sentiment/ios.csv')
df3.columns=['text','sentiment']

df4

t_vectorizer=TfidfVectorizer(ngram_range=(1,2),stop_words={'english'})
t_vector=t_vectorizer.fit_transform(df2.text)

clf = LinearSVC(C=  3)

clf.fit(t_vector, df2['sentiment'])

t_test_vector=t_vectorizer.transform(df3.text)
predictions=clf.predict(t_test_vector)
print type(predictions)
print len(predictions)
target_names = ['class 0', 'class 1', 'class 2']


combined=zip(predictions, df3['sentiment'])
# pprint(combined)
dic={'positive':0, 'neutral':1, 'negative':2}



target_names=Counter(predictions)
print "actuals"
print(Counter(df3['sentiment']))

print "trainings"
print(Counter(df2['sentiment']))

print "predictions"
print(Counter(predictions))
y_true=map(lambda x: dic[x], list(df3['sentiment']))
y_predict=map(lambda x: dic[x], list(predictions))

print(classification_report(y_true,y_predict,target_names=dic.keys()))

# print f1_score(df3['sentiment'], predictions, average='micro')