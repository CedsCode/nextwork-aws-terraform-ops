variable "name_prefix" {
  description = "Prefix for resource names."
  type        = string
}

variable "github_repo" {
  description = "GitHub repository as owner/name."
  type        = string
}

variable "github_branch" {
  description = "Branch the pipeline tracks."
  type        = string
}

variable "artifact_bucket_id" {
  description = "Pipeline artifact bucket name."
  type        = string
}

variable "artifact_bucket_arn" {
  description = "Pipeline artifact bucket ARN."
  type        = string
}

variable "codebuild_project_name" {
  description = "CodeBuild project run by the Build stage."
  type        = string
}

variable "codebuild_project_arn" {
  description = "ARN of the CodeBuild project."
  type        = string
}

variable "codebuild_role_arn" {
  description = "ARN of the CodeBuild service role (the pipeline may pass it)."
  type        = string
}

variable "codedeploy_app_name" {
  description = "CodeDeploy application used by the Deploy stage."
  type        = string
}

variable "codedeploy_app_arn" {
  description = "ARN of the CodeDeploy application."
  type        = string
}

variable "codedeploy_deployment_group_name" {
  description = "CodeDeploy deployment group used by the Deploy stage."
  type        = string
}

variable "codedeploy_deployment_group_arn" {
  description = "ARN of the CodeDeploy deployment group."
  type        = string
}
