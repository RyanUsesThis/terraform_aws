provider "aws" {
  # version = "1.1"
  ## security & access pulled from ~/.aws/credentials
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
  vpc_id            = "${module.vpc.vpc_id}"
  common_name       = "${var.common_name}"
  common_tag        = "${var.common_tag}"
}

module "public_subnets" {
  source                = "../modules/aws/public_subnets"
  az                    = "${var.az}"
  vpc_id                = "${module.vpc.vpc_id}"
  public_subnet_cidr    = "${var.public_subnet_cidr}"
  public_subnet_count   = "${var.public_subnet_count}"
  common_name           = "${var.common_name}"
  common_tag            = "${var.common_tag}"
}

module "internet_gateway" {
  source            = "../modules/aws/igw"
  vpc_id            = "${module.vpc.vpc_id}"
  public_subnet_id  = "${module.public_subnets.public_subnet_id}"
  common_name       = "${var.common_name}"
  common_tag        = "${var.common_tag}"
}

module "public_subnet_route" {
  source            = "../modules/aws/route"
  vpc_id            = "${module.vpc.vpc_id}"
  igw_id            = "${module.internet_gateway.igw_id}"
  public_subnet_id  = "${module.public_subnets.public_subnet_id}"
  common_name       = "${var.common_name}"
  common_tag        = "${var.common_tag}"
}

module "ec2" {
  source            = "../modules/aws/ec2-instance"
  az                = "${var.az}"
  ami               = "${var.ami}"
  sg_id             = "${list("${module.security_group.sg_id}")}"
  public_subnet_id  = "${module.public_subnets.public_subnet_id}"
  instance_count    = "${var.instance_count}"
  aws_key_path      = "${var.aws_key_path}"
  aws_private_key   = "${var.aws_private_key}"
  instance_type     = "${var.instance_type}"
  common_name       = "${var.common_name}"
  common_tag        = "${var.common_tag}"
  # chef_provision    = "${var.chef_provision}"
}

module "resource_group" {
  source        = "../modules/aws/resource_group"
  common_tag    = "${var.common.tag}"
  common_name   = "${var.common_name}"
}
