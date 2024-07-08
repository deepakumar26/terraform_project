output "dns_name" {
  value = aws_lb.cards_website_alb.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.cards_website_target_group.arn
}

output "alb_security_group_id" {
  value = aws_security_group.cards_website_alb_sg.id
}
