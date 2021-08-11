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

resource "aws_instance" "wordpress" {
    ami = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"
    subnet_id = var.wordpress_subnet
    vpc_security_group_ids = [aws_security_group.allow_http.id]

    user_data = <<EOF
    #!/bin/bash
    # install packages
    apt-get update
    apt-get install php php-mysql apache2 wget unzip -y

    # setup wordpress
    cd /var/www/
    curl -O https://wordpress.org/latest.tar.gz
    tar -zxvf latest.tar.gz
    cp -Rfp wordpress/* html/

    #restart apache
    systemctl restart apache2 
    EOF

    tags = {
    Name = "wordpress"
    Terraform = "aws-wordpress-module"
  }
}


resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow http and ssh inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
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
