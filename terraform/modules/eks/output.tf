output "cluster_name" {
  description = "Name of the EKS Cluster"
  value       = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "Endpoint for the EKS Cluster"
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority" {
  description = "Certificate authority data for the EKS Cluster"
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

output "node_group_name" {
  description = "Name of the EKS Node Group"
  value       = aws_eks_node_group.this.node_group_name
}
