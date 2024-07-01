variable "codecommit_repo" {
  description = "The URL of the CodeCommit repository"
}

variable "ecr_repository" {
  description = "The URL of the ECR repository"
}

variable "ecs_cluster" {
  description = "The name of the ECS cluster"
}

variable "ecs_services" {
  description = "The list of ECS services"
  type        = list(string)
}

variable "load_balancer" {
  description = "The ARN of the load balancer"
}

variable "target_groups" {
  description = "The list of target group ARNs"
  type        = list(string)
}

variable "codedeploy_role_arn" {
  description = "The ARN of the CodeDeploy role"
}

variable "listener_http_arn" {
  description = "The ARN of the HTTP listener"
}

variable "listener_http_green_arn" {
  description = "The ARN of the HTTP green listener"
}
