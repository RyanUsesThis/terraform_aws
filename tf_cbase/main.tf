provider "aws" {
    alias      = "us-east-2"
    #access_key = "ACCESS_KEY" --provided by ~/.aws/credentials
    #secret_key = "SECRET_KEY" --provided by ~/.aws/credentials
    region     = "us-east-2"
}

variable "us-east-zones" {
  default = ["us-east-2a", "us-east-2b"]
}

# resource type: aws_instance , name: packager
# ami -  Ubuntu Server 16.04 LTS (HVM), SSD Volume Type
# A.zone - pulls zone from variable. cycles through index.
# instance 'flavor' t2.micro'
# lifecycle options disabled.  Entered for future use.
resource "aws_instance" "packager" {
  count             = 1
  provider          = "aws.us-east-2"
  ami               = "ami-0782e9ee97725263d"
  availability_zone = "${var.us-east-zones[count.index]}"
  instance_type     = "t2.micro"

  lifecycle {
    create_before_destroy = false
    prevent_destroy = false
  }
}

# print out instance public IP addresses once complete.
output "packager_ip" {
  value = "${aws_instance.packager.public_ip}"
}