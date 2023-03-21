#!/bin/bash

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

echo -e "\e[1;33m######################################################################\e[0m"
echo -e "\e[1;33m#\e[0m                                                                   \e[1;33m#\e[0m"
echo -e "\e[1;33m#\e[0m  \e[1;32m$$$$$$$\\  $$$$$$\\  $$\\   $$\\ $$$$$$$$\\ $$$$$$$$\\ $$$$$$\\  \e[1;33m#\e[0m"
echo -e "\e[1;33m#\e[0m  \e[1;32m$$  __$$\\$$  __$$\\ $$ | $$  |$$  _____|$$  _____|\\_$$  _| \e[1;33m#\e[0m"
echo -e "\e[1;33m#\e[0m  \e[1;32m$$ |  $$ |$$ /  $$ |$$ |$$  / $$ |      $$ |        $$ |   \e[1;33m#\e[0m"
echo -e "\e[1;33m#\e[0m  \e[1;32m$$ |  $$ |$$ |  $$ |$$$$$  /  $$$$$\\    $$$$$\\      $$ |   \e[1;33m#\e[0m"
echo -e "\e[1;33m#\e[0m  \e[1;32m$$ |  $$ |$$ |  $$ |$$  _$$<   $$  __|   $$  __|     $$ |   \e[1;33m#\e[0m"
echo -e "\e[1;33m#\e[0m  \e[1;32m$$$$$$$  |$$$$$$$  |$$ | \\$$\\  $$$$$$$$\\ $$$$$$$$\\   $$ |   \e[1;33m#\e[0m"
echo -e "\e[1;33m#\e[0m  \e[1;32m\\_______/ \\_______/ \\__|  \\__| \\________|\\________|  \\__|   \e[1;33m#\e[0m"
echo -e "\e[1;33m#\e[0m                                                                   \e[1;33m#\e[0m"
echo -e "\e[1;33m#\e[0m  \e[1;32mStarting Coinbase and Coingecko Producers...\e[0m                                     \e[1;33m#\e[0m"
echo -e "\e[1;33m#\e[0m  \e[1;36mKeep an eye on the 'coinbase-btc' and 'coingecko-btc' topics in your Confluent Cloud cluster to see real-time financial data analytics in action!\e[0m   \e[1;33m#\e[0m"
echo -e "\e[1;33m#\e[0m  \e[1;34mGet ready to explore use cases such as crypto arbitrage and volatility analysis in a hands-on environment!\e[0m                       \e[1;33m#\e[0m"
echo -e "\e[1;33m#\e[0m                                                                   \e[1;33m#\e[0m"
echo -
python coinbase-btc.py & python coingecko-btc.py

wait

