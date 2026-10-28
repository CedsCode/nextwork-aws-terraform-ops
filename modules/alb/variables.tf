variable "name_prefix" {
  description = "Prefix for resource names."
  type        = string
}

variable "vpc_id" {
  description = "VPC of the target group."
  type        = string
}

variable "subnet_ids" {
  description = "Subnets the ALB spreads across (needs >= 2 AZs)."
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security groups attached to the ALB."
  type        = list(string)
}

variable "instance_id" {
  description = "Instance registered in the target group."
  type        = string
}

variable "internal" {
  description = "Whether the ALB is internal."
  type        = bool
  default     = false
}

variable "app_port" {
  description = "Port the app listens on (target group port)."
  type        = number
}

variable "target_protocol" {
  description = "Protocol used between the ALB and targets."
  type        = string
  default     = "HTTP"
}

variable "listener_port" {
  description = "Port the ALB listens on."
  type        = number
}

variable "listener_protocol" {
  description = "Protocol the ALB listens on."
  type        = string
  default     = "HTTP"
}

variable "health_check_path" {
  description = "Target group health check path."
  type        = string
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
