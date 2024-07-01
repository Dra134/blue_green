output "load_balancer" {
  value = aws_lb.flask_alb.arn
}

output "sg_id" {
  value = aws_security_group.alb_sg.id
}

output "blue_target_group_arn" {
  value = aws_lb_target_group.blue_tg.arn
}

output "green_target_group_arn" {
  value = aws_lb_target_group.green_tg.arn
}

output "listener_http_arn" {
  value = aws_lb_listener.http.arn
}

output "listener_http_green_arn" {
  value = aws_lb_listener.http_green.arn
}
