# About
Terraform practices for provisioning VPC with Number of AZs as variable

# Pre-requistes
- Terraform installed on local machine. [Get Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html)
- Create and save access_key and secret_access_key of your AWS Admin User.
- AWS CLI installed on local machine and correctly configure the settings that the AWS CLI uses to interact with your AWS. [Get AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)

# Inputs
- AWS_REGION: ap-southeast-1 as default
- NUMBER_OF_AZ: 2 as default. This controls the number of availability zones within created VPC.

# Setups
Creating VPC without terraform modules since Terraform does not allow to use "count" inside module block.

## VPC
cidr_block for VPC is assigned to 10.0.0.0/16
Each availability zone will have one public subnet and one private subnet.

## Public subnets
cidr_block for public subnets is assigned within [10.0.1.0/24, 10.0.2.0/24, 10.0.3.0/24] depending on the number of AZs variable.
Route traffic from the public subnets via an internet gateway.

## Private subnets
cidr_block for private subnets is assigned within [10.0.101.0/24, 10.0.102.0/24, 10.0.103.0/24] depending on the number of AZs variable.
Route traffic from the private subnets via a NAT.
