module "aws_web_vpc" {
  source = "./modules/aws-web-vpc"
  vpc_cidr_block    = var.vpc_cidr
  subnet_cidr_block = var.subnet_cidr
}

module "web1" {
  source            = "./modules/aws-web-server-instance"
  ec2_instance_type = var.ec2_instance_type
  ec2_instance_name = "web-num1"

  vpc_id            = module.aws_web_vpc.vpc_id
  subnet_id         = module.aws_web_vpc.subnet_id
  web_server_sc     = module.aws_web_vpc.web_sec_group
}

module "web2" {
  source            = "./modules/aws-web-server-instance"
  ec2_instance_name = "web-num2"
  ec2_instance_type = var.ec2_instance_type
  vpc_id            = module.aws_web_vpc.vpc_id
  subnet_id         = module.aws_web_vpc.subnet_id
  web_server_sc     = module.aws_web_vpc.web_sec_group

}