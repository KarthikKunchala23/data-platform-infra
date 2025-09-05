variable "env" {
  description = "The environment for the deployment (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
  
}

variable "redshift_admin_username" {
  description = "The admin username for the Redshift Serverless namespace"
  type        = string
  default     = "adminuser"
  
}

variable "redshift_admin_password" {
  description = "The admin password for the Redshift Serverless namespace"
  type        = string
  default     = "ChangeMe123!"
  
}