output "public_ip" {
  description = "Public IP of instance"
  value       = aws_instance.test_vm.public_ip
}

output "key_name" {
  description = "SSH Key Name"
  value       = aws_instance.test_vm.key_name
}

output "ami" {
  description = "AMI of instance"
  value       = aws_instance.test_vm.ami
}

output "instance_id" {
  description = "Id of instance"
  value       = aws_instance.test_vm.id
}


# output "ami_details" {
#   description = "Full details of selected AMI - e.g. for troubleshooting filter
#   value = data.aws_ami.amazon_linux2_kernel_5
# }
