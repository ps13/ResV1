import csv, random
import nltk
import pprint
from nltk import bigrams, trigrams
import re
from nltk.tokenize import wordpunct_tokenize
import HTMLParser
import string

import numpy
from nltk.probability import FreqDist, ConditionalFreqDist
from nltk.metrics import BigramAssocMeasures
from nltk.classify.svm import SvmClassifier
#import svmlight
from collections import defaultdict
from sklearn.metrics import f1_score,classification_report, confusion_matrix

# search patterns for features

testFeatures = \
    [('hasAddict',     (' addict',)), \
     ('hasAwesome',    ('awesome',)), \
     ('hasBroken',     ('broke',)), \
     ('hasBad',        (' bad',)), \
     ('hasBug',        (' bug',)), \
     ('hasCant',       ('cant','can\'t')), \
     ('hasCrash',      ('crash',)), \
     ('hasCool',       ('cool',)), \
     ('hasDifficult',  ('difficult',)), \
     ('hasDisaster',   ('disaster',)), \
     ('hasDown',       (' down',)), \
     ('hasDont',       ('dont','don\'t','do not','does not','doesn\'t')), \
     ('hasEasy',       (' easy',)), \
     ('hasExclaim',    ('!',)), \
     ('hasExcite',     (' excite',)), \
     ('hasExpense',    ('expense','expensive')), \
     ('hasFail',       (' fail',)), \
     ('hasFast',       (' fast',)), \
     ('hasFix',        (' fix',)), \
     ('hasFree',       (' free',)), \
     ('hasFrowny',     (':(', '):')), \
     ('hasFuck',       ('fuck',)), \
     ('hasGood',       ('good','great')), \
     ('hasHappy',      (' happy',' happi')), \
     ('hasHate',       ('hate',)), \
     ('hasHeart',      ('heart', '<3')), \
     ('hasIssue',      (' issue',)), \
     ('hasIncredible', ('incredible',)), \
     ('hasInterest',   ('interest',)), \
     ('hasLike',       (' like',)), \
     ('hasLol',        (' lol',)), \
     ('hasLove',       ('love','loving')), \
     ('hasLose',       (' lose',)), \
     ('hasNeat',       ('neat',)), \
     ('hasNever',      (' never',)), \
     ('hasNice',       (' nice',)), \
     ('hasPoor',       ('poor',)), \
     ('hasPerfect',    ('perfect',)), \
     ('hasPlease',     ('please',)), \
     ('hasSerious',    ('serious',)), \
     ('hasShit',       ('shit',)), \
     ('hasSlow',       (' slow',)), \
     ('hasSmiley',     (':)', ':D', '(:')), \
     ('hasSuck',       ('suck',)), \
     ('hasTerrible',   ('terrible',)), \
     ('hasThanks',     ('thank',)), \
     ('hasTrouble',    ('trouble',)), \
     ('hasUnhappy',    ('unhapp',)), \
     ('hasWin',        (' win ','winner','winning')), \
     ('hasWinky',      (';)',)), \
     ('hasWow',        ('wow','omg')) ]
h = HTMLParser.HTMLParser()    
def get_tweet_features(txt, filter):
  all = []
  pat = r'\b(([\w-]+://?|www[.])[^\s()<>]+(?:\([\w\d]+\)|([^%s\s]|/)))'
  pat = pat % re.escape(string.punctuation)
  txt = re.sub(pat, ' URL ', txt)
  txt = h.unescape(txt)
  #txt = re.sub('<3', ' heart ', txt)
  words = wordpunct_tokenize(txt)
  #print txt
  #print [w.lower() for w in words]
  #print ""
  
  #verniedlichungsfeature!
  
  unigram = get_word_features(words)
  all.extend(unigram)
  
  wordshape = get_word_shape_features(words)
  all.extend(wordshape)
  
  markfeatures = get_mark_features(txt, words)
  all.extend(markfeatures)
  
  specialwordfeatures = get_special_word_features(txt, words)
  all.extend(specialwordfeatures)
  
  #sentdictfeatures = get_sent_dict_features(words)
  #all.extend(sentdictfeatures)

  bigramwordfeatures = get_wordbigrams_features(words)
  all.extend(bigramwordfeatures)
  
  trigramwordfeatures = get_wordtrigrams_features(words)
  all.extend(trigramwordfeatures)
  
  emoticonfeatures = get_emoticon_features(txt)
  all.extend(emoticonfeatures)
  
  
  return dict([(f,w) for (f,w) in all if not f in filter])
