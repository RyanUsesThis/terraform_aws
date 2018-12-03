## security & access pulled from ~/.aws/credentials
provider "aws" { 
  # version = "1.1"
  region = "${var.aws_region}"
}

module "security_group" {
  source            = "../modules/aws/security-group"
  vpc_id            = "${module.vpc.vpc_id}"
  common_name       = "${var.common_name}"
  common_tag        = "${var.common_tag}"
}

module "ec2" {
  source            = "../modules/aws/ec2-instance"
  az                = "${var.az}"
  ami               = "${var.ami}"
  sg_id             = "${list("${module.security_group.sg_id}")}"
  instance_count    = "${var.instance_count}"
  aws_key_path      = "${var.aws_key_path}"
  aws_private_key   = "${var.aws_private_key}"
  instance_type     = "${var.instance_type}"
  common_name       = "${var.common_name}"
  common_tag        = "${var.common_tag}"
  chef_provision    = "${var.chef_provision}"
}

module "resource_group" {
  source        = "../modules/aws/resource_group"
  common_tag    = "${var.common.tag}"
  common_name   = "${var.common_name}"
}