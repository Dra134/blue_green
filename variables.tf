variable "region" {
  description = "The AWS region"
  default     = "us-west-2"
}

variable "terraform_state_bucket" {
  description = "The S3 bucket for Terraform state"
}

variable "terraform_state_key" {
  description = "The key for the Terraform state file in S3"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}
