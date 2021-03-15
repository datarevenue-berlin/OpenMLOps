MLFlow usage
============

Custom models
-------------

MLFlow supports multiple model formats (aka *flavors*), also a custom one - the ``pyfunc`` flavor. Having a possibility to have a custom class registered as model in MLFlow opens at least two possibilities:

- include pre- and post-processing steps in the model itself,
- deploy such model with Seldon the same way as we deploy any other model from MLFlow.

If I save my model like this::

    mlflow.pyfunc.save_model(
        path_local,
        python_model=CustomSklearnModel(),
        code_path=[
            "proprietary.py",
        ]
    )

then the files (or directories) listen in code_path will get saved and will be available to import when the model is loaded (also in Seldon).

See `MLFlow docs <https://www.mlflow.org/docs/latest/python_api/mlflow.pyfunc.html#mlflow.pyfunc.save_model>`_.

So the answer is to enclose *everything* in the model itself. Seldon doesn’t need to take part in it. MLFlow lets us save the code alongside the model, so there will be no problem with using old model with new code.

Artifact Storage
----------------

MLflow Tracking is organized around the concept of *runs*, which are executions of some piece of data science code. Each run can record **artifact information**, which are output files in any format. For example, you can record images, models or even data files as artifacts.

There are two properties related to how data is stored:

The **File Store** (exposed via ``--file-store``) is where the server will store run and experiment metadata. It defaults to the local ./mlruns directory, but when running in a server, make sure that this points to a persistent file system location.

The **Artifact Store** is a location suitable for large data (such as an S3 bucket) where clients log their artifact output (for example, models). The Artifact Store is actually a property of an Experiment, but the ``--default-artifact-root`` flag is used to set the artifact root URI for newly-created experments that do not specify one. Once an experiment is created, the ``--default-artifact-root`` is no longer relevant to it.

Credentials
^^^^^^^^^^^
For the clients and server to access the artifact location, you should configure your cloud provider credentials as normal. For example, for S3, you can set the ``AWS_ACCESS_KEY_ID`` and ``AWS_SECRET_ACCESS_KEY`` environment variables, use an IAM role, or configure a default profile in ``~/.aws/credentials``.

Amazon S3
^^^^^^^^^
Specify a URI of the form ``s3://<bucket>/<path>`` to store artifacts in S3. MLflow will obtain credentials to access S3 from your machine’s IAM role, a profile in ``~/.aws/credentials``, or the environment variables ``AWS_ACCESS_KEY_ID`` and ``AWS_SECRET_ACCESS_KEY`` depending on which of these are available. See `Set up AWS Credentials and Region for Development <https://docs.aws.amazon.com/sdk-for-java/latest/developer-guide/setup-credentials.html>`_ for more information on how to set credentials.