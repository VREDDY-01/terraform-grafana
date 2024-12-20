variable "security_group_id" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "target_id" {
  type = string
}

variable "grafana_host_header" {
  type = string
}

variable "node_host_header" {
  type = string
}

variable "prometheus_host_header" {
  type = string
}

variable "cert" {
  type = string
}