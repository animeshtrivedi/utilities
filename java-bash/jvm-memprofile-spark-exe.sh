#!/bin/bash
# This script waits for a spark executor to appear and then calls the 
# jvm-memprofile.sh 
# Author: Animesh Trivedi 
#         atr@zurich.ibm.com

id=$(jps -l 2>&1 | grep CoarseGrainedExecutorBackend | head -1 | awk '{print $1}')
while [[ ! $id ]]; do 
	id=$(jps -l 2>&1 | grep CoarseGrainedExecutorBackend | head -1 | awk '{print $1}')
	echo "waiting for a spark executor to appear..."
	sleep 1 
done
echo "found an executor with $id PID (if there are more than 1, then this is the first one)"
./jvm-memprofile.sh $id
