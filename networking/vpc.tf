locals {
  azs               = data.aws_availability_zones.available.names
  private_subnets   = [
    for az in local.azs:
      cidrsubnet(var.vpc_cidr, var.priv_cidr_newbits, length(local.azs)-index(local.azs, az))
      if index(local.azs, az) < var.private_subnet_count
  ]
  database_subnets   = [
    for az in local.azs:
      cidrsubnet(var.vpc_cidr, var.db_cidr_newbits, length(local.azs)-index(local.azs, az))
      if index(local.azs, az) < var.db_subnet_count
  ]
}

module "vpc" {
  source                            = "terraform-aws-modules/vpc/aws"
  name                              = var.vpc_name
  cidr                              = var.vpc_cidr
  azs                               = local.azs
  private_subnets                   = local.private_subnets
  database_subnets                   = local.database_subnets
  enable_dns_hostnames              = true
  enable_dhcp_options               = true
  dhcp_options_domain_name_servers  = ["AmazonProvidedDNS"]

  ## VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true
  flow_log_max_aggregation_interval    = 60

  ## DB
  create_database_subnet_group = false

}
