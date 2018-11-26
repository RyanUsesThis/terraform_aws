variable "common_name" {}
variable "common_tag" {}

resource "aws_vpc" "web_vpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_support = true

  tags {
    Name        = "${var.common_name}-vpc"
    tf-resource = "${var.common_tag}"
  }
}

