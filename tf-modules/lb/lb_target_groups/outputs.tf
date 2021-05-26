output "target_group_arns" {
  description = "ARNs of the target groups. Useful for passing to your Auto Scaling group."
  value       = aws_lb_target_group.this.*.arn
}
output "target_group_arn_suffix" {
  description = "ARN suffixes of our target groups - can be used with CloudWatch."
  value       = aws_lb_target_group.this.*.arn_suffix
}

output "target_group_name" {
  description = "Name of the target group. Useful for passing to your CodeDeploy Deployment Group."
  value       = aws_lb_target_group.this.*.name
}
