resource "aws_codedeploy_app" "flask_app" {
  name            = "flask-codedeploy-app"
  compute_platform = "ECS"
}

resource "aws_codedeploy_deployment_group" "blue_deployment_group" {
  app_name              = aws_codedeploy_app.flask_app.name
  deployment_group_name = "blue-deployment-group"
  service_role_arn      = var.codedeploy_role_arn
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"

  deployment_style {
    deployment_type   = "BLUE_GREEN"
    deployment_option = "WITH_TRAFFIC_CONTROL"
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  ecs_service {
    cluster_name = var.ecs_cluster
    service_name = var.ecs_services[0]
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.listener_http_arn]
      }
      test_traffic_route {
        listener_arns = [var.listener_http_green_arn]
      }
      target_group {
        name = var.target_groups[0]
      }
      target_group {
        name = var.target_groups[1]
      }
    }
  }
}

resource "aws_codedeploy_deployment_group" "green_deployment_group" {
  app_name              = aws_codedeploy_app.flask_app.name
  deployment_group_name = "green-deployment-group"
  service_role_arn      = var.codedeploy_role_arn
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"

  deployment_style {
    deployment_type   = "BLUE_GREEN"
    deployment_option = "WITH_TRAFFIC_CONTROL"
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  ecs_service {
    cluster_name = var.ecs_cluster
    service_name = var.ecs_services[1]
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.listener_http_arn]
      }
      test_traffic_route {
        listener_arns = [var.listener_http_green_arn]
      }
      target_group {
        name = var.target_groups[0]
      }
      target_group {
        name = var.target_groups[1]
      }
    }
  }
}
