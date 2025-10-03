variable "org" {
  type = string
}

variable "env" {
  type = string
}

variable "airflow_db_password" {
  type      = string
  sensitive = true
}

resource "aws_ssm_parameter" "airflow_db_password" {
  name        = "/${var.org}/${var.env}/airflow/db/password"
  description = "Airflow RDS DB password"
  type        = "SecureString"
  value       = var.airflow_db_password
}
