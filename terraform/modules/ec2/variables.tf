variable "instance_type" {
  description = "The instance type for the EC2 instance."
  type        = string
}

variable "key_name" {
  description = "The name of the SSH key pair to use for the EC2 instance."
  type        = string
}

variable "user_data" {
  description = "The user data used to bootstrap EC2 instance."
  type        = string
  default     = ""
}

variable "subnet_id" {
  description = "The ID of the subnet to launch the EC2 instance in."
  type        = string
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with the EC2 instance."
  type        = list(string)
}

variable "iam_instance_profile" {
  description = "The IAM profile to attach to EC2 instance"
  type        = string
  default     = ""
}


variable "tags" {
  description = "A map of tags to assign to the EC2 instance."
  type        = map(string)
  default     = {}
}
