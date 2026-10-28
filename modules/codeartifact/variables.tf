variable "name_prefix" {
  description = "Prefix for resource names."
  type        = string
}

variable "domain_suffix" {
  description = "Domain name is <name_prefix>-<domain_suffix>."
  type        = string
  default     = "domain"
}

variable "repository_suffix" {
  description = "Repository name is <name_prefix>-<repository_suffix>."
  type        = string
  default     = "repo"
}

variable "upstream_connection" {
  description = "External connection (upstream) for the repository."
  type        = string
  default     = "public:maven-central"
}
