variable "vpc_id" {
  description = "The ID of the VPC"
}

variable "public_subnets" {
  description = "A list of public subnet IDs"
  type        = list(string)
}
