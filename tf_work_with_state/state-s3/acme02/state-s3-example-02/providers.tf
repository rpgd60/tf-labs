terraform {
  required_version = "~> 1.1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.6" # v3.38.0 minimal version to use default tags
    }
  }

  backend "s3" {
    bucket         = "acme02-terraform-state-044858806836-dev"
    key            = "acme02/example-02/terraform.tfstate" ## Note key is application specific
    dynamodb_table = "acme02-terraform-state-locks-dev"
    region         = "eu-west-1"
    encrypt        = true
    profile        = "tfadmin1"
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
