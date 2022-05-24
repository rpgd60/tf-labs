# output "public_ip" {
#   description = "Public IP of instance"
#   value       = aws_instance.test1.public_ip
# }

# output "key_name" {
#   description = "SSH Key Name"
#   value       = aws_instance.test1.key_name
# }

# output "ami" {
#   description = "AMI of instance"
#   value       = aws_instance.test1.ami
# }

# output "instance_id" {
#   description = "Id of instance"
#   value       = aws_instance.test1.id
# }


# output "ami_details" {
#   description = "Full details of selected AMI - e.g. for troubleshooting filter"
#   value = data.aws_ami.ubuntu
# }

output "alb_dns" {
  value = aws_lb.front.dns_name
}

output "alb_url" {
  value = "http://${aws_lb.front.dns_name}:${var.server_port}"
}
output "user_identity" {
  description = "Info about IAM principal used by Terraform to configure AWS"
  value       = data.aws_caller_identity.current
}

## SSM
output "ssm_managed_instances" {
  # count = var.use_ssm? 1: 0 - wrong
  description = "ids of instances managed by SSM"
  value = data.aws_ssm_instances.ssm_managed.ids
}
