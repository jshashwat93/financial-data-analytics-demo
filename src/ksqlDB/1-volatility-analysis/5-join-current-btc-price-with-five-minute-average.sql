  CREATE STREAM current_price_join_average_price
   WITH (KAFKA_TOPIC='internal_join_avg_price_and_current_price')
  AS SELECT 
	COINGECKO_BTC_STREAM.NAME,
	COINGECKO_BTC_STREAM.price,
     FROM_UNIXTIME(COINGECKO_BTC_STREAM.ROWTIME) as event_timestamp,
     average_price_stream_rekeyed.START_PERIOD_TS, average_price_stream_rekeyed.END_PERIOD_TS,
     average_price_stream_rekeyed.FIVE_MINUTE_AVERAGE_PRICE
  FROM coingecko_btc_stream
    INNER JOIN average_price_stream_rekeyed WITHIN 10 seconds ON coingecko_btc_stream.name = average_price_stream_rekeyed.CRYPTOCURRENCY_NAME
  EMIT CHANGES;