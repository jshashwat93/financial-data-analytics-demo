CREATE STREAM coingecko_btc_stream (
  name VARCHAR,
  price DOUBLE,
  one_hour_price_change DOUBLE
) WITH (
  KAFKA_TOPIC='coingecko-btc',
  VALUE_FORMAT='AVRO'
);