terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider

provider "aws" {
  region = "us-east-1"
}

# Key Value pair

resource "aws_key_pair" "my_key_pair" {
   key_name="terraform-key"
   public_key=file("terraform-key.pub")
}

# VPC Default

resource "aws_default_vpc" "default" {
}

# Security Group 

resource "aws_security_group" "my_security_group" {
    name="terraform-security-group"
    vpc_id= aws_default_vpc.default.id  # interpolation
    description = "This is your  instance Security group"
}

# Inbound & Outbound port rules

# This fetches your current public IP from a web service
data "http" "my_public_ip" {
  url = "https://ifconfig.me/ip"
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_jenkins" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4         = "0.0.0.0/0"      #${data.http.my_public_ip.response_body}/32 
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# EC2 instance

variable "instances" {
  default = {
    "jenkins-master" = 8
    "jenkins-agent"  = 15
  }
}
resource "aws_instance" "my_instance" {

  for_each = var.instances
  ami = "ami-091138d0f0d41ff90" # OS AMI ID
  instance_type = "m7i-flex.large" # Instance Type
  key_name = aws_key_pair.my_key_pair.key_name    # Key pair
  vpc_security_group_ids = [aws_security_group.my_security_group.id] # VPC & Security Group

  depends_on = [
    aws_key_pair.my_key_pair,
    aws_vpc_security_group_ingress_rule.allow_ssh,
    aws_vpc_security_group_egress_rule.allow_all_traffic
  ]

  # root storage (EBS)
  root_block_device {
    volume_size = each.value
    volume_type = "gp3"
  }

  tags = {
    Name = each.key
  }
}
