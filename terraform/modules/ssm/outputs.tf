output "airflow_db_password_ssm_name" {
  value = aws_ssm_parameter.airflow_db_password.name
}

output "airflow_db_password_ssm_arn" {
  value = aws_ssm_parameter.airflow_db_password.arn
}
