#!bin/bash
cd terraform
terraform init
terraform apply --var-file var.tfvars -auto-approve
cp jenkins_key.pem ../ansible/
chmod 400 jenkins_key.pem
ansible-playbook -i inventory --private-key jenkins_key.pem web.yml