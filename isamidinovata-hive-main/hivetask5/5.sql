ADD JAR /opt/cloudera/parcels/CDH/lib/hive/lib/hive-contrib.jar;

USE isamidinovata;

SELECT TRANSFORM(ip, query_time, query, page_size, status, info)
USING "sed 's/http/ftp/g'" AS ip, query_time, query, page_size, status, info
FROM Logs
LIMIT 10;
