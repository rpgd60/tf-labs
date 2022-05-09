terraform {
  required_version = "~> 1.1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.6" # v3.38.0 minimal version to use default tags
    }
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

provider "google" {
 credentials = file("~/.gcp/test-rp-01-3297391dce5b.json")
 project     = "test-rp-01"
 region      = var.gcp_region   ## London
}
