import twitter
import re
import csv
import time
import sys
import multiprocessing as mp
from multiprocessing import Process, Queue
from pprint import pprint
import time

files=[]
max_id=0
min_id=-1        
def worker2(input):
        global files
        print len(input)
        fname=input[0]
        tweet=input[1]
        
        fl=files[fname]
       
        # print tweets
        print tweet.keys()
        # print tweet[u'id_str']
        print 'USERID', tweet['user']['id']

        print 'TEXT', tweet['text']
        line='%s\t%s\t%s\t%s\t%s\t%s\n'%(tweet['id_str'],tweet['user']['id'],tweet['created_at'],tweet['source'], re.sub('\s+', ' ', tweet['text']),tweet['entities']['hashtags']) 
        print line           
        fl.write(line.encode('utf-8'))
        

       
        fl.flush()
        # pprint(tweets.keys())


def worker(input):
        global files
        print len(input)
        fname=input[0]
        tweet=input[1]

        fl=files[fname]

        # print tweets
        print tweet.keys()
        # print tweet[u'id_str']
        print 'USERID', tweet['user']['id']

        print 'TEXT', tweet['text']
        line='%s\t%s\t%s\t%s\t%s\t%s\n'%(tweet['id'],tweet['user']['id'],tweet['created_at'],tweet['source'], re.sub('\s+', ' ', tweet['text']),tweet.get('hashtags')) 
        print line           
        fl.write(line.encode('utf-8'))



        fl.flush()


def stream(): 
    bufsize = 1
    global files
    for i in range(10):
        f=open('tweets%s.csv'%(i),'w', bufsize)
        files.append(f)
        
        
    api = twitter.Api(consumer_secret='aTHfRwjbwPKHfGtBM9rwt6Qko8jHAEnnRlZ7m5muc',consumer_key='XMNiN0Aw3S74MPqhAflhpQ',access_token_key='14307977-W28juG3Irm7h14cBkWqUnSsZWsRUsw06x6h1i8iIv',access_token_secret='729lmn1hUJ4e9X4hCCDwBUGvyySDTf8fIxlCc2Htj5gxY')
    samp=api.GetStreamSample()
    po = mp.Pool(10)
    
    
    
    while(True):
    # for j in range(100):
        tweets=[]
        for i in range(10):
                deleted=True
                while(deleted):
                    tweet=samp.next()
                    if tweet.get('delete','NA')=='NA':
                        deleted=False
               
                tweets.append([i,tweet])
                
                # tweet=samp.next()
                # print tweet.user.screen_name
        print 'should go now'
        res = po.map_async(worker2, tweets)
    results = res.get(timeout=100000)
    po.close()
    po.join()

 
 
def search(keywords):
    keyword='\" OR \"'.join(keywords)
    keyword='\"'+keyword+'\"'
    global max_id
    global min_id
    bufsize = 1
    global files
    for i in range(10):
        f=open('tweets%s.csv'%(i),'w', bufsize)
        files.append(f)
        
        
        # secret 1 xr0nXTJytnMdN7XIsoUIGNErJ5QuPJYv92VfBJnX8XI
        # cc key 1 HrI9pkJWwsdTL1jv9fDmg
        # access token key 1 19202628-uzTh3h9JB6pM07JaB4fqA4oHnWffsd1blEwApA
        # access token secret 1 bpP3m3anqew88u3MGAWPqFGElUv5RG4zFkEUDkAD2A
    # key1=[]
    # keys={1:}

    api = twitter.Api(consumer_secret='aTHfRwjbwPKHfGtBM9rwt6Qko8jHAEnnRlZ7m5muc',consumer_key='XMNiN0Aw3S74MPqhAflhpQ',access_token_key='14307977-W28juG3Irm7h14cBkWqUnSsZWsRUsw06x6h1i8iIv',access_token_secret='729lmn1hUJ4e9X4hCCDwBUGvyySDTf8fIxlCc2Htj5gxY')
    print 'API registered'
    po = mp.Pool(10)
    while(True):
    # for k in range(10):
        exceeded=False
         
        try:
            tweets_raw=api.GetSearch(keyword,since_id=max_id, result_type='popular', count=100)
            if  len(tweets_raw)<1:
                tweets_raw=api.GetSearch(keyword,max_id=min_id, result_type='popular', count=100)
        except:
            print 'COOLING DOWN'
            time.sleep(180)
            print 'RESTARTING'
            exceeded=True

        if exceeded:
            # api = twitter.Api(consumer_secret='Bn59lOCmMa4S0NJFmusK4h0y5Zhcwm5XSJ0Kfx8GWs',consumer_key='hQSiHOdR31vBbFU72GHGPw',access_token_key='106426369-qGgp2pZCtUH7jR6ZL5kY3an6mMHJUE5CMCyH7iV9',access_token_secret='fl9D8DrgEmGTwbjhzKwI2Sy2lbAAGqpC7pPkjIzMYScp6')
            continue


        ids=map(lambda x: x.AsDict()['id'], tweets_raw)
    
        if max_id< max(ids):  
            max_id=max(ids)
    
        if min_id==-1: 
            min_id=min(ids)
        elif min_id > min(ids):
            min_id=min(ids)
        
    
            
        tweets=[]
        j=0

        for tweet in tweets_raw:
           j+= 1 
           i=j % 10  
           tweets.append([i,tweet.AsDict()])    
        res = po.map_async(worker, tweets)
    results = res.get(timeout=100000)
    po.close()
    po.join()
        
 
