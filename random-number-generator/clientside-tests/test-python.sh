#!/bin/bash

PYTHON_URL="http://python.se.gmaddra.me/"

for i in `seq 1 10`; do
	rm python-output-$i.txt
	touch python-output-$i.txt
	for k in `seq 1 1000`; do
		curl $PYTHON_URL | awk '{print $1}' >> python-output-$i.txt;
	done
done

for i in `seq 1 10`; do
	echo "Test $i: $(cat python-output-$i.txt | sort | uniq | wc -l) unique numbers"
done
