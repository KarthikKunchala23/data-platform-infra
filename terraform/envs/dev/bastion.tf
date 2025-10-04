data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_key_pair" "existing" {
  key_name = "argo" # Replace with the name of your existing EC2 key pair
}

resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Security group for bastion host"
  vpc_id      = var.vpc_cidr

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}

resource "aws_instance" "bastion_host"{
    ami                         = data.aws_ami.ubuntu.id
    instance_type               = var.bastion_instance_type
    subnet_id                   = var.public_subnets_cidrs[0]
    vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
    key_name                    = data.aws_key_pair.existing.key_name
    associate_public_ip_address = true
    
    tags = {
        Name        = "bastion-host"
        Environment = "dev"
    }
  
}