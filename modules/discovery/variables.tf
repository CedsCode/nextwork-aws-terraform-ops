variable "use_default_vpc" {
  description = "Look up the region's default VPC. If false, vpc_id must be set."
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
}

variable "instance_state" {
  description = "Instance state to match."
  type        = string
  default     = "running"
}
