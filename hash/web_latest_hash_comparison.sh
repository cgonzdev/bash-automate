#!/bin/bash

# Version: v0.0.2
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

# Calculate SHA512 hash of HTML
sha512=$(echo -n "$html" | openssl sha512 | cut -d ' ' -f 2)

# Get latest SHA512 value ​​from CSV file
last_sha512=$(tail -n 1 $csv_file | cut -d ',' -f 3)

# Compare the calculated hash with the last value ​​of the CSV file
if [ "$sha512" != "$last_sha512" ]; then
    echo "The hashes don't match for $url"
else
    echo "The hashes match for $url"
fi

# Store the new SHA512 value ​​in the CSV file
echo "$current_date,$url,$sha512" >> $csv_file