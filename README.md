## AWS Terraform Wordpress module

Terraform module which deploys Wordpress on AWS using EC2 and RDS.

## What will be created

This is the list of resources that the module will create.

- EC2 instance
- RDS mysql instance
- Security Groups to access both EC2 and MYSQL 

## Usage

```hcl
provider "aws" {
  region  = "us-east-1"
}

module "wordpress" {
   source = "https://github.com/vorozhkojulia/wordpress-terraform"

   vpc_id           = "vpc-abcdef1234"
   wordpress_subnet = "subnet-3d9d221c"
   rds_subnet       = "subnet-39f39837"
}
```

## Inputs

- Subnet id for EC2 Wordpres and RDS MySQL

## Outpusts

- Wordpress IP address
- DB Endpoint