variable "common_name" {}
variable "common_tag" {}

resource "aws_route_table" "web-public-rt" {
  vpc_id = "${aws_vpc.web_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name        = "${var.common_name}-Public-Subnet-Route"
    tf-group    = "${var.common_tag}"
  }
}