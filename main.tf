module "network" {
  source = "./modules/network"

  use_default_vpc = var.use_default_vpc
  vpc_id          = var.vpc_id
}

# --- Foundation --------------------------------------------------------------
module "artifacts" {
  source = "./modules/artifacts"

  name_prefix   = var.name_prefix
  force_destroy = var.artifacts_force_destroy
}

module "codeartifact" {
  source = "./modules/codeartifact"

  name_prefix         = var.name_prefix
  upstream_connection = var.codeartifact_upstream
}

module "security_groups" {
  source = "./modules/security_groups"

  name_prefix       = var.name_prefix
  vpc_id            = module.network.vpc_id
  app_port          = var.app_port
  alb_listener_port = var.alb_listener_port
  alb_ingress_cidrs = var.alb_ingress_cidrs
  app_direct_cidrs  = var.app_direct_cidrs
  ssh_cidr          = var.ssh_cidr
  egress_cidrs      = var.egress_cidrs
}

module "web_server" {
  source = "./modules/web_server"

  name_prefix         = var.name_prefix
  subnet_id           = module.network.subnet_ids[0]
  security_group_ids  = [module.security_groups.app_security_group_id]
  artifact_bucket_arn = module.artifacts.bucket_arn
  instance_type       = var.instance_type
  key_name            = var.key_name
  tomcat_version      = var.tomcat_version
  app_port            = var.app_port
  role_tag_key        = var.web_role_tag_key
  role_tag_value      = var.web_role_tag_value
}

# --- CI/CD -------------------------------------------------------------------
module "codebuild" {
  source = "./modules/codebuild"

  name_prefix                 = var.name_prefix
  artifact_bucket_arn         = module.artifacts.bucket_arn
  codeartifact_domain_arn     = module.codeartifact.domain_arn
  codeartifact_repository_arn = module.codeartifact.repository_arn
  build_image                 = var.build_image

  environment_variables = {
    CODEARTIFACT_DOMAIN       = module.codeartifact.domain
    CODEARTIFACT_REPOSITORY   = module.codeartifact.repository
    CODEARTIFACT_DOMAIN_OWNER = module.codeartifact.domain_owner
  }
}

module "codedeploy" {
  source = "./modules/codedeploy"

  name_prefix      = var.name_prefix
  target_tag_key   = var.web_role_tag_key
  target_tag_value = var.web_role_tag_value
}

module "pipeline" {
  source = "./modules/pipeline"

  name_prefix                      = var.name_prefix
  github_repo                      = var.github_repo
  github_branch                    = var.github_branch
  artifact_bucket_id               = module.artifacts.bucket_id
  artifact_bucket_arn              = module.artifacts.bucket_arn
  codebuild_project_name           = module.codebuild.project_name
  codebuild_project_arn            = module.codebuild.project_arn
  codebuild_role_arn               = module.codebuild.role_arn
  codedeploy_app_name              = module.codedeploy.app_name
  codedeploy_app_arn               = module.codedeploy.app_arn
  codedeploy_deployment_group_name = module.codedeploy.deployment_group_name
  codedeploy_deployment_group_arn  = module.codedeploy.deployment_group_arn
}

# --- Ops layer ---------------------------------------------------------------
module "alb" {
  source = "./modules/alb"

  name_prefix        = var.name_prefix
  vpc_id             = module.network.vpc_id
  subnet_ids         = module.network.subnet_ids
  security_group_ids = [module.security_groups.alb_security_group_id]
  instance_id        = module.web_server.instance_id
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
  instance_id              = module.web_server.instance_id
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
