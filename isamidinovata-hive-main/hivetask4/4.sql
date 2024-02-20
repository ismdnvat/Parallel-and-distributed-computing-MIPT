add jar /opt/cloudera/parcels/CDH/lib/hive/lib/hive-contrib.jar;
add jar /opt/cloudera/parcels/CDH/lib/hive/lib/hive-serde.jar;
add file ./UDF.sh;

USE isamidinovata;

select transform(page_size)
using './UDF.sh' as size_transformer
from Logs
limit 10;
