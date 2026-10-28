terraform {
  required_version = ">= 1.10.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.70"
    }
  }

  # Partial config - values come from backend.hcl (created by ./bootstrap):
  #   terraform init -backend-config=backend.hcl
  backend "s3" {}
}
