data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_iam_instance_profile" "ec2_profile_jenkins" {
  name = "ec2_profile_jenkins"
  role = aws_iam_role.ec2_role.name
}

resource "aws_instance" "jenkins" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = var.public1_subnet_id
  key_name = "jenkins_key"
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.ec2_profile_jenkins.name
  tags = {
    Name = "jenkins"
  }
  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy_general,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy_general,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
  ]
  provisioner "local-exec" {
    command = "echo '[default]' > ../ansible/inventory"
  } 
  provisioner "local-exec" {
    command = "echo '${self.public_ip}' >> ../ansible/inventory"
  }
}




resource "aws_network_interface_sg_attachment" "jenkins_sg_attachment" {
  security_group_id    = aws_security_group.allow_ssh_8080.id
  network_interface_id = aws_instance.jenkins.primary_network_interface_id
}