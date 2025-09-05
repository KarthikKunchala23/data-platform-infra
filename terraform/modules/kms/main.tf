module "kms_s3" {
source = "terraform-aws-modules/kms/aws"
version = "~> 3.0"


description = "KMS key for S3 data buckets"
enable_key_rotation = true
aliases = ["alias/data-plat-s3"]
}


module "kms_redshift" {
source = "terraform-aws-modules/kms/aws"
version = "~> 3.0"


description = "KMS for Redshift Serverless"
enable_key_rotation = true
aliases = ["alias/data-plat-redshift"]
}