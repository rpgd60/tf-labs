locals {
  two_pub_subnets  = slice(cidrsubnets(var.vpc_cidr, 8, 8, 8, 8), 0, 2)
  two_priv_subnets = slice(cidrsubnets(var.vpc_cidr, 8, 8, 8, 8), 2, 4)
  ## Should yield 2nd and 3rd AZ
  ## This one requires terraform apply to be seen in console
  two_azs = slice(data.aws_availability_zones.available.names, 1, 3)  

  tags = {
    "managed_by" = "terraform"
  }
}

## Using the above to create a VPC using the aws_vpc module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name               = "${var.environment}-vpc"
  cidr               = var.vpc_cidr
  enable_nat_gateway = false
  single_nat_gateway = true

  azs = local.two_azs
  # azs             = ["${var.region}a", "${var.region}b"]
  public_subnets  = local.two_pub_subnets
  private_subnets = local.two_priv_subnets
}