def get_special_word_features(text, words):
  
  d = []
  if re.search("[HAah][HAah][HAah]+", text) or re.search("ja[ja]+", text):
    d.append(("HAHA", True))
  #else:
  # d.append(("HAHA", False))

  return d
def get_mark_features(text, words):
  d = []
  #!!!!
  #?!?
  if re.search("!!+", text):
    d.append(("EXPLANATION", True))
  #  else:
  #d.append(("EXPLANATION", False))

  if re.search("\.\.+", text):
    d.append(("DOTS", True))
#  else:
#    d.append(("DOTS", False))

  result = re.search("[?!]+", text)
  if result and ('?' in result.group(0) and '!' in result.group(0)):
    d.append(("EXPLAQUESTION", True))
#else:
#   d.append(("EXPLAQUESTION", False))

  return d
def get_word_shape_features(words):
  d = []
  upp = False
  for word in words:
    if word.isupper() and len(word)>1:
      upp = True

  if upp:
    d.append(("UPPER", upp))
  return d
def get_word_features(words):
  
  d =  [(word.lower(), True) for word in words if len(word) > 1]
    #for i in range(0,100):
  #d.append(("blubb"+str(i), False))
  return d  
def get_emoticon_features(text):
  #:D     (not split up)
  #:)     (not split up)
  #:'(    (not split up)
  #&lt;3  (split up by tokenizer)
  d = []
  if re.search("<3", text):
    d.append(("HEART", True))
  if re.search("\:\s?D", text):
    d.append(("BIGSMILE", True))
  
  #else:
  #  d.append(("HEART", False))
  return d
def get_wordbigrams_features(words):
  bigr = bigrams([w.lower() for w in words])
  #print bigr
  d = [(" ".join(b), True) for b in bigr]
  d = [(x,l) for (x,l) in d if not [p for p in string.punctuation if p in x]]
       #('#' in x or '@' in x or '\'' in x or '.' in x or ',' in x or '?' in x or '!' in x)]
  return d

def get_wordtrigrams_features(words):
  trigr = trigrams([w.lower() for w in words])
  d = [(" ".join(b), True) for b in trigr]
  d = [(x,l) for (x,l) in d if not [p for p in string.punctuation if p in x]]
  #print d
  return d
def make_tweet_dict( txt ):
    """ 
    Extract tweet feature vector as dictionary. 
    """
    txtLow = ' ' + txt.lower() + ' '

    # result storage
    fvec = {}

    # search for each feature
    for test in testFeatures:

        key = test[0]

        fvec[key] = False;
        for tstr in test[1]:
            fvec[key] = fvec[key] or (txtLow.find(tstr) != -1)

    return fvec
def is_zero_dict( dict ):
    """
    Identifies empty feature vectors
    """
    has_any_features = False
    for key in dict:
        has_any_features = has_any_features or dict[key]

    return not has_any_features




###################################
username="pinarozturk"
fp = open( '/Users/'+username+'/Dropbox/researthon/sentiment/android.csv', 'rb' )
reader = csv.reader( fp, delimiter=',', quotechar='"', escapechar='\\' )
tweets = []
for row in reader:
    try:
        tweets.append( [row[0].encode('utf-8',"replace"), row[1] ])
    except UnicodeDecodeError: 
        pass
p=0
n=0
nt=0
for i in range(0,len(tweets)):
    #print tweets[i][1]
    if tweets[i][1]=='positive':
        p+=1
    elif tweets[i][1]=='negative':
        n+=1
    else:
        nt+=1
        
print "Positive: " + str(p)
print "Negative: " + str(n)
print "Neutral: " + str(nt)
        


# Extracting features
# Using the feature set provided
#fvecs = [(make_tweet_dict(t),s) for (t,s) in tweets]

