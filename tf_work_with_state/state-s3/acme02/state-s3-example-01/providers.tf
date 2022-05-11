terraform {
  required_version = "~> 1.1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.6" 
    }
  }

  backend "s3" {
    bucket         = "acme02-terraform-state-044858806836-dev"           
    ## Note key is application specific
    key            = "acme02/example-01/terraform.tfstate"  
    dynamodb_table = "acme02-terraform-state-locks-dev"
    region         = "eu-west-1"
    encrypt        = true
    profile = "tfadmin1"
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
