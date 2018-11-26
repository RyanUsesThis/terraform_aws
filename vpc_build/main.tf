provider "aws" {
  ## security & access pulled from ~/.aws/credentials see readme
  #access_key = "${var.access_key}"
  #secret_key = "${var.secret_key}"
  region = "${var.aws_region}"
}

module "vpc" {
  source        = "../modules/aws/vpc"
  vpc_cidr      = "${var.vpc_cidr}"
  common_name   = "${var.common_name}"
  common_tag    = "${var.common_tag}"
}

module "security_group" {
  source            = "../modules/aws/security-group"
  common_name       = "${var.common_name}"
  common_tag        = "${var.common_tag}"
}

module "subnets" {
  source                = "../modules/aws/subnets"
  az                    = "${var.az}"
  public_subnet_cidr    = "${var.public_subnet_cidr}"
  private_subnet_cidr   = "${var.private_subnet_cidr}"
  common_name           = "${var.common_name}"
  common_tag            = "${var.common_tag}"
}

module "internet_gateway" {
  source            = "../modules/aws/igw"
  common_name       = "${var.common_name}"
  common_tag        = "${var.common_tag}"
}

module "public_subnet_route" {
  source            = "../modules/aws/route"
  common_name       = "${var.common_name}"
  common_tag        = "${var.common_tag}"
}

module "ec2" {
  source            = "../modules/aws/ec2-instance"
  az                = "${var.az}"
  ami               = "${var.ami}"
  instance_count    = "${var.instance_count}"
  aws_key_path      = "${var.aws_key_path}"
  aws_private_key   = "${var.aws_private_key}"
  instance_type     = "${var.instance_type}"
  common_name       = "${var.common_name}"
  common_tag        = "${var.common_tag}"
}

