
# Security group for private ssh connection and port 8080 for jenkins

resource "aws_security_group" "allow_ssh_8080" {
  name        = "allow_ssh_8080"
  description = "Allow ssh and port 8080 inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    Name = "allow_ssh_8080"
  }

}

 
 
