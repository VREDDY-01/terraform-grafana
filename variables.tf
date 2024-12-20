variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}

variable "allowed_ips" {
  description = "IP addresses allowed to access the instances"
  type        = list(string)
}

variable "tags" {
  description = "Tags for AWS resources"
  type        = map(string)
  default     = {}
}

variable "public_key" {
  description = "Key RSA Value"
  type        = string
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