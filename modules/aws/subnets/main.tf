variable "public_subnet_cidr" {}
variable "common_tag" {}
variable "common_name" {}
variable "az" {}

resource "aws_subnet" "public-subnet" {
  count = "${var.public_subnet_count}"
  vpc_id = "${aws_vpc.web_vpc.id}"
  cidr_block = "${var.public_subnet_cidr}"
  availability_zone = "${var.az}"

  tags {
    Name = "${var.common_name}-public-subnet-${count.index}"
  }
}