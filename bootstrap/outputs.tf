output "state_bucket" {
  value = aws_s3_bucket.state.id
}

# Copy this into ../backend.hcl, then run: terraform init -backend-config=backend.hcl
output "backend_hcl" {
  value = <<-EOT
    bucket       = "${aws_s3_bucket.state.id}"
    key          = "${var.state_key}"
    region       = "${var.aws_region}"
    encrypt      = true
    use_lockfile = true
  EOT
}
