output "target_group_attachment_ids" {
  description = "A unique identifier for the attachment."
  value       = aws_lb_target_group_attachment.this.*.id
}
