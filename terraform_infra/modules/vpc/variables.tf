variable "aws_region" {
  description = "The region for the project"
  type        = string
}

variable "name_prefix" {
  description = "The name prefix for the resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block of the public subnets"
  type        = list(any)
}