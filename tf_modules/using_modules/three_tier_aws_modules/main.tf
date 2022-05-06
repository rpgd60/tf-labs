## Locals - used for debugging
locals {
  ## To re-use module docs example source code 
  name   = var.project
  region = var.region

  two_pub_subnets  = slice(cidrsubnets(var.vpc_cidr, 8, 8, 8, 8), 0, 2)
  two_priv_subnets = slice(cidrsubnets(var.vpc_cidr, 8, 8, 8, 8), 2, 4)

  # slightly weirder solution if we want to avoid using "10.0.0.0/24 subnet" (that is use .1, .2, .3, .4)
  # pub_subnets  = slice(cidrsubnets(var.vpc_cidr, 8, 8, 8, 8, 8), 1, 3)
  # priv_subnets = slice(cidrsubnets(var.vpc_cidr, 8, 8, 8, 8, 8), 4, 5)

  two_azs = slice(data.aws_availability_zones.available.names, 1, 3)
  tags = {
    "managed_by" = "terraform"
  }
}

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

  enable_ipv6                          = false
  enable_flow_log                      = false
  create_flow_log_cloudwatch_iam_role  = false
  create_flow_log_cloudwatch_log_group = false
}

## Application Load balancer - ALB

## Security group for load balancer
module "alb_http_sg" {
  source  = "terraform-aws-modules/security-group/aws//modules/http-80"
  version = "~> 4.0"

  name        = "${local.name}-alb-http"
  vpc_id      = module.vpc.vpc_id
  description = "Security group for ${local.name} load balancer"

  ingress_cidr_blocks = ["0.0.0.0/0"]

  tags = local.tags
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = local.name

  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnets
  security_groups = [module.alb_http_sg.security_group_id]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  target_groups = [
    {
      name             = local.name
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
    },
  ]

  tags = local.tags
}



