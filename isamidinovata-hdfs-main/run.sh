#!/bin/bash

if [ $# -ne 1 ]; then
  exit 1
fi

block_id=$1

fsck_output=$(hdfs fsck -blockId $block_id | grep 'Block replica on datanode/rack:')
namenode=$(echo "$fsck_output" | sed 's/Block replica on datanode\/rack: //g' | awk '{print $1; exit}' | sed 's/\/default//')

path=$(ssh hdfsuser@$namenode "find /dfs -name $block_id")
echo $namenode":"$path
