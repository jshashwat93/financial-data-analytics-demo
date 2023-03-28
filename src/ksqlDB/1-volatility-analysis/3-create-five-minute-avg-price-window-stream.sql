CREATE STREAM average_price_stream_from_table (name varchar key, cryptocurrency_name string, five_minute_average_price double, start_period varchar, end_period varchar
) WITH (
    KAFKA_TOPIC='internal_five_minute_average_price_windowed',
    VALUE_FORMAT='AVRO',
    KEY_FORMAT='KAFKA'
);