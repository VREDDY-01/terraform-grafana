output "records" {
  value = aws_acm_certificate.cert.domain_validation_options
}