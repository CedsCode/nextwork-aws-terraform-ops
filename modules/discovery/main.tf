# Looks up existing infrastructure. Creates nothing.

data "aws_vpc" "this" {
  default = var.use_default_vpc
  id      = var.use_default_vpc ? null : var.vpc_id
}

data "aws_subnets" "this" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }
}

# The existing web server, found by tag. Errors if not exactly one match.
data "aws_instance" "web" {
  filter {
    name   = "tag:${var.instance_tag_key}"
    values = [var.instance_tag_value]
  }
  filter {
    name   = "instance-state-name"
    values = [var.instance_state]
  }
}

# The instance's network interface (to attach an SG without touching the instance)
data "aws_network_interfaces" "web" {
  filter {
    name   = "attachment.instance-id"
    values = [data.aws_instance.web.id]
  }
}
