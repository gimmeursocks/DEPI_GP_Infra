variable "cluster_name" {
  type        = string
  description = "The name of the EKS Cluster."
}

variable "region" {
  type        = string
  description = "AWS region for the deployment (e.g., 'us-east-1')."
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC where the EKS cluster is deployed."
}

variable "alb_role_arn" {
  type        = string
  description = "ARN of the IAM Role for the AWS Load Balancer Controller (IRSA)."
}
