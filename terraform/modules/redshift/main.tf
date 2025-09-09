
resource "aws_redshiftserverless_namespace" "this" {
  namespace_name = var.namespace_name
  admin_username = var.admin_username
  admin_user_password = var.admin_password
  kms_key_id = var.kms_key_id

  iam_roles = [ aws_iam_role.redshift_s3_access.arn ]
}

resource "aws_redshiftserverless_workgroup" "this" {
  workgroup_name = var.workgroup_name
  namespace_name = aws_redshiftserverless_namespace.this.namespace_name
  base_capacity  = 8
  enhanced_vpc_routing = true
  subnet_ids = var.subnet_ids
  security_group_ids = [aws_security_group.rs_sg.id]
}

output "namespace_name" { value = aws_redshiftserverless_namespace.this.namespace_name }
output "workgroup_name" { value = aws_redshiftserverless_workgroup.this.workgroup_name }
