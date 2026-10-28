provider "aws" {
  region = var.aws_region

  # Applied to every taggable resource this project creates.
  default_tags {
    tags = {
      (var.project_tag_key) = var.project
      Environment           = var.environment
      Owner                 = var.owner
      ManagedBy             = var.managed_by
    }
  }
}
