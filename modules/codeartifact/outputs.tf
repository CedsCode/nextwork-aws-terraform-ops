output "domain" {
  value = aws_codeartifact_domain.this.domain
}

output "domain_arn" {
  value = aws_codeartifact_domain.this.arn
}

output "domain_owner" {
  value = aws_codeartifact_domain.this.owner
}

output "repository" {
  value = aws_codeartifact_repository.this.repository
}

output "repository_arn" {
  value = aws_codeartifact_repository.this.arn
}
