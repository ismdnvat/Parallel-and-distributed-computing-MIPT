#!/bin/bash

if [ $# -ne 1 ]; then
  exit 1
fi

hdfs_file_path=$1

fsck_output=$(hdfs fsck "$hdfs_file_path" -files -blocks -locations)

total_blocks=$(echo "$fsck_output" | grep 'Total blocks')

total_blocks1=$(echo "$total_blocks" | sed 's/ (avg\. block size [0-9]* B)//')

block_size=$(echo "$total_blocks1" | grep -oE '[0-9]+')
echo $block_size
