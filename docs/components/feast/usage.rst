Feast usage
===========

Feast documentation is `here <https://docs.feast.dev/>`__.
Github repository is `here <https://github.com/feast-dev/feast>`__.

.. note:: `Here <https://github.com/feast-dev/feast/blob/master/examples/hello-world/feast-hello-world.ipynb>`__ you can find an **example Jupyter notebook** that walks you through the usage of Feast.

General
-------

Feast is in some way similar to a database. There are tables (*Feature Tables*),
private keys (*Entities*, could be even compound) and columns (*Features*).

A difference is that there are always two timestamp columns which annotate each row:

- *event timestamp* column: specifies when this row began to be true;
- *created timestamp* column: specifies when this raw was ingested into the table.

With such design, it is possible go back in time and recreate the state of the world at any
given time, even after we made updates to our tables.

Please check out the example notebook for details.


Connecting to Feast
-------------------

To connect to Feast from your Python code, you instantiate a client and give it an address of
the Feast Core pod. If you do it from inside the cluster, you do it like this::

    import feast
    client = feast.Client(core_url="feast-feast-core.feast:6565", telemetry=False)


How Feast stores data
---------------------

Offline store - for training
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

For Feast to start storing your data, you must first ingest it. Ingestion is done using Python API,
using a syntax like::

    client.ingest(feature_table_object, features_dataframe)

The data is then stored in a so called *batch source* of your Feature Table. This is usually
a .parquet file (actually a set of files). You specify the location of this file when
defining your Feature Table. This location must be accessible by Feast Core pod and should be persistent, so probably cloud storage like Amazon S3 is a good choice.

Online store - for inference
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Feast can also store the data in a database for fast lookups. You can move your data from
the offline store to the online store. Please see the details in the example notebook.
