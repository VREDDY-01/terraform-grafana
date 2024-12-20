resource "aws_key_pair" "grafana_key" {
  key_name   = var.key_name
  public_key = var.public_key
}

resource "aws_instance" "grafana_prometheus" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.grafana_key.key_name

  vpc_security_group_ids = [var.security_group_id]

  user_data = templatefile("${path.module}/install_scripts/bootstrap.sh", {
    prometheus_script = file("${path.module}/install_scripts/prometheus.sh"),
    grafana_script    = file("${path.module}/install_scripts/grafana.sh"),
    node_exporter_script = file("${path.module}/install_scripts/node_exporter.sh")
  })

  tags = var.tags
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
