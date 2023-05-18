output "flask-ecr-url" {
  value = module.ECR.flask-ecr-url
}
output "mysql-ecr-url" {
  value = module.ECR.mysql-ecr-url
}
output "jenkins_ip" {
  value = module.EC2.jenkins_ip
}