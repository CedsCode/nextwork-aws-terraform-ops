variable "name_prefix" {
  description = "Prefix for resource names."
  type        = string
}

variable "alert_email" {
  description = "Email subscribed to the SNS alerts topic."
  type        = string
}

variable "instance_id" {
  description = "Instance monitored by the status-check alarm."
  type        = string
}

variable "target_group_arn_suffix" {
  description = "ARN suffix of the target group."
  type        = string
}

variable "load_balancer_arn_suffix" {
  description = "ARN suffix of the load balancer."
  type        = string
}

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
