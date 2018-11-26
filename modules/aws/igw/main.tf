## Internet Gateway
variable "common_name" {}
variable "common_tag" {}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.web_vpc.id}"

  tags {
    Name        = "${var.common_name}-igw"
    tf-group    = "${var.common_tag}"
  }
}