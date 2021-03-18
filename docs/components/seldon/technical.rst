Seldon technical details
========================

Custom resource
---------------

You deploy a model by creating a Custom Resource in the cluster. This resource is of type
``SeldonDeployment`` in ``machinelearning.seldon.io/v1alpha2`` API. Its documentation can be found
`here <https://docs.seldon.io/projects/seldon-core/en/v0.2.7/reference/apis/crd.html>`__.

Ingress: Ambassador
-------------------

For Seldon to expose the model to the outside, it needs an ingress controller to handle the networking. We are using `Ambassador API Gateway <https://www.getambassador.io/docs/latest/topics/install/install-ambassador-oss/>`_ which Seldon natively cooperates with.


Seldon troubleshooting
======================

Model deployment is stuck during rollout
----------------------------------------

Symptoms:
    The pod doesn't become Ready.

Possible cause:
    Kubernetes kills the container before it completes its start-up.
    This happens e.g. when Conda takes long time to create the environment.

Solution:
    In the definition of Seldon deployment, you need to specify longer timeouts
    for liveness and readiness probes (see `this SO thread <https://stackoverflow.com/a/66460408/2607426>`_). You can do it by adding this to your YAML definition::

        apiVersion: machinelearning.seldon.io/v1alpha2
        kind: SeldonDeployment
        metadata:
          name: ...
        spec:
          name: ...
          predictors:
            - graph:
                ...
              name: ...
              replicas: ...
              componentSpecs:
                - spec:
                    containers:
                      - name: classifier
                        readinessProbe:
                          failureThreshold: 10
                          initialDelaySeconds: 120
                          periodSeconds: 30
                          successThreshold: 1
                          tcpSocket:
                            port: 9000
                          timeoutSeconds: 3
                        livenessProbe:
                          failureThreshold: 10
                          initialDelaySeconds: 120
                          periodSeconds: 30
                          successThreshold: 1
                          tcpSocket:
                            port: 9000
                          timeoutSeconds: 3

