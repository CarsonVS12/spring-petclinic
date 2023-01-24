module "vpc" {
  source             = "./modules/vpc"
  aws_region         = var.aws_region
  name_prefix        = var.name_prefix
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
}

module "ec2" {
  source = "./modules/ec2"
  # aws_region       = var.aws_region
  name_prefix             = var.name_prefix
  public_subnet_id        = module.vpc.public_subnet_id
  vpc_id                  = module.vpc.vpc_id
  container_port          = var.container_port
  alb_alarm_email_address = var.alb_alarm_email_address
  domain_name             = var.domain_name

}