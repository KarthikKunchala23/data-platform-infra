variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "oidc_provider_url" {
  type        = string
  description = "OIDC provider URL for EKS cluster"
}


variable "service_account_name" {
  type        = string
  description = "Kubernetes service account name for the AWS Load Balancer Controller"
  default     = "aws-load-balancer-controller"
}

variable "region" {
  type        = string
  description = "AWS region where the EKS cluster is deployed"
  
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the EKS cluster is deployed"
  
}

variable "create_oidc_provider" {
  type        = bool
  description = "Whether to create a new OIDC provider for the EKS cluster"
  default     = true
  
}