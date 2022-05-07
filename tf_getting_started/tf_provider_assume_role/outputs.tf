output "user_identity" {
  description = "Info about IAM principal used by Terraform to configure AWS"
  value       = data.aws_caller_identity.who_am_i
}

output "role_assumed" {
  value = local.assumed_role_child_account
}
