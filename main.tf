terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }

  required_version = ">= 1.5.0"
}

provider "aws" {
  region = "us-east-1"
}

# Find the latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Security group
resource "aws_security_group" "docker_sg" {
  name        = "docker-server-sg"
  description = "Security group for Docker server"

  # SSH
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "docker-server-sg"
  }
}

# EC2 instance
resource "aws_instance" "amazon_linux" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  key_name           = "k8s"

  vpc_security_group_ids = [aws_security_group.docker_sg.id]

  user_data = <<-EOF
              #!/bin/bash

              dnf update -y
              dnf install -y docker

              systemctl enable docker
              systemctl start docker
              usermod -aG docker ec2-user
              newgrp docker

              docker run -d \
                --name nginx-container \
                -p 80:80 \
                nginx:latest
              EOF

  tags = {
    Name = "docker-server"
  }
}

# Output the EC2 public IP
output "public_ip" {
  value = aws_instance.amazon_linux.public_ip
}

# Output the EC2 public DNS
output "public_dns" {
  value = aws_instance.amazon_linux.public_dns
}

