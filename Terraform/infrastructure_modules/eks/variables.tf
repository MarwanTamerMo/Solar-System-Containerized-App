variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets IDS"
  type        = list(string)
}

variable "node_groups" {
  description = "EKS node groups configuration"
  type = map(object({
    instance_types = list(string)
    capacity_type  = string
    scaling_config = object({
      desired_size = number
      max_size     = number
      min_size     = number
    })
  }))
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "public_subnet_ids" {
  description = "Subnets for the EKS control plane"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "Subnets for the EKS worker nodes"
  type        = list(string)
}
