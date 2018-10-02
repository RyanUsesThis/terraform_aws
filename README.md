# Terraform - AWS - Template
The purpose of this repo is to provide a well-commented template for AWS EC2 instance creation via Terraform

# AWS Credentials
For terraform to create AWS service instances it requires an access key, and a secret key from your AWS account.  
The information is stored in your home directory in a file called ~/.aws/credentials

The contents of the file look like --

[default]\
aws_access_key_id = yourKey\
aws_secret_access_key = yourKey
