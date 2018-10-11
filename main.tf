# Define variables for all user input

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

# Specify provider - Amazon Web Services

provider "aws" {
  region = "us-east-2"
}

# Define virtual private Cloud network

resource "aws_vpc" "test_vpc" {
  cidr_block         = "${var.vpc_cidr}"
  enable_dns_support = true

  tags {
    Name = "test_vpc"
  }
}

# Define public network subnet

resource "aws_subnet" "public-subnet" {
  vpc_id = "${aws_vpc.test_vpc.id}"
  cidr_block = "${var.public_subnet_cidr}"
  availability_zone = "us-east-2b"

  tags {
    Name = "Web Public Subnet"
  }
}

# Define private network subnet

resource "aws_subnet" "private-subnet" {
  vpc_id = "${aws_vpc.test_vpc.id}"
  cidr_block = "${var.private_subnet_cidr}"
  availability_zone = "us-east-2b"

  tags {
    Name = "Database Private Subnet"
  }
}

# To make the public subnet addressable by the Internet, we need an Internet Gateway
# Define the internet gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.test_vpc.id}"

  tags {
    Name = "VPC IGW"
  }
}


# To allow traffics from the public subnet to the internet throught the NAT Gateway, we need to create a new Route Table.
# # Define the route table

resource "aws_route_table" "web-public-rt" {
  vpc_id = "${aws_vpc.test_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "Public Subnet RT"
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
  name = "vpc_test_web"
  description = "Allow incoming http connections & ssh access"

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

  vpc_id="${aws_vpc.test_vpc.id}"

  tags {
    Name = "Web Server SG"
  }
}

# Define the security group for private subnet
# This Security Group enable MySQL 3306 port, ping and SSH only from the public subnet.

resource "aws_security_group" "sgdb" {
  name = "sg_test_web"
  description = "allow traffic from public subnet"

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }

  vpc_id = "${aws_vpc.test_vpc.id}"

  tags {
    Name = "DB SG"
  }
}

# Define SSH key pair for SSH connection to instances

resource "aws_key_pair" "default" {
  key_name = "vpctestkeypair"
  public_key = "${file("${var.key_path}")}"
}

# Define webserver inside the public subnet

resource "aws_instance" "wb" {
  ami = "${var.ami}"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.default.id}"
  subnet_id = "${aws_subnet.public-subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.sgweb.id}"]
  associate_public_ip_address = true
  source_dest_check = false
  user_data = "${file("install.sh")}"

  tags {
    Name = "webserver"
  }
}

# Define database inside the private subnet

resource "aws_instance" "db" {
  ami = "${var.ami}"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.default.id}"
  subnet_id = "${aws_subnet.private-subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.sgdb.id}"]
  source_dest_check = false

  tags {
    Name = "database"
  }
}