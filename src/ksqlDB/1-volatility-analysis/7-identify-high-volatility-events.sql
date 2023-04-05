  CREATE STREAM high_volatility_events
  WITH (KAFKA_TOPIC='output_high_volatility_events')
AS SELECT 
NAME, event_timestamp, VOLATILITY_PERCENT, START_PERIOD_TS, END_PERIOD_TS
  FROM btc_volatility_percent
  WHERE VOLATILITY_PERCENT > 0.05
  EMIT CHANGES;