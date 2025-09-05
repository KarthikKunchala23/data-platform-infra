module "vpc" {
source = "terraform-aws-modules/vpc/aws"
version = "~> 5.0"


name = "data-plat-vpc"
cidr = "10.0.0.0/16"


azs = ["us-east-1a","us-east-1b"]
public_subnets = ["10.0.0.0/20","10.0.16.0/20"]
private_subnets = ["10.0.32.0/19","10.0.96.0/19"]


enable_nat_gateway = true
single_nat_gateway = true


enable_dns_support = true
enable_dns_hostnames = true


enable_flow_log = true
flow_log_destination_type = "cloud-watch-logs"
flow_log_log_format = "${join(" ", ["${var.account_id}", "${var.region}"])} %V %A %n %p %I %o %S %D %F %B %f %b %e %g %l %u %t"
}