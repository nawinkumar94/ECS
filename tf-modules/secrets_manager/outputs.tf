output "secret_ids" {
  description = "Secret id list"
  value       = aws_secretsmanager_secret.secretsmanager_secret.*.id
}

output "secret_arns" {
  description = "Secret arn list"
  value       = aws_secretsmanager_secret.secretsmanager_secret.*.arn
}
