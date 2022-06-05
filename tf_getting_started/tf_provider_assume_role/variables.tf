## Environment and Project

variable "company" {
  type = string
  description = "company name - will be used in tags"
  default = "acme"
}

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

### Parameters related to AWS Organizations
variable "parent_account_profile" {
  description = "profile associated with IAM user in parent/management account"
  type        = string
}

variable "child_account_number" {
  description = "Managed / Child account were we are going to configure stuff with Terraform"
  type        = string
}

variable "child_account_role" {
  type        = string
  description = "Role in child account assumed by some user from management account"
  default     = "OrganizationAccountAccessRole" #Default value by AWS Organizations
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




