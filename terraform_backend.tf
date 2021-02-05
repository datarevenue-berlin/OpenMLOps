// There is no easy way of switching between Terraform backend types (such as `local` or `s3`). The only way for now
// is to comment out one block and uncomment another. After such operation, you must run:
//     terraform init --reconfigure
// to start using a new backend. `--reconfigure` flag tells terraform to NOT try to move state file from the previous
// backend to the new one. Omit it if you want to move the data.
//
// Changing a backend may be useful if you first want to test things locally (e.g. against minikube) and store
// the state file locally as well, but then you want to move to staging or production and store the state file remotely
// to share it with others.
//
// Switching a workspace (`terraform workspace select`) does not change the backend. State files for all workspaces
// will be stored in a currently configured backend. If you want to use different backends for different workspaces,
// use must manually change the backend.
// Seel related issue: https://github.com/hashicorp/terraform/issues/16627

terraform {
  backend "s3" {
    bucket = "eks-mlops-tf-state"
    key = "mlops-dev.tfstate"
    region = "eu-west-1"
  }
//  backend "local" {}
}