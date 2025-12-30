#######################################
# VPC
########################################
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

########################################
# EKS Cluster
########################################
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.4"

  cluster_name    = var.cluster_name
  cluster_version = "1.29"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # 🔑 IMPORTANT: Enable public endpoint access
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = false

  # EKS Managed Node Group
  eks_managed_node_groups = {
    default = {
      name           = "default-node-group"
      desired_size   = 1
      min_size       = 1
      max_size       = 2
      instance_types = [var.node_instance_type]
      capacity_type  = "ON_DEMAND"
    }
  }

  tags = {
    Project = "fitness-dashboard"
  }
}
