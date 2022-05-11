output "public_ip" {
  description = "Public IP of instance"
  value       = aws_instance.test_import.public_ip
}

output "key_name" {
  description = "SSH Key Name"
  value       = aws_instance.test_import.key_name
}

output "ami" {
  description = "AMI of instance"
  value       = aws_instance.test_import.ami
}

output "instance_id" {
  description = "Id of instance"
  value       = aws_instance.test_import.id
}


# output "ami_details" {
#   description = "Full details of selected AMI - e.g. for troubleshooting filter
#   value = data.aws_ami.amazon_linux2_kernel_5
# }

output "user_identity" {
    description = "Info about IAM principal used by Terraform to configure AWS"
    value = data.aws_caller_identity.current
}
