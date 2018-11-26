# Define variables for all user input

variable "chef_provision" { 
  type                      = "map"
  description               = "Configuration details for chef server"
  default = {
    server_url              = "https://api.chef.io/organizations/yourorganization"
    user_name               = "yourusername"
    user_key_path           = "~/.chef/your.pem"
    recreate_client         = true
    }
}

variable "aws_region" {}
variable "az" {}
variable "instance_type" {}
variable "ami" {}
variable "instance_count" {}
variable "common_name" {}
variable "common_tag" {}
variable public_subnet_count {}
variable private_subnet_count {}
variable "vpc_cidr" {}
variable "public_subnet_cidr" {}
variable "private_subnet_cidr" {}
variable "aws_private_key" {}
variable "aws_key_path" {}
