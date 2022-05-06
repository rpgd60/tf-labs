output "public_ips" {
  description = "Public IP of instances"
  value       = aws_instance.test[*].public_ip
}

# output "key_name" {
#   description = "SSH Key Name"
#   value       = aws_instance.test.key_name
# }

# output "ami" {
#   description = "AMI of instance"
#   value       = aws_instance.test.ami
# }

output "instance_ids" {
  description = "Id of instances"
  value       = aws_instance.test[*].id
}

output "instance_subnets" {
  description = "Id of instances"
  value       = aws_instance.test[*].subnet_id
}

output "server_ids" {
    value = [for sid in aws_instance.test[*].id: format("server - %s", sid) ]
}

output "server_id_and_pub_ip" {
    value = [
        for idx in range(var.num_instances): 
          format("id %s - pub IP : %s", aws_instance.test[idx].id, aws_instance.test[idx].public_ip)
    ]
}

output "instance_idx" {
    
    value = range(var.num_instances)
}