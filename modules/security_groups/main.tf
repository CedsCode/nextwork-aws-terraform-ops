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

resource "aws_security_group" "app_from_alb" {
  name        = "${var.name_prefix}-app-from-alb-sg"
  description = "App port reachable only from the ALB"
  vpc_id      = var.vpc_id

  ingress {
    description     = "App traffic from the ALB only"
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.egress_cidrs
  }

  tags = { Name = "${var.name_prefix}-app-from-alb-sg" }
}

# Attach the SG above to the existing instance's ENI, without modifying the
# CloudFormation-managed instance resource.
resource "aws_network_interface_sg_attachment" "app" {
  security_group_id    = aws_security_group.app_from_alb.id
  network_interface_id = var.network_interface_id
}
