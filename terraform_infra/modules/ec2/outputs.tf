output "alb_target_group" {
  description = "The target group of EC2 service for the ALB"
  value       = aws_alb_target_group.main.arn
}

output "aws_alb_listener_http" {
  description = "The http listener of ALB forward traffic to EC2."
  value       = aws_alb_listener.http.arn
}

output "website_name" {
  description = "The website name for petclinic service"
  value       = aws_route53_record.alb.name
}

output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.main.dns_name
}

output "aws_security_group_alb" {
  description = "The security group of the ALB"
  value       = aws_security_group.alb.id
}

output "ec2_public_dns" {
  value = aws_instance.ec2_web.public_dns
}

output "ec2_public_ip" {
  value = aws_eip.eip.public_ip
}

output "ec2_sg" {
  value = aws_security_group.public_sg.id
}