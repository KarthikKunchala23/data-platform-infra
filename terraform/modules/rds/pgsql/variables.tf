variable "name" {
  description = "Name/identifier for the RDS instance"
  type        = string
}

variable "engine_version" {
  description = "Postgres engine version"
  type        = string
  default     = "16.1"
}

variable "instance_class" {
  description = "DB instance class"
  type        = string
  default     = "db.t3.medium"
}

variable "allocated_storage" {
  description = "Initial storage in GB"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Max autoscaled storage"
  type        = number
  default     = 100
}

variable "username" {
  description = "DB master username"
  type        = string
}



variable "subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "vpc_security_group_ids" {
  description = "List of security groups for RDS"
  type        = list(string)
}


variable "org" {
  description = "Organization name"
  type        = string
  
}

variable "env" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
  
}

variable "vpc_id" {
  description = "VPC ID where RDS will be deployed"
  type        = string
  
}

variable "private_subnet_cidrs" {
  description = "CIDRs of private subnets that should access RDS"
  type        = list(string)
}
