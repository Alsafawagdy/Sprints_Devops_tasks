terraform {
  backend "s3" {
    bucket         = "terraform-state-file-alsafa"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
}