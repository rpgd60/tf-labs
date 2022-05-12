variable "ec2_instance_name" {
  type    = string
  default = "web_server_instance"
}

variable "ec2_instance_type" {
  description = "Instance type for web server EC2 instance"
  type        = string
  default     = "t2.micro"
}


variable "vpc_id" {
  type = string
  default = null
}

variable "subnet_id" {
  type = string
  default = null
}

variable "web_server_sc" {
  type = string
  default = null
}

