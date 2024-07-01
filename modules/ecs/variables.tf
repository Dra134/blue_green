variable "vpc_id" {
  description = "The ID of the VPC"
}

variable "public_subnets" {
  description = "A list of public subnet IDs"
  type        = list(string)
}

variable "sg_id" {
  description = "The ID of the security group"
}

variable "ecr_repository" {
  description = "The URL of the ECR repository"
}

variable "blue_target_group_arn" {
  description = "The ARN of the blue target group"
}

variable "green_target_group_arn" {
  description = "The ARN of the green target group"
}
