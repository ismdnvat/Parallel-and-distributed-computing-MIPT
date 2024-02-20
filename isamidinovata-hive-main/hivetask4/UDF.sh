#!/bin/bash

while read input
do
    if [[ $input =~ ^-?[0-9]+$ ]]
    then
    	number=$((input))
	echo $((number / 1024))
    else
        echo NULL
    fi
done
