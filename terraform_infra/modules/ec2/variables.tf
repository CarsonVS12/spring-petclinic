variable "name_prefix" {
  description = "The name prefix for the resources"
  type        = string
}

variable "domain_name" {
  description = "The domain name for the backend"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "public_subnet_id" {
  description = "The IDs of the public subnets"
  type        = list(any)
}


variable "container_port" {
  description = "The port of docker containers"
  type        = number
}


variable "alb_alarm_email_address" {
  description = "The email address for receiving docker container health status"
  type        = string
}