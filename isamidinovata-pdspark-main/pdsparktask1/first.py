import re 
from pyspark import SparkContext, SparkConf 


config = SparkConf().setAppName("first task").setMaster("yarn")
sc = SparkContext(conf = config)

rdd = sc.textFile("/data/wiki/en_articles_part") 
rdd = rdd.map(lambda x: x.strip().lower()) 

rdd = rdd.map(lambda x: re.sub("narodnaya\W+", "narodnaya_", x)).flatMap(lambda x: x.split(" ")) 
rdd = rdd.map(lambda x: re.sub("^\W+|\W+$", "", x)) 
rdd = rdd.filter(lambda x: "narodnaya" in x) 
rdd = rdd.map(lambda x: (x, 1)).reduceByKey(lambda x, y: x + y)
rdd = rdd.sortByKey(ascending=True) 

final_result = rdd.collect() 
for bigram, count in final_result: 
    print bigram, count
