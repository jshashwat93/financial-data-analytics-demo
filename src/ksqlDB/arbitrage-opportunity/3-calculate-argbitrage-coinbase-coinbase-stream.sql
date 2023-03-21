CREATE STREAM coinbase_coingecko_arbitrage_stream
  AS SELECT  round(ABS(COINBASE_PRICE - COINGECKO_PRICE)/coinbase_price,4) as arbitrage_percent,
  COINBASE_BTC_STREAM_NAME as name
  FROM COINBASE_COINGECKO_JOIN
  EMIT CHANGES;