output "web_server_url" {
  description = "Direct app URL (works only if app_direct_cidrs allows your IP)."
  value       = "http://${module.web_server.public_dns}:${var.app_port}/nextwork-web-project"
}

output "alb_url" {
  description = "App URL through the ALB."
  value       = "http://${module.alb.dns_name}/nextwork-web-project"
}

output "web_instance_id" {
  value = module.web_server.instance_id
}

output "pipeline_name" {
  value = module.pipeline.pipeline_name
}

output "github_connection_arn" {
  value = module.pipeline.connection_arn
}

output "github_connection_status" {
  description = "PENDING until you authorize it once in the console."
  value       = module.pipeline.connection_status
}

output "artifact_bucket" {
  value = module.artifacts.bucket_id
}

output "codeartifact_domain" {
  value = module.codeartifact.domain
}

output "codeartifact_repository" {
  value = module.codeartifact.repository
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

output "app_security_group_id" {
  value = module.security_groups.app_security_group_id
}

output "sns_topic_arn" {
  value = module.monitoring.sns_topic_arn
}

output "budget_name" {
  value = module.budget.name
}
