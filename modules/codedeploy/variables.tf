variable "name_prefix" {
  description = "Prefix for resource names."
  type        = string
}

variable "target_tag_key" {
  description = "Tag key of the instances to deploy to."
  type        = string
  default     = "role"
}

variable "target_tag_value" {
  description = "Tag value of the instances to deploy to."
  type        = string
  default     = "webserver"
}

variable "deployment_config_name" {
  description = "CodeDeploy deployment configuration."
  type        = string
  default     = "CodeDeployDefault.AllAtOnce"
}
