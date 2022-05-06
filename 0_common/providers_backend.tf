terraform {
  required_version = "~> 1.1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.6" 
    }
  }

  backend "s3" {
    bucket         = "zzzzz"  # "acme02-terraform-state-dev"           
    ## Note key is application specific
    key            =  "yyyyyy/terraform.tfstate" #"acme02/example-01/terraform.tfstate"  
    dynamodb_table =  "xxxx_xxxx" #"acme02-terraform-state-locks-dev"
    region         = "eu-west-1"
    encrypt        = true
  }
}

provider "aws" {
  region  = var.region
  profile = var.profile
  default_tags {
    tags = {
      environment = var.environment
      project     = var.project
      created_by  = "terraform"
      disposable  = true
    }
  }
}
