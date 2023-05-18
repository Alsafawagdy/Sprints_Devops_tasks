module "EkS" {
  source     = "./EKS"
  subnet_ids = var.subnet_ids
}

module "ECR" {
  source = "./ECR"
}

module "EC2" {
  source            = "./EC2"
  public1_subnet_id = var.public1_subnet_id
  vpc_id            = var.vpc_id
}