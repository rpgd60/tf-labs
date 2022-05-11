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
  value = [for sid in aws_instance.test[*].id : format("server - %s", sid)]
}

output "server_id_and_pub_ip" {
  description = "More complex way to show together different attributes of the set of instances created using count"
  value = [
    for idx in range(var.num_instances) :
    format("id %s - pub IP : %s", aws_instance.test[idx].id, aws_instance.test[idx].public_ip)
  ]
}

output "subnet_and_priv_ip" {
  description = "Same as above this time mapping subnet and private_ip"
  value = [
    for idx in range(var.num_instances) :
    format("id %s - pub IP : %s", aws_instance.test[idx].subnet_id, aws_instance.test[idx].private_ip)
  ]
}

output "index_and_pub_ip" {
  description = "More concise but less powerful (only shows index in the splat)"
  value = [
    for index, pub_ip in aws_instance.test.*.public_ip :
    format("id %s - pub IP : %s", index, pub_ip)
  ]
}

output "zipped_index_and_pub_ip" {
  description = "much simpler with zipmap"
  value       = zipmap(aws_instance.test.*.id, aws_instance.test.*.public_ip)
}

output "zipped_index_subnet_id" {
  description = "much simpler with zipmap"
  value       = zipmap(aws_instance.test.*.id, aws_instance.test.*.subnet_id)
}

output "subnet_ids" {
  value = data.aws_subnets.def_vpc_subnets.ids
}

output "instance_idx" {
  value = range(var.num_instances)
}

