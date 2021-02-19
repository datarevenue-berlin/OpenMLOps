Architecture Overview
*************************


The MLOps reference architecture is a set of open-source tools carefullychosen to ease user experience of experimenting and deploying machinelearning models. The tools consist of the following:

* **Prefect** for data flow automation
* **Jupyter Hub** for experimenting lab
* **Dask** for distributed computing
* **Feast** for Feature Store and Feature Serving
* **MLFlow** for model registry and experiment tracking
* **Seldon Core** for model deployment


.. image:: components.png
    :width: 500px
    :align: center
    :height: 100px

Jupyter Hub
############

With Jupyter Hub, we enabled a multi-user environment in which each user can spawn a Jupyter server to do their experiments. Users can work on different environments being able to install any library necessary to meet their needs. We also provide a default Jupyter server image that comes with most ofthe data science packages installed.

Prefect
############

We use Prefect as our task orchestration tool. This helps us model, schedule and run each task and the dependencies between them. Workflows can be run locally or on the Prefect server.

Usage Example
==============

First, the tasks are defined as follows, where each task can be dependent on or be dependencies of other tasks.

.. code-block:: python

    from prefect import task, Task, Flow

    @task
    def download_dataset(data_dir):
        """Download the MNIST data set to the KFP volume to share it among all steps"""

        # DOWNLOAD DATASET CODE GOES HERE

        return dataset

    @task
    def train_model(dataset):
        """Trains a single-layer CNN for 5 epochs using a pre-downloaded dataset.

        # MODEL TRAINING CODE GOES HERE

        return model


These classes are then used to define the flow, setting dependencies as follows.

.. code-block:: python

    with Flow('My Functional Flow') as flow:
        dataset = download_dataset(data_dir)
        model = plus_one(dataset=dataset)

    flow.run()


.. image:: flow.png
    :width: 200px
    :align: center
    :height: 100px

Feast
#######

Feast is an open source feature store for machine learning. Feature stores let you keep track of the features you use to train your models. They’re a relatively new concept, but they’re increasingly popular. Every feature can be stored, versioned, and organized in your feature store. This pre-prepared data can then easily be used to train other models in the future. As a result, you’ll avoid calculating the datasets repeatedly.

MLFlow
########

We use MLFlow as our model registry.  With MLFlow you can have all the versions of your model stored in a central place, annotated with comments and evaluation metrics, so that you don’t get lost in all your trials and errors.

Usage Example
===============

.. code-block:: python

    with mlflow.start_run():
        lr = ElasticNet(alpha=alpha, l1_ratio=l1_ratio, random_state=42)
        lr.fit(train_x, train_y)

        predicted_qualities = lr.predict(test_x)

        (rmse, mae, r2) = eval_metrics(test_y, predicted_qualities)

        mlflow.log_param("alpha", alpha)
        mlflow.log_param("l1_ratio", l1_ratio)
        mlflow.log_metric("rmse", rmse)
        mlflow.log_metric("r2", r2)
        mlflow.log_metric("mae", mae)

        mlflow.sklearn.log_model(lr, "model", registered_model_name="ElasticnetWineModel")


Seldon Core
#############

Seldon Core is an open source platform for deploying machine learning models on a Kubernetes cluster. Seldon makes your model available for your clients over the network, so that they can use it to make predictions. Seldon Core makes it easy to update the live model, so your clients won’t experience any downtime while you deploy a new version.

Usage Example
==============

After creating a Seldon Deployment, the endpoint can be accessed as follows.

.. code-block:: bash

    curl -s  \
    http://localhost:8003/seldon/seldon/seldon-deployment-example/api/v0.1/predictions \
    -H "Content-Type: application/json" -d  \
    '{"data":{"ndarray":[[5.964,4.006,2.081,1.031]]}}' \

To which the output should be:

.. code-block:: json

    {"data":{"names":["t:0","t:1","t:2"],"ndarray":[[0.9548873249364059,0.04505474761562512,5.792744796895372e-05]]},"meta":{}}

