#!/bin/bash
# install packages
sudo apt-get update
sudo apt-get install php php-mysql apache2 wget unzip -y

# setup wordpress
cd /var/www/
sudo rm html/index.html

sudo curl -O https://wordpress.org/latest.tar.gz
sudo tar -zxvf latest.tar.gz
sudo cp -Rfp wordpress/* html/