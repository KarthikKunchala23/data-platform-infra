variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "oidc_provider_url" {
  type        = string
  description = "OIDC provider URL for EKS cluster"
}

variable "oidc_provider_arn" {
  type        = string
  description = "OIDC provider ARN for EKS cluster"
}

variable "service_account_name" {
  type        = string
  description = "Kubernetes service account name for the AWS Load Balancer Controller"
  default     = "aws-load-balancer-controller"
}