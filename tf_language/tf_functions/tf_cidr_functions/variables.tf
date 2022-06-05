## Environment and Project
variable "environment" {
  type        = string
  description = "e.g. test dev prod"
  default     = "dev"
}

variable "project" {
  type    = string
  default = "proj99"
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

## VPC
variable "vpc_cidr" {
  description = "CIDR for deployment VPC"
  type        = string
}

