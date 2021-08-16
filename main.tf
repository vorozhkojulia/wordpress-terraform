data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "random_password" "password_rds" {
  length           = 16
  special          = false
  override_special = "_%@"
}

resource "aws_instance" "wordpress" {
    ami = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"
    subnet_id = var.wordpress_subnet
    vpc_security_group_ids = [aws_security_group.allow_http_ssh.id]

    //user_data = file("${path.module}/bootstrap.sh")
    user_data = templatefile(
        "${path.module}/bootstrap.sh.tmpl", 
        {db_pass = random_password.password_rds.result,
         db_name = "wp_database",
         db_user = "admin",
         db_host = aws_db_instance.wp-db.address}
        )

    tags = {
    Name = "wordpress"
    Terraform = "aws-wordpress-module"
  }
}

resource "aws_security_group" "allow_http_ssh" {
  name        = "allow_http_ssh"
  description = "Allow http and ssh inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "wordpress"
    Terraform = "aws-wordpress-module"
  }
}

resource "aws_db_instance" "wp-db" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0.20"
  instance_class       = "db.t2.micro"
  db_subnet_group_name = aws_db_subnet_group.wp-db-sub.name
  name                 = "wp_database"
  username             = "admin"
  password             = random_password.password_rds.result
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.allow_mysql.id]
}

resource "aws_db_subnet_group" "wp-db-sub" {
  name       = "wordpress"
  subnet_ids = var.rds_subnet

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_security_group" "allow_mysql" {
  name        = "Allow_mysql"
  description = "RDS Security Group"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "wordpress"
  }
}

output "wordpress_ip" {
    description = "Wordpress instance ID:"
    value       = aws_instance.wordpress.public_ip
}

output "endpoint" {
    description = "DB instance MySQL endpoint:"
    value = aws_db_instance.wp-db.address
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
    value = random_password.password_rds.result
    sensitive = true
}