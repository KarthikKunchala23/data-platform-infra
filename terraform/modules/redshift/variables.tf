variable "namespace_name" { type = string }
variable "workgroup_name" { type = string }
variable "kms_key_id" {
   type = string
   description = "KMS Key ID for Redshift encryption"
}
variable "subnet_ids" { type = list(string) }
variable "vpc_id" { type = string }
variable "ingress_from_security_group_ids" {
   type = list(string)
  default = []
}
variable "admin_username" { type = string }
variable "admin_password" { type = string }
