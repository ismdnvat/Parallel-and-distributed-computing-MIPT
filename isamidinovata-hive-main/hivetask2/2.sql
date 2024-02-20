ADD JAR /opt/cloudera/parcels/CDH/lib/hive/lib/hive-contrib.jar;
ADD jar /opt/cloudera/parcels/CDH/lib/hive/lib/hive-serde.jar;

USE isamidinovata;

SELECT query_time, COUNT(DISTINCT status) AS unique_status_count
FROM Logs
GROUP BY query_time
ORDER BY unique_status_count DESC;
