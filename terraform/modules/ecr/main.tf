module "ecr" {
source = "terraform-aws-modules/ecr/aws"
version = "~> 1.6"


repository_name = "airflow-platform"
repository_image_scan_on_push = true
repository_encryption_configuration = {
encryption_type = "KMS"
kms_key = module.kms_s3.key_arn
}
}