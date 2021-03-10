Feast troubleshooting
=====================

Key error when getting historical features
------------------------------------------

Symptoms
    When doing this::

        job = client.get_historical_features(
            feature_refs=[
                "driver_statistics:avg_daily_trips",
            ],
            entity_source=entities_with_timestamp
        )

    You get this::

        /opt/conda/lib/python3.8/configparser.py in get(self, section, option, raw, vars, fallback)
            790         except KeyError:
            791             if fallback is _UNSET:
        --> 792                 raise NoOptionError(option, section)
            793             else:
            794                 return fallback

        NoOptionError: No option 'historical_feature_output_location' in section: 'general'

Solution 1
    Set necessary options when creating a Client or in environment variables::

        options = {
            "HISTORICAL_FEATURE_OUTPUT_LOCATION": "file:///home/jovyan/test_data/output",
            "SPARK_STAGING_LOCATION": "file:///home/jovyan/test_data/staging"
        }
        client = Client(options)

Solution 2
    Add a proper keyword argument when calling data retrieval method::

        job = client.get_historical_features(
            feature_refs=[
                "driver_statistics:avg_daily_trips",
            ],
            entity_source=entities_with_timestamp,
            output_location="file:///home/jovyan/test_data/output",
        )


Ingestion from streaming source hangs
-------------------------------------

Symptoms
    With the following code::

        def send_avro_record_to_kafka(topic, record):
            value_schema = avro.schema.parse(avro_schema_json)
            writer = DatumWriter(value_schema)
            bytes_writer = io.BytesIO()
            encoder = BinaryEncoder(bytes_writer)
            writer.write(record, encoder)
            producer = Producer({
                "bootstrap.servers": KAFKA_BROKER,
            })
            producer.produce(topic=topic, value=bytes_writer.getvalue())
            producer.flush()

        for record in trips_df.drop(columns=['created']).to_dict('record'):
            record["datetime"] = (
                record["datetime"].to_pydatetime().replace(tzinfo=pytz.utc)
            )

            send_avro_record_to_kafka(topic="driver_trips", record=record)

    function ``send_avro_record_to_kafka`` takes forever to complete.

Solution
    This function actually does complete - but takes a very long time. The problem is with ``producer.flush()``.

    Adding ``flush()`` makes the client wait for any outstanding messages to be delivered to the broker (and this will be around ``queue.buffering.max.ms``, plus latency).
    If you add ``flush()`` after each ``produce()`` call you are effectively implementing a sync producer (which you shouldn't). Because synchronous producing is a performance killer and scales very poorly, it is effectively bound by network and broker latency. If the round-trip to produce a message is 2ms the maximum achievable rate is 500 messages per second. In scenarios where the broker or network is getting slower for whatever reason this rate decreases even more, possibly causing back pressure in the application affecting the upstream data source.

    It is thus better to design the application to use asynchronous sends and use the delivery report callback to take action when the message is finally delivered or fails permanently.

    Thus, this command can be reimplemented as::

        writer = DatumWriter(value_schema)
        bytes_writer = io.BytesIO()
        encoder = BinaryEncoder(bytes_writer)
        producer = Producer({
            "bootstrap.servers": KAFKA_BROKER,
        })

        for record in trips_df.drop(columns=['created']).to_dict('record'):
            record["datetime"] = (
                record["datetime"].to_pydatetime().replace(tzinfo=pytz.utc)
            )
            print(record)

            value_schema = avro.schema.parse(avro_schema_json)
            writer.write(record, encoder)
            producer.produce(topic="driver_trips", value=bytes_writer.getvalue())

        producer.flush()