# Extracting features from data
fvecs = [(get_tweet_features(t, set()),s) for (t,s) in tweets]
#pprint.pprint(fvecs)

# Extract best word features
word_fd = FreqDist()
label_word_fd = ConditionalFreqDist()
#
for (feats, label) in fvecs:
  #print label
  for key in feats:
    #print key
    if feats[key]:
      word_fd.inc(key)
      #print word_fd
      label_word_fd[label].inc(key)
      #print label_word_fd[label]
#
##print word_fd['positive']
##print label_word_fd      
print label_word_fd.conditions()
cls_set=label_word_fd.conditions()
#
#
pos_word_count = label_word_fd['positive'].N()
print "positive word count: " + str(pos_word_count)
neg_word_count = label_word_fd['negative'].N()
print "negative word count: " + str(neg_word_count)
total_word_count = pos_word_count + neg_word_count
print "totl word count: " + str(total_word_count)
#
feature_scores = {}

for feature, freq in word_fd.iteritems():
  #print feature, freq
  pos_score = BigramAssocMeasures.chi_sq(label_word_fd['positive'][feature],
                                         (freq, pos_word_count), total_word_count)
  #print pos_score                                
  neg_score = BigramAssocMeasures.chi_sq(label_word_fd['negative'][feature],
                                         (freq, neg_word_count), total_word_count)
  #print neg_score
  feature_scores[feature] = pos_score + neg_score

#print feature_scores

sorted_feature_scores = sorted(feature_scores.iteritems(), key=lambda (w,s): s, reverse=True)
sorted_features = [w for (w,s) in sorted_feature_scores]
#print "best features:"
#for w in sorted_features[0:100]:
#  print w

print "length of sorted features: " + str(len(sorted_features))

worst = sorted_feature_scores[2000:]
#print worst
worstfeaturesfilter = set([w for w, s in worst])
#print worstfeaturesfilter

# split in to training and test sets
random.shuffle( tweets );

num_train = int(0.8 * len(tweets)) # 80% training - 20%testing
#print num_train

#filter the feature vectors:
fvecs = [(get_tweet_features(t, worstfeaturesfilter),s) for (t,s) in tweets]
#print fvecs
v_train = fvecs
#print v_train


#--------
testfp = open( '/Users/'+username+'/Dropbox/researthon/sentiment/ios.csv', 'rb' )
reader = csv.reader( testfp, delimiter=',', quotechar='"', escapechar='\\' )
testtweets = []
for row in reader:
    try:
        testtweets.append( [row[0].encode('utf-8',"replace"), row[1] ])
    except UnicodeDecodeError: 
        pass
#Extracting features from data
tfvecs = [(get_tweet_features(t, set()),s) for (t,s) in testtweets]
#pprint.pprint(fvecs)

# Extract best word features
tword_fd = FreqDist()
tlabel_word_fd = ConditionalFreqDist()
#
for (tfeats, tlabel) in tfvecs:
  #print tlabel
  for tkey in tfeats:
    #print tkey
    if tfeats[tkey]:
      tword_fd.inc(tkey)
      #print tword_fd
      tlabel_word_fd[tlabel].inc(tkey)
      #print tlabel_word_fd[label]
#
##print tword_fd['positive']
##print tlabel_word_fd      
print tlabel_word_fd.conditions()
tcls_set=tlabel_word_fd.conditions()
#
tpos_word_count = tlabel_word_fd['positive'].N()
tneg_word_count = tlabel_word_fd['negative'].N()
ttotal_word_count = tpos_word_count + tneg_word_count

tfeature_scores = {}

for tfeature, tfreq in tword_fd.iteritems():
  #print feature, freq
  tpos_score = BigramAssocMeasures.chi_sq(tlabel_word_fd['positive'][tfeature],
                                         (tfreq, tpos_word_count), ttotal_word_count)
  #print pos_score                                
  tneg_score = BigramAssocMeasures.chi_sq(tlabel_word_fd['negative'][tfeature],
                                         (tfreq, tneg_word_count), ttotal_word_count)
  #print neg_score
  tfeature_scores[tfeature] = tpos_score + tneg_score

