variable "aws_region" {
    description = "Region for the VPC"
    default = "us-east-2"
}

variable "vpc_cidr" {
    description = "CIDR for the VPC"
    default = "10.0.1.0/16"
}

variable "public_subnet_cidr" {
    description = "CIDR for the public subnet"
    default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
    description = "CIDR for the private subnet"
    default = "10.0.2.0/24"
}

variable "ami" {
    description = "Ubuntu 14.08 AMI"
    default = "ami-0782e9ee97725263d"
}

variable "key_path" {
    description = "SSH Public Key Path"
    default = "/home/rkn/.aws/rkn.pem"
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_vpc" "test_vpc" {
  cidr_block         = "${var.vpc_cidr}"
  enable_dns_support = true

  tags {
    Name = "test_vpc"
  }
}

resource "aws_subnet" "public-subnet" {
  vpc_id = "${vaws_vpc.test_vpc.id}"
  cidr_block = "${var.public_subnet_cidr}"
  availability_zone = "us-east-2b"

  tags {
    Name = "Web Public Subnet"
  }
}

resource "aws_subnet" "private-subnet" {
  vpc_id = "${aws_vpc.test_vpc.id}"
  cidr_block = "${var.private_subnet_cidr}"
  availability_zone = "us-east-2b"

  tags {
    Name = "Database Private Subnet"
  }
}
















resource "aws_instance" "test_ec2" {
  ami             = "ami-0782e9ee97725263d"
  instance_type   = "t2.micro"
  key_name        = "rkn"
  security_groups = ["default"]

  tags {
    Name = "test_ec2"
  }

  connection {
    user        = "ubuntu"
    type        = "ssh"
    private_key = "~/.aws/rkn.pem"
  }
}
