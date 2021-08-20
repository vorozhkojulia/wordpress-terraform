output "wordpress_ip" {
    description = "Wordpress instance ID:"
    value       = aws_instance.wordpress.public_ip
}

output "db_endpoint" {
    description = "DB instance MySQL endpoint:"
    value = aws_db_instance.db_mysql.address
}

output "db_name" {
    description = "Name of DB instance MySQL:"
    value = "db_wordpress"
}

output "db_username" {
    description = "DB instance MySQL username:"
    value = "admin"
}

output "db_password" {
    description = "DB instance MySQL sensitive password:"
    value = random_password.rds_password.result
    sensitive = true
}