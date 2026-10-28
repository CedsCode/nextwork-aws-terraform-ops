variable "aws_region" {
  description = "Region for the state bucket."
  type        = string
  default     = "ap-southeast-1"
}

variable "name_prefix" {
  description = "Prefix for the state bucket name."
  type        = string
  default     = "nextwork"
}

variable "state_bucket_name" {
  description = "Override the generated state bucket name."
  type        = string
  default     = null
}

variable "state_key" {
  description = "Object key of the main config's state file."
  type        = string
  default     = "nextwork/terraform.tfstate"
}

variable "noncurrent_version_days" {
  description = "Days to keep old state versions."
  type        = number
  default     = 90
}

variable "project" {
  description = "Project tag value."
  type        = string
  default     = "nextwork-web-project"
}

variable "project_tag_key" {
  description = "Project tag key."
  type        = string
  default     = "Project"
}

variable "environment" {
  description = "Environment tag value."
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
