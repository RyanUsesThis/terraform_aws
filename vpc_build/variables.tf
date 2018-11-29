# Define variables for all user input

# variable "chef_provision" { 
#   type                      = "map"
#   description               = "Configuration details for chef server"
#   default = {
#     server_url              = "https://api.chef.io/organizations/ryanusesthis"
#     user_name               = "ryanusesthis"
#     user_key_path           = "/home/rkn/.chef/ryanusesthis.pem"
#     recreate_client         = true
#     }
# }

##########################################

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
variable "instance_type" {
  default = "t2-micro"
}
variable "ami" {
  default = "ami-023c8dbf8268fb3ca"
}
variable "instance_count" {
  default = "1"
}
variable "public_subnet_count" {
  default = "1"
}
# variable "private_subnet_count" {
#   default = "1"
# }

variable "vpc_cidr" {}

variable "public_subnet_cidr" {
  type    = "list"
  default = []
}

#variable "private_subnet_cidr" {}

variable "aws_private_key" {}
variable "aws_key_path" {}

variable "common_name" {}
variable "common_tag" {}