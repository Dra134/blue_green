output "cluster_name" {
  value = aws_ecs_cluster.fargate_cluster.name
}

output "blue_service_name" {
  value = aws_ecs_service.blue_service.name
}

output "green_service_name" {
  value = aws_ecs_service.green_service.name
}
