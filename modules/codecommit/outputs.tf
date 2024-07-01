output "repository" {
  value = aws_codecommit_repository.flask_repo.clone_url_http
}
