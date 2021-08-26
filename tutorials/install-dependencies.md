To set up the Open MLOps architecture, you need several dependencies on your local or client machine. If you've used Docker, Terraform, and Kubectl before, you'll likely have everything you need. If not, below are instructions for installing all the client-side dependencies on a fresh install of Ubuntu 20.04.

## Install Git

apt install git

## Install Docker

```
snap install docker
mkdir ~/.docker && echo "{}" > ~/.docker/config.json
```

## Install Terraform

Follow the instructions available at https://learn.hashicorp.com/tutorials/terraform/install-cli

## Install AWS CLI

```
apt install -y awscli
aws configure
```

## Install Kubectl

```
snap install kubectl --classic
```

## Install AWS IAM Authenticator

Follow the instructions available at https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html
