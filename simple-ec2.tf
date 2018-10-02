resource "aws_vpc" "ec2_test_vpc" {
  cidr_block         = "192.192.41.0/24"
  enable_dns_support = false
}

resource "aws_instance" "ec2_instance" {
  ami           = "${var.vm_ami}"
  instance_type = "t2.micro"
  key_name      = "rkn_str"

  # tags {
  #   Name = "centos-tf"
  # }
  # Networking
  /*    subnet_id = "subnet-3ac971fa14ea4cdf93670f3c8df1e97e"*/
  security_groups = ["default"]
}
