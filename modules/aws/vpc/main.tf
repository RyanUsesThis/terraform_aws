variable "vpc_cidr" {}
variable "common_name" {}
variable "common_tag" {}

resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_support = true

  tags {
    Name        = "${var.common_name}-vpc"
    tf-resource = "${var.common_tag}"
  }
}

output "vpc_id" {
  value = "${aws_vpc.main.id}"
}
