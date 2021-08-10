## wordpress-terraform-aws

Terraform module which deploys Wordpress on AWS using EC2, RDS for database and an application load balancer.

## What will be created

This is the list of resources that the module will create.

1. VPC with Subnets
2. EC2 instance
3. RDS mysql 

## Inputs

- VPC id
- Subnet id's for EC2 Wordpres and RDS MySQL
- HostedZone
- Domain Name

## Outpusts

- DB Endpoint
