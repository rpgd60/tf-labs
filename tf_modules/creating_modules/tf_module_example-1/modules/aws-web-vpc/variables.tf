variable "vpc_cidr_block" {
  description = "CIDR block for webserer VPC"
  type        = string
  default     = "10.22.0.0/16"
}

variable "vpc_name" {
  type    = string
  default = "web_server_vpc"
}

variable "subnet_cidr_block" {
  type    = string
  default = "10.22.1.0/24"
}

variable "subnet_name" {
  type    = string
  default = "web_server_subnet"
}

variable "aws_az" {
  type    = string
  default = "eu-west-1a"
}

variable "igw_name" {
  type    = string
  default = "web_server_igw"
}

variable "rt_name" {
  type    = string
  default = "web_server_rt"
}

variable "security_group_name" {
  type    = string
  default = "web_server_sc"
}

variable "security_group_description" {
  type    = string
  default = "Allow traffic for webserver"
}

