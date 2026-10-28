output "instance_id" {
  value = aws_instance.this.id
}

output "public_dns" {
  value = aws_instance.this.public_dns
}

output "role_arn" {
  value = aws_iam_role.this.arn
}
