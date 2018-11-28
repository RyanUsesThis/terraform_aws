## Internet Gateway
variable "common_name" {}
variable "common_tag" {}
variable "vpc_id" {}
variable "public_subnet_id" {}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${var.vpc_id}"

  tags {
    Name        = "${var.common_name}-igw"
    tf-group    = "${var.common_tag}"
  }
}

output "igw_id" {
  value = "${aws_internet_gateway.gw.id}"
}