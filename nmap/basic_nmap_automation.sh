#!/bin/bash

# Version: v0.0.1
# Author: cgonzdev
# Creation date: 2023-03-13

# Get list IPs from IP environment variable 
ip_list=$IP_LIST 

# Get nmap arguments from environment variable
nmap_arguments=$NMAP_ARGS

# Iterate over the list of IPs
for ip in $(echo "$ip_list" | tr ',' '\n'); do
    # Run an nmap scan on the current IP and
    nmap_result=$(nmap $nmap_arguments $ip)

    # Create a file name
    file_name=$(echo "$ip" | tr '.' '_')

    # Save results to the file
    echo  "$nmap_result" > "$file_name.txt"
done
