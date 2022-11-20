variable "aws_region" {
  type = string
}

variable "env" {
  type = string
}

variable "image_name" {
  description = "Name of ami."
  default     = "amzn2-ami-kernel-5.10-hvm-2.0.20221004.0-x86_64-gp2"
}

variable "key_name" {
  description = "Key name of the key pair to be used for the instance."
  default     = null
  type        = string
}

variable "project_name" {
    type = string
    description = "Project Name"
    default	= "tyropower"
}

variable "rds_mysql" {
    type = map(map(string))
    description = "RDS MySQL information (users, passwords and databases)"
    sensitive   = true
}

variable "user_data" {
  description = "User data to provide when launching the management instance."
  default     = null
}