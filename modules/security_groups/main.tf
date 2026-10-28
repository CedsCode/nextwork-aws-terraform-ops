resource "aws_security_group" "alb" {
  name        = "${var.name_prefix}-alb-sg"
  description = "Public HTTP in to the ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from allowed CIDRs"
    from_port   = var.alb_listener_port
    to_port     = var.alb_listener_port
    protocol    = "tcp"
    cidr_blocks = var.alb_ingress_cidrs
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.egress_cidrs
  }

  tags = { Name = "${var.name_prefix}-alb-sg" }
}

resource "aws_security_group" "app" {
  name        = "${var.name_prefix}-app-sg"
  description = "App port reachable from the ALB (and optional direct/SSH CIDRs)"
  vpc_id      = var.vpc_id

  ingress {
    description     = "App traffic from the ALB only"
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  # Optional: reach the app directly (e.g. to verify before the ALB works).
  dynamic "ingress" {
    for_each = length(var.app_direct_cidrs) > 0 ? [1] : []
    content {
      description = "Direct app access from allowed CIDRs"
      from_port   = var.app_port
      to_port     = var.app_port
      protocol    = "tcp"
      cidr_blocks = var.app_direct_cidrs
    }
  }

  # Optional: SSH. Empty by default - use SSM Session Manager instead.
  dynamic "ingress" {
    for_each = var.ssh_cidr != "" ? [var.ssh_cidr] : []
    content {
      description = "SSH from allowed CIDR"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.egress_cidrs
  }

  tags = { Name = "${var.name_prefix}-app-sg" }
}
