terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
    tls = {
      source = "hashicorp/tls"
      version = "~> 4.0"
    }
 /*    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    } */
  }


  # copying the state file to s3 bucket
  backend "s3" {
    bucket         = "my-terraform-state-bucket-9908253843"
    key            = "terraform.tfstate"
    region         = "ap-south-1"

  }
}

provider "aws" {
  region = var.aws_region
}

#module for vpc and providing the source location
module "vpc" {
  source = "./modules/vpc"
}

#module for alb and providing the source location and passing the varaibles required for alb
module "alb" {
  source            = "./modules/alb"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
}

#module for asg and providing the source location and passing the varaibles required for asg
module "asg" {
  source            = "./modules/asg"
  public_subnet_ids = module.vpc.public_subnet_ids
  target_group_arn  = module.alb.target_group_arn
  key_name          = aws_key_pair.generated_key.key_name
  public_key        = tls_private_key.generated_key.public_key_openssh
  security_group_id = module.alb.alb_security_group_id
}

# creating the private key

resource "tls_private_key" "generated_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# creating the public key

resource "aws_key_pair" "generated_key" {
  key_name   = "my-key-pair"
  public_key = tls_private_key.generated_key.public_key_openssh
}

# Save the private key to a local file
resource "local_file" "example" {
  content  = tls_private_key.private_key.private_key_pem
  filename = "${path.module}/my-key-pair.pem"
}


