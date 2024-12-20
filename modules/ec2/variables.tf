variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "public_key" {
  description = "Public key material for the key pair"
  type        = string
}
