variable "db_name" {
  description = "The name of the DocumentDB database."
  type        = string
}

variable "db_username" {
  description = "The username for the DocumentDB database."
  type        = string
}

variable "db_password" {
  description = "The password for the DocumentDB database."
  type        = string
  sensitive   = true
}

variable "subnet_ids" {
  description = "A list of private subnet IDs for the DocumentDB subnet group."
  type        = list(string)
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with the DocumentDB cluster."
  type        = list(string)
}

variable "instance_count" {
  description = "The number of DocumentDB instances to create in the cluster."
  type        = number
  default     = 1 # Default to 1 instance
}

variable "instance_class" {
  description = "The DocumentDB instance class."
  type        = string
  default     = "db.t3.medium" # Default instance class
}
