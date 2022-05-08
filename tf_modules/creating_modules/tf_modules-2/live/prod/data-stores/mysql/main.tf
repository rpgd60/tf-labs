terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket         = "tf-state-acme99-prod"
    key            = "data-stores/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "tf-state-lock-acme99-prod"
    encrypt        = true
  }
}

provider "aws" {
  region = "eu-west-1"
}

module "mysql" {
  source = "../../../../modules/data-stores/mysql"

  db_name     = var.db_name
  db_id_prefix = "${var.project}-prod-"
  db_username = var.db_username
  db_password = var.db_password
}
