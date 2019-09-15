#!/bin/bash

JAVA_URL="http://java.se.gmaddra.me/"

for i in `seq 1 10`; do
	rm java-output-$i.txt
	touch java-output-$i.txt
	for k in `seq 1 1000`; do
		curl $JAVA_URL | awk '{print $1}' >> java-output-$i.txt;
	done
done

for i in `seq 1 10`; do
	echo "Test $i: $(cat java-output-$i.txt | sort | uniq | wc -l) unique numbers"
done
