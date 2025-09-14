variable "region" {
  type    = string
  default = "us-east-1"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "account_id" {
  type    = string
  default = "897722700244" # replace with your AWS account ID
  
}

variable "org" {
  type    = string
  default = "platform-org"
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
  default = ["10.10.0.0/20", "10.10.16.0/20", "10.10.32.0/20"]
}
variable "private_subnets_cidrs" {
  type    = list(string)
  default = ["10.10.48.0/20", "10.10.64.0/20", "10.10.80.0/20"]
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

#RBAC
variable "rbac_policies" {
  type        = string
  description = "CSV-formatted RBAC policies for the account"
  default = <<EOT
# Allow the account to sync ALL applications in the default project
p, proj:default, applications, sync, *, allow
# Allow the account to view apps
p, proj:default, applications, get, *, allow
# Map the account to role
g, github-actions, role:admin
EOT
}

# RDS Postgres
variable "org" {
  type    = string
  default = "platform-org"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "username" {
  type        = string
  description = "Airflow DB username"
  default     = "airflow"
}
