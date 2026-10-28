variable "name_prefix" {
  description = "Prefix for resource names."
  type        = string
}

variable "bucket_name" {
  description = "Override the generated bucket name."
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "Delete the bucket even if it contains objects (dev only)."
  type        = bool
  default     = true
}
