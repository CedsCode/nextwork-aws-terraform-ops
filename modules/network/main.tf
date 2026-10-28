# Looks up the existing VPC and its subnets. Creates nothing.

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
