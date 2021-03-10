Usage of Prefect
================

How Prefect works
-----------------

1. You write your pipeline as a set of Prefect *Tasks*.
2. You connect the Tasks into a graph called a *Flow*.
3. You register the Flow in Prefect *Server*.
4. Prefect *Agent* runs your Flow at a given schedule or when you request it.

Register a flow
---------------

.. code-block:: python

    import prefect
    from prefect import task, Flow

    @task
    def say_hello():
        logger = prefect.context.get("logger")
        logger.info("Hello, Cloud!")

    with Flow("hello-flow") as flow:
        say_hello()

    # Register the flow under the "tutorial" project
    flow.register(project_name="tutorial")

When a flow is registered, the following steps happen:

- The flow is validated to catch common errors
- The flow's source is serialized and stored in the flow's Storage on your infrastructure. What this entails depends on the type of Storage used. Examples include building a `docker image <https://docs.prefect.io/orchestration/flow_config/storage.html#docker>`_, saving the code to an `S3 bucket <https://docs.prefect.io/orchestration/flow_config/storage.html#aws-s3>`_, or referencing a `GitHub repository <https://docs.prefect.io/orchestration/flow_config/storage.html#github>`_.
- The flow's **metadata** is packaged up and sent to the Prefect Backend.

Note that the the Prefect Backend only receives the flow metadata (name, structure, etc...) and *not* the actual source for the flow. Your flow code itself remains safe and secure on your infrastructure.

Configure Flow Storage
----------------------

``Storage`` objects define where a Flow's definition is stored. Examples include things like ``Local`` storage or ``S3``. **Flows themselves are never stored directly in Prefect's backend; only a reference to the storage location is persisted.** This helps keep your flow's code secure, as the Prefect servers never have direct access.

To configure a Flow's storage, you can either specify the ``storage`` as part of the ``Flow`` constructor, or set it as an attribute later before calling ``flow.register``. For example, to configure a flow to use ``Local`` storage:

.. code-block:: python

    from prefect import Flow
    from prefect.storage import Local

    # Set storage as part of the constructor
    with Flow("example", storage=Local()) as flow:
        ...

    # OR set storage as an attribute later
    with Flow("example") as flow:
        ...

    flow.storage = Local()

As of Prefect version ``0.9.0`` every storage option except for ``Docker`` and ``GitHub`` will automatically have a result handler attached that will write results to the corresponding platform. This means that if you register a flow with the Prefect API using the S3 storage option then the **flow's results will also be written to the same S3 bucket** through the use of the `S3 Result <https://docs.prefect.io/api/latest/engine/results.html#s3result>`_.

`S3 Storage <https://docs.prefect.io/api/latest/storage.html#s3>`_ is a storage option that uploads flows to an AWS S3 bucket.

.. code-block:: python

    from prefect import Flow
    from prefect.storage import S3

    flow = Flow("s3-flow", storage=S3(bucket="<my-bucket>"))

    flow.storage.build()

The flow is now available in the bucket under ``s3-flow/slugified-current-timestamp``.

More storage options found `here <https://docs.prefect.io/orchestration/execution/storage_options.html#gitlab>`__.


Define an Imperative Flow
-------------------------

First, the tasks are defined in classes as follows, where each class represents one individual task, which can be dependent on or be dependencies of other tasks.

.. code-block:: python

    from prefect import Task, Flow

    DIR_DATA = "data"
    PATH_MODEL = "MNISTClassifier.h5"

    class DownloadDataset(Task):
        def run(self, data_dir: str):
            # DOWNLOAD DATASET CODE GOES HERE

    class TrainModel(Task):
        def run(self, data_dir: str, model_dir: str):
            # MODEL TRAINING CODE GOES HERE
            model.save(PATH_MODEL)

These classes are then used to define the flow, setting dependencies as follows:

.. code-block:: python

    from prefect import Task, Flow

    flow = Flow('My Imperative Flow')

    download_dataset = DownloadDataset()
    train_model = TrainModel()
    evaluate_model = EvaluateModel()

    flow.set_dependencies(
        task=evaluate_model,
        upstream_tasks=[train_model],
        keyword_tasks=dict(data_dir="", model_dir="", metrics_path="")
    )

    flow.set_dependencies(
        task=train_model,
        upstream_tasks=[download_dataset],
        keyword_tasks=dict(data_dir="", model_dir="")
    )

    flow.set_dependencies(
        task=download_dataset,
        keyword_tasks=dict(data_dir="")
    )

    flow.visualize()

.. image:: /images/flow.png
    :align: center
    :height: 200px

In order to run the flow, we use ``flow.run()`` in the place of ``flow.visualize()``.

The success of the run can be asserted from inside the script as follows::

    state = flow.run()
    assert state.is_successful()
