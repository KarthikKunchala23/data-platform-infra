module "s3" {
source = "terraform-aws-modules/s3-bucket/aws"
version = "~> 4.1"


for_each = {
raw = { name = "${var.org}-raw-${var.env}" }
configs = { name = "${var.org}-configs-${var.env}" }
airflow_logs = { name = "${var.org}-airflow-logs-${var.env}" }
}


bucket = each.value.name


server_side_encryption_configuration = {
rule = {
apply_server_side_encryption_by_default = {
sse_algorithm = "aws:kms"
kms_master_key_id = module.kms_s3.key_id
}
}
}


versioning = { enabled = true }
acl = "private"
block_public_acls = true
block_public_policy = true
ignore_public_acls = true
restrict_public_buckets = true


lifecycle_rule = [{
id = "expire-mpu"
enabled = true
abort_incomplete_multipart_upload_days = 7
}]
}