variable "name_prefix" {
  description = "Prefix for resource names."
  type        = string
}

variable "monthly_budget_usd" {
  description = "Monthly cost budget in USD."
  type        = number
}

variable "tag_key" {
  description = "Cost-allocation tag key the budget filters on."
  type        = string
}

variable "tag_value" {
  description = "Cost-allocation tag value the budget filters on."
  type        = string
}

variable "alert_email" {
  description = "Email notified when thresholds are crossed."
  type        = string
}

variable "notification_thresholds" {
  description = "Percentages of the budget at which to notify."
  type        = list(number)
  default     = [50, 80, 100]
}
