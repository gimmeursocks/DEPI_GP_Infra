output "vpc_id" {
  value = aws_vpc.main.id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "default_sg_id" {
  value = aws_security_group.default.id
}

output "ec2_ssh_sg_id" {
  value = aws_security_group.ec2_ssh.id
}

output "jenkins_sg_id" {
  value = aws_security_group.jenkins.id
}
