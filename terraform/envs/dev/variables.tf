variable "region" {
  type    = string
  default = "us-east-1"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "org" {
  type    = string
  default = "yourorg"
}

variable "account_id" {
  type = string
}

variable "tfstate_bucket" {
  type = string
}

# VPC
variable "vpc_name" {
  type    = string
  default = "data-plat-vpc"
}
variable "vpc_cidr" {
  type    = string
  default = "10.10.0.0/16"
}
variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
variable "public_subnets_cidrs" {
  type    = list(string)
  default = ["10.10.0.0/20", "10.10.16.0/20", "10.10.80.0/20"]
}
variable "private_subnets_cidrs" {
  type    = list(string)
  default = ["10.10.32.0/19", "10.10.64.0/19", "10.10.96.0/19" ]
}

# EKS
variable "cluster_name" {
  type    = string
  default = "data-plat-eks-dev"
}
variable "node_instance_type" {
  type    = string
  default = "m6i.large"
}
variable "node_min_size" { 
  type = number
  default = 2 
}
variable "node_desired_size" { 
  type = number 
  default = 3 
}
variable "node_max_size" { 
  type = number
  default = 6 
}

# S3
variable "s3_prefix" {
  type    = string
  default = "yourorg-data-dev"
}

# Redshift
variable "redshift_admin_username" { 
  type = string
  default = "rsadmin" 
}
variable "redshift_admin_password" { 
  type = string
  description = "Pass via CI or secrets"

}

# ECR
variable "ecr_repo_name" { 
  type = string
  default = "airflow-platform" 
}

# IAM IRSA (pass OIDC provider ARN created from EKS)
variable "eks_oidc_provider_arn" {
  type        = string
  description = "ARN of IAM OIDC provider for EKS cluster. Create once and pass here for IRSA role creation."
  default     = ""
}
