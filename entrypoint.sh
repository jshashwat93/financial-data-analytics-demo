#!/bin/bash

source ./secrets.txt
export BOOTSTRAP_SERVERS
export SASL_USERNAME
export SASL_PASSWORD
export SCHEMA_REGISTRY_URL
export BASIC_AUTH_USER_INFO

echo -e "\033[1;33m================================================================================\033[0m"
echo -e "\033[1;92m🚀 Our producers are up and running! 🚀\033[0m"
echo -e "\033[1;93m👀 Keep an eye on the topics:\033[0m"
echo -e "\033[1;94m  - 'coinbase-btc'\033[0m"
echo -e "\033[1;94m  - 'coingecko-btc'\033[0m"
echo -e "\033[1;93min your \033[1;95mConfluent Cloud cluster\033[0m for \033[1;96mreal-time financial data analytics!\033[0m"
echo -e "\033[1;92m🎓 Get ready to explore use cases such as:\033[0m"
echo -e "\033[1;96m  - Crypto arbitrage\033[0m"
echo -e "\033[1;96m  - Volatility analysis\033[0m"
echo -e "\033[1;92min a hands-on environment! 🌟\033[0m"
echo -e "\033[1;33m================================================================================\033[0m"

python coinbase-btc.py & python coingecko-btc.py

wait

