# User defined values for all variables.

aws_region =	"us-east-2"	        ##	US East (Ohio)
# aws_region =	"us-east-1"	        ##	US East (N. Virginia)
# aws_region =	"us-west-1"	        ##	US West (N. California)
# aws_region =	"us-west-2"	        ##	US West (Oregon)
# aws_region =	"ap-south-1"	    ##	Asia Pacific (Mumbai)
# aws_region =	"ap-northeast-3"	##	Asia Pacific (Osaka-Local)
# aws_region =	"ap-northeast-2"	##	Asia Pacific (Seoul)
# aws_region =	"ap-southeast-1"	##	Asia Pacific (Singapore)
# aws_region =	"ap-southeast-2"	##	Asia Pacific (Sydney)
# aws_region =	"ap-northeast-1"	##	Asia Pacific (Tokyo)
# aws_region =	"ca-central-1"	    ##	Canada (Central)
# aws_region =	"cn-north-1"	    ##	China (Beijing)
# aws_region =	"cn-northwest-1"	##	China (Ningxia)
# aws_region =	"eu-central-1"	    ##	EU (Frankfurt)
# aws_region =	"eu-west-1"	        ##	EU (Ireland)
# aws_region =	"eu-west-2"	        ##	EU (London)
# aws_region =	"eu-west-3"	        ##	EU (Paris)
# aws_region =	"sa-east-1"	        ##	South America (São Paulo)
# aws_region =	"us-gov-east-1"	    ##	AWS GovCloud (US-East)
# aws_region =	"us-gov-west-1"	    ##	AWS GovCloud (US)

## availability zones
#az = ""

## for a full list of available instance types go to - https://aws.amazon.com/ec2/instance-types/ 
instance_type = "t2-micro"

## AMI images are region specific
ami = "ami-0b59bfac6be064b78"

## how many EC3 instances you would like to spin up
instance_count = "3"

## common_name will be interpolated at the module to create the resource name, ie: NAME-ec2-1, NAME-vpc, etc
common_name = "rkn"

## common tag to search for resources within AWS.
common_tag = "RKN"

## how many subnets you would like to create
public_subnet_count = "3"
#private_subnet_count = ""

## IP Address CIDR blocks
vpc_cidr = "10.0.0.0/16"
public_subnet_cidr  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
private_subnet_cidr = ["172.0.1.0/24","172.0.2.0/24","172.0.3.0/24"]

## credentials for EC2 access
aws_private_key = "rkn"
aws_key_path = "~/.aws/rkn.pem"


