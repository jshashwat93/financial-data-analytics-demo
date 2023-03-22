from confluent_kafka import Producer
from confluent_kafka.serialization import SerializationContext, MessageField
from confluent_kafka.schema_registry import SchemaRegistryClient
from confluent_kafka.schema_registry.avro import AvroSerializer
from confluent_kafka.admin import AdminClient, NewTopic
import os
import requests
import time

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
        "name": "BitcoinPriceUpdate",
        "namespace": "com.example",
        "fields": [
            { "name": "name", "type": "string" },
            { "name": "price", "type": "double" }
        ]
    }
"""

count_avro_serializer = AvroSerializer(schema_registry_client = schema_registry_client,
                                        schema_str =  schema_str,
                                        to_dict = None)

admin_client = AdminClient({"bootstrap.servers": bootstrap_servers,
                     'security.protocol': 'SASL_SSL', 
                     'sasl.mechanisms': 'PLAIN', 
                     'sasl.username': sasl_username, 
                     'sasl.password': sasl_password})

admin_client.create_topics([NewTopic(
        "coinbase-btc",
        num_partitions=1,
        replication_factor=3
)])

while True:
    url = "https://api.coinbase.com/v2/prices/BTC-USD/spot"
    response = requests.get(url)

    if response.status_code == 200:
        data = response.json()
        crypto_data = {"name": "Bitcoin", "price": float(data["data"]["amount"])}

        producer.produce("coinbase-btc", 
                    key="btc", 
                    value=count_avro_serializer(crypto_data, SerializationContext("coinbase-btc", MessageField.VALUE)))
        producer.poll(10000)
        producer.flush()
        time.sleep(10)
    else:
        print("Error: Unable to fetch data from Coinbase API.")


    


