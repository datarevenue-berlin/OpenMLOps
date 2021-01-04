module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = local.cluster_name
  cluster_version = "1.17"
  subnets         = module.vpc.private_subnets

  tags = {
    Environment = "development"
    "deployment-date" = timestamp()
  }

  vpc_id = module.vpc.vpc_id
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
      asg_max_size                  = "2"
      asg_desired_capacity          = "2"

    },

  ]
}


data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
