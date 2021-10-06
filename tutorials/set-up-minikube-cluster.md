# Set up your Minikube cluster in under 30 minutes

## Step 1: Cloning the repositories

On your local machine, create a directory called `openmlops` and clone the following three Open MLOps repositories into that directory.

```
git clone git@github.com:datarevenue-berlin/OpenMLOps.git
```

## Step 2: Starting a minikube cluster locally

After you install minikube as described [here](https://minikube.sigs.k8s.io/docs/start/), you can start your minikube cluster by running:

```
minikube start --kubernetes-version=v1.17.17
```

Then, start a [minikube tunnel](https://minikube.sigs.k8s.io/docs/handbook/accessing/#using-minikube-tunnel) by running:

```
minikube tunnel
```

## Step 3: Create a `my_vars.tfvars` file

Next you'll need to personalise the secrets and other values in the tfvars file. You can create  a file in `openmlops/OpenMLOps/my_vars.tfvars` and use the example settings below.


```
aws = false
db_username = "mlflow-db-user"
db_password = "mlflow-db-pasword"
hostname = "myambassador.com"
ory_kratos_cookie_secret = "secret"
ory_kratos_db_password = "password"
install_metrics_server = false
install_feast = false
install_seldon = false
prefect_create_tenant_enabled = false
jhub_proxy_secret_token = "IfYouDecideToUseJhubProxyYouShouldChangeThisValueToARandomString"
enable_ory_authentication = false
oauth2_providers = []
mlflow_artifact_root = "/tmp"
```

## Step 4: Initialising Terraform

Run the following in your shell to set your Kubectl config.

```
export KUBE_CONFIG_PATH=~/.kube/config
```

Now change into the `OpenMLOps` directory and run `terraform init`, which will pull down the terraform dependencies that you need.

You should see "Terraform has been successfully initialized!" towards the end of the output.

### Initialising the Kubernetes secrets
Before you continue with the next steps of Terraform, you need to generate some secrets for Kubernetes by using the following commands:

```
sh generate_secrets.sh
```

## Step 5: Creating the infrastructure

Now you can run

```
terraform apply -var-file=my_vars.tfvars
```

Note that this step will actually create the resources on your minikube cluster.

Enter `yes` when prompted and wait for everything to create. You can follow along as it makes progress, or go make coffee and wait for it to finish.

## Step 6: Creating Prefect tenant

Prefect tenant is not created automatically when running on minikube. To create a tenant, following the following steps:

- Install prefect locally

```
pip install prefect
```

- In another terminal session, port forward the graphql

```
kubectl port-forward -n prefect svc/prefect-server-apollo 4200
```

- Run the command below to create a tenant. You should see a message that a tenant is created.

```
prefect backend server && prefect server create-tenant --name default --slug default
```

## Trying out the services

The first step is to look at the service addresses and ports available. Run the command

```
kubectl get services --all-namespaces
```

You should look for the `EXTERNAL_IP` and `PORT` of the `LoadBalancer` services you want to access. For example,

* `http://[EXTERNAL_IP_OF_JUPYTER_HUB_PROXY_PUBLIC]:80` to start writing code in your setup
* `http://[EXTERNAL_IP_OF_PREFECT_UI]:8080` to configure workflow and dataflows
* `http://[EXTERNAL_IP_OF_MLFLOW]:5000` to see and track your experiments

Next, take a look at [our tutorial](./basic-usage-of-jupyter-mlflow-and-prefect.md) on creating a basic production machine learning system using the Open MLOps architecture.

## Tearing down the cluster

To destroy all the resources, run the following command:

```
terraform destroy -var-file=my_vars.tfvars
```

To delete the minikube cluster, run the following commands:

```
minikube stop
minikube delete
```

## Troubleshooting

### Terraform keeps waiting on resources to become ready and then fails

This may be caused by External IPs not being assigned to the services that expect them.
- Do you have `minikube tunnel` running? Isn't it asking for sudo password?
- On Macs, when using Docker driver to run minikube, `minikube tunnel` doesn't behave very well. Try using e.g. Virtualbox. Please refer to `minikube` documentation.

### Kubectl hangs, Terraform exits with `the server was unable to return a response in the time allotted, but may still be processing the request`

You may have allocated too little resources for the minikube cluster. Try starting the cluster with:
```commandline
minikube start --kubernetes-version=v1.17.17 --memory 8192 --cpus 2
```
