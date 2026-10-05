# terraform-project
Infrastructure as Code (IaC) with Terraform on AWS
# Terraform-Docker
Provision a Docker container on an AWS EC2 instance using Terraform.
# prerequisites
1. Terraform
2. AWS
3. Amazon EC2
4. Docker
5. Nginx
# Install terraform
1. Install prerequisites
2. sudo apt-get update
3. sudo apt-get install -y gnupg software-properties-common
# Add HashiCorp's repository
1. wget -O- https://apt.releases.hashicorp.com/gpg | \
   gpg --dearmor | \
   sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
2. echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
   https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
   sudo tee /etc/apt/sources.list.d/hashicorp.list
# Install Terraform
1. sudo apt-get update && sudo apt-get install -y terraform
2. terraform version
# Create terraform configuration files
1. main.tf
# Create AWS resources using terraform
1. terraform init
2. terraform validate
3. terraform plan
4. terraform apply
# Output
1. Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
2. public_ip
3. public_dns
# Destroy infrastructure
1. terraform destory
# Output
1. Apply complete! Resources: 0 added, 0 changed, 2 destroyed.
# END

