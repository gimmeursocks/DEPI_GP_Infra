output "ami_id" {
  description = "The AMI ID of the EC2 instance."
  value       = aws_instance.jenkins_server.ami
}

output "instance_id" {
  description = "The ID of the EC2 instance."
  value       = aws_instance.jenkins_server.id
}

output "public_ip" {
  description = "The public IP address of the EC2 instance."
  value       = aws_instance.jenkins_server.public_ip
}

output "private_ip" {
  description = "The private IP address of the EC2 instance."
  value       = aws_instance.jenkins_server.private_ip
}

output "public_dns" {
  description = "The public DNS name of the EC2 instance."
  value       = aws_instance.jenkins_server.public_dns
}
