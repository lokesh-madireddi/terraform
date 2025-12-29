#################################
# VPC
#################################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.1"

  name = "fitness-vpc"
  cidr = var.vpc_cidr

  azs             = ["eu-north-1a", "eu-north-1b"]
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    Project = "fitness-dashboard"
  }
}

#################################
# EKS
#################################
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.4"

  cluster_name    = var.cluster_name
  cluster_version = "1.29"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    default = {
      desired_size   = 2
      min_size       = 1
      max_size       = 3
      instance_types = [var.node_instance_type]
    }
  }

  tags = {
    Project = "fitness-dashboard"
  }
}
