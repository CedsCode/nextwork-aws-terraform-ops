variable "name_prefix" {
  description = "Prefix for resource names."
  type        = string
}

variable "vpc_id" {
  description = "VPC the security groups are created in."
  type        = string
}

variable "network_interface_id" {
  description = "ENI of the existing instance to attach the app SG to."
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

variable "egress_cidrs" {
  description = "CIDRs both security groups may send traffic to."
  type        = list(string)
}
