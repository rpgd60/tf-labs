# backend.hcl
bucket         = "acme02-terraform-state-044858806836-dev"           
dynamodb_table = "acme02-terraform-state-locks-dev"
region         = "eu-west-1"
encrypt        = true
profile        = "tfadmin1"
