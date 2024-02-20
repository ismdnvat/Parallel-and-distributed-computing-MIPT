ADD JAR /opt/cloudera/parcels/CDH/lib/hive/lib/hive-contrib.jar;
ADD JAR /opt/cloudera/parcels/CDH/lib/hive/lib/hive-serde.jar;

SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.exec.max.dynamic.partitions.pernode=300;
SET hive.exec.max.dynamic.partitions=1200;

USE isamidinovata;

DROP TABLE IF EXISTS user_logs;

CREATE EXTERNAL TABLE user_logs (
	    ip STRING,
	    query_time INT,
	    query STRING,
	    page_size SMALLINT,
	    status SMALLINT,
	    info STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe'
WITH SERDEPROPERTIES (
	    "input.regex" = '^(\\S+)\\t{3}(\\d{8})\\d+\\t(\\S+)\\t(\\d+)\\t(\\d+)\\t(\\S+).*$'
)
STORED AS TEXTFILE
LOCATION '/data/user_logs/user_logs_M';

DROP TABLE IF EXISTS Logs;

CREATE EXTERNAL TABLE Logs (
	    ip STRING,
	    query STRING,
	    page_size SMALLINT,
	    status SMALLINT,
	    info STRING
)
PARTITIONED BY (query_time INT)
STORED AS TEXTFILE;

INSERT OVERWRITE TABLE Logs PARTITION (query_time)
SELECT ip, query, page_size, status, info, query_time FROM user_logs;

SELECT * FROM Logs LIMIT 10;

DROP TABLE IF EXISTS Users;

CREATE EXTERNAL TABLE Users (
	    ip STRING,
	    browser STRING,
	    sex STRING,
	    age TINYINT
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY  '\t'
STORED AS TEXTFILE
LOCATION '/data/user_logs/user_data_M';

SELECT * FROM Users LIMIT 10;

DROP TABLE IF EXISTS IPRegions;

CREATE EXTERNAL TABLE IPRegions (
	    ip STRING,
	    region STRING
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY  '\t'
STORED AS TEXTFILE
LOCATION '/data/user_logs/ip_data_M';

SELECT * FROM IPRegions LIMIT 10;

DROP TABLE IF EXISTS Subnets;

CREATE EXTERNAL TABLE Subnets (
	    ip STRING,
	    mask STRING
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY  '\t'
STORED AS TEXTFILE
LOCATION '/data/subnets/variant2';

SELECT * FROM Subnets LIMIT 10;
