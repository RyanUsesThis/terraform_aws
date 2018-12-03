# Define variables for all user input

variable "chef_provision" { 
  type                      = "map"
  description               = "Configuration details for chef server"
  default = {
    server_url              = "https://api.chef.io/organizations/ryanusesthis"
    user_name               = "ryanusesthis"
    user_key_path           = "/home/rkn/.chef/ryanusesthis.pem"
    recreate_client         = true
    }
}

variable "vpc_id" {}
variable "common_name" {}
variable "common_tag" {}
variable "ami" {}
variable "sg_id" {}
variable "instance_count" {}
variable "aws_key_path" {}
variable "aws_private_key" {}
variable "instance_type" {}