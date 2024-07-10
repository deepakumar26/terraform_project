variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "target_group_arn" {
  description = "The ARN of the target group"
  type        = string
}

variable "key_name" {
  description = "Name of the key pair"
  type        = string
}

variable "public_key" {
  description = "The public key for SSH access"
  type        = string
}

variable "security_group_id" {
  description = "The security group ID"
  type        = string
}

variable "image_id_ami" {
  type = string
  default = "ami-0f58b397bc5c1f2e8"
}

variable "ami_instance_type" {
  type = string
  default = "t2.micro"
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}