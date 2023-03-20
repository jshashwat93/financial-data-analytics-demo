from confluent_kafka import Producer
from confluent_kafka.serialization import SerializationContext, MessageField
from confluent_kafka.schema_registry import SchemaRegistryClient
from confluent_kafka.schema_registry.avro import AvroSerializer
import os
import requests
import time
import logging

# Run the following in your terminal before running this script:
# export BOOTSTRAP_SERVERS=<Bootstrap Server>
# export SASL_USERNAME=<API Key>
# export SASL_PASSWORD=<API Secret>
# export SCHEMA_REGISTRY_URL=<Schema Registry URL>
# export BASIC_AUTH_USER_INFO=<Schema Reistry API Key>:<Schema Registry API Secret>

bootstrap_servers = os.environ['BOOTSTRAP_SERVERS']
sasl_username = os.environ['SASL_USERNAME']
sasl_password = os.environ['SASL_PASSWORD']
schema_registry_url = os.environ['SCHEMA_REGISTRY_URL']
basic_auth_user_info = os.environ['BASIC_AUTH_USER_INFO']

producer = Producer({"bootstrap.servers": bootstrap_servers,
                     'security.protocol': 'SASL_SSL', 
                     'sasl.mechanisms': 'PLAIN', 
                     'sasl.username': sasl_username, 
                     'sasl.password': sasl_password})

schema_registry_client = SchemaRegistryClient({'url': schema_registry_url, 
                                               'basic.auth.user.info': basic_auth_user_info})

schema_str = """
    {
        "type": "record",
        "name": "CryptoData",
        "fields": [
            {"name": "name", "type": "string"},
            {"name": "price", "type": "double"},
            {"name": "one_hour_price_change", "type": "double"}
        ]
    }
"""

count_avro_serializer = AvroSerializer(schema_registry_client = schema_registry_client,
                                        schema_str =  schema_str,
                                        to_dict = None)




logging.basicConfig(level=logging.ERROR, format='%(asctime)s - %(levelname)s - %(message)s')

url = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=bitcoin&price_change_percentage=1h"

# Dynamic backoff mechanism
polling_interval = 7
backoff_factor = 2
max_polling_interval = 60

while True:
    try:
        response = requests.get(url)

        if response.status_code == 200:
            data = response.json()

            if isinstance(data, list):
                for item in data:
                    try:
                        crypto_data = {
                            "name": item["name"],
                            "price": item["current_price"],
                            "one_hour_price_change": item["price_change_percentage_1h_in_currency"]
                        }

                    except Exception as e:
                        logging.error(f"Error processing data: {str(e)}. Data: {item}")

                producer.produce("coingecko-btc", 
                                 key="btc", 
                                 value=count_avro_serializer(crypto_data, SerializationContext("coingecko-btc", MessageField.VALUE)))
                producer.poll(10000)
                producer.flush()

                # Reset the polling interval after successful fetch and processing
                polling_interval = 7

            else:
                logging.error(f"Unexpected data format: {data}")

        elif response.status_code == 429:
            # Double the polling interval when the rate limit is exceeded
            polling_interval *= backoff_factor
            polling_interval = min(polling_interval, max_polling_interval)
            logging.error(f"Rate limit exceeded. Backing off for {polling_interval} seconds.")

        else:
            logging.error(f"Unexpected status code: {response.status_code}. Response: {response.text}")

    except requests.exceptions.RequestException as e:
        logging.error(f"Error fetching data from API: {str(e)}")

    except Exception as e:
        logging.error(f"Unexpected error: {str(e)}")

    time.sleep(polling_interval)

