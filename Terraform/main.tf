module "vpc" {
  source             = "./infrastructure_modules/vpc"
  project_name       = var.project_name
  vpc_cidr_block     = var.vpc_cidr_block
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  availability_zones = var.availability_zones
}

module "eks" {
  source             = "./infrastructure_modules/eks"
  project_name       = var.project_name
  vpc_id             = module.vpc.vpc_id
  cluster_name       = var.cluster_name
  cluster_version    = var.cluster_version
  subnet_ids         = module.vpc.public_subnet_ids
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids

  node_groups = {

    "${var.node_group_name}" = {
      instance_types = [var.node_instance_type]
      capacity_type  = "ON_DEMAND"
      scaling_config = {
        desired_size = var.desired_capacity
        max_size     = var.max_size
        min_size     = var.min_size
      }
    }
  }
}
