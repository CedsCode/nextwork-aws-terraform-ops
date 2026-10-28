module "discovery" {
  source = "./modules/discovery"

  use_default_vpc    = var.use_default_vpc
  vpc_id             = var.vpc_id
  instance_tag_key   = var.instance_tag_key
  instance_tag_value = var.instance_tag_value
  instance_state     = var.instance_state
}

module "security_groups" {
  source = "./modules/security_groups"

  name_prefix          = var.name_prefix
  vpc_id               = module.discovery.vpc_id
  network_interface_id = module.discovery.network_interface_id
  app_port             = var.app_port
  alb_listener_port    = var.alb_listener_port
  alb_ingress_cidrs    = var.alb_ingress_cidrs
  egress_cidrs         = var.egress_cidrs
}

module "alb" {
  source = "./modules/alb"

  name_prefix        = var.name_prefix
  vpc_id             = module.discovery.vpc_id
  subnet_ids         = module.discovery.subnet_ids
  security_group_ids = [module.security_groups.alb_security_group_id]
  instance_id        = module.discovery.instance_id
  internal           = var.alb_internal
  app_port           = var.app_port
  listener_port      = var.alb_listener_port

  health_check_path                = var.health_check_path
  health_check_matcher             = var.health_check_matcher
  health_check_interval            = var.health_check_interval
  health_check_healthy_threshold   = var.health_check_healthy_threshold
  health_check_unhealthy_threshold = var.health_check_unhealthy_threshold
}

module "monitoring" {
  source = "./modules/monitoring"

  name_prefix              = var.name_prefix
  alert_email              = var.alert_email
  instance_id              = module.discovery.instance_id
  target_group_arn_suffix  = module.alb.target_group_arn_suffix
  load_balancer_arn_suffix = module.alb.arn_suffix

  alarm_period               = var.alarm_period
  alarm_evaluation_periods   = var.alarm_evaluation_periods
  alarm_threshold            = var.alarm_threshold
  alb_5xx_treat_missing_data = var.alb_5xx_treat_missing_data
}

module "budget" {
  source = "./modules/budget"

  name_prefix             = var.name_prefix
  monthly_budget_usd      = var.monthly_budget_usd
  tag_key                 = var.project_tag_key
  tag_value               = var.project
  alert_email             = var.alert_email
  notification_thresholds = var.budget_notification_thresholds
}
