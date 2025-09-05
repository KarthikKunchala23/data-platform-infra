module "vpc_endpoints" {
source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
version = "~> 5.0"


vpc_id = module.vpc.vpc_id
security_group_ids = [module.vpc.default_security_group_id]


endpoints = {
s3 = { service = "s3", service_type = "Gateway", route_table_ids = module.vpc.private_route_table_ids }
ecr_api = { service = "ecr.api", private_dns_enabled = true, subnet_ids = module.vpc.private_subnets }
ecr_dkr = { service = "ecr.dkr", private_dns_enabled = true, subnet_ids = module.vpc.private_subnets }
sts = { service = "sts", private_dns_enabled = true, subnet_ids = module.vpc.private_subnets }
secretsmanager = { service = "secretsmanager", private_dns_enabled = true, subnet_ids = module.vpc.private_subnets }
logs = { service = "logs", private_dns_enabled = true, subnet_ids = module.vpc.private_subnets }
}
}