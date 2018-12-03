variable "common_tag" {}
variable "common_name" {}

resource "aws_inspector_resource_group" "${var.common_name}-resources" {
  tags {
    tf-group = "${var.common_tag}"
  }
}