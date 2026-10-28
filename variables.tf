# --- General ----------------------------------------------------------------
variable "aws_region" {
  description = "Region to deploy into."
  type        = string
  default     = "ap-southeast-1"
}

variable "name_prefix" {
  description = "Prefix for the names of all resources created."
  type        = string
  default     = "nextwork"
}

variable "alert_email" {
  description = "Email for SNS alerts and budget notifications. REQUIRED."
  type        = string
}

# --- Tags -------------------------------------------------------------------
variable "project" {
  description = "Project tag value (also the budget cost-allocation tag value)."
  type        = string
  default     = "nextwork-web-project"
}

variable "project_tag_key" {
  description = "Tag key for the project tag (also the budget cost-allocation tag key)."
  type        = string
  default     = "Project"
}

variable "environment" {
  description = "Deployment environment tag value (dev, staging, prod)."
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Owner tag value."
  type        = string
  default     = "ced"
}

variable "managed_by" {
  description = "ManagedBy tag value."
  type        = string
  default     = "terraform"
}

# --- Network ----------------------------------------------------------------
variable "use_default_vpc" {
  description = "Use the region's default VPC. If false, set vpc_id."
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "VPC to use when use_default_vpc is false."
  type        = string
  default     = null
}

# --- Artifacts / CodeArtifact -----------------------------------------------
variable "artifacts_force_destroy" {
  description = "Allow destroying the artifact bucket while it holds objects (dev only)."
  type        = bool
  default     = true
}

variable "codeartifact_domain_name" {
  description = "Exact CodeArtifact domain name the app repo's build files expect. Null = <name_prefix>-domain."
  type        = string
  default     = null
}

variable "codeartifact_repository_name" {
  description = "Exact CodeArtifact repository name the app repo's build files expect. Null = <name_prefix>-repo."
  type        = string
  default     = null
}

variable "codeartifact_upstream" {
  description = "External connection used as the CodeArtifact repository upstream."
  type        = string
  default     = "public:maven-central"
}

# --- Web server -------------------------------------------------------------
variable "instance_type" {
  description = "EC2 instance type for the web server."
  type        = string
  default     = "t3.micro"
}

variable "tomcat_version" {
  description = "Tomcat version installed on the web server."
  type        = string
  default     = "9.0.109"
}

variable "key_name" {
  description = "Optional EC2 key pair name. Null = none (use SSM Session Manager)."
  type        = string
  default     = null
}

variable "ssh_cidr" {
  description = "CIDR allowed SSH access (x.x.x.x/32). Empty = no SSH rule."
  type        = string
  default     = ""
}

variable "app_direct_cidrs" {
  description = "CIDRs allowed to reach the app port directly, bypassing the ALB (e.g. your IP to verify before the ALB works). Empty = ALB only."
  type        = list(string)
  default     = []
}

variable "web_role_tag_key" {
  description = "Tag key on the web server that CodeDeploy targets."
  type        = string
  default     = "role"
}

variable "web_role_tag_value" {
  description = "Tag value on the web server that CodeDeploy targets."
  type        = string
  default     = "webserver"
}

# --- CI/CD ------------------------------------------------------------------
variable "github_repo" {
  description = "GitHub repository as owner/name."
  type        = string
  default     = "CedsCode/nextwork-web-project"
}

variable "github_branch" {
  description = "Branch the pipeline tracks."
  type        = string
  default     = "main"
}

variable "build_image" {
  description = "CodeBuild image."
  type        = string
  default     = "aws/codebuild/amazonlinux-x86_64-standard:corretto8-23.04.25"
}

# --- Networking / ALB -------------------------------------------------------
variable "app_port" {
  description = "Port the Tomcat app listens on."
  type        = number
  default     = 8080
}

variable "alb_listener_port" {
  description = "Port the ALB listens on."
  type        = number
  default     = 80
}

variable "alb_internal" {
  description = "Whether the ALB is internal."
  type        = bool
  default     = false
}

variable "alb_ingress_cidrs" {
  description = "CIDRs allowed to reach the ALB."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "egress_cidrs" {
  description = "CIDRs the ALB and app security groups may send traffic to."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "health_check_path" {
  description = "Target group health check path."
  type        = string
  default     = "/nextwork-web-project/"
}

variable "health_check_matcher" {
  description = "HTTP codes that count as healthy."
  type        = string
  default     = "200-399"
}

variable "health_check_interval" {
  description = "Seconds between health checks."
  type        = number
  default     = 30
}

variable "health_check_healthy_threshold" {
  description = "Consecutive successes before a target is healthy."
  type        = number
  default     = 2
}

variable "health_check_unhealthy_threshold" {
  description = "Consecutive failures before a target is unhealthy."
  type        = number
  default     = 2
}

# --- Monitoring -------------------------------------------------------------
variable "alarm_period" {
  description = "Alarm evaluation period in seconds."
  type        = number
  default     = 60
}

variable "alarm_evaluation_periods" {
  description = "Number of periods evaluated before alarming."
  type        = number
  default     = 1
}

variable "alarm_threshold" {
  description = "Threshold the alarms compare against (GreaterThanThreshold)."
  type        = number
  default     = 0
}

variable "alb_5xx_treat_missing_data" {
  description = "How the ALB 5XX alarm treats missing data."
  type        = string
  default     = "notBreaching"
}

# --- Budget -----------------------------------------------------------------
variable "monthly_budget_usd" {
  description = "Monthly cost budget (USD) for resources tagged with the project tag."
  type        = number
  default     = 20
}

variable "budget_notification_thresholds" {
  description = "Percentages of the budget at which to notify."
  type        = list(number)
  default     = [50, 80, 100]
}
