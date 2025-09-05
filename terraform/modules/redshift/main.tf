resource "aws_redshiftserverless_namespace" "this" {
namespace_name = "data-plat-${var.env}"
admin_username = var.redshift_admin_username
admin_user_password = var.redshift_admin_password
kms_key_id = module.kms_redshift.key_arn
}


resource "aws_redshiftserverless_workgroup" "this" {
workgroup_name = "data-plat-${var.env}"
base_capacity = 16 // RPU; adjust
namespace_name = aws_redshiftserverless_namespace.this.namespace_name
enhanced_vpc_routing = true
publicly_accessible = false
subnet_ids = module.vpc.private_subnets
security_group_ids = [module.vpc.default_security_group_id]
}