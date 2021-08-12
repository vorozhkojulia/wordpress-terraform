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
   source = "../wordpress-terraform-v2"

   vpc_id           = "vpc-af4a87d2"
   wordpress_subnet = "subnet-bd2c9ddb"
   rds_subnet       = ["subnet-bd2c9ddb", "subnet-3d9d221c"]
}

output "password" {
    value = random_password.password_rds.result
    sensitive = true
}

output "username" {
    value = "admin"
}

output "database" {
    value = "wp_database"
}
```

## Inputs

- VPC id
- Subnet id for EC2 Wordpres and RDS MySQL

## Outpusts

- Wordpress IP address
- DB Endpoint