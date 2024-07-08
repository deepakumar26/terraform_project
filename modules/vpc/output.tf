output "vpc_id" {
  value = aws_vpc.cards_website_vpc.id
}

output "public_subnet_ids" {
  value = [aws_subnet.cards_website_subnet_public_1a.id,aws_subnet.cards_website_subnet_public_1b.id]
}
