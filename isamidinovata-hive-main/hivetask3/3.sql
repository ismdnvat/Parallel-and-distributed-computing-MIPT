ADD JAR /opt/cloudera/parcels/CDH/lib/hive/lib/hive-contrib.jar;
ADD jar /opt/cloudera/parcels/CDH/lib/hive/lib/hive-serde.jar;

USE isamidinovata;

SELECT Logs.info, count(CASE WHEN Users.sex = 'male' THEN 1 END), count(CASE WHEN Users.sex = 'female' THEN 1 END)
FROM Logs INNER JOIN Users
ON Logs.ip = Users.ip
GROUP BY Logs.info;
