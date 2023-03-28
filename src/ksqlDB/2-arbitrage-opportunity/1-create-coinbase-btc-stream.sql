CREATE STREAM coinbase_btc_stream (
  name VARCHAR,
  price DOUBLE
) WITH (
  KAFKA_TOPIC='coinbase-btc',
  VALUE_FORMAT='AVRO'
);