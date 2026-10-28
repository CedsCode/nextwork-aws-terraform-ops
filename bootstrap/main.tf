# One-off config that creates the S3 bucket holding the main config's remote state.
# It uses LOCAL state on purpose (chicken-and-egg). Run it once, then never destroy it
# while the main config still uses the bucket.

terraform {
  required_version = ">= 1.10.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.70"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      (var.project_tag_key) = var.project
      Environment           = var.environment
      Owner                 = var.owner
      ManagedBy             = var.managed_by
    }
  }
}

data "aws_caller_identity" "current" {}

locals {
  bucket_name = coalesce(var.state_bucket_name, "${var.name_prefix}-tfstate-${data.aws_caller_identity.current.account_id}-${var.aws_region}")
}

resource "aws_s3_bucket" "state" {
  bucket = local.bucket_name

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "state" {
  bucket = aws_s3_bucket.state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state" {
  bucket = aws_s3_bucket.state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "state" {
  bucket                  = aws_s3_bucket.state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Old state versions are kept for recovery, then expire.
resource "aws_s3_bucket_lifecycle_configuration" "state" {
  bucket = aws_s3_bucket.state.id

  rule {
    id     = "expire-noncurrent-state"
    status = "Enabled"

    filter {}

    noncurrent_version_expiration {
      noncurrent_days = var.noncurrent_version_days
    }
  }
}
