Ambassador Usage
============================

Ambassador is designed around a declarative, self-service management model.
The core resource used to support application development teams who need to manage the
edge with Ambassador is the Mapping resource. This resource allows us to define custom
routing rules to our services.
This routing configuration can achieved by applying a custom Kubernetes Resource like
the following::

        ---
        apiVersion: getambassador.io/v2
        kind:  Mapping
        metadata:
          name:  httpbin-mapping
        spec:
          prefix: /httpbin/
          service: httpbin.httpbin_namespace


Apply this configuration with `kubectl apply -f httpbin-mapping.yaml`.

Terraform
~~~~~~~~~~~~~~~~~~~~

Since this project uses Terraform to manage resources and, with the current version, it's
still not possible to apply custom Kubernetes resource definitions, we need to add this
YAML file inside the services annotation.
One way to do this is by using Service's Metadata field::

        resource "kubernetes_service" "httpbin" {
          metadata {
            ...
            annotations = {
              "getambassador.io/config" = <<YAML
        ---
        apiVersion: getambassador.io/v2
        kind: Mapping
        name: httpbin-mapping
        service: httpbin.httpbin_namespace
        prefix: /httpbin/
        YAML
            }
          }
        }

This will produce the same behaviour as applying the custom yaml file described above.

Authentication
~~~~~~~~~~~~~~

Since we're exposing our services in the Internet, we need an Authentication and
Authorization system to prevent unwanted users to accessing our services.
Ambassador API Gateway can control the access by using an External Authentication Service
resource (AuthService).
An AuthService is an API that has a verification endpoint, which determines if the user
can access this resource (returning `200` or not, `401`).
In this project, we rely on ORY ecosystem to enable authentication.
ORY is an open-source ecosystem of services with clear boundaries that solve
authentication and authorization.