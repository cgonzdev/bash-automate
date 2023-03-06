#!/bin/bash

# Version: v0.0.1
# Author: cgonzdev
# Creation date: 2023-03-05

# Get the value of the environment variable 
domain=$DOMAIN 

curl -s https://api.domainsdb.info/v1/domains/search?domain=$domain | jq -r --arg execution_date "$(date +%Y-%m-%d)" '.domains[] | [$execution_date, .domain, .create_date, .update_date, .country] | @csv' > domainsdb.csv