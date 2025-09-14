output "db_endpoint" {
  description = "RDS endpoint"
  value       = aws_db_instance.this.endpoint
}

output "db_name" {
  description = "DB name"
  value       = aws_db_instance.this.db_name
}

output "db_username" {
  description = "DB username"
  value       = aws_db_instance.this.username
}

output "db_password_ssm" {
  description = "SSM parameter name for DB password"
  value       = aws_ssm_parameter.airflow_db_password.name
}

output "security_group_id" {
  description = "RDS SG ID"
  value       = aws_security_group.this.id
}
