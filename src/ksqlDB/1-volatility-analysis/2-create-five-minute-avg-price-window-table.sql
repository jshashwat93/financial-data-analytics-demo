CREATE TABLE five_minute_average_price_windowed
WITH (KAFKA_TOPIC='internal_five_minute_average_price_windowed')
AS SELECT name, LATEST_BY_OFFSET(name) as cryptocurrency_name, AVG(price) as five_minute_average_price, TIMESTAMPTOSTRING(WINDOWSTART, 'HH:mm:ss', 'America/New_York') AS START_PERIOD, TIMESTAMPTOSTRING(WINDOWEND, 'HH:mm:ss', 'America/New_York') AS END_PERIOD, windowstart as START_PERIOD_TS, windowend as END_PERIOD_TS
FROM  COINGECKO_BTC_STREAM 
  WINDOW HOPPING (SIZE 300 SECONDS, ADVANCE BY 60 SECONDS)
  GROUP BY name
  EMIT CHANGES;