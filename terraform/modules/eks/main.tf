module "eks" {
source = "terraform-aws-modules/eks/aws"
version = "~> 20.8"


cluster_name = "data-plat-eks-${var.env}"
cluster_version = "1.29"
vpc_id = module.vpc.vpc_id
subnet_ids = module.vpc.private_subnets


cluster_endpoint_private_access = true
cluster_endpoint_public_access = true // lock to CIDRs as needed


enable_irsa = true


eks_managed_node_groups = {
default = {
instance_types = ["m6i.large"]
min_size = 2
max_size = 6
desired_size = 3
subnets = module.vpc.private_subnets
ami_type = "AL2_x86_64"
}
}


tags = { env = var.env, system = "data-platform" }
}