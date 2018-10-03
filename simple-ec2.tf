resource "aws_vpc" "ec2_test_vpc" {
  cidr_block         = "192.192.41.0/24"
  enable_dns_support = false
}

resource "aws_instance" "ec2_instance" {
  ami             = "${var.vm_ami}"
  instance_type   = "t2.micro"
  security_groups = ["default"]

  connection {
    user        = "ubuntu"
    type        = "ssh"
    private_key = "${file(var.vm_key)}"
  }
}
