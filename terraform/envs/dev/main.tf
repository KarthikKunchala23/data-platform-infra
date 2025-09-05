# VPC
module "vpc" {
  source = "../modules/vpc"
  name   = "dev-vpc"
  cidr   = "10.0.0.0/16"
  azs    = ["us-east-1a", "us-east-1b"]
}

# EKS
module "eks" {
  source          = "../modules/eks"
  cluster_name    = "dev-eks"
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  public_subnets  = module.vpc.public_subnets
}

# S3 for raw data + Airflow configs
module "s3_data" {
  source     = "../modules/s3_data"
  bucket_name = "dev-data-raw"
}

# Redshift Serverless
module "redshift_serverless" {
  source           = "../modules/redshift_serverless"
  namespace_name   = "dev-namespace"
  workgroup_name   = "dev-workgroup"
  subnet_ids       = module.vpc.private_subnets
  security_group_id = module.eks.cluster_security_group_id
}

# ECR (for Airflow custom images)
module "ecr" {
  source      = "../modules/ecr"
  repo_name   = "airflow"
}

# KMS (optional, for S3 encryption + Redshift)
module "kms" {
  source      = "../modules/kms"
  alias_name  = "dev-kms-key"
}

# IAM/IRSA for Airflow + ExternalSecrets
module "iam_irsa" {
  source       = "../modules/iam_irsa"
  cluster_name = module.eks.cluster_name
  namespace    = "airflow"
  service_account = "airflow-scheduler"
  s3_bucket_arn   = module.s3_data.bucket_arn
  redshift_role_arn = module.redshift_serverless.redshift_role_arn
}
