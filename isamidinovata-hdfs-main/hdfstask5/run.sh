#!/bin/bash

if [ $# -ne 1 ]; then
  exit 1
fi

size=$1

dd if=/dev/zero of=tmp.txt bs=$size count=1 >/dev/null

hdfs dfs -put tmp.txt /tmp/tmp.txt >/dev/null

hdfs dfs -setrep 1 /tmp/tmp.txt >/dev/null

size_sec=$(hdfs dfs -du /tmp/tmp.txt | grep -o ' [0-9]*'| grep -o [0-9]*)

hdfs dfs -rm /tmp/tmp.txt >/dev/null

echo $(($size_sec - $size))
