CREATE STREAM arbitrage_opportunity
  WITH (KAFKA_TOPIC='output_arbitrage_opportunity')
  AS SELECT name, ARBITRAGE_PERCENT, TIMESTAMPTOSTRING(ROWTIME, 'yyyy-MM-dd HH:mm:ss.SSS','America/New_York') as arbitrage_time
  FROM COINBASE_COINGECKO_ARBITRAGE_STREAM
  WHERE ARBITRAGE_PERCENT > 0.15;