## Environment and Project
variable "environment" {
  type        = string
  description = "e.g. test dev prod"
  default     = "dev"
}

variable "project" {
  type    = string
  default = "acme99"
}

## AWS Specific parameters
variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "profile" {
  type    = string
  default = "tfadmin1"
}

## EC2 Instance Parameters
variable "ec2_instance_type" {
  type    = string
  default = "t2.namo"
}

variable "vpc_cidr" {
  description = "CIDR for VPC"
  type = string
}

## Discuss why this variable may be a bad idea...
variable "subnet_cidr" {
  description = "CIDR for subnet"
  type = string
}

# variable "key_name" {
#   type    = string
#   default = "tf-course"
# }
