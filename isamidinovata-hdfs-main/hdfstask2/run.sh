#!/bin/bash

if [ $# -ne 1 ]; then
  exit 1
fi

file_url="http://mipt-master.atp-fivt.org:50070/webhdfs/v1"
file_url+="$1"
file_url+="?op=OPEN"

result=$(curl --silent -i "$file_url" | grep -o 'Location: .*')
location=$(echo "$result" | grep -o 'http://[^ ]*')
location=$(echo "$location" | tr -d '[:space:]')

new_location="${location}&length=10"

firt_ten_bytes=$(curl --silent "${new_location}")

echo "$firt_ten_bytes"