#print feature_scores

tsorted_feature_scores = sorted(tfeature_scores.iteritems(), key=lambda (w,s): s, reverse=True)
tsorted_features = [w for (w,s) in tsorted_feature_scores]
#print "best features:"
#for w in sorted_features[0:100]:
#  print w

print "length of sorted features: " + str(len(tsorted_features))

tworst = tsorted_feature_scores[2000:]
#print worst
tworstfeaturesfilter = set([w for w, s in tworst])
#print worstfeaturesfilter

tfvecs = [(get_tweet_features(t, tworstfeaturesfilter),s) for (t,s) in testtweets]
v_test  = tfvecs
#-----

# dump tweets which our feature selector 
for i in range(0,len(tweets)):
    #print fvecs[i][0]
    if is_zero_dict( fvecs[i][0] ):
        print tweets[i][1] + ': ' + tweets[i][0]

#DIFFERENT CLASSIFIERS       
#classifier = SvmClassifier.train(v_train) # Doesn't work right now!
#classifier = nltk.classify.maxent.train_maxent_classifier_with_gis(v_train) # Ave accr: 0.69 (slow)
classifier = nltk.classify.maxent.train_maxent_classifier_with_iis(v_train) #Ave accr: 0.72 (very slow)
#classifier = nltk.classify.maxent.train_maxent_classifier_with_scipy(v_train, algorithm='BFGS') #Doesn't work on my comp!
#classifier = nltk.NaiveBayesClassifier.train(v_train) # Ave accr: 0.60(fast)


###----------------------LinearSVC------------
#from sklearn.svm import LinearSVC
#from nltk.classify.scikitlearn import SklearnClassifier
## SVM with a Linear Kernel and default parameters 
#classifier = SklearnClassifier(LinearSVC())
#classifier.train(v_train)
#
#
#test_skl = []
#t_test_skl = []
#for d in v_test:
# test_skl.append(d[0])
# #print test_skl
# t_test_skl.append(d[1])
#
## run the classifier on the train test
#p = classifier.batch_classify(test_skl)
#
## getting a full report
#print classification_report(t_test_skl, p, labels=list(set(t_test_skl)),target_names=cls_set)
##---------------------End of LinearSVC ---------

#classifier.show_most_informative_features(n=500)

refsets = defaultdict(set)
testsets = defaultdict(set)

for i, (feats, label) in enumerate(v_test):
  refsets[label].add(i)
  observed = classifier.classify(feats)
  testsets[observed].add(i)
  
#print refsets
#print testsets

print 'accuracy %f' % nltk.classify.accuracy(classifier, v_test)
print 'pos precision:', nltk.metrics.precision(refsets['positive'], testsets['positive'])
print 'pos recall:', nltk.metrics.recall(refsets['positive'], testsets['positive'])
print 'pos F-measure:', nltk.metrics.f_measure(refsets['positive'], testsets['positive'])
print 'neg precision:', nltk.metrics.precision(refsets['negative'], testsets['negative'])
print 'neg recall:', nltk.metrics.recall(refsets['negative'], testsets['negative'])
print 'neg F-measure:', nltk.metrics.f_measure(refsets['negative'], testsets['negative'])

print 'Confusion Matrix'
test_truth   = [s for (t,s) in v_test]
test_predict = [classifier.classify(t) for (t,s) in v_test]
print nltk.ConfusionMatrix( test_truth, test_predict )

dic={'positive':0, 'neutral':1, 'negative':2}
y_true=map(lambda x: dic[x], test_truth)
y_predict=map(lambda x: dic[x], test_predict)

print(classification_report(test_truth,test_predict,target_names=dic.keys()))

print f1_score(test_truth, test_predict, average='micro')

# Print wrongly classified ones
#i=0
#for (t,s) in v_test:
#  predlabel = classifier.classify(t)
#  if s != predlabel:
#    print "classified as %s but is %s" % (predlabel, s)
#    (text, label) = tweets[num_train+i]
#    print text
#    print t
#    #print classifier.explain(t)
#    print ""
#  i+=1
