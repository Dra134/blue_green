resource "aws_codebuild_project" "flask_build" {
  name          = "flask-build"
  description   = "Build project for Flask API"
  service_role  = var.codebuild_role_arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = "us-west-2"
    }
  }

  source {
    type            = "CODECOMMIT"
    location        = var.codecommit_repo
    buildspec       = <<EOF
version: 0.2

phases:
  install:
    runtime-versions:
      python: 3.8
    commands:
      - pip install -r requirements.txt
  build:
    commands:
      - echo Build started on `date`
      - echo Building the Docker image...
      - docker build -t flask-api .
  post_build:
    commands:
      - echo Build completed on `date`
      - docker tag flask-api:latest ${var.ecr_repository}:latest
      - $(aws ecr get-login --no-include-email --region us-west-2)
      - docker push ${var.ecr_repository}:latest
EOF
  }
}
