output "dns_name" {
  description = "ALB DNS name"
  value       = aws_lb.main.dns_name
}

output "arn" {
  description = "ALB ARN"
  value       = aws_lb.main.arn
}

output "zone_id" {
  description = "ALB Zone ID"
  value       = aws_lb.main.zone_id
}

output "listener_arn" {
  description = "ALB listener ARN"
  value       = aws_lb_listener.main.arn
}

output "test_listener_arn" {
  description = "ALB test listener ARN"
  value       = aws_lb_listener.test.arn
}

output "target_group_blue_arn" {
  description = "Blue target group ARN"
  value       = aws_lb_target_group.blue.arn
}

output "target_group_green_arn" {
  description = "Green target group ARN"
  value       = aws_lb_target_group.green.arn
}

output "target_group_blue_name" {
  description = "Blue target group name"
  value       = aws_lb_target_group.blue.name
}

output "target_group_green_name" {
  description = "Green target group name"
  value       = aws_lb_target_group.green.name
}