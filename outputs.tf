output "public_ip" {
  description = "Public IP of the Grafana instance"
  value       = module.ec2_instance.public_ip
}

output "grafana_url" {
  value = "http://${module.aws_lb.lb_dns}:3000"
}

output "prometheus_url" {
  value = "http://${module.aws_lb.lb_dns}:9090"
}

output "node_exporter_url" {
  value = "http://${module.aws_lb.lb_dns}:9100"
}

output "scm_records" {
  value = module.acm.records
}