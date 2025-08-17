project_name = "sprints"

vpc_cidr_block = "10.0.0.0/16"
aws_region     = "eu-central-1"

public_subnets = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

private_subnets = [
  "10.0.3.0/24",
  "10.0.4.0/24"
]

availability_zones = [
  "eu-central-1a",
  "eu-central-1b"
]

# EKS module variables
cluster_name       = "solar-system-cluster"
node_group_name    = "sprints-node-group"
node_instance_type = "t3.medium"
desired_capacity   = 2
max_size           = 3
min_size           = 1
cluster_version    = "1.29" # or your desired EKS version
