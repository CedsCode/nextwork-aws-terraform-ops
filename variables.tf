# --- General ----------------------------------------------------------------
variable "aws_region" {
  description = "Region where the existing environment lives."
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
  default     = "prod"
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

# --- Existing infrastructure lookup -----------------------------------------
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

variable "instance_tag_key" {
  description = "Tag key identifying the existing web server instance."
  type        = string
  default     = "role"
}

variable "instance_tag_value" {
  description = "Tag value identifying the existing web server instance."
  type        = string
  default     = "webserver"
}

variable "instance_state" {
  description = "Instance state to match when looking up the web server."
  type        = string
  default     = "running"
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
