  CREATE STREAM btc_volatility_percent
  WITH (KAFKA_TOPIC='output_bitcoin_volatility')
AS SELECT 
NAME, event_timestamp, ABS(PRICE-FIVE_MINUTE_AVERAGE_PRICE) price_fluctuation, round(ABS(PRICE-FIVE_MINUTE_AVERAGE_PRICE)/FIVE_MINUTE_AVERAGE_PRICE*100,4) VOLATILITY_PERCENT, START_PERIOD_TS, END_PERIOD_TS
  FROM current_price_join_average_price
  WHERE event_timestamp > START_PERIOD_TS and event_timestamp < END_PERIOD_TS
  EMIT CHANGES;