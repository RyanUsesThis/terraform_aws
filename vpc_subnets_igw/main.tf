provider "aws" {
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