module "aws_web_vpc" {
  source = "./modules/aws-web-vpc"
  vpc_cidr_block    = var.vpc_cidr
  subnet_cidr_block = var.subnet_cidr
}

module "aws_web_server_instance" {
  source            = "./modules/aws-web-server-instance"
  ec2_instance_type = var.ec2_instance_type
  vpc_id            = module.aws_web_vpc.vpc_id
  subnet_id         = module.aws_web_vpc.subnet_id
}