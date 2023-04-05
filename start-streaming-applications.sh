#!/bin/bash

source terraform/secrets.txt

# Color definitions
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
NC="\033[0m"

echo "Executing Volatility Analysis queries"
for file in $(ls src/ksqlDB/1-volatility-analysis | sort -n); do
    #echo "Running ${file}"
    QUERY=$(cat src/ksqlDB/1-volatility-analysis/${file})
    echo "${QUERY}" | docker run --rm -i confluentinc/ksqldb-cli:0.28.2 ksql \
        -u "${KSQL_API_KEY}" \
        -p "${KSQL_API_SECRET}" \
        "${KSQL_ENDPOINT}" > /dev/null 2>&1
    echo "Successfully executed ${file}"
done

echo -e "${GREEN}Volatility Analysis streaming application is up and running!${NC}"
echo -e "${YELLOW}----------------------------------------------${NC}"

echo "Executing Arbitrage Opportunity queries"
for file in $(ls src/ksqlDB/2-arbitrage-opportunity | sort -n); do
    #echo "Running ${file}"
    QUERY=$(cat src/ksqlDB/2-arbitrage-opportunity/${file})
    echo "${QUERY}" | docker run --rm -i confluentinc/ksqldb-cli:0.28.2 ksql \
        -u "${KSQL_API_KEY}" \
        -p "${KSQL_API_SECRET}" \
        "${KSQL_ENDPOINT}" > /dev/null 2>&1
    echo "Successfully executed ${file}"
done

echo -e "${GREEN}Arbitrage Opportunity streaming application is up and running!${NC}"

