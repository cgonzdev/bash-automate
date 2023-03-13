#!/bin/bash

# Version: v0.0.1
# Author: cgonzdev
# Creation date: 2023-03-13

# Get current date in dd/mm/yyyy format
current_date=$(date +%d/%m/%Y)

# Website URL
url=$URL

# Name of the file where the hashes will be stored
csv_file=$FILE

# Get website HTML file
html=$(curl -s $url)

# Calculate MD5 and SHA256 hash of HTML
md5=$(echo -n "$html" | openssl md5 | cut -d ' ' -f 2)
sha256=$(echo -n "$html" | openssl sha256 | cut -d ' ' -f 2)

# Get latest MD5 and SHA256 values ​​from CSV file
last_md5=$(tail -n 1 $csv_file | cut -d ',' -f 3)
last_sha256=$(tail -n 1 $csv_file | cut -d ',' -f 4)

# Compare the calculated hashes with the last values ​​of the CSV file
echo $sha256
echo $last_sha256
if [ "$md5" != "$last_md5" ] || [ "$sha256" != "$last_sha256" ]; then
    echo "The hashes don't match for $url"
else
    echo "The hashes match for $url"
fi

# Store the new MD5 and SHA256 values ​​in the CSV file
echo "$current_date,$url,$md5,$sha256" >> $csv_file