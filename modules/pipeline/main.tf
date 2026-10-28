data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_partition" "current" {}

locals {
  codedeploy_arn_prefix = "arn:${data.aws_partition.current.partition}:codedeploy:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}"
}

# Created PENDING. It must be authorized once in the console
# (Developer Tools -> Settings -> Connections) before the Source stage can run.
resource "aws_codestarconnections_connection" "github" {
  name          = "${var.name_prefix}-github"
  provider_type = "GitHub"
}

data "aws_iam_policy_document" "assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = "${var.name_prefix}-pipeline-role"
  assume_role_policy = data.aws_iam_policy_document.assume.json
}

data "aws_iam_policy_document" "this" {
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
    sid       = "UseConnection"
    actions   = ["codestar-connections:UseConnection"]
    resources = [aws_codestarconnections_connection.github.arn]
  }

  statement {
    sid       = "StartBuild"
    actions   = ["codebuild:StartBuild", "codebuild:BatchGetBuilds"]
    resources = [var.codebuild_project_arn]
  }

  statement {
    sid       = "PassBuildRole"
    actions   = ["iam:PassRole"]
    resources = [var.codebuild_role_arn]
  }

  statement {
    sid = "Deploy"
    actions = [
      "codedeploy:CreateDeployment",
      "codedeploy:GetDeployment",
      "codedeploy:GetApplication",
      "codedeploy:GetApplicationRevision",
      "codedeploy:RegisterApplicationRevision",
    ]
    resources = [var.codedeploy_app_arn, var.codedeploy_deployment_group_arn]
  }

  statement {
    sid       = "DeployConfig"
    actions   = ["codedeploy:GetDeploymentConfig"]
    resources = ["${local.codedeploy_arn_prefix}:deploymentconfig:*"]
  }
}

resource "aws_iam_role_policy" "this" {
  name   = "pipeline"
  role   = aws_iam_role.this.id
  policy = data.aws_iam_policy_document.this.json
}

resource "aws_codepipeline" "this" {
  name          = "${var.name_prefix}-pipeline"
  role_arn      = aws_iam_role.this.arn
  pipeline_type = "V2"

  artifact_store {
    type     = "S3"
    location = var.artifact_bucket_id
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        ConnectionArn        = aws_codestarconnections_connection.github.arn
        FullRepositoryId     = var.github_repo
        BranchName           = var.github_branch
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]

      configuration = {
        ProjectName = var.codebuild_project_name
      }
    }
  }

  stage {
    name = "Deploy"
    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      version         = "1"
      input_artifacts = ["BuildArtifact"]

      configuration = {
        ApplicationName     = var.codedeploy_app_name
        DeploymentGroupName = var.codedeploy_deployment_group_name
      }
    }
  }
}
