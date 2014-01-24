import twitter
import re
import csv
import time
import sys
from pprint import pprint
import time
import os
import pandas as pd

texts={}
texts_old=[]
sentiments={}
texts_missing=[]
fl=open('texts.csv','a+')
fl2=open('texts.csv','r')

fm=open('missing.csv','a+')
fm2=open('missing.csv','r')

lines_m=fm2.readlines()
for line in lines_m:
    texts_missing.append(int(line.strip()))


lines=fl2.readlines()
print 'reading file'
for line in lines:
    id,text,sentiment= line.split('\t',2)
    id=int(id)
    texts[id]=text
    texts_old.append(id)
    
df=pd.read_csv('sentiment_corpus.csv', header=0)

api = twitter.Api(consumer_secret='C00nSzpC4508tqkYVaOP3KZGwfOPCXEBGmaaVXLo',\
                  consumer_key='4izIDgFD12NqIBeGCN8VA',\
                  access_token_key='89115036-P0JAxz91ORhON3fBqnzU30HhKKZfbekxBfgcF82GC',\
                  access_token_secret='6ymuu9Gd4EDgoVusGIMxQyakXxK0sWO1JYJoPDs8uaOlk')

# api = twitter.Api(consumer_secret='aTHfRwjbwPKHfGtBM9rwt6Qko8jHAEnnRlZ7m5muc',\
#                  consumer_key='XMNiN0Aw3S74MPqhAflhpQ',\
#                  access_token_key='14307977-W28juG3Irm7h14cBkWqUnSsZWsRUsw06x6h1i8iIv',\
#                  access_token_secret='729lmn1hUJ4e9X4hCCDwBUGvyySDTf8fIxlCc2Htj5gxY')

print 'already existing\n',texts_old
for row in df.iterrows():
    row=row[1]
    id=int(row[2])
    sentiment=row[1]
    if id in texts_old:
        continue
    if id in texts_missing:
        continue     
    print 'trying' ,id, sentiment
    try:
        tweet=api.GetStatus(id)
        td=tweet.AsDict()
        text=td['text'].encode('utf-8')
        print text

        texts[id]=text
        sentiments[id]=sentiment
      
    except:
            
            print 'couldn\'t find'
            
            if sys.exc_info()[1][0][0]['code'] in [34,179]:
                texts_missing.append(id)
                continue
            else:
                print "Unexpected error:",sys.exc_info()[1][0][0]  
                break
            
for id in texts_missing:
    fm.write(str(id)+'\n')
fm.close()


for id, text in texts.iteritems():
    if id not in texts_old:
        fl.write(str(id)+'\t'+sentiment +'\t'+re.sub('\s+',' ',text)+'\n')

fl.close()
try: 
    df.insert(3,'text',texts.values())
    df.to_csv('sentiment_with_text')
except:
     print 'can\'t save yet'