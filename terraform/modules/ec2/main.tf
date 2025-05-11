# Data source to find the newest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_latest" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}


data "aws_subnet" "selected" {
  id = var.subnet_id
}

resource "aws_instance" "jenkins_server" {
  ami                         = data.aws_ami.amazon_linux_latest.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.vpc_security_group_ids
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y gcc openssl-devel bzip2-devel libffi-devel zlib-devel wget make
              cd /usr/src
              sudo wget https://www.python.org/ftp/python/3.8.12/Python-3.8.12.tgz
              sudo tar xzf Python-3.8.12.tgz
              cd Python-3.8.12
              sudo ./configure --enable-optimizations
              sudo make altinstall
              EOF

  tags = merge(var.tags, {
    Name = "jenkins-server"
  })
}

