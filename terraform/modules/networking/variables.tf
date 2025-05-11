variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
}

variable "allowed_ssh_cidr_blocks" {
  description = "A list of CIDR blocks that are allowed to SSH into resources in this VPC."
  type        = list(string)
  default     = ["0.0.0.0/0"] # WARNING: This is insecure for production. Restrict this.
}
