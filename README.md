## AWS Terraform Wordpress module

Terraform module which deploys Wordpress on AWS using EC2 and RDS.

## What will be created

This is the list of resources that the module will create.

- EC2 instance (ubuntu-focal-20.04-amd64-server and ```instance_type = "t2.micro"```)
- bootstrap.sh.tmpl file for setup wordpress und setting up a configuration file for a database using variables for ```wp-config.php```
- RDS mysql instance (using ```random_password``` and ```instance_class = "db.t2.micro"```)
- Security Groups to access both EC2 (allow_http_ssh) and MYSQL (allow_mysql) 

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

output "wordpress_ip" {
    description = "Wordpress instance ID:"
    value       = module.wordpress.wordpress_ip
}

output "endpoint" {
    description = "DB instance MySQL endpoint:"
    value = module.wordpress.endpoint
}

output "database" {
    description = "Name of DB instance MySQL:"
    value = "wp_database"
}

output "username" {
    description = "DB instance MySQL username:"
    value = "admin"
}

output "password" {
    description = "DB instance MySQL sensitive password:"
    value = module.wordpress.password
    sensitive = true
}
```

Use the public ip address (output - ```wordpress_ip```) to run the WordPress installation. 

## Inputs

- VPC id
- Subnet id for EC2 Wordpres and RDS MySQL

## Outpusts

- Wordpress IP address
- DB Endpoint
- DB Name
- DB Username
- DB Password - You can show sensitive password using the command ```terraform output -json```