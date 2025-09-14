# Random password generator (only if you want Terraform to create it)
resource "random_password" "airflow_db" {
  length           = 16
  special          = true
  override_special = "_%@"
}

# Store password in SSM
resource "aws_ssm_parameter" "airflow_db_password" {
  name        = "/${var.org}/${var.env}/airflow/db-password"
  description = "Airflow RDS DB password"
  type        = "SecureString"
  value       = random_password.airflow_db.result
}

# RDS subnet group
resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-subnet-group"
  subnet_ids = var.subnet_ids
}
  
# Security Group for RDS
resource "aws_security_group" "this" {
  name        = "${var.name}-sg"
  description = "Security group for RDS"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name}-sg"
  }
}

# Allow inbound PostgreSQL (5432) only from private subnets CIDRs
resource "aws_security_group_rule" "rds_ingress_private" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = var.private_subnet_cidrs
  security_group_id = aws_security_group.this.id
}

# Allow egress everywhere (for RDS to reach S3, KMS, etc.)
resource "aws_security_group_rule" "rds_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this.id
}


# Fetch password back from SSM (ensures RDS always pulls from SSM)
data "aws_ssm_parameter" "airflow_db_password" {
  name           = aws_ssm_parameter.airflow_db_password.name
  with_decryption = true
}

# RDS Instance
resource "aws_db_instance" "this" {
  identifier              = var.name
  engine                  = "postgres"
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  max_allocated_storage   = var.max_allocated_storage
  username                = var.username
  password                = data.aws_ssm_parameter.airflow_db_password.value
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [aws_security_group.this.id]
  skip_final_snapshot     = true
  publicly_accessible     = false
}
