# Creating the security group for alb and allowing port 80 and 22 for the access

resource "aws_security_group" "cards_website_alb_sg" {
  name        = "cards_website_alb_sg"
  description = "Allow inbound HTTP traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Creating the load balancer

resource "aws_lb" "cards_website_alb" {
  name               = "cards-website-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.cards_website_alb_sg.id]
  subnets            = var.public_subnet_ids

}

# Creating the target group 

resource "aws_lb_target_group" "cards_website_target_group" {
  name     = "cards-website-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

# Creating the listener on port 80

resource "aws_lb_listener" "cards_website_listener" {
  load_balancer_arn = aws_lb.cards_website_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cards_website_target_group.arn
  }
}
