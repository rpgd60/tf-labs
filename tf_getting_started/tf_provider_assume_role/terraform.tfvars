# profile in parent/management account that can manage child accounts
parent_account_profile = "managed-admin"

## NOTE must change number below to an actual account number
child_account_number   = "123456789012"

## this is the standard created by default by AWS Organizations
child_account_role = "OrganizationAccountAccessRole"

region             = "eu-west-1"

project     = "acme02"
environment = "dev"


instance_type = "t2.micro"

sec_allowed_external = ["0.0.0.0/0"]
key_name             = "tf-course"
