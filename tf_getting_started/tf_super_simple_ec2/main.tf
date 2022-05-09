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
  region  = "eu-west-1"
  profile = "tfadmin1"
  default_tags {
    tags = {
      disposable = true
    }
  }
}

# ==== resources
resource "aws_instance" "test_vm" {
  ami                         = "ami-00e7df8df28dfa791" # ubuntu 20.04 in eu-west-1
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = "tf-course"
  # vpc_security_group_ids      = ["sg-046e7328c8c8afc63"] # Pre-created security group
  vpc_security_group_ids = ["sg-06f2dded043e263c5"] # Pre-created security group
  tags = {
    Name = "super_basic"
  }
}
