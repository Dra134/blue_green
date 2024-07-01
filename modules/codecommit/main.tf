resource "aws_codecommit_repository" "flask_repo" {
  repository_name = "flask-api-repo"
  description     = "Repository for Flask API"
}
