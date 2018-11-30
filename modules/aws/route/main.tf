variable "common_name" {}
variable "common_tag" {}
variable "vpc_id" {}
variable "igw_id" {}
variable "public_subnet_id" {
  type = "list"
}

resource "aws_route_table" "web-public-rt" {
  vpc_id = "${var.vpc_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${var.igw_id}"
  }

  tags {
    Name     = "${var.common_name}-webroute"
    tf_group = "${var.common_tag}"
  }
}

resource "aws_route_table_association" "web-public-rt" {
  subnet_id      = "${var.public_subnet_id[count.index]}"
  route_table_id = "${aws_route_table.web-public-rt.id}"
}