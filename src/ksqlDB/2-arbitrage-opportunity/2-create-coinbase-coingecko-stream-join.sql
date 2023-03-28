CREATE STREAM coinbase_coingecko_join
WITH (KAFKA_TOPIC='imply_coinbase_coingecko_join')
AS SELECT 
     COINBASE_BTC_STREAM.NAME,
     coinbase_btc_stream.price AS coinbase_price, 
     coingecko_btc_stream.price AS coingecko_price,
     COINBASE_BTC_STREAM.ROWTIME as event_timestamp
  FROM coingecko_btc_stream
    INNER JOIN coinbase_btc_stream WITHIN 5 seconds ON coingecko_btc_stream.name = coinbase_btc_stream.name
  EMIT CHANGES;