# Cluster Variables
variable "region" {
  default     = "eu-west-1"
  description = "AWS region"
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      userarn = "arn:aws:iam::827659017777:user/Kayibal"
      username = "Kayibal"
      groups  = ["system:masters"]
    },
    {
      userarn = "arn:aws:iam::827659017777:user/tamara"
      username = "tamara"
      groups = ["system:master"]
   },
  ]
}
