  CREATE STREAM high_volatility_event
AS SELECT 
NAME, event_timestamp, VOLATILITY_PERCENT, START_PERIOD_TS, END_PERIOD_TS
  FROM btc_volatility_percent
  WHERE VOLATILITY_PERCENT > 0.1
  EMIT CHANGES;