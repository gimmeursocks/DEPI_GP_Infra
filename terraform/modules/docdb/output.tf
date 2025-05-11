output "cluster_endpoint" {
  description = "The endpoint of the DocumentDB cluster."
  value       = aws_docdb_cluster.this.endpoint
}

output "instance_endpoints" {
  description = "A list of endpoints for the DocumentDB instances."
  value       = aws_docdb_cluster_instance.this[*].endpoint
}
