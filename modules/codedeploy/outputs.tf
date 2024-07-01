# Output for the blue deployment group name
output "blue_deployment_group_name" {
  value = aws_codedeploy_deployment_group.blue_deployment_group.deployment_group_name
}

# Output for the green deployment group name
output "green_deployment_group_name" {
  value = aws_codedeploy_deployment_group.green_deployment_group.deployment_group_name
}

# Output for the CodeDeploy application name
output "codedeploy_app_name" {
  value = aws_codedeploy_app.flask_app.name
}
