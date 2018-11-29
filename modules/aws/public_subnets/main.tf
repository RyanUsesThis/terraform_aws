variable "public_subnet_cidr" {
  type = "list"
}
variable "public_subnet_count" {}
variable "common_tag" {}
variable "common_name" {}
variable "az" {
  type = "map"
}
variable "vpc_id" {}

resource "aws_subnet" "public-subnet" {
  count             = "${var.public_subnet_count}"
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "${var.public_subnet_cidr[count.index]}"
  availability_zone = "${lookup(var.az, "zone${count.index}")}"

  tags {
    Name     = "${var.common_name}-public-subnet-${count.index}"
    tf_group = "${var.common_tag}"
  }
}

output "public_subnet_id" {
  value = ["${aws_subnet.public-subnet.id}"]
}
