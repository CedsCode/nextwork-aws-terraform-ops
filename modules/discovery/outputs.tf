output "vpc_id" {
  value = data.aws_vpc.this.id
}

output "subnet_ids" {
  value = data.aws_subnets.this.ids
}

output "instance_id" {
  value = data.aws_instance.web.id
}

output "network_interface_id" {
  description = "First network interface of the web server."
  value       = tolist(data.aws_network_interfaces.web.ids)[0]
}
