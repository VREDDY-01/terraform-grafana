output "public_ip" {
  value = aws_instance.grafana_prometheus.public_ip
}

output "instance_id" {
  value = aws_instance.grafana_prometheus.id
}
