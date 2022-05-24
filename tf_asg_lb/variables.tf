## AWS Specific parameters

variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "profile" {
  type    = string
  default = "tfadmin1"
}


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


## EC2 Instance Parameters

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "key_name" {
  type    = string
  default = "tf-course"
}


## Security Groups
variable "sec_allowed_external" {
  description = "CIDRs from which access is allowed"
  type        = list(string)
  default     = ["0.0.0.0/10", "0.0.0.0/10"]
}

## ALB / ASG
variable "access_logs" {

}

variable "server_port" {
  description = "TCP Port for basic web application"
  default     = 8080
}

variable "asg_target_alb_requests" {
  type = number

}

variable "asg_target_tracking_cpu" {
  type = number

}

# ASG 
variable "asg_min_size" {
  type    = string
  default = "1"
}

variable "asg_max_size" {
  type    = string
  default = "1"
}

variable "asg_desired_capacity" {
  type    = string
  default = "1"
}

variable "target_autoscaling_track_cpu" {
  type    = bool
  default = false
}

variable "target_autoscaling_track_lbreq" {
  type    = bool
  default = false
}


variable "use_ssm" {
  type = bool
  default = false
}