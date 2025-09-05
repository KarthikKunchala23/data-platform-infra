data "aws_caller_identity" "account_id" {
  
}

variable "account_id" {
  description = "The AWS account ID where resources will be deployed"
  type        = string
  default     = data.aws_caller_identity.account_id.account_id
  
}

variable "env" {
  description = "The environment name to suffix resource names"
  type        = string
  default     = "dev"
  
}

variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default = "us-east-1"
  
}