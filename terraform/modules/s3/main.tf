resource "aws_s3_bucket" "raw" {
  bucket = "${var.name_prefix}-raw"
  acl    = "private"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = var.kms_key_id
      }
    }
  }
  versioning { enabled = true }
  tags = { Name = "${var.name_prefix}-raw" }
}

resource "aws_s3_bucket" "configs" {
  bucket = "${var.name_prefix}-configs"
  acl    = "private"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = var.kms_key_id
      }
    }
  }
  versioning { enabled = true }
  tags = { Name = "${var.name_prefix}-configs" }
}

resource "aws_s3_bucket" "airflow_logs" {
  bucket = "${var.name_prefix}-airflow-logs"
  acl    = "private"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = var.kms_key_id
      }
    }
  }
  versioning { enabled = true }
  tags = { Name = "${var.name_prefix}-airflow-logs" }
}
