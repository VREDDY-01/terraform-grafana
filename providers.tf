terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  # backend "s3" {
  #   bucket         = "your-terraform-state-bucket"
  #   key            = "grafana-prometheus/terraform.tfstate"
  #   region         = "ap-south-1"
  # }
}

provider "aws" {
  region = var.aws_region
}
