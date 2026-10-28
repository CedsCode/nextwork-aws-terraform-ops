variable "name_prefix" {
  description = "Prefix for resource names."
  type        = string
}

variable "artifact_bucket_arn" {
  description = "Pipeline artifact bucket."
  type        = string
}

variable "codeartifact_domain_arn" {
  description = "CodeArtifact domain the build reads from."
  type        = string
}

variable "codeartifact_repository_arn" {
  description = "CodeArtifact repository the build reads from."
  type        = string
}

variable "build_image" {
  description = "CodeBuild image."
  type        = string
  default     = "aws/codebuild/amazonlinux-x86_64-standard:corretto8-23.04.25"
}

variable "compute_type" {
  description = "CodeBuild compute type."
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
}

variable "build_timeout_minutes" {
  description = "Build timeout in minutes."
  type        = number
  default     = 15
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days."
  type        = number
  default     = 30
}

variable "environment_variables" {
  description = "Plaintext environment variables exposed to the build."
  type        = map(string)
  default     = {}
}
