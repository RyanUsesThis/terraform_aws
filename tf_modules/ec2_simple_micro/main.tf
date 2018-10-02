resource "aws_instance" "instance" {
  count                 = "${var.total_instances}"
  ami                   = "${var.amis[var.region]}"
  instance_type         = "t2.micro"
}

