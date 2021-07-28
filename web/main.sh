#!/bin/bash

hostname=web # To make it easier for you, only change the hostname here and no need to touch other lines ;)

# Change the hostname of your VM
sudo hostnamectl set-hostname $hostname

# Change permanently the hostname of your VM
sudo rm -rf /etc/hosts
sudo cp ./hosts /etc/hosts

# Setup your VM's network to be able to connect to the Gateway
sudo rm -rf /etc/network/interfaces
sudo cp ./interfaces /etc/network/interfaces

# Change the nameserver to reach internet
sudo rm -rf /etc/resolv.conf
sudo cp ./resolv.conf /etc/resolv.conf

# Restart the network of your VM to update it
sudo service networking restart

# Creation of the text that will be displayed every time someone will try to connect in ssh to your VM
sudo rm -rf /etc/issue.net
sudo cp ./issue.net /etc/issue.net

# Enabled the message to be displayed
sudo rm -rf /etc/sshd_config
sudo cp ./sshd_config /etc/sshd_config
sudo cp ./sshd_config /etc/ssh/sshd_config

# Update the ssh server
sudo service ssh reload

# Install Apache2 & nginx
sudo apt install apache2
sudo apt install nginx

# Create a file that will contain the password for a user bob
sudo htpasswd -c /etc/nginx/.htpasswd bob

# Create the 2 virtual hosts needed to be able to reach `web` and `admin`
sudo rm -rf /etc/nginx/conf.d/vhost.conf
sudo cp ./vhost.conf /etc/nginx/conf.d/vhost.conf

# Restart the nginx of your VM to update it
sudo systemctl restart nginx

# Create the folder source for our website pages
sudo mkdir /var/www/
sudo mkdir /var/www/html
sudo mkdir /var/www/private

# Create the index for the web page
sudo cp ./index.html /var/www/html/index.html

sudo rm -rf ./index.html
sudo touch index.html

# Change the index.html file to update it
echo "Hello Admin" >> ./index.html

# Create the index fot he admin page
sudo cp ./index.html /var/www/private/index.html