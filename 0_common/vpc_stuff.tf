### VPC Module call
data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.14.0"

  name = "example_vpc"
  cidr = var.vpc_cidr

  azs             = data.aws_availability_zones.available.names
  public_subnets  = slice(cidrsubnets(var.vpc_cidr, 8,8,8,8,8),1,3)  ## /24s  .1 and .2
  private_subnets = slice(cidrsubnets(var.vpc_cidr, 8,8,8,8,8),3,5)  ## /24s  .3 and .4

  enable_ipv6          = false
  enable_nat_gateway   = true
  enable_vpn_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true
}
