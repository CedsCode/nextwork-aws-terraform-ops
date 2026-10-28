data "aws_region" "current" {}
data "aws_partition" "current" {}

data "aws_ssm_parameter" "ami" {
  name = var.ami_ssm_parameter
}

data "aws_iam_policy_document" "assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = "${var.name_prefix}-webserver-role"
  assume_role_policy = data.aws_iam_policy_document.assume.json
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# The CodeDeploy agent downloads the revision from the pipeline artifact bucket.
data "aws_iam_policy_document" "artifacts_read" {
  statement {
    actions   = ["s3:GetObject", "s3:GetObjectVersion"]
    resources = ["${var.artifact_bucket_arn}/*"]
  }
  statement {
    actions   = ["s3:ListBucket"]
    resources = [var.artifact_bucket_arn]
  }
}

resource "aws_iam_role_policy" "artifacts_read" {
  name   = "artifact-bucket-read"
  role   = aws_iam_role.this.id
  policy = data.aws_iam_policy_document.artifacts_read.json
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.name_prefix}-webserver-profile"
  role = aws_iam_role.this.name
}

resource "aws_instance" "this" {
  ami                         = nonsensitive(data.aws_ssm_parameter.ami.value)
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  iam_instance_profile        = aws_iam_instance_profile.this.name
  associate_public_ip_address = true
  key_name                    = var.key_name

  user_data = templatefile("${path.module}/user_data.sh.tftpl", {
    region           = data.aws_region.current.name
    tomcat_version   = var.tomcat_version
    tomcat_major     = split(".", var.tomcat_version)[0]
    app_port         = var.app_port
    corretto_package = var.corretto_package
  })
  user_data_replace_on_change = true

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    volume_size = var.root_volume_gb
    volume_type = "gp3"
    encrypted   = true
  }

  tags = {
    Name               = "${var.name_prefix}-webserver"
    (var.role_tag_key) = var.role_tag_value
  }
}
