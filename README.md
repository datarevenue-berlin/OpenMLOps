# Open MLOps - A Production-focused Open-Source Machine Learning Framework

Open MLOps is a set of open-source tools carefully
chosen to ease user experience of conducting machine learning experiments and deploying machine
learning models. Read our announcement blog post with more background [here](https://datarevenue.com/en-blog/open-mlops-open-source-production-machine-learning).

We also provide a [step by step set-up guide](./tutorials/set-up-open-source-production-mlops-architecture-aws.md) and some other [getting started tutorials](./tutorials).

In this repository, we provide these applications as Terraform modules
with which the user will be able to install them into a Kubernetes
cluster. The tools we provide are the following:
- Prefect for data flow automation
- Jupyter Hub for experimenting lab
- Dask for distributed computing
- Feast for Feature Store and Serving
- MLFlow for model registry and experiment tracking
- Seldon for model deployment

![Architecture diagram](https://global-uploads.webflow.com/5d3ec351b1eba4332d213004/6001c1daafa02889e5389a59_EE2q1dQqp2fmiaXGX5vuaVVnTPXmKlmD3BC1dp90YrPB2TOiHWSq3RCCmC39MzsmYHUrQFXVK9nmTf4haQ0dIj-vdk_we67e1SR5yqEWPTuEAApuiNOXOgdr7mSefSmlZxSwu0JB.png)

# Other repositories

![Repositories diagram](http://www.plantuml.com/plantuml/svg/fP91Qpen4CNl-HI3ztNlV_u7fVHGR6d1GW_Y8IQZEvYTMJA9HKg_UwEY29MriBTaU8_vpPkPQB8nvJOO5wmgZ5wUNpk5QNGD9NGfHmHXQ8bfcrSuWYy3yCJ55OB2IPn4ofiOx4K7BcHD6A6eFNP1zkWXY2kk_RZK5eicfKx_rVM6KfDNOoTjxMrXmHroncg5CH3NRP1EAtj5KmbNbov5ieNbqdoRVlpfn_n4_XPbHqh22lR2I4T1-Khs1s3B7kZ6YCF1xQV-XVbkpBDSsZ0crFCGmzYke5XI-U8wcVU6529sOf0z7EfzAJ_Evl1mOhaHzMzWo4gyETeKuuuSWgmFUnYOCcwrEhUuYlhkNV-lgfkRC7qdDS3Kdw0n3Na4Hz45D1Dadzlm0m00)


# Modules

- [Jupyter Hub](#Jupyter-Hub)
- [Prefect](#Prefect)
- [Dask](#Dask)
- [MLFlow](#MLFlow)
- [Feast](#Feast)
- [Seldon](#Seldon)


## Jupyter Hub

With the Jupyter Hub, we enabled a multi-user environment in which each
of them can spawn a Jupyter server to do their experiments. Users can
work on different environments being able to install any library
necessary to meet their needs.

We provide a default Jupyter server image that comes with most of
the data science packages installed. Users can use their own Jupyter 
server images as well.


### Configuration

Below we provide a lists of the configurable parameters available and their
default values.


| Parameter (* *required parameter*) | Description                    | Default |
|:-----------------------------------|:-------------------------------|:--------|
| `jupyterhub_namespace`             | Namespace to install jupyterhb | `jhub`  |


#### Proxy configuration

The proxy receives the requests from the client’s browser and forwards
all requests to the Hub.
[In the JupyterHub docs](https://jupyterhub.readthedocs.io/en/stable/getting-started/security-basics.html)
you can find a more in-depth explanation.

*\* Required parameters*

| Parameter                                    | Description                                                                                                                                                                                   | Default |
|:---------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:--------|
| `jhub_proxy_https_enabled`                   | Indicator to set whether HTTPS should be enabled or not on the proxy                                                                                                                          | `false`  |
| `jhub_proxy_https_hosts`                     | You domains in list form. Required for automatic HTTPS                                                                                                                                        | `[]`    |
| `jhub_proxy_secret_token *`                  | A 32-byte cryptographically secure randomly generated string used to secure communications between the hub and the configurable-http-proxy (for example, generated by `openssl rand -hex 32`) | `nil`   |
| `jhub_proxy_https_letsencrypt_contact_email` | The contact email to be used for automatically provisioned HTTPS certificates by Let’s Encrypt                                                                                                | `""`    |

#### Authentication configuration

JupyterHub’s OAuthenticator has support for enabling your users to
authenticate via a third-party OAuth2 identity provider such as GitHub.

You can configure authentication using GitHub accounts and restrict what
users are authorized based on membership in a GitHub organization.

[See details on how to set up a GitHub Oauth here.](https://zero-to-jupyterhub.readthedocs.io/en/stable/administrator/authentication.html#github)


If you choose not to use GitHub to authenticate users, the
[DummyAuthenticator](https://tljh.jupyter.org/en/latest/howto/auth/dummy.html)
will be used as default. The Dummy Authenticator lets any user log in
with the given password.

The dummy password is: `a-shared-secret-password`.


*\* Required parameters* *\*\* Required when `oauth_github_enable` is
enabled*

| Parameter                            | Description                                                                                                        | Default |
|:-------------------------------------|:-------------------------------------------------------------------------------------------------------------------|:--------|
| `oauth_github_enable`                | Defines whether the authentication will be handled by github oauth. Required when `oauth_github_enable` is enabled | `false` |
| `oauth_github_client_id **`          | Github client id used on GitHubOAuthenticator.                                                                     | `""`    |
| `oauth_github_client_secret **`      | Github secret used to authenticate with github.                                                                    | `""`    |
| `oauth_github_admin_users`           | List of github user names to allow as administrator                                                                | `[]`    |
| `oauth_github_callback_url`          | The URL that people are redirected to after they authorize your GitHub App to act on their behalf                  | `""`    |
| `oauth_github_allowed_organizations` | List of Github organization to restrict access to the members                                                      | `[""]`  |


#### User configuration

Single user configuration refers to the default settings for each user
logged in the JupyterHub.

A user can choose a Docker image to spawn a new Jupyter server. Each
Docker image can have different libraries and environments installed. We
use the `singleuser_profile_list` parameter to set up a list of default
images available to the user. This parameter receives a list of maps
that describes the image details such as the image location and
description.

See an example:

```
[{
  display_name = "Prefect"
  description  = "Notebook with prefect installed"
  default      = true
  kubespawner_override = {
    image = "drtools/prefect:notebook-prefect"
  }
}]

```

You must pass the image pull secret if you provide an image located in a
private container registry. The image pull secret parameter is defined
as below:

```
default = [{
    name = ""
}]
```


| Parameter                       | Description                                                | Default                   |
|:--------------------------------|:-----------------------------------------------------------|:--------------------------|
| `singleuser_profile_list`       | List of images which the user can select to spawn a server |                           |
| `singleuser_image_pull_secrets` | List of image secrets                                      | nil                       |
| `singleuser_image_pull_policy`  | Image pull policy                                          | `Always`                  |
| `singleuser_memory_guarantee`   | How much memory will be guarateed to the user              | `1G`                      |
| `singleuser_storage_capacity`   | How much storage capacity a user will have                 | `1G`                      |
| `singleuser_storage_mount_path` | Storage mount path                                         | `/home/jovyan/persistent` |


## Prefect

...

| Parameter             | Description                                   | Default  |
|:----------------------|:----------------------------------------------|:---------|
| `namespace`           | Namespace name to deploy the application      | `prefect |
| `prefect_version_tag` | Configures the default tag for prefect images | `latest` |

#### Agent

According to Prefect docs, Agents are lightweight processes for orchestrating
flow runs. Agents run inside a user's architecture, and are responsible
for starting and monitoring flow runs. During operation the agent
process queries the Prefect API for any scheduled flow runs, and
allocates resources for them on their respective deployment platforms.

| Parameter                 | Description                                                                         | Default             |
|:--------------------------|:------------------------------------------------------------------------------------|:--------------------|
| `agent_enabled`           | determines if the Prefect Kubernetes agent is deployed                              | `True`              |
| `agent_prefect_labels`    | Defines what scheduling labels (not K8s labels) should be associated with the agent | `[""]`              |
| `agent_image_name`        | Defines the prefect agent image name                                                | `prefecthq/prefect` |
| `agent_image_tag`         | Defines agent image tag                                                             | `"`                 |
| `agent_image_pull_policy` | Defines the image pull policy                                                       | `Always`            |

#### Postgresql

| Parameter                        | Description                                                                                                                                                                                                                                                       | Default    |
|:---------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-----------|
| `postgresql_database`            | Defines the postgresql database name                                                                                                                                                                                                                              | `prefect`  |
| `postgresql_username`            | Defines the username to authenticate with                                                                                                                                                                                                                         | `prefect`  |
| `postgresql_existing_secret`     | Configures which secret should be referenced for access to the database.                                                                                                                                                                                          | `""`       |
| `postgresql_service_port`        | Configures the port that the database should be accessed at                                                                                                                                                                                                       | `5432`     |
| `postgresql_external_hostname`   | Defines the address to contact an externally managed postgres database instance at                                                                                                                                                                                | `""`       |
| `postgresql_use_subchart`        | Determines if a this chart should deploy a user-manager postgres database or use an externally managed postgres instance                                                                                                                                          | `true`     |
| `postgresql_persistence_enabled` | Enables a PVC that stores the database between deployments. If making changes to the database deployment, this PVC will need to be deleted for database changes to take effect. This is especially notable when the authentication password changes on redeploys. | `false`    |
| `postgresql_persistence_size`    | Defines the persistence storage size for postgres                                                                                                                                                                                                                 | `8G`       |
| `postgresql_init_user`           | Defines the initial db username                                                                                                                                                                                                                                   | `postgres` |

## Dask

...

| Parameter                          | Description                                                                              | Default        |
|:-----------------------------------|:-----------------------------------------------------------------------------------------|:---------------|
| `namespace`                        | Namespace name to deploy the application                                                 | `dask`         |
| `worker_name`                      | Dask worker name                                                                         | `worker`       |
| `worker_replicas`                  | Default number of workers                                                                | `3`            |
| `worker_image_repository`          | Containe image repository                                                                | `daskdev/dask` |
| `worker_image_tag`                 | Container image tag                                                                      | `2.30.0`       |
| `worker_image_pull_policy`         | Container image pull policy.                                                             | `IfNotPresent` |
| `worker_image_dask_worker_command` | ask worker command. E.g `dask-cuda-worker` for GPU worker.                               | `dask-worker`  |
| `worker_image_pull_secret`         | Container image pull secrets                                                             | `[{name: ""}]` |
| `worker_environment_variables`     | Environment variables. See [values.yaml](./modules/dask/values.yaml) for example values. | `[{}]`         |


## Feast

...

| Parameter                                  | Description                                   | Default |
|:-------------------------------------------|:----------------------------------------------|:--------|
| `namespace`                                | Namespace name to deploy the application      | `feast` |
| `feast_core_enabled`                       | Defines whether to install feast core         | `True`  |
| `feast_online_serving_enabled`             | Defines whether to install feast server       | `True`  |
| `feast_jupyter_enabled`                    | Defines whether to install feast jupyther hub | `False` |
| `feast_jobservice_enabled`                 | Defines whether to install feast job service  | `True`  |
| `feast_posgresql_enabled`                  | Defines whether to enable postgresql          | `True`  |
| `feast_postgresql_password *`              | Postgress password                            | `""`    |
| `feast_kafka_enabled`                      | Defines whether to enable kafka               | `False` |
| `feast_redis_enabled`                      | Defines whether to enable redis               | `True`  |
| `feast_redis_use_password`                 | Defines whether to enable redis password      | `False` |
| `feast_prometheus_enabled`                 | Defines whether to install prometheys         | `False` |
| `feast_prometheus_statsd_exporter_enabled` | Defines whether to enable statsd exporter     | `False` |
| `feast_grafana_enabled`                    | Defines whether to enable grafana             | `True`  |

## MLFlow

...

| Parameter               | Description                                                                                                                                    | Default          |
|:------------------------|:-----------------------------------------------------------------------------------------------------------------------------------------------|:-----------------|
| `namespace`             | Namespace name to deploy the application                                                                                                       | `mlflow`         |
| `db_host`               | Database host address                                                                                                                          | ``               |
| `db_username`           | Database username                                                                                                                              | `mlflow`         |
| `db_password *`         | Database password                                                                                                                              | ``               |
| `database_name`         | Database name                                                                                                                                  | `mlflow`         |
| `db_port`               | Database port                                                                                                                                  | `5432`           |
| `default_artifact_root` | local or remote filepath to store model artifacts. It is mandatory when specifying a database backend store                                    | `/tmp`           |
| `image_pull_policy`     | Docker image pull policy                                                                                                                       | `IfNotPresent`   |
| `image_repository`      | Docker image repository                                                                                                                        | `drtools/mlflow` |
| `image_tag`             | Docker image tag                                                                                                                               | `1.13.1`         |
| `service_type`          | Kubernetes service type                                                                                                                        | `NodePort`       |
| `docker_registry_server`| Docker Registry Server                                                                                                                         | ``               |
| `docker_auth_key`       | Base64 Enconded combination of {registry_username}:{registry_password}. Can be found in ~/.docker/config.json                                  | ``               |
| `docker_private_repo`   | Whether the MLFlow's image comes from a private repository or not. If `true`, `docker_registry_server` and `docker_auth_key` will be required  | `false`               |

Note: The variables `docker_registry_server` and `docker_auth_key` are optional and 
should only be used when pulling MLFlow's image from a private repository.

## Seldon

| Parameter               | Description                                    | Default       |
|:------------------------|:-----------------------------------------------|:--------------|
| `namespace`             | Namespace name to deploy the application       | `mlflow`      |
| `istio_enabled`         | Whether to install istio as ingress controller | `true`        |
| `usage_metrics_enabled` | Whether to enable usage metrics                | `true`        |


## Exposing Services
In order to access the services from outside the cluster, we need to expose them.
Usually, this is done through Kubernetes Ingress resources. In this project, since we 
rely on Seldon to expose our prediction endpoints, we use Ambassador API Gateway as our 
ingress controller. 
Seldon Core works well with Ambassador, allowing a single ingress to be used to expose 
ambassador and running machine learning deployments can then be dynamically exposed 
through seldon-created ambassador configurations.
### Ambassador
Ambassador is a Kubernetes-native API Gateway built on the Envoy Proxy. In addition to
the classical routing capabilities of an ingress, it can perform sophisticated traffic
management functions, such as load balancing, circuit breakers, rate limits, and automatic retries.
Also, it has support for independent authentication systems, such as the ORY ecosystem. 
#### Exposing a service in Ambassador
Ambassador is designed around a declarative, self-service management model. 
The core resource used to support application development teams who need to manage the 
edge with Ambassador is the Mapping resource. This resource allows us to define custom
routing rules to our services.
This routing configuration can achieved by applying a custom Kubernetes Resource like 
the following
```yaml
# mapping.yaml
---
apiVersion: getambassador.io/v2
kind:  Mapping
metadata:
  name:  httpbin-mapping
spec:
  prefix: /httpbin/
  service: httpbin.httpbin_namespace
```
By applying this configuration with `kubectl apply -f httpbin-mapping.yaml`.
### Terraform
Since this project uses Terraform to manage resources and, with the current version, it's
still not possible to apply custom Kubernetes resource definitions, we need to add this 
YAML file inside the services annotation.
One way to do this is by using Service's Metadata field 
```terraform
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
```
This will produce the same behaviour as applying the custom yaml file described above.
## Authentication
Since we're exposing our services in the Internet, we need an Authentication and 
Authorization system to prevent unwanted users to accessing our services.
Ambassador API Gateway can control the access by using an External Authentication Service 
resource (AuthService).
An AuthService is an API that has a verification endpoint, which determines if the user 
can access this resource (returning `200` or not, `401`).
In this project, we rely on ORY ecosystem to enable authentication.
ORY is an open-source ecosystem of services with clear boundaries that solve 
authentication and authorization.
### Session Lifespan
The session lifespan of authenticated users can be managed through the 
`/ory/kratos/values.yaml` file. By default, the session lifespan is 24h, 
but it is currently set to 30 days.
```yaml
kratos:
  config:
  ...
    session:
      cookie:
        domain: ${cookie_domain}
      lifespan: 720h
```
### ORY Oathkeeper
ORY Oathkeeper is an Identity and Access Proxy. It functions as a centralized way to 
manage different Authentication and Authorization methods, and inform the gateway, whether
the HTTP request is allowed or not. 
The Oathkeeper serves perfectly as an Ambassador's External AuthService. 
### Zero-Trust and Unauthorized Resources
Oathkeeper is rooted in the principle of "never trust, always verify,". This means that
if no additional configuration is provided, the Oathkeeper will always block the incoming
request. In practice, all endpoints exposed in Ambassador will be blocked by external 
requests, until further configuration is made.
### Access Rules
To configure an access rule to ORY Oathkeeper, the file `access-rule-oathkeeper.yaml` is
used. Example:
#### Allow all incoming requests
```yaml
- id: oathkeeper-access-rule
  match:
    url: <{http,https}>://${hostname}/allowed-service/<**>
    methods:
      - GET
  authenticators:
    - handler: anonymous
  authorizer:
    handler: allow
  mutators:
    - handler: noop
  credentials_issuer:
    handler: noop
```
This configuration will register all the incoming requests as a `guest` user, thus, not
performing any credentials validation. 
#### Authorize on KRATOS
```yaml
- id: httpbin-access-rule
  match:
    url: <{http,https}>://${hostname}/blocked-service/<**>
    methods:
      - GET
  authenticators:
    - handler: cookie_session
  authorizer:
    handler: allow
  mutators:
    - handler: id_token
  credentials_issuer:
    handler: noop
  errors:
    - handler: redirect
      config:
        to: http://${hostname}/auth/login
```
This configuration will force authenticating all incoming requests by checking a cookie_session,
which configuration is specified in `config-oathkeeper.yaml`
