output "vpc_id" {
  value = module.vpc.vpc_id
}

output "alb_dns_name" {
  value = module.alb.dns_name
}

output "private_key_pem" {
  value     = tls_private_key.private_key.private_key_pem
  sensitive = true
}
