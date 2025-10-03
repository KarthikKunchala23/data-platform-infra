variable "name_prefix" {
  type        = string
  description = "Prefix for naming Airflow resources"
}

variable "oidc_provider_arn" {
  type        = string
  description = "OIDC provider ARN for EKS cluster"
}

variable "oidc_provider_url" {
  type        = string
  description = "OIDC provider URL (issuer) for EKS cluster"
}
