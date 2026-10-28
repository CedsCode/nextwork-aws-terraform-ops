resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/codebuild/${var.name_prefix}-build"
  retention_in_days = var.log_retention_days
}

data "aws_iam_policy_document" "assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = "${var.name_prefix}-codebuild-role"
  assume_role_policy = data.aws_iam_policy_document.assume.json
}

data "aws_iam_policy_document" "this" {
  statement {
    sid       = "Logs"
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["${aws_cloudwatch_log_group.this.arn}:*"]
  }

  statement {
    sid       = "ArtifactBucketObjects"
    actions   = ["s3:GetObject", "s3:GetObjectVersion", "s3:PutObject"]
    resources = ["${var.artifact_bucket_arn}/*"]
  }

  statement {
    sid       = "ArtifactBucket"
    actions   = ["s3:GetBucketLocation", "s3:ListBucket"]
    resources = [var.artifact_bucket_arn]
  }

  statement {
    sid       = "CodeArtifactToken"
    actions   = ["codeartifact:GetAuthorizationToken"]
    resources = [var.codeartifact_domain_arn]
  }

  statement {
    sid       = "CodeArtifactRead"
    actions   = ["codeartifact:GetRepositoryEndpoint", "codeartifact:ReadFromRepository"]
    resources = [var.codeartifact_repository_arn]
  }

  statement {
    sid       = "CodeArtifactBearerToken"
    actions   = ["sts:GetServiceBearerToken"]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "sts:AWSServiceName"
      values   = ["codeartifact.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "this" {
  name   = "build"
  role   = aws_iam_role.this.id
  policy = data.aws_iam_policy_document.this.json
}

resource "aws_codebuild_project" "this" {
  name          = "${var.name_prefix}-build"
  service_role  = aws_iam_role.this.arn
  build_timeout = var.build_timeout_minutes

  source {
    type = "CODEPIPELINE"
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    type         = "LINUX_CONTAINER"
    compute_type = var.compute_type
    image        = var.build_image

    dynamic "environment_variable" {
      for_each = var.environment_variables
      content {
        name  = environment_variable.key
        value = environment_variable.value
      }
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.this.name
    }
  }
}
