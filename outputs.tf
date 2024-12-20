output "public_ip" {
  description = "Public IP of the Grafana instance"
  value       = module.ec2_instance.public_ip
}

output "grafana_url" {
  value = "http://${var.grafana_host_header}"
}

output "prometheus_url" {
  value = "http://${var.node_host_header}"
}

output "node_exporter_url" {
  value = "http://${var.prometheus_host_header}"
}