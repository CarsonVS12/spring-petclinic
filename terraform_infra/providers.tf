
output "ec2_public_ip" {
  description = "The ip address for ec2 server"
  value       = module.ec2.ec2_public_ip
}

output "ec2_public_dns" {
  value = module.ec2.ec2_public_dns
}