resource "aws_codeartifact_domain" "this" {
  domain = "${var.name_prefix}-${var.domain_suffix}"
}

resource "aws_codeartifact_repository" "this" {
  repository = "${var.name_prefix}-${var.repository_suffix}"
  domain     = aws_codeartifact_domain.this.domain

  external_connections {
    external_connection_name = var.upstream_connection
  }
}
