# User defined values for all variables.

aws_region =	"us-east-2"	        ##	US East (Ohio)

## availability zones
#az = ""

## common_name will be interpolated at the module to create the resource name, ie: NAME-ec2-1, NAME-vpc, etc
common_name = "ATEME-TITAN-TEST"

## common tag to search for resources within AWS.
common_tag = "RNJK"

## how many subnets you would like to create
public_subnet_count = "3"
#private_subnet_count = ""

## IP Address CIDR blocks
vpc_cidr = "10.0.0.0/16"
public_subnet_cidr  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
private_subnet_cidr = ["172.0.1.0/24","172.0.2.0/24","172.0.3.0/24"]


