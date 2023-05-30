variable "region" {
  default = "us-east-1"
}
variable "vpc_id" {
  default = "vpc-0eee4cb26a9fd7b99"
}
variable "pubsubnet_id" {
  default = "subnet-0c424bad1a72cc417"
}

# TODO: Designate a cloud provider, region, and credentials
terraform {
  backend "local" {
    path = ".terraform/terraform.state"
  }
}

provider "aws" {
  region = var.region
  profile = "udacity"
}

# TODO: provision 4 AWS t2.micro EC2 instances named Udacity T2

data "aws_vpc" "default" {
  id = var.vpc_id
}

data "aws_subnet" "pubsub" {
  vpc_id = data.aws_vpc.default.id
  id = var.pubsubnet_id
}

# TODO: provision 2 m4.large EC2 instances named Udacity M4

resource "aws_instance" "udacity_t2" {
  count = 4
  ami           = "ami-0715c1897453cabd1"
  instance_type = "t2.micro"
  subnet_id = data.aws_subnet.pubsub.id

  tags = {
    Name = "Udacity T2"
    Created_by = "Terraform"
  }
}

resource "aws_instance" "udacity_m4" {
  count = 2
  ami           = "ami-0715c1897453cabd1"
  instance_type = "m4.large"
  subnet_id = data.aws_subnet.pubsub.id

  tags = {
    Name = "Udacity M4"
    Created_by = "Terraform"
  }
}