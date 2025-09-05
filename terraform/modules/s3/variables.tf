variable "org" {
  description = "The organization name to prefix resource names"
  type        = string
  default     = "myorg" 
  
}

variable "env" {
  description = "The environment name to suffix resource names"
  type        = string
  default     = "dev"
  
}