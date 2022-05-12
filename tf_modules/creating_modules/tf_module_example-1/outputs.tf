output "vpc_id" {
  description = "ID of the vpc"
  value       = module.aws_web_vpc.vpc_id
}

output "subnet_id" {
  description = "ID of the vpc"
  value       = module.aws_web_vpc.subnet_id
}

output "subnet_cidr" {
  description = "ID of the vpc"
  value       = module.aws_web_vpc.subnet_cidr
}

output "web1_instance_id" {
  description = "ID of EC2 instance"
  value       = module.web1.instance_id
}

output "web2_instance_id" {
  description = "ID of EC2 instance"
  value       = module.web2.instance_id
}

output "web1_public_ip" {
  description = "Public IP of EC2 instance"
  value       = module.web1.instance_public_ip
}