output "cluster_name" {
  value = module.ecs.cluster_name
}

output "repository_url" {
  value = module.ecr.repository_url
}
