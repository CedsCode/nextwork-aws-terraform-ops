output "alb_dns_name" {
  description = "Public DNS of the ALB - open this in a browser."
  value       = module.alb.dns_name
}

output "alb_arn" {
  value = module.alb.arn
}

output "target_group_arn" {
  value = module.alb.target_group_arn
}

output "alb_security_group_id" {
  value = module.security_groups.alb_security_group_id
}

output "app_from_alb_security_group_id" {
  value = module.security_groups.app_from_alb_security_group_id
}

output "web_instance_id" {
  value = module.discovery.instance_id
}

output "sns_topic_arn" {
  value = module.monitoring.sns_topic_arn
}

output "budget_name" {
  value = module.budget.name
}
