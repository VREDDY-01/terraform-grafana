module "security_group" {
  source      = "./modules/security_group"
  allowed_ips = var.allowed_ips
}

module "ec2_instance" {
  source            = "./modules/ec2"
  instance_type     = var.instance_type
  key_name          = var.key_name
  public_key        = var.public_key
  security_group_id = module.security_group.security_group_id
  tags              = var.tags
}

module "aws_lb" {
  source = "./modules/load_balancer"
  security_group_id = module.security_group.security_group_id
  tags = var.tags
  target_id = module.ec2_instance.instance_id
  grafana_host_header = var.grafana_host_header
  prometheus_host_header = var.prometheus_host_header
  node_host_header = var.node_host_header
  cert = var.cert
}