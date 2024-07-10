# Creating the launch template 

resource "aws_launch_template" "cards_website_lt" {
  name_prefix   = "cards_website-launch-template"
  image_id      = var.image_id_ami 
  instance_type = var.ami_instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [var.security_group_id]
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "cards_website_lt"
    }
  }
  user_data = filebase64("${path.module}/userdata.sh")
}

# Creating the auto scaling group and mapping it with the launch template
resource "aws_autoscaling_group" "cards_website_asg" {
  desired_capacity     = 2
  max_size             = 5
  min_size             = 2
  vpc_zone_identifier  = var.public_subnet_ids
  target_group_arns    = [var.target_group_arn]
  launch_template {
    id      = aws_launch_template.cards_website_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "cards_website_asg"
    propagate_at_launch = true
  }

}




# Creating the launch template for private ec2 server

resource "aws_launch_template" "private_cards_website_lt" {
  name_prefix   = "private_cards_website-launch-template"
  image_id      = var.image_id_ami 
  instance_type = var.ami_instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [var.security_group_id]
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "private"
    }
  }
}

# Creating the auto scaling group and mapping it with the launch template
resource "aws_autoscaling_group" "private_cards_website_asg" {
  desired_capacity     = 2
  max_size             = 5
  min_size             = 2
  vpc_zone_identifier  = var.private_subnet_ids
  #target_group_arns    = [var.target_group_arn]
  launch_template {
    id      = aws_launch_template.private_cards_website_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "private_cards_website_asg"
    propagate_at_launch = true
  }

}

