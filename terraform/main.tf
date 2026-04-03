terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# -------------------------------------------------------
# CONFIGURE YOUR REGION HERE
# -------------------------------------------------------
provider "aws" {
  region = "us-east-1"
}

# -------------------------------------------------------
# SECURITY GROUP — allows SSH, app port, Prometheus, Grafana
# -------------------------------------------------------
resource "aws_security_group" "devops_sg" {
  name        = "devops-practice-sg"
  description = "Security group for DevOps practice project"

  # SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH"
  }

  # Flask app
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Flask App"
  }

  # Prometheus
  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Prometheus"
  }

  # Grafana
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Grafana"
  }

  # Node Exporter (Prometheus scrapes this)
  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Node Exporter"
  }

  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "devops-practice-sg"
    Project = "devops-practice"
  }
}

# -------------------------------------------------------
# EC2 INSTANCE
# -------------------------------------------------------
resource "aws_instance" "devops_server" {
  # Ubuntu 22.04 LTS (us-east-1) — update AMI if using a different region
  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"  # Free tier eligible

  # IMPORTANT: Replace with your actual key pair name in AWS
  key_name = "terraformboot"

  vpc_security_group_ids = [aws_security_group.devops_sg.id]

  tags = {
    Name    = "devops-practice-server"
    Project = "devops-practice"
  }
}

# -------------------------------------------------------
# OUTPUTS — printed after terraform apply
# -------------------------------------------------------
output "server_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.devops_server.public_ip
}

output "ssh_command" {
  description = "SSH into the server"
  value       = "ssh -i terraformboot ubuntu@${aws_instance.devops_server.public_ip}"
}

output "app_url" {
  description = "Flask app URL"
  value       = "http://${aws_instance.devops_server.public_ip}:5000"
}

output "grafana_url" {
  description = "Grafana dashboard URL"
  value       = "http://${aws_instance.devops_server.public_ip}:3000"
}
