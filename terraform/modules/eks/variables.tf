variable "cluster_name" {
  description = "Name of the EKS Cluster"
  type        = string
}

variable "eks_cluster_role_arn" {
  type = string
}

variable "eks_node_group_role_arn" {
  type = string
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS Cluster"
  type        = string
  default     = "1.27"
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS Cluster"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs for the EKS Cluster"
  type        = list(string)
}

variable "node_group_name" {
  description = "Name of the EKS Node Group"
  type        = string
  default     = "default-node-group"
}

variable "node_instance_types" {
  description = "List of EC2 instance types for the Node Group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 3
}

variable "key_name" {
  description = "The name of the SSH key pair to use for the EC2 instance."
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
