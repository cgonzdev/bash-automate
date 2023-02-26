#!/bin/bash

# Version: v0.0.1

# Get current date in dd/mm/yyyy format
current_date=$(date +%d/%m/%Y)

# Get the value of the environment variable 
keyword=$KEYWORD 

# Make the GET request to the API and save the response in a variable
response=$(curl -s https://api.opensquat.com/prod/?keyword=$keyword)

# Extract the list of domains from the response using grep and sed
opensquat_domains=$(echo $response | grep -oP '(?<=domains": \[)[^]]+' | sed 's/\"//g' | sed 's/,/\
/g')

# Write CSV file header
echo "Execution date,Domain,Creation date,Updated date" > opensquat_domains.csv

# Iterate over the list of domains
for domain in $opensquat_domains; do
    # Make a whois query and save the response in a variable
    whois_result=$(whois $domain)

    # Add a small delay to avoid overloading the whois server
    sleep 3

    # Get creation date from whois result
    creation_date=$(echo "$whois_result" | grep -Ei 'Creation Date:' | awk '{print $NF}' | cut -dT -f1 | awk -F- '{print $3"/"$2"/"$1}')

    # Check if the creation date is valid
    if [[ $creation_date =~ ^[0-9]{2}/[0-9]{2}/[0-9]{4}$ ]]; then
        # Get update date from whois result
        update_date=$(echo "$whois_result" | grep -Ei 'Updated Date:' | awk '{print $NF}' | cut -dT -f1 | awk -F- '{print $3"/"$2"/"$1}')

        # Check if the updated date is valid
        if [[ $update_date =~ ^[0-9]{2}/[0-9]{2}/[0-9]{4}$ ]]; then
            # Write domain data to CSV file
            echo "$current_date,$domain,$creation_date,$update_date" >> opensquat_domains.csv
        else
            # Assign a default value to $update_date if it is invalid
            update_date="N/A"
            # Write domain data to CSV file
            echo "$current_date,$domain,$creation_date,$update_date" >> opensquat_domains.csv
        fi
    else
        # Assign a default value to $creation_date and $update_date if they are not valid
        creation_date="N/A"
        update_date="N/A"
        # Write domain data to CSV file
        echo "$current_date,$domain,$creation_date,$update_date" >> opensquat_domains.csv
    fi
done