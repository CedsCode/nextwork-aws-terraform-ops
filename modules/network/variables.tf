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
