#!/bin/bash
################################################################################
CONCURRENT_REQUESTS=100	# Number of concurrent requests
TOTAL_REQUESTS=1000  	# Total number of requests
REQUEST_SIZE=1073741824 # Size of each request data in bytes (adjust as needed)
################################################################################
OUTPUT_FILE="/output/stats.txt"
echo $(head -c $REQUEST_SIZE < /dev/urandom | base64) > temporary
ab -c $CONCURRENT_REQUESTS -n $TOTAL_REQUESTS -p temporary -T application/x-www-form-urlencoded $TARGET_URL
cat $OUTPUT_FILE
