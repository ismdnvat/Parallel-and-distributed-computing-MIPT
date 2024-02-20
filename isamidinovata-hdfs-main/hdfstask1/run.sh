#!/bin/bash

if [ $# -ne 1 ]; then
  exit 1
fi

hdfs_file_path=$1

fsck_output=$(hdfs fsck "$hdfs_file_path" -files -blocks -locations)

echo $fsck_output | grep -oP 'DatanodeInfoWithStorage\[\K[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | head -n 1
