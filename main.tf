# Define variables for all user input

variable "aws_region" {
    description = "Region for the VPC"
    default = "us-east-2"
}

variable "vpc_cidr" {
    description = "CIDR for the VPC"
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
    description = "CIDR for the public subnet"
    default = "10.0.1.0/24"
}

variable "ami" {
    description = "Amazon Linux AMI 2018.03.0 (HVM), SSD Volume Type"
    default = "ami-0b59bfac6be064b78"
}

variable "aws_private_key" {
  description = "name of AWS private key defined in AWS console"
  default = "rkn"
}

variable "aws_key_path" {
  description = "EC2 instance SSH Private Key Path"
  default = "~/.aws/rkn.pem"
}

variable "chef_provision" { 
  type                      = "map"
  description               = "Configuration details for chef server"

  default = {
    server_url              = "https://api.chef.io/organizations/ryanusesthis"
    user_name               = "ryanusesthis"
    user_key_path           = "~/.chef/ryanusesthis.pem"
    recreate_client         = true
    }
}

# Specify provider - Amazon Web Services

provider "aws" {
  region = "us-east-2"
}

# Define virtual private Cloud network

resource "aws_vpc" "web_vpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_support = true

  tags {
    Name = "Web and Database VPC"
  }
}

# Define public network subnet

resource "aws_subnet" "public-subnet" {
  vpc_id = "${aws_vpc.web_vpc.id}"
  cidr_block = "${var.public_subnet_cidr}"
  availability_zone = "us-east-2b"

  tags {
    Name = "Web Public Subnet"
  }
}

# To make the public subnet addressable by the Internet, we need an Internet Gateway
# Define the internet gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.web_vpc.id}"

  tags {
    Name = "VPC Internet Gateway"
  }
}

# To allow traffics from the public subnet to the internet throught the NAT Gateway, we need to create a new Route Table.
# # Define the route table

resource "aws_route_table" "web-public-rt" {
  vpc_id = "${aws_vpc.web_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "Public Subnet Route"
  }
}

# Assign the route table to the public Subnet

resource "aws_route_table_association" "web-public-rt" {
  subnet_id = "${aws_subnet.public-subnet.id}"
  route_table_id = "${aws_route_table.web-public-rt.id}"
}


# Define the security group for public subnet
# This Security Group allows HTTP/HTTPS and SSH connections from anywhere.

resource "aws_security_group" "sgweb" {
  name = "sg_web"
  description = "Allow incoming http connections & ssh access"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id="${aws_vpc.web_vpc.id}"

  tags {
    Name = "Web Security Group"
  }
}

# Define webserver inside the public subnet

resource "aws_instance" "wb" {
  ami = "${var.ami}"
  instance_type = "t2.micro"
  key_name = "${var.aws_private_key}"
  subnet_id = "${aws_subnet.public-subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.sgweb.id}"]
  associate_public_ip_address = true
  source_dest_check = false

  tags {
    Name = "webserver"
  }

  connection {
    user        = "ec2-user"
    type        = "ssh"
    private_key = "${file(var.aws_key_path)}"
  }

  provisioner "chef" {
  server_url      = "${var.chef_provision.["server_url"]}"
  user_name       = "${var.chef_provision.["user_name"]}"
  user_key        = "${file("${var.chef_provision.["user_key_path"]}")}"
  node_name       = "web"
  run_list        = ["role[web]"]
  recreate_client = "${var.chef_provision.["recreate_client"]}"
  on_failure      = "continue"
  attributes_json = <<-EOF
  {
    "tags": [
      "webserver"
    ]
  }
  EOF
  }
  
}

