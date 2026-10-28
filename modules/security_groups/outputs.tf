output "alb_security_group_id" {
  value = aws_security_group.alb.id
}

output "app_from_alb_security_group_id" {
  value = aws_security_group.app_from_alb.id
}
