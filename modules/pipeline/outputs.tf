output "pipeline_name" {
  value = aws_codepipeline.this.name
}

output "connection_arn" {
  value = aws_codestarconnections_connection.github.arn
}

output "connection_status" {
  description = "PENDING until authorized once in the console."
  value       = aws_codestarconnections_connection.github.connection_status
}
