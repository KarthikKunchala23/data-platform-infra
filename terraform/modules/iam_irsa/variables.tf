variable "name_prefix" { type = string }
variable "oidc_provider_arn" { type = string } # must be set (see notes)
variable "namespace" { type = string }
variable "service_account" { type = string }
variable "s3_bucket_arns" { 
  type = list(string) 
  default = [] 
}
