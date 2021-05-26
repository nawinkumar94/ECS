output "name" {
  value = aws_iam_role.this.name
}

output "arn" {
  value = aws_iam_role.this.arn
}

output "path" {
  value = aws_iam_role.this.path
}

output "id" {
  value = aws_iam_role.this.id
}

output "instance_profile_name" {
  value = var.create_instance_profile ? aws_iam_instance_profile.this.0.name : ""
}

output "instance_profile_id" {
  value = var.create_instance_profile ? aws_iam_instance_profile.this.0.id : ""
}

output "instance_profile_arn" {
  value = var.create_instance_profile ? aws_iam_instance_profile.this.0.arn : ""
}
