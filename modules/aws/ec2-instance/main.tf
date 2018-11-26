variable "ami" {}
variable "instance_type" {}
variable "aws_private_key" {}
variable "aws_key_path" {}
variable "chef_provision" {}
variable "common_name" {}
variable "common_tag" {}
variable "instance_count" {}

resource "aws_instance" "public-ec2" {
  count                       = "${var.instance_count}"
  availability_zone           = "${var.az}"
  ami                         = "${var.ami}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.aws_private_key}"
  subnet_id                   = "${aws_subnet.public-subnet.id}"        ## figure out how to assign via count.index
  vpc_security_group_ids      = ["${aws_security_group.sgweb.id}"]      ## figure out how to assign via count.index
  associate_public_ip_address = true
  source_dest_check           = false

  tags {
    Name        = "${var.common_name}-ec2-${count.index}"
    tf-group    = "${var.common_tag}"
  }

  connection {
    user        = "ec2-user"
    type        = "ssh"
    private_key = "${file(var.aws_key_path)}"
  }

  provisioner "chef" {
  server_url      = "${var.chef_provision.["server_url"]}"
  user_name       = "${var.chef_provision.["user_name"]}"
  user_key        = "${file("${var.chef_provision.["user_key_path"]}")}"
  node_name       = "web"
  run_list        = ["role[web]"]
  recreate_client = "${var.chef_provision.["recreate_client"]}"
  on_failure      = "continue"
  attributes_json = <<-EOF
  {
    "tags": [
      "webserver"
    ]
  }
  EOF
  }
  
}