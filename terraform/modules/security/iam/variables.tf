variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_depends_on" {
  description = "Dependency variable for the EKS cluster"
  type        = any
  default     = null
}