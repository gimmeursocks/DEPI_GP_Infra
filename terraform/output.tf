output "jenkins_master_public_dns" {
  value = module.jenkins_master.public_dns
}

output "jenkins_agent_public_dns" {
  value = module.jenkins_agent.public_dns
}

output "jenkins_master_private_ip" {
  value = module.jenkins_master.private_ip
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_ca_certificate" {
  value = module.eks.cluster_ca_certificate
}
