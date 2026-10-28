variable "name_prefix" {
  description = "Prefix for resource names."
  type        = string
}

variable "vpc_id" {
  description = "VPC the security groups are created in."
  type        = string
}

variable "app_port" {
  description = "Port the app listens on."
  type        = number
}

variable "alb_listener_port" {
  description = "Port the ALB accepts traffic on."
  type        = number
}

variable "alb_ingress_cidrs" {
  description = "CIDRs allowed to reach the ALB."
  type        = list(string)
}

variable "app_direct_cidrs" {
  description = "CIDRs allowed to reach the app port directly, bypassing the ALB. Empty = ALB only."
  type        = list(string)
  default     = []
}

variable "ssh_cidr" {
  description = "CIDR allowed SSH access (x.x.x.x/32). Empty = no SSH rule; use SSM Session Manager."
  type        = string
  default     = ""
}

variable "egress_cidrs" {
  description = "CIDRs both security groups may send traffic to."
  type        = list(string)
}
