# Define variables for all user input

variable "aws_region" {
  default = "us-east-2" #ohio
}

variable "az" {
  default = {
    zone0 = "us-east-2a"
    zone1 = "us-east-2b"
    zone2 = "us-east-2c"
  }
}
variable "public_subnet_count" {
  default = "1"
}

variable "vpc_cidr" {}

variable "public_subnet_cidr" {
  type    = "list"
  default = []
}

variable "common_name" {}
variable "common_tag" {}