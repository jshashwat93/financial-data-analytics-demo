# financial-data-analytics-demo
An interactive demo and workshop demonstrating real-time financial data analytics using Coinbase and CoinGecko APIs, Kafka on Confluent Cloud, ksqlDB, and dashboard visualizations with Imply. Explore use cases such as crypto arbitrage and volatility analysis in a hands-on environment.

Basic Steps (Work In Progress):

Start:
[Change directory to the repo "financial-data-analytics"]
./terraform/setup-confluent-cloud.sh
docker build -t financial-data-analytics .
docker run -it --rm --name fdad-container -v $(pwd)/terraform/secrets.txt:/app/secrets.txt financial-data-analytics

Cleanup:
control + c
./terraform/destroy-confluent-cloud.sh [enter yes to confirm]
rm -f terraform/.env