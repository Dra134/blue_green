resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs_task_execution_role_new"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  inline_policy {
    name = "ecs_task_execution_policy"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
EOF
  }
}

resource "aws_ecs_task_definition" "flask_task" {
  family                   = "flask-api-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = <<DEFINITION
[
  {
    "name": "flask-api",
    "image": "${var.ecr_repository}:latest",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 5000,
        "hostPort": 5000
      }
    ]
  }
]
DEFINITION
}

resource "aws_ecs_service" "blue_service" {
  name            = "blue-service"
  cluster         = aws_ecs_cluster.fargate_cluster.id
  task_definition = aws_ecs_task_definition.flask_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  network_configuration {
    subnets         = var.public_subnets
    security_groups = [var.sg_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.blue_target_group_arn
    container_name   = "flask-api"
    container_port   = 5000
  }
}

resource "aws_ecs_service" "green_service" {
  name            = "green-service"
  cluster         = aws_ecs_cluster.fargate_cluster.id
  task_definition = aws_ecs_task_definition.flask_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  network_configuration {
    subnets         = var.public_subnets
    security_groups = [var.sg_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.green_target_group_arn
    container_name   = "flask-api"
    container_port   = 5000
  }
}

resource "aws_ecs_cluster" "fargate_cluster" {
  name = "fargate-cluster"
}
