output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.web_server_vpc.id
}

output "subnet_id" {
  description = "ID of the VPC subnet"
  value       = aws_subnet.web_server_subnet.id
}

output "subnet_cidr" {
  description = "CIDR of the subnet"
  value       = aws_subnet.web_server_subnet.cidr_block
}

output "web_sec_group" {
  description = "Id of vpc security group"
  value = aws_security_group.web_server_sc.id
}