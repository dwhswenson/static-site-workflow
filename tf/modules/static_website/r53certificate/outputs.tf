output "certificate_arn" {
  description = "The ARN of the validated certificate"
  value       = aws_acm_certificate.certificate.arn
}
