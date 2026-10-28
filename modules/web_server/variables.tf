variable "name_prefix" {
  description = "Prefix for resource names."
  type        = string
}

variable "subnet_id" {
  description = "Subnet to launch in (needs a public IP route for package downloads)."
  type        = string
}

variable "security_group_ids" {
  description = "Security groups attached to the instance."
  type        = list(string)
}

variable "artifact_bucket_arn" {
  description = "Pipeline artifact bucket the CodeDeploy agent reads revisions from."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "ami_ssm_parameter" {
  description = "SSM parameter resolving to the AMI id."
  type        = string
  default     = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

variable "key_name" {
  description = "Optional EC2 key pair. Null = none (use SSM Session Manager)."
  type        = string
  default     = null
}

variable "root_volume_gb" {
  description = "Root volume size in GiB."
  type        = number
  default     = 8
}

variable "tomcat_version" {
  description = "Tomcat version to install."
  type        = string
  default     = "9.0.109"
}

variable "corretto_package" {
  description = "dnf package providing the JDK."
  type        = string
  default     = "java-1.8.0-amazon-corretto"
}

variable "app_port" {
  description = "Port Tomcat listens on."
  type        = number
}

variable "role_tag_key" {
  description = "Tag key that CodeDeploy uses to find this instance."
  type        = string
  default     = "role"
}

variable "role_tag_value" {
  description = "Tag value that CodeDeploy uses to find this instance."
  type        = string
  default     = "webserver"
}
