## Environment and Project
variable "environment" {
  type        = string
  description = "e.g. test dev prod stage"
  default     = "prod"
}

variable "project" {
  description = "Project Name"
  type        = string
}

## AWS Specific parameters
variable "profile" {
  description = "AWS profile"
  type        = string
}
variable "region" {
  description = "AWS Region"
  type        = string
}

