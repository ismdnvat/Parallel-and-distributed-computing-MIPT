#!/bin/bash

mpic++ main.cpp -o a.out

> output.txt

for NUMBER in {1..8}; do
	echo "Running with $NUMBER processes"
	mpiexec --use-hwthread-cpus -n $NUMBER ./a.out $input | grep "Program working time = " >> output.txt
done

