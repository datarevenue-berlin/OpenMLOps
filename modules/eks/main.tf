data "aws_availability_zones" "available" {}

locals {
  cluster_name = "eks-mlops"
}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = local.cluster_name
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}



module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = local.cluster_name
  cluster_version = "1.17"
  subnets         = module.vpc.private_subnets

  tags = {
    Environment       = "development"
    "deployment-date" = timestamp()
  }

  vpc_id    = module.vpc.vpc_id
  map_users = var.map_users

  worker_groups = [
    # {
    #   name                          = "worker-group-medium"
    #   instance_type                 = "t3.medium"
    #   additional_userdata           = ""
    #   additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]

    #   #autoscaling group section
    #   asg_max_size                  = "5"
    #   asg_desired_capacity          = "1"
    # },

    {
      name                          = "worker-group-large"
      instance_type                 = "t3.large"
      additional_userdata           = ""
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_two.id]

      #autoscaling group section
      asg_max_size         = "2"
      asg_desired_capacity = "2"

    },

  ]
}


data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
