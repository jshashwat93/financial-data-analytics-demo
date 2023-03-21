!/bin/bash

echo "Please enter your Bootstrap Server: "
read BOOTSTRAP_SERVERS
export BOOTSTRAP_SERVERS
echo

echo "Please enter your Kafka API Key: "
read -s SASL_USERNAME
export SASL_USERNAME
echo

echo "Please enter you Kafka API Secret: "
read -s SASL_PASSWORD
export SASL_PASSWORD
echo

echo "Please enter your Schema Registry URL: "
read SCHEMA_REGISTRY_URL
export SCHEMA_REGISTRY_URL
echo

echo "Please enter your Schema Registry API Key:"
read -s SCHEMA_REGISTRY_API_KEY
echo

echo "Please enter your Schema Registry API Secret:"
read -s SCHEMA_REGISTRY_API_SECRET
echo

BASIC_AUTH_USER_INFO="${SCHEMA_REGISTRY_API_KEY}:${SCHEMA_REGISTRY_API_SECRET}"
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

