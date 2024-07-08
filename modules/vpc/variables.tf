variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
}

variable "vpc_subnet_cidr_public_1a" {
    type = string
    default = "10.0.1.0/24"
}

variable "vpc_subnet_cidr_public_1b" {
    type = string
    default = "10.0.2.0/24"
}

variable "vpc_subnet_cidr_private_1a" {
    type = string
    default = "10.0.3.0/24"
}

variable "vpc_subnet_cidr_private_1b" {
    type = string
    default = "10.0.4.0/24"
}

variable "vpc_az_1a" {
    type = string
    default = "ap-south-1a"
}

variable "vpc_az_1b" {
    type = string
    default = "ap-south-1b"
}