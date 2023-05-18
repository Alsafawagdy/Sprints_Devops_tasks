output "flask-ecr-url" {
  value = aws_ecr_repository.flask-app.repository_url
}
output "mysql-ecr-url" {
  value = aws_ecr_repository.mysql-db.repository_url
}