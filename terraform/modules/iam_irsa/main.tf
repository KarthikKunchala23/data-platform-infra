module "airflow_irsa" {
source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
version = "~> 5.38"


role_name_prefix = "airflow-${var.env}-"
role_policy_arns = [
aws_iam_policy.airflow_data_access.arn
]
oidc_providers = {
eks = {
provider_arn = module.eks.oidc_provider_arn
namespace_service_accounts = [
"platform:airflow-scheduler",
"platform:airflow-web",
"platform:airflow-worker",
]
}
}
}


resource "aws_iam_policy" "airflow_data_access" {
name = "airflow-data-access-${var.env}"
description = "Airflow pods access to S3 and Secrets"


policy = jsonencode({
Version = "2012-10-17",
Statement = [
{
Sid: "S3DataBuckets",
Effect: "Allow",
Action: ["s3:GetObject","s3:PutObject","s3:ListBucket"],
Resource: [
module.s3["raw"].s3_bucket_arn,
"${module.s3["raw"].s3_bucket_arn}/*",
module.s3["configs"].s3_bucket_arn,
"${module.s3["configs"].s3_bucket_arn}/*",
module.s3["airflow_logs"].s3_bucket_arn,
"${module.s3["airflow_logs"].s3_bucket_arn}/*",
]
},
{
Sid: "SecretsAccess",
Effect: "Allow",
Action: ["secretsmanager:GetSecretValue","secretsmanager:DescribeSecret"],
Resource: ["arn:aws:secretsmanager:${var.region}:${var.account_id}:secret:airflow/*"]
}
]
})
}