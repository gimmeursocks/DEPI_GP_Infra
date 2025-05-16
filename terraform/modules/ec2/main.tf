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

resource "aws_instance" "this" {
  ami           = data.aws_ami.amazon_linux_latest.id
  instance_type = var.instance_type
  key_name      = var.key_name
  user_data     = var.user_data

  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.vpc_security_group_ids
  iam_instance_profile        = var.iam_instance_profile
  associate_public_ip_address = true

  tags = var.tags
}

