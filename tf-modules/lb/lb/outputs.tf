output "lb_dnsname" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.this.dns_name
}

output "lb_id" {
  description = "The id of the load balancer"
  value       = aws_lb.this.id
}

output "lb_zone_id" {
  description = "zone id for load balancer"
  value       = aws_lb.this.zone_id
}

output "lb_arn" {
  value = aws_lb.this.arn
}

output "lb_name" {
  value = aws_lb.this.name
}

output "lb_arn_suffix" {
  value = aws_lb.this.arn_suffix
}
