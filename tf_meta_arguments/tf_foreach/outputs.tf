output "instances" {
  value = aws_instance.test
}

output "subnet_ids" {
  value = data.aws_subnets.def_vpc_subnets.ids
}

