variable "aws_region" {
  description = "The region for the project"
  type        = string
}

variable "tags" {
  description = "The global tags for the resources"
  type        = map(string)
}

variable "name_prefix" {
  description = "The name prefix for the resources"
  type        = string
}

variable "domain_name" {
  description = "The domain name for the petclinic service"
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


variable "container_port" {
  description = "The port of the docker containers"
  type        = number
}


variable "alb_alarm_email_address" {
  description = "The email address for receiving docker container health status"
  type        = string
}
