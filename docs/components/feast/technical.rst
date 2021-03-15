Feast technical details
=======================

Components of the deployment
----------------------------

Feast components are:

- Feast Core: this is where the clients connect
- Postgresql: stores metadata about your Feature Tables
- Jobservice
- Online Serving
- Redis: stores data for fast online serving

Requirements for working with Feast
-----------------------------------

To *connect* to Feast Core from e.g. a Jupyter notebook, you just need to ``pip install feast``.

However, to *retrieve* the data, you need to have Spark installed and configured so that it can
be used by the Feast Client. This documentation doesn't provide details on how to configure Spark,
but you can use existing solutions.

**TODO:** MLOps Architecture provides a Docker image for Jupyterhub that has Spark installed
and can be used to retrieve data from Feast.

.. hint::
    Jupyter image included in `feast example <https://github.com/feast-dev/feast/tree/master/infra/docker-compose>`_ is based on https://hub.docker.com/r/jupyter/pyspark-notebook. Dockerfile: https://github.com/jupyter/docker-stacks/blob/master/pyspark-notebook/Dockerfile

    Docs on Feast+Spark: https://docs.feast.dev/reference/feast-and-spark

**TODO:** We also provide a base Python image (without Jupyter) with Spark installed.
