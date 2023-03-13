#!/bin/bash

# Version: v0.0.1
# Author: cgonzdev
# Creation date: 2023-03-13

# Get domains from DOMAINS environment variable, is important that they're separated by (,)
domains=$DOMAINS

# Get output name file
file=$FILENAME

# Delete the file if it exists
if [ -f "$file" ]; then
    rm "$file"
fi

# Write in the header of the file
echo "domain,created,updated" > "$file"

# Iterate the list of domains
for domain in $(echo "$domains" | tr ',' '\n')
do
  # Run whois request and get created and updated dates
  created=$(timeout 10s whois "$domain" | grep -Eim1 "Creation Date:|created:|created-date:|created date:" | awk '{print $NF}' | cut -dT -f1 | awk -F- '{print $3"/"$2"/"$1}')
  update=$(timeout 10s whois "$domain" | grep -Eim1 "Updated Date:|updated:|updated-date:|updated date:" | awk '{print $NF}' | cut -dT -f1 | awk -F- '{print $3"/"$2"/"$1}')

  if [ -z "$created" ]
    then
        echo "$domain" >> "$file"
    else
        echo "$domain,$created,$update" >> "$file"
  fi

done

echo "data successfully exported to $file"