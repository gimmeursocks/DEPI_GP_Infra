variable "db_password" {
  description = "Password for the RDS database (authdb)"
  type        = string
  sensitive   = true
}

variable "docdb_password" {
  description = "Password for the DocumentDB (tododb)"
  type        = string
  sensitive   = true
}
