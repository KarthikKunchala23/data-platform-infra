# Terraform configuration for the dev environment
# Create VPC
module "vpc" {
  source = "../../modules/vpc"
  name   = var.vpc_name
  cidr   = var.vpc_cidr
  azs    = var.azs
  public_subnets_cidrs  = var.public_subnets_cidrs
  private_subnets_cidrs = var.private_subnets_cidrs
}

# KMS keys
module "kms" {
  source = "../../modules/kms"
  name   = "${var.org}-${var.env}"
}

# S3 buckets
module "s3_data" {
  source = "../../modules/s3"
  name_prefix = var.s3_prefix
  kms_key_id  = module.kms.kms_key_id
}

# ECR
module "ecr" {
  source = "../../modules/ecr"
  name   = var.ecr_repo_name
  kms_key_id = module.kms.kms_key_id
}

# EKS cluster + node group
module "eks" {
  source          = "../../modules/eks"
  cluster_name    = var.cluster_name
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  public_subnets  = module.vpc.public_subnets
  node_instance_type = var.node_instance_type
  node_min_size = var.node_min_size
  node_desired_size = var.node_desired_size
  node_max_size = var.node_max_size
}

# Redshift serverless
module "redshift" {
  source = "../../modules/redshift"
  namespace_name = "${var.org}-${var.env}"
  workgroup_name = "${var.org}-${var.env}-wg"
  kms_key_id     = module.kms.kms_key_arn
  subnet_ids     = module.vpc.private_subnets
  vpc_id         = module.vpc.vpc_id
  ingress_from_security_group_ids = [module.eks.cluster_security_group_id]
  admin_username = var.redshift_admin_username
  admin_password = data.aws_ssm_parameter.redshift_admin_password.value
}

# IAM IRSA role for Airflow service account (requires OIDC provider ARN)
module "iam_irsa" {
  source = "../../modules/iam_irsa"
  name_prefix = "${var.org}-${var.env}-airflow"
  oidc_provider_arn = aws_iam_openid_connect_provider.eks_oidc.arn
  namespace = "platform"
  service_account = "airflow"
  s3_bucket_arns = [
    module.s3_data.raw_bucket_arn,
    module.s3_data.configs_bucket_arn,
    module.s3_data.airflow_logs_bucket_arn
  ]
}


data "aws_ssm_parameter" "redshift_admin_password" {
  name = "/rspasswd"
  with_decryption = true
}

