# backend.hcl
bucket         = "acme02-terraform-state-dev"           
dynamodb_table = "acme02-terraform-state-locks-dev"
region         = "eu-west-1"
encrypt        = true
