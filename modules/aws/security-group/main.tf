variable "common_name" {}
variable "common_tag" {}
variable "vpc_id" {}

resource "aws_security_group" "sgweb" {
  name = "sg_web"
  description = "Allow incoming http connections & ssh access"
  vpc_id = "${var.vpc_id}"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

## allow HTTP
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

## allow HTTPS
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

## allow ICMP
  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

## allow SSH
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${var.common_name}-webSG"
    tf-group    = "${var.common_tag}"
  }
}

output "sg_id" {
  value = "${aws_security_group.sgweb.id}"
}