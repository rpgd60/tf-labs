locals {
  assumed_role_child_account = "arn:aws:iam::${var.child_account_number}:role/${var.child_account_role}"
}
terraform {
  required_version = "~> 1.2.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.6" # v3.38.0 minimal version to use default tags
    }
  }
}

provider "aws" {
  region  = var.region
  profile = var.parent_account_profile
  assume_role {
    role_arn = local.assumed_role_child_account
  }
  default_tags {
    tags = {
      "${var.company}:environment" = var.environment
      "${var.company}:project"     = var.project
      created_by  = "terraform"
      disposable  = true
    }
  }
}

